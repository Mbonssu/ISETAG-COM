/**
 * Service de gestion des relances.
 *
 * Routes exposées par backend/ISETAG_COM_API/relance_api/urls.py :
 *   /relance_api/ISETAG_COM.relances/        (GET liste, POST création)
 *   /relance_api/ISETAG_COM.relances/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/relance_api/ISETAG_COM.relances/';

export const relanceService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all relances:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idRelance) => {
    ('📡 GET relance by ID:', idRelance);
    return api.get(`${BASE_URL}${idRelance}/`);
  },

  create: (data) => {
    const payload = { idRelance: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE relance:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idRelance, data) => {
    ('📝 UPDATE relance:', idRelance, data);
    return api.put(`${BASE_URL}${idRelance}/`, data);
  },

  delete: (idRelance) => {
    ('🗑️ DELETE relance:', idRelance);
    return api.delete(`${BASE_URL}${idRelance}/`);
  },
};
