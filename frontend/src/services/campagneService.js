// import { api } from './api';

// const BASE_URL = '/campagnes';

// export const campagneService = {
//   getAll: (params = {}) => {
//     const queryString = new URLSearchParams(params).toString();
//     return api.get(`${BASE_URL}?${queryString}`);
//   },
//   getById: (id) => api.get(`${BASE_URL}/${id}`),
//   create: (data) => api.post(BASE_URL, data),
//   update: (id, data) => api.put(`${BASE_URL}/${id}`, data),
//   delete: (id) => api.delete(`${BASE_URL}/${id}`),
//   getParticipations: (campagneId) => api.get(`${BASE_URL}/${campagneId}/participations`),
//   addParticipation: (campagneId, data) => api.post(`${BASE_URL}/${campagneId}/participations`, data),
//   getStats: (id) => api.get(`${BASE_URL}/${id}/stats`)
// };


/**
 * Service de gestion des campagnes
 * 
 * Route réellement exposée par backend/ISETAG_COM_API/campagne_api/urls.py
 * URL de base : /campagne_api/ISETAG_COM.campagnes/
 */

import { api } from './api';

// ============================================================
// 1. CONFIGURATION DE BASE
// ============================================================

/**
 * URL de base pour les endpoints liés aux campagnes
 * Adaptée à la route Django : /campagne_api/ISETAG_COM.campagnes/
 */
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
    // ✅ Filtrer les paramètres undefined et null
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });

    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all campagnes:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /**
   * GET /campagne_api/ISETAG_COM.campagnes/<pk>/ -> une campagne précise
   * 
   * @param {string} pk - L'identifiant de la campagne
   * @returns {Promise} - Promesse contenant les données de la campagne
   * 
   * @example
   * const campagne = await campagneService.getById('CAMP001');
   */
  getById: (pk) => {
    console.log('📡 GET campagne by id:', pk);
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
    console.log('📡 POST create campagne:', data);
    return api.post(BASE_URL, data);
  },

  // ============================================================
  // 2c. MISE À JOUR D'UNE CAMPAGNE
  // ============================================================

  /**
   * PUT /campagne_api/ISETAG_COM.campagnes/<pk>/ -> mise à jour complète
   * 
   * @param {string} pk - L'identifiant de la campagne
   * @param {Object} data - Les nouvelles données
   * @param {string} data.libelle - Nouveau nom
   * @param {string} data.type - Nouveau type
   * @param {string} data.statut - Nouveau statut
   * @param {string} data.dateDebut - Nouvelle date de début
   * @param {string} data.dateFin - Nouvelle date de fin
   * @param {string} data.objectif - Nouvel objectif
   * @param {string} data.description - Nouvelle description
   * @param {string} data.agentId - Nouvel agent responsable
   * 
   * @returns {Promise} - Promesse contenant la campagne mise à jour
   * 
   * @example
   * const updatedCampagne = await campagneService.update('CAMP001', {
   *   statut: 'En cours',
   *   objectif: '600 prospects'
   * });
   */
  update: (pk, data) => {
    console.log('📡 PUT update campagne:', pk, data);
    return api.put(`${BASE_URL}${pk}/`, data);
  },

  // ============================================================
  // 2d. SUPPRESSION D'UNE CAMPAGNE
  // ============================================================

  /**
   * DELETE /campagne_api/ISETAG_COM.campagnes/<pk>/ -> supprimer une campagne
   * 
   * ⚠️ Cette action est irréversible !
   * 
   * @param {string} pk - L'identifiant de la campagne
   * @returns {Promise} - Promesse confirmant la suppression
   * 
   * @example
   * await campagneService.delete('CAMP001');
   */
  delete: (pk) => {
    console.log('📡 DELETE campagne:', pk);
    return api.delete(`${BASE_URL}${pk}/`);
  },

  // ============================================================
  // 2e. PARTICIPATIONS (ressource séparée, PAS une sous-route de campagne)
  // ============================================================

  /**
   * ⚠️ CORRIGÉ : il n'existe AUCUNE route
   * "/campagne_api/ISETAG_COM.campagnes/<id>/participations/".
   * Les participations sont une ressource indépendante :
   *
   *   /campagne_api/ISETAG_COM.participations/
   *
   * et le modèle Participation ne référence pas idCampagne : il relie
   * idUtilisateur <-> idSortie (schéma ParticipationRequest). Pour avoir
   * les participations d'une campagne, il faut donc passer par ses
   * sorties (sortieService), pas directement par cet endpoint.
   *
   * Cette méthode récupère ici les participations liées à UNE SORTIE
   * (idSortie), ce qui correspond à ce que le backend expose réellement.
   *
   * @param {string} idSortie - L'identifiant de la sortie
   */
  getParticipationsBySortie: (idSortie) => {
    console.log('📡 GET participations for sortie:', idSortie);
    return api.get(`/campagne_api/ISETAG_COM.participations/?idSortie=${idSortie}`);
  },

  /**
   * POST /campagne_api/ISETAG_COM.participations/ -> créer une participation
   *
   * Champs attendus (schéma ParticipationRequest) :
   *   idParticipation, idUtilisateur, idSortie, dateAssignation,
   *   heureArrivee, heureDepart, statut, observation
   *
   * @param {Object} data
   */
  addParticipation: (data) => {
    const payload = { idParticipation: `TEMP-${Date.now()}`, ...data };
    console.log('📝 POST create participation:', payload);
    return api.post('/campagne_api/ISETAG_COM.participations/', payload);
  },

  // ============================================================
  // getStats() et export() ont été retirées : aucune route
  // ".../<id>/stats/" ou ".../export" n'existe dans le schéma OpenAPI
  // pour les campagnes.
  // ============================================================
};