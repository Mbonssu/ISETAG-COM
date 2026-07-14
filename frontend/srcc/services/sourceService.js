/**
 * Service de gestion des sources.
 *
 * Routes exposées par backend/ISETAG_COM_API/source_api/urls.py :
 *   /source_api/ISETAG_COM.sources/        (GET liste, POST création)
 *   /source_api/ISETAG_COM.sources/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/source_api/ISETAG_COM.sources/';

export const sourceService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all sources:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idSource) => {
    console.log('📡 GET source by ID:', idSource);
    return api.get(`${BASE_URL}${idSource}/`);
  },

  create: (data) => {
    const payload = { idSource: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE source:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idSource, data) => {
    console.log('📝 UPDATE source:', idSource, data);
    return api.put(`${BASE_URL}${idSource}/`, data);
  },

  delete: (idSource) => {
    console.log('🗑️ DELETE source:', idSource);
    return api.delete(`${BASE_URL}${idSource}/`);
  },
};
