/**
 * Service de gestion des fiches prospect.
 *
 * Routes exposées par backend/ISETAG_COM_API/fiche_api/urls.py :
 *   /fiche_api/ISETAG_COM.fiches/        (GET liste, POST création)
 *   /fiche_api/ISETAG_COM.fiches/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/fiche_api/ISETAG_COM.fiches/';

export const ficheService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all fiches:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idFiche) => {
    console.log('📡 GET fiche by ID:', idFiche);
    return api.get(`${BASE_URL}${idFiche}/`);
  },

  create: (data) => {
    const payload = { idFiche: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE fiche:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idFiche, data) => {
    console.log('📝 UPDATE fiche:', idFiche, data);
    return api.put(`${BASE_URL}${idFiche}/`, data);
  },

  delete: (idFiche) => {
    console.log('🗑️ DELETE fiche:', idFiche);
    return api.delete(`${BASE_URL}${idFiche}/`);
  },
};
