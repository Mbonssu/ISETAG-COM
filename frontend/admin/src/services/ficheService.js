import { api } from './api';

const BASE_URL = '/campagne_api/ISETAG_COM.fiches-sortie/';

export const ficheService = {

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

  getById: (idFiche) => {
    return api.get(`${BASE_URL}${idFiche}/`);
  },

    // services/ficheService.js - Ajouter cette méthode

  getBySortie: (idSortie, idAgent = null) => {
    // console.log('📡 GET fiches by sortie:', idSortie, 'agent:', idAgent);
    let url = `${BASE_URL}?idSortie=${idSortie}`;
    if (idAgent) {
      url += `&idAgent=${idAgent}`;
    }
    return api.get(url);
  },

  create: (data) => {
    const payload = { idFiche: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  update: (idFiche, data) => {
    return api.put(`${BASE_URL}${idFiche}/`, data);
  },

  delete: (idFiche) => {
    return api.delete(`${BASE_URL}${idFiche}/`);
  },
};
