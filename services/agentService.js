/**
 * Service de gestion des agents.
 *
 * Routes exposées par backend/ISETAG_COM_API/agent_api/urls.py :
 *   /agent_api/ISETAG_COM.agents/        (GET liste, POST création)
 *   /agent_api/ISETAG_COM.agents/<pk>/   (GET un, PUT, DELETE)
 */

import { api } from './api';

const BASE_URL = '/agent_api/ISETAG_COM.agents/';

export const agentService = {

  /**
   * GET /agent_api/ISETAG_COM.agents/ -> liste de tous les agents
   *
   * @param {Object} params - Paramètres de filtrage (optionnel)
   * @param {string} params.search   - Recherche par nom / email
   * @param {string} params.statut   - Filtrer par statut (actif, inactif)
   * @param {string} params.zone     - Filtrer par zone
   */
  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all agents:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /**
   * GET /agent_api/ISETAG_COM.agents/<pk>/ -> un agent précis
   *
   * @param {string} idAgent - Identifiant de l'agent
   */
  getById: (idAgent) => {
    ('📡 GET agent by ID:', idAgent);
    return api.get(`${BASE_URL}${idAgent}/`);
  },

  /**
   * POST /agent_api/ISETAG_COM.agents/ -> créer un agent
   *
   * @param {Object} data
   * @param {string} data.nom           - Nom de l'agent (obligatoire)
   * @param {string} data.prenom        - Prénom
   * @param {string} data.email         - Email
   * @param {string} data.telephone     - Téléphone
   * @param {string} data.statut        - Statut (actif / inactif)
   * @param {string} data.idZone        - ID de la zone affectée
   */
  create: (data) => {
    const payload = { idAgent: `TEMP-${Date.now()}`, ...data };
    ('📝 CREATE agent:', payload);
    return api.post(BASE_URL, payload);
  },

  /**
   * PUT /agent_api/ISETAG_COM.agents/<pk>/ -> mise à jour complète
   *
   * @param {string} idAgent - Identifiant de l'agent
   * @param {Object} data    - Nouvelles données
   */
  update: (idAgent, data) => {
    ('📝 UPDATE agent:', idAgent, data);
    return api.put(`${BASE_URL}${idAgent}/`, data);
  },

  /**
   * DELETE /agent_api/ISETAG_COM.agents/<pk>/ -> supprimer un agent
   *
   * @param {string} idAgent - Identifiant de l'agent
   */
  delete: (idAgent) => {
    ('🗑️ DELETE agent:', idAgent);
    return api.delete(`${BASE_URL}${idAgent}/`);
  },

  /**
   * GET /agent_api/ISETAG_COM.agents/<pk>/stats/ -> statistiques d'un agent
   *
   * @param {string} idAgent - Identifiant de l'agent
   */
  getStats: (idAgent) => {
    ('📊 GET stats for agent:', idAgent);
    return api.get(`${BASE_URL}${idAgent}/stats/`);
  },
};
