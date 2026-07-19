/**
 * Service de gestion des rendez-vous.
 *
 * Route réelle confirmée dans ISETAG_COM_API.yaml :
 *   /prospect_api/ISETAG_COM.rendezvous/        (GET liste, POST création)
 *   /prospect_api/ISETAG_COM.rendezvous/<id>/   (GET un, PUT, DELETE)
 *
 *  Corrigé :
 * - L'ancienne URL "/rendezvous_api/ISETAG_COM.rendezvous/" n'existe pas :
 *   le préfixe réel est "prospect_api".
 * - La clé primaire du modèle est "idRendezVous" (pas "idRdv"), champ
 *   requis par le schéma RendezVousRequest.
 */

import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.rendezvous/';

export const rendezvousService = {

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all rendezvous:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idRendezVous) => {
    ('📡 GET rendez-vous by ID:', idRendezVous);
    return api.get(`${BASE_URL}${idRendezVous}/`);
  },

  create: (data) => {
    const payload = { idRendezVous: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE rendez-vous:', payload);
    return api.post(BASE_URL, payload);
  },

  update: (idRendezVous, data) => {
    ('📝 UPDATE rendez-vous:', idRendezVous, data);
    return api.put(`${BASE_URL}${idRendezVous}/`, data);
  },

  delete: (idRendezVous) => {
    ('🗑️ DELETE rendez-vous:', idRendezVous);
    return api.delete(`${BASE_URL}${idRendezVous}/`);
  },
};
