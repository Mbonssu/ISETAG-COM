/**
 * Configuration de l'API - Point d'entrée pour toutes les communications avec le backend
 * 
 * Ce fichier gère toutes les requêtes HTTP vers l'API Django.
 * Il inclut la gestion des tokens CSRF, l'authentification JWT,
 * et le formatage des requêtes/réponses.
 */

// const API_BASE_URL = 'https://cake-reset-smoky.ngrok-free.dev';
// const API_BASE_URL = 'http://192.168.30.33:8000';
const API_BASE_URL = '';

const getApiUrl = (url) => {
  if (!url) return API_BASE_URL;
  if (/^https?:\/\//i.test(url)) return url;
  return `${API_BASE_URL}${url.startsWith('/') ? url : `/${url}`}`;
};

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
export const apiRequest = async (url, options = {}) => {
  // ============================================================
  // 3a. L'URL EST DÉJÀ COMPLÈTE
  // ============================================================

  /**
   * `url` doit être un chemin absolu fourni par le service appelant,
   * ex: '/user_api/ISETAG_COM.users/' ou '/user_api/ISETAG_COM.users/5/'
   * On ne préfixe plus rien automatiquement.
   */

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
  const isFormData = options.body instanceof FormData;

  const config = {
    // Spread operator pour inclure toutes les options passées
    ...options,
    
    // Configuration des headers HTTP
    headers: {
      // Indique que le corps de la requête est en JSON.
      // Exception : si on envoie du FormData (ex: upload photoProfil),
      // il ne faut PAS fixer Content-Type nous-mêmes : le navigateur
      // doit générer le bon "multipart/form-data; boundary=..." lui-même.
      ...(!isFormData && { 'Content-Type': 'application/json' }),
      
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
    const finalUrl = getApiUrl(url);
    const response = await fetch(finalUrl, config);
    
    /**
     * Vérifie le type de contenu de la réponse
     * Django peut renvoyer du JSON (normal) ou du HTML (en cas d'erreur)
     */
    const contentType = response.headers.get('content-type');
    
    /**
     * Parse la réponse en fonction de son type.
     * Cas particulier : un DELETE réussi renvoie souvent 204 No Content,
     * donc aucun corps à parser — il ne faut pas appeler response.json()
     * dans ce cas, sinon ça lève une erreur de parsing.
     */
    let data = null;
    if (response.status !== 204) {
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
        if (!response.ok) {
          throw new Error(`Erreur ${response.status}: ${text || 'réponse invalide du serveur'}`);
        }
        data = text;
      }
    }

    /**
     * Vérifie si la réponse est OK (status 200-299)
     * Si ce n'est pas le cas, on lance une erreur avec le message du backend
     */
    if (!response.ok) {
      /**
       * Le backend Django/DRF peut renvoyer plusieurs formats d'erreur :
       * - { detail: "..." }            -> erreur générale DRF
       * - { error: "..." }             -> erreur custom des vues de ce projet
       * - { nom: ["Le nom est requis"] } -> erreurs de validation par champ
       */
      const fieldErrors =
        data && typeof data === 'object'
          ? Object.entries(data)
              .filter(([key]) => !['detail', 'error', 'message'].includes(key))
              .map(([field, errs]) => `${field}: ${Array.isArray(errs) ? errs.join(', ') : errs}`)
              .join(' | ')
          : null;

      const message = data?.message || data?.detail || data?.error || fieldErrors || `Erreur ${response.status}`;

      const err = new Error(message);
      err.status = response.status;
      // On expose aussi `response` avec un `.data` et un `.json()` pour rester
      // compatible avec le code existant qui fait `error.response.data`
      // ou `await error.response.json()` (ex: UtilisateurForm.jsx).
      err.response = { status: response.status, data, json: async () => data };
      throw err;
    }

    /**
     * Retourne les données parsées.
     * Le backend de ce projet renvoie directement le JSON de DRF
     * (un tableau pour une liste, un objet pour un élément) —
     * PAS un objet enveloppé du type { data: { items: [...] } }.
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
 * Export des méthodes HTTP pour une utilisation simplifiée.
 *
 * Chaque méthode prend désormais une URL ABSOLUE (et non plus un simple
 * suffixe collé à une base figée) :
 *   api.get('/user_api/ISETAG_COM.users/')
 *   api.post('/user_api/ISETAG_COM.users/', { nom: 'Test' })
 *   api.put('/user_api/ISETAG_COM.users/APP-1234/', { nom: 'Nouveau' })
 *   api.delete('/user_api/ISETAG_COM.users/APP-1234/')
 */
export const api = {
  /** Requête GET. Exemple: api.get('/user_api/ISETAG_COM.users/?search=test') */
  get: (url) => apiRequest(url, { method: 'GET' }),

  /**
   * Requête POST. Accepte un objet JS classique (sera sérialisé en JSON)
   * ou un FormData (pour l'upload de fichiers, ex: photoProfil) — dans ce
   * cas il ne faut PAS appeler JSON.stringify dessus.
   */
  post: (url, body) =>
    apiRequest(url, {
      method: 'POST',
      body: body instanceof FormData ? body : JSON.stringify(body),
    }),

  /** Requête PUT. Même règle que POST pour le FormData. */
  put: (url, body) =>
    apiRequest(url, {
      method: 'PUT',
      body: body instanceof FormData ? body : JSON.stringify(body),
    }),

  /** Requête PATCH. Même règle que POST pour le FormData. */
  patch: (url, body) =>
    apiRequest(url, {
      method: 'PATCH',
      body: body instanceof FormData ? body : JSON.stringify(body),
    }),

  /** Requête DELETE. Exemple: api.delete('/user_api/ISETAG_COM.users/APP-1234/') */
  delete: (url) => apiRequest(url, { method: 'DELETE' }),
};