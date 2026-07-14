/**
 * Service de gestion des filières.
 *
 * Routes exposées par backend/ISETAG_COM_API/filiere_api/urls.py :
 *   /filiere_api/ISETAG_COM.filieres/        (GET liste, POST création)
 *   /filiere_api/ISETAG_COM.filieres/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/filiere_api/ISETAG_COM.filieres/';

export const filiereService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all filieres:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idFiliere) => {
    console.log('📡 GET filiere by ID:', idFiliere);
    return api.get(`${BASE_URL}${idFiliere}/`);
  },

  create: (data) => {
    const payload = { idFiliere: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE filiere:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idFiliere, data) => {
    console.log('📝 UPDATE filiere:', idFiliere, data);
    return api.put(`${BASE_URL}${idFiliere}/`, data);
  },

  delete: (idFiliere) => {
    console.log('🗑️ DELETE filiere:', idFiliere);
    return api.delete(`${BASE_URL}${idFiliere}/`);
  },

  /** GET /filiere_api/ISETAG_COM.filieres/<pk>/specialites/ */
  getSpecialites: (idFiliere) => {
    console.log('📡 GET specialites for filiere:', idFiliere);
    return api.get(`${BASE_URL}${idFiliere}/specialites/`);
  },

  /** POST /filiere_api/ISETAG_COM.filieres/<pk>/specialites/ */
  addSpecialite: (idFiliere, data) => {
    console.log('📝 ADD specialite to filiere:', idFiliere, data);
    return api.post(`${BASE_URL}${idFiliere}/specialites/`, data);
  },
};
