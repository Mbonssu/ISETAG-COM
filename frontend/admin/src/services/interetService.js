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
  //
  // ⚠️ CORRIGÉ : le YAML expose une vraie route dédiée pour ça
  //   GET /specialite_api/ISETAG_COM.interetspecialites/prospect/{prospect_id}/
  // au lieu du filtre par query string "?idProspect=" qui n'est documenté
  // nulle part dans le schéma OpenAPI.
  // ============================================================
  getByProspect: (idProspect) => {
    console.log('📡 GET interets by prospect:', idProspect);
    return api.get(`${BASE_URL}prospect/${idProspect}/`);
  },

  // ============================================================
  // RÉCUPÉRER LES NIVEAUX D'INTÉRÊT D'UNE SPÉCIALITÉ
  //
  // ⚠️ Aucune route dédiée n'existe pour ça dans le YAML (seule la route
  // "prospect/{prospect_id}/" est documentée). On garde le filtre par
  // query string ci-dessous à titre de best-effort, mais rien ne garantit
  // que le backend le respecte réellement.
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
  //
  // ⚠️ CORRIGÉ : il n'existe AUCUNE route de suppression en masse par
  // query string ("DELETE .../?idProspect=..."). Le seul DELETE documenté
  // dans le YAML est ".../<id>/" (un intérêt à la fois). On récupère donc
  // d'abord la liste réelle des intérêts du prospect via la route dédiée
  // "prospect/{prospect_id}/", puis on supprime chacun individuellement.
  // ============================================================
  deleteByProspect: async (idProspect) => {
    console.log('🗑️ DELETE all interets for prospect:', idProspect);
    const interets = await api.get(`${BASE_URL}prospect/${idProspect}/`);
    const list = Array.isArray(interets) ? interets : (interets ? [interets] : []);
    return Promise.all(
      list
        .map((interet) => interet.idInteret)
        .filter(Boolean)
        .map((idInteret) => api.delete(`${BASE_URL}${idInteret}/`))
    );
  },

  // ============================================================
  // SYNCHRONISER LES INTÉRÊTS D'UN PROSPECT (utilisé par ProspectForm.jsx)
  //
  // Prend la liste LOCALE de ProspectForm, au format :
  //   [{ idInteret: string|null, idFiliere: string, niveauInteret: string }]
  // (idInteret === null/undefined => pas encore créé côté backend)
  //
  // Calcule le diff avec l'état réel côté serveur (via la vraie route
  // "prospect/{id}/") puis :
  //   - POST   pour les nouveaux (idInteret null)
  //   - PUT    pour ceux dont le niveau ou la spécialité a changé
  //   - DELETE pour ceux qui existaient côté serveur mais plus dans la liste locale
  //
  // Toutes ces trois opérations utilisent des routes réellement
  // documentées dans le YAML :
  //   POST   /specialite_api/ISETAG_COM.interetspecialites/
  //   PUT    /specialite_api/ISETAG_COM.interetspecialites/<id>/
  //   DELETE /specialite_api/ISETAG_COM.interetspecialites/<id>/
  // ============================================================
  syncInterets: async (idProspect, localInterets = []) => {
    console.log('🔄 SYNC interets for prospect:', idProspect, localInterets);

    if (!idProspect) {
      console.warn('⚠️ syncInterets appelé sans idProspect, on annule');
      return { deleted: 0, updated: 0, added: 0 };
    }

    // 1. État réel côté serveur
    let existants = [];
    try {
      const raw = await api.get(`${BASE_URL}prospect/${idProspect}/`);
      existants = Array.isArray(raw) ? raw : (raw ? [raw] : []);
    } catch (err) {
      console.warn('⚠️ Impossible de récupérer les intérêts existants, on part de zéro:', err);
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

    console.log(`✅ Sync done — deleted: ${deleted}, updated: ${updated}, added: ${added}`);
    return { deleted, updated, added };
  },
};