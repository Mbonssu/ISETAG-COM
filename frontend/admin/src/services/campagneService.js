
import { api } from './api';
const BASE_URL = '/campagne_api/ISETAG_COM.campagnes/';

// ============================================================
// 2. SERVICE DES CAMPAGNES
// ============================================================

export const campagneService = {

  // ============================================================
  // 2a. RÉCUPÉRATION DES CAMPAGNES
  // ============================================================

  /**
   * GET /campagne_api/ISETAG_COM.campagnes/ -> liste de toutes les campagnes (tableau direct)
   * 
   * @param {Object} params - Paramètres de recherche et filtrage
   * @param {string} params.search - Recherche par libellé
   * @param {string} params.type - Filtre par type (Email, SMS, Appel)
   * @param {string} params.status - Filtre par statut (Planifiée, En cours, Terminée)
   * @param {string} params.agentId - Filtre par agent responsable
   * @param {string} params.dateDebut - Filtre par date de début
   * @param {string} params.dateFin - Filtre par date de fin
   * @param {number} params.page - Numéro de page
   * @param {number} params.limit - Nombre d'éléments par page
   * 
   * @returns {Promise} - Promesse contenant la liste des campagnes
   * 
   * @example
   * // Récupérer toutes les campagnes
   * const campagnes = await campagneService.getAll();
   * 
   * // Récupérer avec filtres
   * const campagnes = await campagneService.getAll({ 
   *   type: 'Email', 
   *   status: 'En cours' 
   * });
   */
  getAll: (params = {}) => {
    //  Filtrer les paramètres undefined et null
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });

    const queryString = new URLSearchParams(cleanParams).toString();
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /**
   * 
   * @param {string} pk - L'identifiant de la campagne
   * @returns {Promise} - Promesse contenant les données de la campagne
   * 
   * @example
   * const campagne = await campagneService.getById('CAMP001');
   */
  getById: (pk) => {
    return api.get(`${BASE_URL}${pk}/`);
  },

  // ============================================================
  // 2b. CRÉATION D'UNE CAMPAGNE
  // ============================================================

  /**
   * POST /campagne_api/ISETAG_COM.campagnes/ -> créer une campagne
   * 
   * @param {Object} data - Les données de la campagne
   * @param {string} data.libelle - Nom de la campagne (obligatoire)
   * @param {string} data.type - Type de campagne (Email, SMS, Appel)
   * @param {string} data.statut - Statut (Planifiée, En cours, Terminée)
   * @param {string} data.dateDebut - Date de début (YYYY-MM-DD)
   * @param {string} data.dateFin - Date de fin (YYYY-MM-DD)
   * @param {string} data.objectif - Objectif de la campagne
   * @param {string} data.description - Description de la campagne
   * @param {string} data.agentId - ID de l'agent responsable
   * 
   * @returns {Promise} - Promesse contenant la campagne créée
   * 
   * @example
   * const newCampagne = await campagneService.create({
   *   libelle: 'Campagne Mai 2025',
   *   type: 'Email',
   *   statut: 'Planifiée',
   *   dateDebut: '2025-05-01',
   *   dateFin: '2025-05-31',
   *   objectif: '500 prospects',
   *   agentId: 'AGT001'
   * });
   */
  create: (data) => {
    return api.post(BASE_URL, data);
  },

  // ============================================================
  // 2c. MISE À JOUR D'UNE CAMPAGNE
  // ============================================================

  update: (pk, data) => {
    return api.put(`${BASE_URL}${pk}/`, data);
  },

  // ============================================================
  // 2d. SUPPRESSION D'UNE CAMPAGNE
  // ============================================================

  delete: (pk) => {
    return api.delete(`${BASE_URL}${pk}/`);
  },

  // ============================================================
  // 2e. PARTICIPATIONS (ressource séparée, PAS une sous-route de campagne)

  getParticipationsBySortie: (idSortie) => {
    return api.get(`/campagne_api/ISETAG_COM.participations/?idSortie=${idSortie}`);
  },

  getAllParticipations: () => {
    return api.get('/campagne_api/ISETAG_COM.participations/');
  },

  addParticipation: (data) => {
    const payload = { idParticipation: `TEMP-${Date.now()}`, ...data };
    return api.post('/campagne_api/ISETAG_COM.participations/', payload);
  },
teParticipation: (idParticipation, data) => {
    return api.put(`/campagne_api/ISETAG_COM.participations/${idParticipation}/`, { idParticipation, ...data });
  },


  deleteParticipation: (idParticipation) => {
    return api.delete(`/campagne_api/ISETAG_COM.participations/${idParticipation}/`);
  },

};