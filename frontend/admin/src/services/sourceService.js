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
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idSource) => {
    return api.get(`${BASE_URL}${idSource}/`);
  },

  create: (data) => {
    const payload = { idSource: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  update: (idSource, data) => {
    return api.put(`${BASE_URL}${idSource}/`, data);
  },

  delete: (idSource) => {
    return api.delete(`${BASE_URL}${idSource}/`);
  },
};
