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
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  // ============================================================
  // RÉCUPÉRER UN NIVEAU D'INTÉRÊT PAR SON ID
  // ============================================================
  getById: (idInteret) => {
    return api.get(`${BASE_URL}${idInteret}/`);
  },

 
  getByProspect: (idProspect) => {
    return api.get(`${BASE_URL}prospect/${idProspect}/`);
  },

  getBySpecialite: (idSpecialite) => {
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
    return api.put(`${BASE_URL}${idInteret}/`, payload);
  },

  // ============================================================
  // SUPPRIMER UN NIVEAU D'INTÉRÊT
  // ============================================================
  delete: (idInteret) => {
    return api.delete(`${BASE_URL}${idInteret}/`);
  },

  deleteByProspect: async (idProspect) => {
    const interets = await api.get(`${BASE_URL}prospect/${idProspect}/`);
    const list = Array.isArray(interets) ? interets : (interets ? [interets] : []);
    return Promise.all(
      list
        .map((interet) => interet.idInteret)
        .filter(Boolean)
        .map((idInteret) => api.delete(`${BASE_URL}${idInteret}/`))
    );
  },

  syncInterets: async (idProspect, localInterets = []) => {

    if (!idProspect) {
      console.warn(' syncInterets appelé sans idProspect, on annule');
      return { deleted: 0, updated: 0, added: 0 };
    }

    // 1. État réel côté serveur
    let existants = [];
    try {
      const raw = await api.get(`${BASE_URL}prospect/${idProspect}/`);
      existants = Array.isArray(raw) ? raw : (raw ? [raw] : []);
    } catch (err) {
      console.warn('Impossible de récupérer les intérêts existants, on part de zéro:', err);
      existants = [];
    }
    const existantsById = new Map(existants.map((e) => [e.idInteret, e]));
    const localIds = new Set(
      localInterets.filter((i) => i.idInteret).map((i) => i.idInteret)
    );

    let added = 0, updated = 0, deleted = 0;

    // 2. Supprimer ceux qui ont disparu de la liste locale
    const toDelete = existants.filter((e) => !localIds.has(e.idInteret));
    await Promise.all(
      toDelete.map(async (e) => {
        await api.delete(`${BASE_URL}${e.idInteret}/`);
        deleted++;
      })
    );

    // 3. Créer les nouveaux / mettre à jour les existants modifiés
    await Promise.all(
      localInterets.map(async (item) => {
        const idSpecialite = item.idFiliere || item.idSpecialite;

        if (item.idInteret && existantsById.has(item.idInteret)) {
          const existant = existantsById.get(item.idInteret);
          const aChange =
            existant.niveauInteret !== item.niveauInteret ||
            existant.idSpecialite !== idSpecialite;
          if (aChange) {
            await api.put(`${BASE_URL}${item.idInteret}/`, {
              idInteret: item.idInteret,
              idSpecialite,
              idProspect,
              niveauInteret: item.niveauInteret,
            });
            updated++;
          }
        } else {
          await api.post(BASE_URL, {
            idInteret: `INT-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
            idSpecialite,
            idProspect,
            niveauInteret: item.niveauInteret,
          });
          added++;
        }
      })
    );

    return { deleted, updated, added };
  },
};