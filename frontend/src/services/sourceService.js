/**
 * Service de gestion des sources.
 *
 * Route réelle confirmée dans ISETAG_COM_API.yaml :
 *   /campagne_api/ISETAG_COM.sources/        (GET liste, POST création)
 *   /campagne_api/ISETAG_COM.sources/<id>/   (GET un, PUT, DELETE)
 *
 *  Corrigé : l'ancienne URL "/source_api/ISETAG_COM.sources/" n'existe
 * pas dans l'API. Les sources sont exposées sous le préfixe "campagne_api".
 */

import { api } from './api';

const BASE_URL = '/campagne_api/ISETAG_COM.sources/';

export const sourceService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all sources:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idSource) => {
    ('📡 GET source by ID:', idSource);
    return api.get(`${BASE_URL}${idSource}/`);
  },

  create: (data) => {
    const payload = { idSource: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE source:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idSource, data) => {
    ('📝 UPDATE source:', idSource, data);
    return api.put(`${BASE_URL}${idSource}/`, data);
  },

  delete: (idSource) => {
    ('🗑️ DELETE source:', idSource);
    return api.delete(`${BASE_URL}${idSource}/`);
  },
};
