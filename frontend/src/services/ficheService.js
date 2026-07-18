/**
 * Service de gestion des fiches de sortie (ficheSortie).
 *
 * Route réelle confirmée dans ISETAG_COM_API.yaml :
 *   /campagne_api/ISETAG_COM.fiches-sortie/        (GET liste, POST création)
 *   /campagne_api/ISETAG_COM.fiches-sortie/<id>/   (GET un, PUT, DELETE)
 *
 *  Corrigé : l'ancienne URL "/fiche_api/ISETAG_COM.fiches/" n'existe
 * pas dans l'API. La ressource s'appelle "fiches-sortie" et vit sous le
 * préfixe "campagne_api" (pas "fiche_api").
 *
 * Champs attendus par le backend (schéma ficheSortieRequest) :
 *   idFiche, idParticipation, idProspect, idSource,
 *   dateCollecte, commentaire, scoreInteret
 */

import { api } from './api';

const BASE_URL = '/campagne_api/ISETAG_COM.fiches-sortie/';

export const ficheService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all fiches:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idFiche) => {
    ('📡 GET fiche by ID:', idFiche);
    return api.get(`${BASE_URL}${idFiche}/`);
  },

  create: (data) => {
    const payload = { idFiche: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE fiche:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idFiche, data) => {
    ('📝 UPDATE fiche:', idFiche, data);
    return api.put(`${BASE_URL}${idFiche}/`, data);
  },

  delete: (idFiche) => {
    ('🗑️ DELETE fiche:', idFiche);
    return api.delete(`${BASE_URL}${idFiche}/`);
  },
};
