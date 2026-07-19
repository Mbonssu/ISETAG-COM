import { api } from './api';

const BASE_URL = '/campagne_api/ISETAG_COM.etablissements/';

export const etablissementService = {

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

  getById: (idEtablissement) => {
    return api.get(`${BASE_URL}${idEtablissement}/`);
  },

  create: (data) => {
    const payload = { idEtablissement: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  update: (idEtablissement, data) => {
    return api.put(`${BASE_URL}${idEtablissement}/`, data);
  },

  delete: (idEtablissement) => {
    return api.delete(`${BASE_URL}${idEtablissement}/`);
  },
};
