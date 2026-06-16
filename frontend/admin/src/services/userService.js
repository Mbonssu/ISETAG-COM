import { api } from './api';

export const userService = {
  getAll: (params = {}) => {
    // ✅ Filtrer les paramètres undefined et null
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all users:', queryString || 'sans paramètres');
    return api.get(queryString ? `?${queryString}` : '');
  },

  // ... le reste du code inchangé
};
