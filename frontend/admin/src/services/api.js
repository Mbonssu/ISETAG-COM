/**
 * Configuration de l'API - Point d'entrée pour toutes les communications avec le backend
 * 
 * Ce fichier gère toutes les requêtes HTTP vers l'API Django.
 * Il inclut la gestion des tokens CSRF, l'authentification JWT,
 * et le formatage des requêtes/réponses.
 */

// ============================================================
// 1. CONFIGURATION DE BASE
// ============================================================

/**
 * URL de base de l'API
 * Utilise un chemin relatif qui sera redirigé via le proxy React
 * vers http://192.168.30.106:8000/user_api/ISETAG_COM.users/
 */
const API_BASE_URL = '/user_api/ISETAG_COM.users/';

// ============================================================
// 2. FONCTIONS UTILITAIRES
// ============================================================

/**
 * Récupère le token CSRF depuis les cookies du navigateur
 * 
 * Django stocke le token CSRF dans un cookie nommé 'csrftoken'.
 * Ce token est nécessaire pour toutes les requêtes POST/PUT/DELETE
 * afin de protéger contre les attaques CSRF (Cross-Site Request Forgery).
 * 
 * @returns {string|null} Le token CSRF ou null s'il n'est pas trouvé
 */
const getCSRFToken = () => {
  // Récupère la chaîne complète des cookies
  // Exemple: "csrftoken=abc123; sessionid=xyz789"
  const cookies = document.cookie;
  
  // Sépare les cookies individuels en utilisant '; ' comme séparateur
  // Puis cherche celui qui commence par 'csrftoken='
  // Exemple: ["csrftoken=abc123", "sessionid=xyz789"]
  const cookie = cookies
    .split('; ')
    .find(row => row.startsWith('csrftoken='));
  
  // Si le cookie existe, on extrait la valeur après le '='
  // Sinon, on retourne null
  return cookie ? cookie.split('=')[1] : null;
};

// ============================================================
// 3. FONCTION PRINCIPALE DE REQUÊTE API
// ============================================================

/**
 * Fonction générique pour effectuer des requêtes API
 * 
 * Gère automatiquement :
 * - L'ajout du token CSRF pour les requêtes sécurisées
 * - L'ajout du token JWT pour l'authentification
 * - L'envoi des cookies avec credentials: 'include'
 * - Le parsing des réponses JSON
 * - La gestion des erreurs
 * 
 * @param {string} endpoint - Le chemin de l'API (ex: "?search=test")
 * @param {Object} options - Options de la requête (method, body, headers)
 * @returns {Promise} - La réponse JSON de l'API
 * @throws {Error} - Lance une erreur si la requête échoue
 */
export const apiRequest = async (endpoint, options = {}) => {
  // ============================================================
  // 3a. CONSTRUCTION DE L'URL
  // ============================================================
  
  /**
   * Construction de l'URL complète en concaténant l'URL de base et l'endpoint
   * Exemple: '/user_api/ISETAG_COM.users/' + '?search=test'
   *          → '/user_api/ISETAG_COM.users/?search=test'
   */
  const url = `${API_BASE_URL}${endpoint}`;

  // ============================================================
  // 3b. RÉCUPÉRATION DES TOKENS D'AUTHENTIFICATION
  // ============================================================
  
  /**
   * Récupère le token CSRF depuis les cookies
   * Nécessaire pour les requêtes POST, PUT, PATCH, DELETE
   */
  const csrfToken = getCSRFToken();
  
  /**
   * Récupère le token JWT depuis le localStorage
   * Stocké lors de la connexion de l'utilisateur
   */
  const authToken = localStorage.getItem('auth_token');

  // ============================================================
  // 3c. CONFIGURATION DE LA REQUÊTE
  // ============================================================
  
  /**
   * Construction de l'objet de configuration pour fetch()
   * Fusionne les options passées en paramètre avec les options par défaut
   */
  const config = {
    // Spread operator pour inclure toutes les options passées
    ...options,
    
    // Configuration des headers HTTP
    headers: {
      // Indique que le corps de la requête est en JSON
      'Content-Type': 'application/json',
      
      // Indique que la réponse attendue est en JSON
      'Accept': 'application/json',
      
      /**
       * Ajoute le token CSRF si disponible
       * Django vérifie ce header pour valider les requêtes
       * Exemple: 'X-CSRFToken: abc123'
       */
      ...(csrfToken && { 'X-CSRFToken': csrfToken }),
      
      /**
       * Ajoute le token JWT si disponible
       * Utilisé pour authentifier l'utilisateur sur le backend
       * Exemple: 'Authorization: Bearer eyJhbGciOiJIUzI1NiIs...'
       */
      ...(authToken && { 'Authorization': `Bearer ${authToken}` }),
      
      // Fusionne avec les headers personnalisés passés en paramètre
      ...options.headers,
    },
    
    /**
     * credentials: 'include' permet d'envoyer automatiquement les cookies
     * Nécessaire pour que Django puisse lire le cookie CSRF
     * et maintenir la session utilisateur
     */
    credentials: 'include',
  };

  // ============================================================
  // 3d. EXÉCUTION DE LA REQUÊTE ET GESTION DE LA RÉPONSE
  // ============================================================
  
  try {
    /**
     * Exécute la requête HTTP avec fetch()
     * fetch() est une API native du navigateur pour faire des requêtes réseau
     * 
     * Exemple de requête GET:
     * fetch('/user_api/ISETAG_COM.users/?search=test', { method: 'GET', ... })
     * 
     * Exemple de requête POST:
     * fetch('/user_api/ISETAG_COM.users/', { 
     *   method: 'POST', 
     *   body: '{"nom":"Test"}',
     *   headers: { 'X-CSRFToken': 'abc123' }
     * })
     */
    const response = await fetch(url, config);
    
    /**
     * Vérifie le type de contenu de la réponse
     * Django peut renvoyer du JSON (normal) ou du HTML (en cas d'erreur)
     */
    const contentType = response.headers.get('content-type');
    
    /**
     * Parse la réponse en fonction de son type
     * Si c'est du JSON, on le parse avec response.json()
     * Sinon, on récupère le texte brut pour l'erreur
     */
    let data;
    if (contentType && contentType.includes('application/json')) {
      /**
       * response.json() parse le JSON reçu
       * Exemple: { "status": "ok", "data": [...] }
       */
      data = await response.json();
    } else {
      /**
       * Si ce n'est pas du JSON, on récupère le texte pour l'erreur
       * Cela arrive souvent avec les erreurs 403, 404, 500
       */
      const text = await response.text();
      throw new Error(`Erreur ${response.status}: Réponse non-JSON reçue`);
    }

    /**
     * Vérifie si la réponse est OK (status 200-299)
     * Si ce n'est pas le cas, on lance une erreur avec le message du backend
     */
    if (!response.ok) {
      /**
       * Le backend Django peut renvoyer plusieurs formats d'erreur :
       * - message: message d'erreur simple
       * - detail: message détaillé (DRF)
       * - non_field_errors: erreurs générales
       */
      throw new Error(data.message || data.detail || `Erreur ${response.status}`);
    }

    /**
     * Retourne les données parsées
     * Exemple: { data: { items: [...], total: 10 } }
     */
    return data;
    
  } catch (error) {
    /**
     * Capture toutes les erreurs :
     * - Erreurs réseau (fetch échoue)
     * - Erreurs de parsing JSON
     * - Erreurs HTTP (404, 403, 500)
     * - Erreurs personnalisées du backend
     */
    console.error('❌ API Error:', error);
    
    /**
     * Relance l'erreur pour qu'elle soit capturée par le composant appelant
     * Le composant pourra alors afficher un message à l'utilisateur
     */
    throw error;
  }
};

// ============================================================
// 4. MÉTHODES HTTP EXPORTÉES
// ============================================================

/**
 * Export des méthodes HTTP pour une utilisation simplifiée
 * 
 * Chaque méthode est une fonction qui appelle apiRequest avec la méthode appropriée
 * 
 * Exemple d'utilisation:
 *   api.get('/prospects')          → GET /user_api/ISETAG_COM.users/prospects/
 *   api.post('/prospects', {...})  → POST /user_api/ISETAG_COM.users/prospects/
 *   api.put('/prospects/1', {...}) → PUT /user_api/ISETAG_COM.users/prospects/1/
 *   api.delete('/prospects/1')     → DELETE /user_api/ISETAG_COM.users/prospects/1/
 */
export const api = {
  /**
   * Requête GET
   * Utilisée pour récupérer des données
   * Exemple: api.get('?search=test')
   */
  get: (endpoint) => apiRequest(endpoint, { method: 'GET' }),
  
  /**
   * Requête POST
   * Utilisée pour créer de nouvelles ressources
   * Exemple: api.post('', { nom: 'Test' })
   */
  post: (endpoint, body) => apiRequest(endpoint, { 
    method: 'POST', 
    body: JSON.stringify(body) 
  }),
  
  /**
   * Requête PUT
   * Utilisée pour remplacer complètement une ressource
   * Exemple: api.put('1/', { nom: 'Nouveau' })
   */
  put: (endpoint, body) => apiRequest(endpoint, { 
    method: 'PUT', 
    body: JSON.stringify(body) 
  }),
  
  /**
   * Requête PATCH
   * Utilisée pour modifier partiellement une ressource
   * Exemple: api.patch('1/', { nom: 'Modification' })
   */
  patch: (endpoint, body) => apiRequest(endpoint, { 
    method: 'PATCH', 
    body: JSON.stringify(body) 
  }),
  
  /**
   * Requête DELETE
   * Utilisée pour supprimer une ressource
   * Exemple: api.delete('1/')
   */
  delete: (endpoint) => apiRequest(endpoint, { method: 'DELETE' }),
};
