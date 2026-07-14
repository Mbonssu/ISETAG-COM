/**
 * Service de gestion des établissements.
 *
 * Route réelle confirmée dans ISETAG_COM_API.yaml :
 *   /campagne_api/ISETAG_COM.etablissements/        (GET liste, POST création)
 *   /campagne_api/ISETAG_COM.etablissements/<id>/   (GET un, PUT, DELETE)
 *
 * ⚠️ Corrigé :
 * - L'ancienne URL "/etablissement_api/ISETAG_COM.etablissements/"
 *   n'existe pas dans l'API : le préfixe réel est "campagne_api".
 * - getClasses()/addClasse() ont été retirées : aucune route
 *   ".../<id>/classes/" n'existe côté backend (absente du schéma OpenAPI).
 */

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
};
