/**
 * Service de gestion des sorties (tournées terrain).
 *
 * Route réelle confirmée dans ISETAG_COM_API.yaml :
 *   /campagne_api/ISETAG_COM.sorties/        (GET liste, POST création)
 *   /campagne_api/ISETAG_COM.sorties/<id>/   (GET un, PUT, DELETE)
 *
 *  Corrigé : l'ancienne URL "/sortie_api/ISETAG_COM.sorties/" n'existe
 * pas dans l'API. Les sorties sont exposées sous le préfixe "campagne_api".
 */

import { api } from './api';

const BASE_URL = '/campagne_api/ISETAG_COM.sorties/';

export const sortieService = {

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

  getById: (idSortie) => {
    return api.get(`${BASE_URL}${idSortie}/`);
  },

  create: (data) => {
    const payload = { idSortie: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  update: (idSortie, data) => {
    return api.put(`${BASE_URL}${idSortie}/`, data);
  },

  delete: (idSortie) => {
    return api.delete(`${BASE_URL}${idSortie}/`);
  },
};
