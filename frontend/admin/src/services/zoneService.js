import { api } from './api';

const BASE_URL = '/campagne_api/ISETAG_COM.zones/';

export const zoneService = {

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

  getById: (idZone) => {
    return api.get(`${BASE_URL}${idZone}/`);
  },

  create: (data) => {
    const payload = { idZone: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  update: (idZone, data) => {
    return api.put(`${BASE_URL}${idZone}/`, data);
  },

  delete: (idZone) => {
    return api.delete(`${BASE_URL}${idZone}/`);
  },
};
