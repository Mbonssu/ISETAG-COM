/**
 * Service de gestion des prospects.
 *
 * IMPORTANT : ce fichier cible les VRAIES routes exposées par
 * backend/ISETAG_COM_API/prospect_api/urls.py, à savoir :
 *   /prospect_api/ISETAG_COM.prospects/        (GET liste, POST création)
 *   /prospect_api/ISETAG_COM.prospects/<pk>/   (GET un, PUT, DELETE)
 *
 * Les fonctions getInterets/addInteret/deleteInteret/export qui existaient
 * dans une version précédente de ce fichier ont été retirées : elles
 * appelaient des endpoints qui n'existent pas du tout côté Django.
 * Le modèle Prospect a bien une relation ManyToMany `specialiteInteret`,
 * mais elle n'est exposée par aucune route pour l'instant — ce sera à
 * ajouter côté backend avant de pouvoir la consommer ici.
 */

import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.prospects/';

export const prospectService = {
  /**
   * GET /prospect_api/ISETAG_COM.prospects/ -> liste de tous les prospects
   * (tableau JSON direct, sans pagination ni filtre côté serveur pour
   * l'instant : ProspectView.get() fait juste Prospect.objects.all()).
   */
  getAll: () => {
    return api.get(BASE_URL);
  },

  /** GET /prospect_api/ISETAG_COM.prospects/<pk>/ -> un prospect précis */
  getById: (idProspect) => {
    return api.get(`${BASE_URL}${idProspect}/`);
  },
  create: (data) => {
    const payload = { idProspect: `TEMP-${Date.now()}`, ...data };
    return api.post(BASE_URL, payload);
  },

  /** PUT /prospect_api/ISETAG_COM.prospects/<pk>/ -> mise à jour complète */
  update: (idProspect, data) => {
    return api.put(`${BASE_URL}${idProspect}/`, data);
  },

  /** DELETE /prospect_api/ISETAG_COM.prospects/<pk>/ */
  delete: (idProspect) => {
    return api.delete(`${BASE_URL}${idProspect}/`);
  },
};

