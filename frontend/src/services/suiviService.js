/**
 * Service de gestion des suivis.
 *
 * Route réelle confirmée dans ISETAG_COM_API.yaml :
 *   /prospect_api/ISETAG_COM.suivis/        (GET liste, POST création)
 *   /prospect_api/ISETAG_COM.suivis/<id>/   (GET un, PUT, DELETE)
 *
 *  Corrigé :
 * - L'ancienne URL "/suivi_api/ISETAG_COM.suivis/" n'existe pas dans
 *   l'API : le préfixe réel est "prospect_api".
 * - getStats(), getByProspect() et getByAgent() ont été retirées : aucune
 *   route ".../stats/", ".../prospect/<id>/" ou ".../agent/<id>/" n'existe
 *   pour cette ressource dans le schéma OpenAPI (contrairement à
 *   interetspecialites qui, elle, expose bien "prospect/<id>/").
 * - export() a été retirée : aucune route ".../export" n'existe.
 * - Le modèle SuiviProspect n'a d'ailleurs pas de champ agent/idUtilisateur
 *   (seulement idProspect, libeleSuivi, dateSuivi, commentaire), donc un
 *   filtrage par agent n'aurait de toute façon pas de sens côté backend.
 */

import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.suivis/';

export const suiviService = {

  /**
   * GET /prospect_api/ISETAG_COM.suivis/ -> liste de tous les suivis
   *
   * @param {Object} params - Paramètres de filtrage (optionnel)
   */
  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all suivis:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /**
   * GET /prospect_api/ISETAG_COM.suivis/<id>/ -> un suivi précis
   */
  getById: (idSuivi) => {
    ('📡 GET suivi by ID:', idSuivi);
    return api.get(`${BASE_URL}${idSuivi}/`);
  },

  /**
   * POST /prospect_api/ISETAG_COM.suivis/ -> créer un suivi
   *
   * Champs attendus (schéma SuiviProspectRequest) :
   *   idSuivi, idProspect, libeleSuivi, dateSuivi, commentaire
   */
  create: (data) => {
    const payload = { idSuivi: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE suivi:', payload);
    return api.post(BASE_URL, payload);
  },

  /**
   * PUT /prospect_api/ISETAG_COM.suivis/<id>/ -> mise à jour complète
   */
  update: (idSuivi, data) => {
    ('📝 UPDATE suivi:', idSuivi, data);
    return api.put(`${BASE_URL}${idSuivi}/`, data);
  },

  /**
   * DELETE /prospect_api/ISETAG_COM.suivis/<id>/ -> supprimer un suivi
   */
  delete: (idSuivi) => {
    ('🗑️ DELETE suivi:', idSuivi);
    return api.delete(`${BASE_URL}${idSuivi}/`);
  },
};