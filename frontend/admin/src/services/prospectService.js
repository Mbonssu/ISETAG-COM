/**
 * Service de gestion des prospects
 * 
 * Ce fichier contient toutes les fonctions liées à la gestion des prospects.
 * Il fait le lien entre les composants React et l'API Django pour les opérations CRUD.
 * 
 * Toutes les fonctions utilisent l'objet 'api' qui gère automatiquement :
 * - Les tokens CSRF pour les requêtes sécurisées
 * - L'authentification JWT
 * - Le formatage des requêtes et réponses
 * - La gestion des erreurs
 */

import { api } from './api';

// ============================================================
// 1. CONFIGURATION DE BASE
// ============================================================

/**
 * URL de base pour les endpoints liés aux prospects
 * 
 * L'URL complète sera construite en concaténant avec l'URL de base de l'API
 * Définie dans api.js : '/user_api/ISETAG_COM.users/'
 * 
 * Résultat final : '/user_api/ISETAG_COM.users/prospects/'
 */
const BASE_URL = '/prospects';

// ============================================================
// 2. SERVICE DES PROSPECTS
// ============================================================

export const prospectService = {
  
  // ============================================================
  // 2a. RÉCUPÉRATION DES PROSPECTS
  // ============================================================

  /**
   * Récupère la liste de tous les prospects avec pagination et filtres
   * 
   * Correspond à l'endpoint GET /prospects
   * 
   * @param {Object} params - Paramètres de recherche et filtrage
   * @param {string} params.search - Terme de recherche (nom, email, téléphone)
   * @param {string} params.status - Filtre par statut
   * @param {string} params.source - Filtre par source
   * @param {string} params.filiere - Filtre par filière
   * @param {number} params.page - Numéro de page pour la pagination
   * @param {number} params.limit - Nombre d'éléments par page
   * @param {string} params.sort - Tri des résultats (ex: 'createdAt:desc')
   * 
   * @returns {Promise} - Promesse contenant la liste des prospects
   * 
   * @example
   * // Récupérer tous les prospects
   * const prospects = await prospectService.getAll();
   * 
   * // Récupérer avec recherche
   * const prospects = await prospectService.getAll({ 
   *   search: 'Marie', 
   *   status: 'À relancer' 
   * });
   * 
   * // Récupérer avec pagination
   * const prospects = await prospectService.getAll({ 
   *   page: 2, 
   *   limit: 20 
   * });
   */
  getAll: (params = {}) => {
    /**
     * URLSearchParams convertit un objet JavaScript en chaîne de requête
     * 
     * Exemple: 
     *   { search: 'Marie', status: 'À relancer', page: 1 }
     *   → 'search=Marie&status=%C3%80%20relancer&page=1'
     * 
     * Cette chaîne est ajoutée à l'URL pour filtrer les résultats
     */
    const queryString = new URLSearchParams(params).toString();
    console.log('📡 GET all prospects:', queryString);
    
    /**
     * Appelle la méthode GET de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects?search=Marie
     */
    return api.get(`${BASE_URL}?${queryString}`);
  },

  /**
   * Récupère un prospect spécifique par son ID
   * 
   * Correspond à l'endpoint GET /prospects/{id}
   * 
   * @param {string} id - L'identifiant unique du prospect
   * @returns {Promise} - Promesse contenant les données du prospect
   * 
   * @example
   * // Récupérer le prospect avec l'ID 'P001'
   * const prospect = await prospectService.getById('P001');
   */
  getById: (id) => {
    console.log('📡 GET prospect by ID:', id);
    
    /**
     * Appelle la méthode GET de l'API avec l'ID dans l'URL
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/P001
     */
    return api.get(`${BASE_URL}/${id}`);
  },

  // ============================================================
  // 2b. CRÉATION D'UN PROSPECT
  // ============================================================

  /**
   * Crée un nouveau prospect dans la base de données
   * 
   * Correspond à l'endpoint POST /prospects
   * 
   * @param {Object} data - Les données du nouveau prospect
   * @param {string} data.nomComplet - Nom complet du prospect
   * @param {string} data.telephone - Numéro de téléphone
   * @param {string} data.email - Adresse email
   * @param {string} data.niveauEtude - Niveau d'étude (Terminale, Bac+1, etc.)
   * @param {string} data.concerne - Établissement concerné
   * @param {string} data.adresse - Adresse complète
   * @param {string} data.sexe - Sexe (M ou F)
   * @param {string} data.typeProspect - Type de prospect (Etudiant, Parent, etc.)
   * @param {string} data.source - Source de provenance
   * @param {string} data.status - Statut du prospect
   * @param {string} data.agentId - ID de l'agent assigné
   * 
   * @returns {Promise} - Promesse contenant le prospect créé
   * 
   * @example
   * const newProspect = await prospectService.create({
   *   nomComplet: 'Jean Dupont',
   *   telephone: '691234567',
   *   email: 'jean@example.com',
   *   niveauEtude: 'Terminale',
   *   concerne: 'Lycée de Biyem-Assi',
   *   adresse: 'Biyem-Assi, Yaoundé',
   *   sexe: 'M',
   *   typeProspect: 'Etudiant',
   *   source: 'Lycée',
   *   status: 'Nouveau'
   * });
   */
  create: (data) => {
    console.log('📝 CREATE prospect:', data);
    
    /**
     * Appelle la méthode POST de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects
     * Les données sont automatiquement converties en JSON
     */
    return api.post(BASE_URL, data);
  },

  // ============================================================
  // 2c. MISE À JOUR D'UN PROSPECT
  // ============================================================

  /**
   * Met à jour un prospect existant
   * 
   * Correspond à l'endpoint PUT /prospects/{id}
   * 
   * @param {string} id - L'identifiant du prospect à modifier
   * @param {Object} data - Les nouvelles données
   * @param {string} data.nomComplet - Nouveau nom complet
   * @param {string} data.telephone - Nouveau téléphone
   * @param {string} data.email - Nouvel email
   * @param {string} data.niveauEtude - Nouveau niveau d'étude
   * @param {string} data.concerne - Nouvel établissement concerné
   * @param {string} data.adresse - Nouvelle adresse
   * @param {string} data.sexe - Nouveau sexe
   * @param {string} data.typeProspect - Nouveau type de prospect
   * @param {string} data.status - Nouveau statut
   * @param {string} data.agentId - Nouvel ID de l'agent assigné
   * 
   * @returns {Promise} - Promesse contenant le prospect mis à jour
   * 
   * @example
   * const updatedProspect = await prospectService.update('P001', {
   *   nomComplet: 'Jean-Pierre Dupont',
   *   status: 'Contacté',
   *   agentId: 'AGT002'
   * });
   */
  update: (id, data) => {
    console.log('📝 UPDATE prospect:', id, data);
    
    /**
     * Appelle la méthode PUT de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/P001
     */
    return api.put(`${BASE_URL}/${id}`, data);
  },

  // ============================================================
  // 2d. SUPPRESSION D'UN PROSPECT
  // ============================================================

  /**
   * Supprime un prospect de la base de données
   * 
   * Correspond à l'endpoint DELETE /prospects/{id}
   * 
   * ⚠️ Cette action est irréversible !
   * 
   * @param {string} id - L'identifiant du prospect à supprimer
   * @returns {Promise} - Promesse confirmant la suppression
   * 
   * @example
   * // Supprimer le prospect avec l'ID 'P001'
   * await prospectService.delete('P001');
   */
  delete: (id) => {
    console.log('🗑️ DELETE prospect:', id);
    
    /**
     * Appelle la méthode DELETE de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/P001
     */
    return api.delete(`${BASE_URL}/${id}`);
  },

  // ============================================================
  // 2e. GESTION DES INTÉRÊTS D'UN PROSPECT
  // ============================================================

  /**
   * Récupère la liste des intérêts d'un prospect
   * 
   * Correspond à l'endpoint GET /prospects/{id}/interets
   * 
   * Les intérêts représentent les filières et spécialités qui intéressent le prospect
   * 
   * @param {string} prospectId - L'identifiant du prospect
   * @returns {Promise} - Promesse contenant la liste des intérêts
   * 
   * @example
   * // Récupérer les intérêts du prospect 'P001'
   * const interets = await prospectService.getInterets('P001');
   */
  getInterets: (prospectId) => {
    console.log('📡 GET interets for prospect:', prospectId);
    
    /**
     * Appelle la méthode GET de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/P001/interets
     */
    return api.get(`${BASE_URL}/${prospectId}/interets`);
  },

  /**
   * Ajoute un intérêt à un prospect (filière/spécialité)
   * 
   * Correspond à l'endpoint POST /prospects/{id}/interets
   * 
   * @param {string} prospectId - L'identifiant du prospect
   * @param {Object} data - Les données de l'intérêt
   * @param {string} data.filiereId - ID de la filière
   * @param {string} data.specialiteId - ID de la spécialité (optionnel)
   * @param {number} data.ordrePreference - Ordre de préférence (1, 2, 3...)
   * @param {number} data.niveauInteret - Niveau d'intérêt (0-100)
   * @param {string} data.commentaire - Commentaire sur l'intérêt
   * 
   * @returns {Promise} - Promesse contenant l'intérêt créé
   * 
   * @example
   * await prospectService.addInteret('P001', {
   *   filiereId: 'F001',
   *   specialiteId: 'S001',
   *   ordrePreference: 1,
   *   niveauInteret: 95,
   *   commentaire: 'Très motivé'
   * });
   */
  addInteret: (prospectId, data) => {
    console.log('📝 ADD interet for prospect:', prospectId, data);
    
    /**
     * Appelle la méthode POST de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/P001/interets
     */
    return api.post(`${BASE_URL}/${prospectId}/interets`, data);
  },

  /**
   * Supprime un intérêt spécifique d'un prospect
   * 
   * Correspond à l'endpoint DELETE /prospects/{id}/interets/{interetId}
   * 
   * @param {string} prospectId - L'identifiant du prospect
   * @param {string} interetId - L'identifiant de l'intérêt à supprimer
   * @returns {Promise} - Promesse confirmant la suppression
   * 
   * @example
   * // Supprimer l'intérêt avec l'ID 'I001' du prospect 'P001'
   * await prospectService.deleteInteret('P001', 'I001');
   */
  deleteInteret: (prospectId, interetId) => {
    console.log('🗑️ DELETE interet:', interetId, 'from prospect:', prospectId);
    
    /**
     * Appelle la méthode DELETE de l'API
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/P001/interets/I001
     */
    return api.delete(`${BASE_URL}/${prospectId}/interets/${interetId}`);
  },

  // ============================================================
  // 2f. EXPORT DES PROSPECTS
  // ============================================================

  /**
   * Exporte les prospects dans différents formats
   * 
   * Correspond à l'endpoint GET /prospects/export
   * 
   * @param {string} format - Format d'export ('excel', 'csv', 'pdf', 'json')
   * @param {Object} params - Paramètres de filtrage pour l'export
   * @returns {Promise} - Promesse contenant le fichier exporté
   * 
   * @example
   * // Exporter en Excel
   * await prospectService.export('excel');
   * 
   * // Exporter en CSV avec filtres
   * await prospectService.export('csv', { 
   *   status: 'Converti',
   *   dateStart: '2026-01-01',
   *   dateEnd: '2026-06-16'
   * });
   */
  export: (format = 'excel', params = {}) => {
    console.log('📤 Export prospects as:', format);
    
    /**
     * Construit la chaîne de requête avec les paramètres
     * Ajoute le format à l'URL
     */
    const queryString = new URLSearchParams({
      format: format,
      ...params
    }).toString();
    
    /**
     * Appelle la méthode GET de l'API pour l'export
     * L'URL finale sera: /user_api/ISETAG_COM.users/prospects/export?format=excel
     * 
     * Note: Les exports retournent généralement un blob (fichier)
     * et non du JSON. Le traitement est fait dans le composant.
     */
    return api.get(`${BASE_URL}/export?${queryString}`);
  }
};
