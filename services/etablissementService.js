/**
 * Service de gestion des établissements.
 *
 * Routes exposées par backend/ISETAG_COM_API/etablissement_api/urls.py :
 *   /etablissement_api/ISETAG_COM.etablissements/        (GET liste, POST création)
 *   /etablissement_api/ISETAG_COM.etablissements/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/etablissement_api/ISETAG_COM.etablissements/';

export const etablissementService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all etablissements:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idEtablissement) => {
    console.log('📡 GET etablissement by ID:', idEtablissement);
    return api.get(`${BASE_URL}${idEtablissement}/`);
  },

  create: (data) => {
    const payload = { idEtablissement: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE etablissement:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idEtablissement, data) => {
    console.log('📝 UPDATE etablissement:', idEtablissement, data);
    return api.put(`${BASE_URL}${idEtablissement}/`, data);
  },

  delete: (idEtablissement) => {
    console.log('🗑️ DELETE etablissement:', idEtablissement);
    return api.delete(`${BASE_URL}${idEtablissement}/`);
  },

  /**
   * GET /etablissement_api/ISETAG_COM.etablissements/<pk>/classes/
   * -> Récupère les classes d'un établissement
   */
  getClasses: (idEtablissement) => {
    console.log('📡 GET classes for etablissement:', idEtablissement);
    return api.get(`${BASE_URL}${idEtablissement}/classes/`);
  },

  /**
   * POST /etablissement_api/ISETAG_COM.etablissements/<pk>/classes/
   * -> Ajoute une classe à un établissement
   */
  addClasse: (idEtablissement, data) => {
    console.log('📝 ADD classe to etablissement:', idEtablissement, data);
    return api.post(`${BASE_URL}${idEtablissement}/classes/`, data);
  },
};
