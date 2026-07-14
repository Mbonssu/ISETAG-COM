// services/interetService.js

import { api } from './api';

const BASE_URL = '/specialite_api/ISETAG_COM.interetspecialites/';

export const interetService = {

  // ============================================================
  // RÉCUPÉRER TOUS LES NIVEAUX D'INTÉRÊT
  // ============================================================
  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all interets:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  // ============================================================
  // RÉCUPÉRER UN NIVEAU D'INTÉRÊT PAR SON ID
  // ============================================================
  getById: (idInteret) => {
    console.log('📡 GET interet by ID:', idInteret);
    return api.get(`${BASE_URL}${idInteret}/`);
  },

  // ============================================================
  // RÉCUPÉRER LES NIVEAUX D'INTÉRÊT D'UN PROSPECT
  // ============================================================
  getByProspect: (idProspect) => {
    console.log('📡 GET interets by prospect:', idProspect);
    return api.get(`${BASE_URL}?idProspect=${idProspect}`);
  },

  // ============================================================
  // RÉCUPÉRER LES NIVEAUX D'INTÉRÊT D'UNE SPÉCIALITÉ
  // ============================================================
  getBySpecialite: (idSpecialite) => {
    console.log('📡 GET interets by specialite:', idSpecialite);
    return api.get(`${BASE_URL}?idSpecialite=${idSpecialite}`);
  },

  // ============================================================
  // CRÉER UN NIVEAU D'INTÉRÊT
  // ============================================================
  create: (data) => {
    const payload = {
      idInteret: data.idInteret || `INT-${Date.now()}`,
      idSpecialite: data.idSpecialite,
      idProspect: data.idProspect,
      niveauInteret: data.niveauInteret || '1',
    };
    console.log('📝 CREATE interet:', payload);
    return api.post(BASE_URL, payload);
  },

  // ============================================================
  // METTRE À JOUR UN NIVEAU D'INTÉRÊT
  // ============================================================
  update: (idInteret, data) => {
    const payload = {
      idInteret: idInteret,
      idSpecialite: data.idSpecialite,
      idProspect: data.idProspect,
      niveauInteret: data.niveauInteret || '1',
    };
    console.log('📝 UPDATE interet:', idInteret, payload);
    return api.put(`${BASE_URL}${idInteret}/`, payload);
  },

  // ============================================================
  // SUPPRIMER UN NIVEAU D'INTÉRÊT
  // ============================================================
  delete: (idInteret) => {
    console.log('🗑️ DELETE interet:', idInteret);
    return api.delete(`${BASE_URL}${idInteret}/`);
  },

  // ============================================================
  // SUPPRIMER TOUS LES NIVEAUX D'INTÉRÊT D'UN PROSPECT
  // ============================================================
  deleteByProspect: (idProspect) => {
    console.log('🗑️ DELETE all interets for prospect:', idProspect);
    return api.delete(`${BASE_URL}?idProspect=${idProspect}`);
  },
};