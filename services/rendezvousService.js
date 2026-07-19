/**
 * Service de gestion des rendez-vous.
 *
 * Routes exposées par backend/ISETAG_COM_API/rendezvous_api/urls.py :
 *   /rendezvous_api/ISETAG_COM.rendezvous/        (GET liste, POST création)
 *   /rendezvous_api/ISETAG_COM.rendezvous/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/rendezvous_api/ISETAG_COM.rendezvous/';

export const rendezvousService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all rendezvous:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idRdv) => {
    ('📡 GET rendez-vous by ID:', idRdv);
    return api.get(`${BASE_URL}${idRdv}/`);
  },

  create: (data) => {
    const payload = { idRdv: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE rendez-vous:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idRdv, data) => {
    ('📝 UPDATE rendez-vous:', idRdv, data);
    return api.put(`${BASE_URL}${idRdv}/`, data);
  },

  delete: (idRdv) => {
    ('🗑️ DELETE rendez-vous:', idRdv);
    return api.delete(`${BASE_URL}${idRdv}/`);
  },
};
