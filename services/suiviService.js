/**
 * Service de gestion des suivis.
 *
 * Routes exposées par backend/ISETAG_COM_API/suivi_api/urls.py :
 *   /suivi_api/ISETAG_COM.suivis/        (GET liste, POST création)
 *   /suivi_api/ISETAG_COM.suivis/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

// ============================================================
// 1. CONFIGURATION DE BASE
// ============================================================

/**
 * URL de base pour les endpoints liés aux suivis
 * Route Django : /suivi_api/ISETAG_COM.suivis/
 */
const BASE_URL = '/suivi_api/ISETAG_COM.suivis/';

// ============================================================
// 2. SERVICE DES SUIVIS
// ============================================================

export const suiviService = {

  // ============================================================
  // 2a. RÉCUPÉRATION DES SUIVIS
  // ============================================================

  /**
   * GET /suivi_api/ISETAG_COM.suivis/ -> liste de tous les suivis
   * 
   * @param {Object} params - Paramètres de filtrage (optionnel)
   * @param {string} params.prospect - Filtrer par prospect
   * @param {string} params.type - Filtrer par type de suivi
   * @param {string} params.agent - Filtrer par agent
   * @param {string} params.dateDebut - Filtrer par date de début
   * @param {string} params.dateFin - Filtrer par date de fin
   * 
   * @returns {Promise} - Promesse contenant la liste des suivis
   * 
   * @example
   * const suivis = await suiviService.getAll();
   * const suivisFiltres = await suiviService.getAll({ prospect: 'PROS-001', type: 'Appel' });
   */
  getAll: (params = {}) => {
    // Filtrer les paramètres undefined et null
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });

    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all suivis:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /**
   * GET /suivi_api/ISETAG_COM.suivis/<pk>/ -> un suivi précis
   * 
   * @param {string} id - L'identifiant du suivi
   * @returns {Promise} - Promesse contenant les données du suivi
   * 
   * @example
   * const suivi = await suiviService.getById('SUIV-001');
   */
  getById: (idSuivi) => {
    ('📡 GET suivi by ID:', idSuivi);
    return api.get(`${BASE_URL}${idSuivi}/`);
  },

  // ============================================================
  // 2b. CRÉATION D'UN SUIVI
  // ============================================================

  /**
   * POST /suivi_api/ISETAG_COM.suivis/ -> créer un suivi
   * 
   * @param {Object} data - Les données du suivi
   * @param {string} data.idProspect - ID du prospect (obligatoire)
   * @param {string} data.dateSuivi - Date du suivi (YYYY-MM-DD)
   * @param {string} data.typeSuivi - Type de suivi (Appel, Email, Visite, SMS, Autre)
   * @param {string} data.commentaire - Commentaire sur le suivi
   * @param {string} data.prochainAction - Prochaine action à réaliser
   * @param {string} data.idUtilisateur - ID de l'agent responsable (obligatoire)
   * @param {string} data.statut - Statut du suivi (Optionnel)
   * 
   * @returns {Promise} - Promesse contenant le suivi créé
   * 
   * @example
   * const newSuivi = await suiviService.create({
   *   idProspect: 'PROS-001',
   *   dateSuivi: '2026-06-18',
   *   typeSuivi: 'Appel',
   *   commentaire: 'Premier contact, prospect intéressé',
   *   prochainAction: 'Rappeler dans 2 jours',
   *   idAgent: 'AGT-001'
   * });
   */
  create: (data) => {
    // Ajouter un ID temporaire si nécessaire (comme pour les autres services)
    const payload = { idSuivi: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE suivi:', payload);
    return api.post(BASE_URL, payload);
  },

  // ============================================================
  // 2c. MISE À JOUR D'UN SUIVI
  // ============================================================

  /**
   * PUT /suivi_api/ISETAG_COM.suivis/<pk>/ -> mise à jour complète
   * 
   * @param {string} idSuivi - L'identifiant du suivi
   * @param {Object} data - Les nouvelles données
   * @param {string} data.idProspect - ID du prospect
   * @param {string} data.dateSuivi - Date du suivi
   * @param {string} data.typeSuivi - Type de suivi
   * @param {string} data.commentaire - Commentaire
   * @param {string} data.prochainAction - Prochaine action
   * @param {string} data.idUtilisateur - ID de l'agent
   * @param {string} data.statut - Statut du suivi
   * 
   * @returns {Promise} - Promesse contenant le suivi mis à jour
   * 
   * @example
   * const updatedSuivi = await suiviService.update('SUIV-001', {
   *   commentaire: 'Prospect rappelé, toujours intéressé',
   *   prochainAction: 'Envoyer documentation'
   * });
   */
  update: (idSuivi, data) => {
    ('📝 UPDATE suivi:', idSuivi, data);
    return api.put(`${BASE_URL}${idSuivi}/`, data);
  },

  // ============================================================
  // 2d. SUPPRESSION D'UN SUIVI
  // ============================================================

  /**
   * DELETE /suivi_api/ISETAG_COM.suivis/<pk>/ -> supprimer un suivi
   * 
   *  Cette action est irréversible !
   * 
   * @param {string} idSuivi - L'identifiant du suivi
   * @returns {Promise} - Promesse confirmant la suppression
   * 
   * @example
   * await suiviService.delete('SUIV-001');
   */
  delete: (idSuivi) => {
    ('🗑️ DELETE suivi:', idSuivi);
    return api.delete(`${BASE_URL}${idSuivi}/`);
  },

  // ============================================================
  // 2e. STATISTIQUES DES SUIVIS
  // ============================================================

  /**
   * GET /suivi_api/ISETAG_COM.suivis/stats/ -> statistiques des suivis
   * 
   * @param {Object} params - Paramètres de filtrage (optionnel)
   * @param {string} params.prospect - Filtrer par prospect
   * @param {string} params.agent - Filtrer par agent
   * @param {string} params.dateDebut - Date de début
   * @param {string} params.dateFin - Date de fin
   * 
   * @returns {Promise} - Promesse contenant les statistiques
   * 
   * @example
   * const stats = await suiviService.getStats();
   * const statsAgent = await suiviService.getStats({ agent: 'AGT-001' });
   */
  getStats: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📊 GET suivis stats:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}stats?${queryString}` : `${BASE_URL}stats`);
  },

  // ============================================================
  // 2f. SUIVIS PAR PROSPECT
  // ============================================================

  /**
   * GET /suivi_api/ISETAG_COM.suivis/prospect/<prospectId>/ -> suivis d'un prospect
   * 
   * @param {string} idProspect - L'identifiant du prospect
   * @param {Object} params - Paramètres de filtrage (optionnel)
   * @param {string} params.type - Filtrer par type de suivi
   * @param {string} params.dateDebut - Date de début
   * @param {string} params.dateFin - Date de fin
   * 
   * @returns {Promise} - Promesse contenant les suivis du prospect
   * 
   * @example
   * const suivisProspect = await suiviService.getByProspect('PROS-001');
   */
  getByProspect: (idProspect, params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET suivis for prospect:', idProspect, queryString);
    return api.get(queryString ? `${BASE_URL}prospect/${idProspect}/?${queryString}` : `${BASE_URL}prospect/${idProspect}/`);
  },

  // ============================================================
  // 2g. SUIVIS PAR AGENT
  // ============================================================

  /**
   * GET /suivi_api/ISETAG_COM.suivis/agent/<agentId>/ -> suivis d'un agent
   * 
   * @param {string} idUtilisateur - L'identifiant de l'agent
   * @param {Object} params - Paramètres de filtrage (optionnel)
   * @param {string} params.type - Filtrer par type de suivi
   * @param {string} params.dateDebut - Date de début
   * @param {string} params.dateFin - Date de fin
   * 
   * @returns {Promise} - Promesse contenant les suivis de l'agent
   * 
   * @example
   * const suivisAgent = await suiviService.getByAgent('AGT-001');
   */
  getByAgent: (idUtilisateur, params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET suivis for agent:', idUtilisateur, queryString);
    return api.get(queryString ? `${BASE_URL}/${idUtilisateur}/?${queryString}` : `${BASE_URL}/${idUtilisateur}/`);
  },

  // ============================================================
  // 2h. EXPORT DES SUIVIS
  // ============================================================

  /**
   * GET /suivi_api/ISETAG_COM.suivis/export?format=excel -> export des suivis
   * 
   * @param {string} format - Format d'export ('excel', 'csv', 'pdf')
   * @param {Object} params - Paramètres de filtrage pour l'export
   * 
   * @returns {Promise} - Promesse contenant le fichier exporté
   * 
   * @example
   * await suiviService.export('excel', { agent: 'AGT-001' });
   */
  export: (format = 'excel', params = {}) => {
    ('📤 Export suivis as:', format);
    const cleanParams = { format, ...params };
    Object.keys(cleanParams).forEach(key => {
      if (cleanParams[key] === undefined || cleanParams[key] === null || cleanParams[key] === '') {
        delete cleanParams[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    return api.get(`${BASE_URL}export?${queryString}`);
  }
};
