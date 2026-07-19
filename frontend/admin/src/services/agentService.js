/**
 * Service de gestion des agents.
 *
 *  IMPORTANT : il n'existe AUCUNE route "/agent_api/..." dans l'API
 * (ISETAG_COM_API.yaml). Les "agents" ne sont pas une ressource à part :
 * ce sont des lignes du modèle Utilisateur qui ont un champ `role`
 * (ex: role = "agent"). La seule route réelle est donc :
 *
 *   /user_api/ISETAG_COM.users/        (GET liste, POST création)
 *   /user_api/ISETAG_COM.users/<id>/   (GET un, PUT, DELETE)
 *
 * Ce service filtre côté client sur params.role si besoin, mais tape
 * bien sur la route utilisateurs. getStats() a été retirée : aucune
 * route ".../stats/" n'existe dans le schéma OpenAPI.
 */

import { api } from './api';

const BASE_URL = '/user_api/ISETAG_COM.users/';

export const agentService = {

  /**
   * GET /user_api/ISETAG_COM.users/ -> liste des utilisateurs.
   * On force role=agent par défaut pour ne récupérer que les agents,
   * sauf si l'appelant précise explicitement un autre rôle.
   *
   * @param {Object} params - Paramètres de filtrage (optionnel)
   * @param {string} params.search - Recherche par nom / email
   * @param {string} params.role   - Rôle (par défaut: 'agent')
   */
  getAll: (params = {}) => {
    const cleanParams = { role: 'agent', ...params };
    Object.keys(cleanParams).forEach(key => {
      if (cleanParams[key] === undefined || cleanParams[key] === null || cleanParams[key] === '') {
        delete cleanParams[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /**
   * GET /user_api/ISETAG_COM.users/<id>/ -> un agent précis
   *
   * @param {string} idAgent - Identifiant de l'utilisateur (idUtilisateur)
   */
  getById: (idAgent) => {
    return api.get(`${BASE_URL}${idAgent}/`);
  },

  /**
   * POST /user_api/ISETAG_COM.users/ -> créer un agent (un utilisateur
   * avec role="agent").
   *
   * @param {Object} data
   * @param {string} data.nom
   * @param {string} data.prenom
   * @param {string} data.email
   * @param {string} data.telephone
   * @param {string} data.statut
   */
  create: (data) => {
    const payload = { role: 'agent', ...data };
    return api.post(BASE_URL, payload);
  },

  /**
   * PUT /user_api/ISETAG_COM.users/<id>/ -> mise à jour complète
   *
   * @param {string} idAgent
   * @param {Object} data
   */
  update: (idAgent, data) => {
    return api.put(`${BASE_URL}${idAgent}/`, data);
  },

  /**
   * DELETE /user_api/ISETAG_COM.users/<id>/ -> supprimer un agent
   *
   * @param {string} idAgent
   */
  delete: (idAgent) => {
    return api.delete(`${BASE_URL}${idAgent}/`);
  },
};
