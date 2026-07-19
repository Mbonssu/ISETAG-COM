import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.suivis/';

export const suiviService = {

  /**
   * GET /prospect_api/ISETAG_COM.suivis/ -> liste de tous les suivis
   *
   * @param {Object} params - Paramètres de filtrage (optionnel)
   */
  getAll: (params = {}) => {
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
   * GET /prospect_api/ISETAG_COM.suivis/<id>/ -> un suivi précis
   */
  getById: (idSuivi) => {
    return api.get(`${BASE_URL}${idSuivi}/`);
  },

  /**
   * POST /prospect_api/ISETAG_COM.suivis/ -> créer un suivi
   *
   * Champs attendus (schéma SuiviProspectRequest) :
   *   idSuivi, idProspect, libeleSuivi, dateSuivi, commentaire
   */
  create: (data) => {
    const payload = { idSuivi: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  /**
   * PUT /prospect_api/ISETAG_COM.suivis/<id>/ -> mise à jour complète
   */
  update: (idSuivi, data) => {
    return api.put(`${BASE_URL}${idSuivi}/`, data);
  },

  /**
   * DELETE /prospect_api/ISETAG_COM.suivis/<id>/ -> supprimer un suivi
   */
  delete: (idSuivi) => {
    return api.delete(`${BASE_URL}${idSuivi}/`);
  },
};