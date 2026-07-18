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
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  /** GET /user_api/ISETAG_COM.users/<pk>/ -> un utilisateur précis */
  getById: (pk) => {
    return api.get(`${BASE_URL}${pk}/`);
  },

  create: (userData) => {
    if (userData.photoProfil instanceof File) {
      return api.post(BASE_URL, buildFormData(userData));
    }
    return api.post(BASE_URL, stripFile(userData));
  },

  update: (pk, userData) => {
    if (userData.photoProfil instanceof File) {
      return api.put(`${BASE_URL}${pk}/`, buildFormData(userData));
    }
    return api.put(`${BASE_URL}${pk}/`, stripFile(userData));
  },

  /** DELETE /user_api/ISETAG_COM.users/<pk>/ */
  delete: (pk) => {
    return api.delete(`${BASE_URL}${pk}/`);
  },
};

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