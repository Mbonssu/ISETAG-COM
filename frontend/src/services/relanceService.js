// services/relanceService.js

import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.relances/';

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
    //  L'API attend exactement ces champs
    const payload = {
      idRelance: data.idRelance || `REL-${Date.now()}`,
      idProspect: data.idProspect,
      dateRelance: data.dateRelance || new Date().toISOString(),
      sujet: data.sujet || '',
      description: data.description || '',
    };
    ('📝 CREATE relance:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idRelance, data) => {
    const payload = {
      idRelance: idRelance,
      idProspect: data.idProspect,
      dateRelance: data.dateRelance,
      sujet: data.sujet || '',
      description: data.description || '',
    };
    ('📝 UPDATE relance:', idRelance, payload);
    return api.put(`${BASE_URL}${idRelance}/`, payload);
  },

  delete: (idRelance) => {
    ('🗑️ DELETE relance:', idRelance);
    return api.delete(`${BASE_URL}${idRelance}/`);
  },
};