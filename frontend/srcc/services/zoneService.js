/**
 * Service de gestion des zones.
 *
 * Routes exposées par backend/ISETAG_COM_API/zone_api/urls.py :
 *   /zone_api/ISETAG_COM.zones/        (GET liste, POST création)
 *   /zone_api/ISETAG_COM.zones/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/zone_api/ISETAG_COM.zones/';

export const zoneService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all zones:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idZone) => {
    console.log('📡 GET zone by ID:', idZone);
    return api.get(`${BASE_URL}${idZone}/`);
  },

  create: (data) => {
    const payload = { idZone: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE zone:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idZone, data) => {
    console.log('📝 UPDATE zone:', idZone, data);
    return api.put(`${BASE_URL}${idZone}/`, data);
  },

  delete: (idZone) => {
    console.log('🗑️ DELETE zone:', idZone);
    return api.delete(`${BASE_URL}${idZone}/`);
  },
};
