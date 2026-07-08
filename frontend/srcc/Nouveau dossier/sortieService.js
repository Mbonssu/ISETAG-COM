/**
 * Service de gestion des sorties (tournées terrain).
 *
 * Routes exposées par backend/ISETAG_COM_API/sortie_api/urls.py :
 *   /sortie_api/ISETAG_COM.sorties/        (GET liste, POST création)
 *   /sortie_api/ISETAG_COM.sorties/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/sortie_api/ISETAG_COM.sorties/';

export const sortieService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all sorties:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idSortie) => {
    console.log('📡 GET sortie by ID:', idSortie);
    return api.get(`${BASE_URL}${idSortie}/`);
  },

  create: (data) => {
    const payload = { idSortie: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE sortie:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idSortie, data) => {
    console.log('📝 UPDATE sortie:', idSortie, data);
    return api.put(`${BASE_URL}${idSortie}/`, data);
  },

  delete: (idSortie) => {
    console.log('🗑️ DELETE sortie:', idSortie);
    return api.delete(`${BASE_URL}${idSortie}/`);
  },
};
