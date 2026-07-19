import { api } from './api';

// Route réellement exposée par backend/ISETAG_COM_API/user_api/urls.py
const BASE_URL = '/user_api/ISETAG_COM.users/';

export const userService = {
  /** GET /user_api/ISETAG_COM.users/ -> liste de tous les utilisateurs (tableau direct) */
  getAll: (params = {}) => {
    //  Filtrer les paramètres undefined et null
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });

    const queryString = new URLSearchParams(cleanParams).toString();
    ('📡 GET all users:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /** GET /user_api/ISETAG_COM.users/<pk>/ -> un utilisateur précis */
  getById: (pk) => {
    ('📡 GET user by id:', pk);
    return api.get(`${BASE_URL}${pk}/`);
  },

  /**
   * POST /user_api/ISETAG_COM.users/ -> créer un utilisateur.
   * Si une photo (File) est fournie, on envoie du FormData car le backend
   * utilise MultiPartParser ; sinon on envoie du JSON classique.
   */
  create: (userData) => {
    ('📡 POST create user:', userData);
    if (userData.photoProfil instanceof File) {
      return api.post(BASE_URL, buildFormData(userData));
    }
    return api.post(BASE_URL, stripFile(userData));
  },

  /**
   * PUT /user_api/ISETAG_COM.users/<pk>/ -> mise à jour complète.
   * Même règle FormData/JSON que create().
   */
  update: (pk, userData) => {
    ('📡 PUT update user:', pk, userData);
    if (userData.photoProfil instanceof File) {
      return api.put(`${BASE_URL}${pk}/`, buildFormData(userData));
    }
    return api.put(`${BASE_URL}${pk}/`, stripFile(userData));
  },

  /** DELETE /user_api/ISETAG_COM.users/<pk>/ */
  delete: (pk) => {
    ('📡 DELETE user:', pk);
    return api.delete(`${BASE_URL}${pk}/`);
  },
};

/**
 * Retire le champ photoProfil quand ce n'est pas un nouveau fichier
 * (par exemple quand c'est déjà une URL string renvoyée par le backend) :
 * on évite ainsi d'envoyer une chaîne à un champ ImageField en JSON.
 */
function stripFile(userData) {
  const { photoProfil, ...rest } = userData;
  return rest;
}

function buildFormData(userData) {
  const formData = new FormData();
  Object.entries(userData).forEach(([key, value]) => {
    if (value === null || value === undefined || value === '') return;
    formData.append(key, value);
  });
  return formData;
}