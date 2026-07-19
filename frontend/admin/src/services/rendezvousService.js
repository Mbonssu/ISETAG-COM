
import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.rendezvous/';

export const rendezvousService = {

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

  getById: (idRendezVous) => {
    return api.get(`${BASE_URL}${idRendezVous}/`);
  },

  create: (data) => {
    const payload = { idRendezVous: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  update: (idRendezVous, data) => {
    return api.put(`${BASE_URL}${idRendezVous}/`, data);
  },

  delete: (idRendezVous) => {
    return api.delete(`${BASE_URL}${idRendezVous}/`);
  },
};
