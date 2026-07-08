// // // services/specialiteService.js

// import { api } from './api';

// const BASE_URL = '/specialite_api/ISETAG_COM.specialites/';

// export const specialiteService = {

//   // ============================================================
//   // RÉCUPÉRER TOUTES LES SPÉCIALITÉS
//   // ============================================================
//   getAll: (params = {}) => {
//     const cleanParams = {};
//     Object.keys(params).forEach(key => {
//       if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
//         cleanParams[key] = params[key];
//       }
//     });
//     const queryString = new URLSearchParams(cleanParams).toString();
//     console.log('📡 GET all specialites:', queryString || 'sans paramètres');
//     return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
//   },

//   // ============================================================
//   // RÉCUPÉRER UNE SPÉCIALITÉ PAR SON ID
//   // ============================================================
//   getById: (idSpecialite) => {
//     console.log('📡 GET specialite by ID:', idSpecialite);
//     return api.get(`${BASE_URL}${idSpecialite}/`);
//   },

//   // ============================================================
//   // CRÉER UNE SPÉCIALITÉ
//   // ============================================================
//   create: (data) => {
//     const payload = {
//       idSpecialite: data.idSpecialite || `SPEC-${Date.now()}`,
//       libeleSpecialite: data.libeleSpecialite || data.libele || data.nom || '',
//       description: data.description || '',
//       // updatedAt sera généré automatiquement par le backend
//     };
//     console.log('📝 CREATE specialite:', payload);
//     return api.post(BASE_URL, payload);
//   },

//   // ============================================================
//   // METTRE À JOUR UNE SPÉCIALITÉ
//   // ============================================================
//   update: (idSpecialite, data) => {
//     const payload = {
//       idSpecialite: idSpecialite,
//       libeleSpecialite: data.libeleSpecialite || data.libele || data.nom || '',
//       description: data.description || '',
//       // updatedAt sera généré automatiquement par le backend
//     };
//     console.log('📝 UPDATE specialite:', idSpecialite, payload);
//     return api.put(`${BASE_URL}${idSpecialite}/`, payload);
//   },

//   // ============================================================
//   // SUPPRIMER UNE SPÉCIALITÉ
//   // ============================================================
//   delete: (idSpecialite) => {
//     console.log('🗑️ DELETE specialite:', idSpecialite);
//     return api.delete(`${BASE_URL}${idSpecialite}/`);
//   },
// };

// services/specialiteService.js

import { api } from './api';

const BASE_URL = '/specialite_api/ISETAG_COM.specialites/';

export const specialiteService = {

  // ============================================================
  // RÉCUPÉRER TOUTES LES SPÉCIALITÉS
  // ============================================================
  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all specialites:', queryString || 'sans paramètres');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  // ============================================================
  // RÉCUPÉRER UNE SPÉCIALITÉ PAR SON ID
  // ============================================================
  getById: (idSpecialite) => {
    console.log('📡 GET specialite by ID:', idSpecialite);
    return api.get(`${BASE_URL}${idSpecialite}/`);
  },

  // ============================================================
  // CRÉER UNE SPÉCIALITÉ
  // ============================================================
  create: (data) => {
    const payload = {
      idSpecialite: data.idSpecialite || `SPEC-${Date.now()}`,
      libeleSpecialite: data.libeleSpecialite || data.libele || '',
      acronyme: data.acronyme || '',
      description: data.description || '',
    };
    console.log('📝 CREATE specialite:', payload);
    return api.post(BASE_URL, payload);
  },

  // ============================================================
  // METTRE À JOUR UNE SPÉCIALITÉ
  // ============================================================
  update: (idSpecialite, data) => {
    const payload = {
      idSpecialite: idSpecialite,
      libeleSpecialite: data.libeleSpecialite || data.libele || '',
      acronyme: data.acronyme || '',
      description: data.description || '',
    };
    console.log('📝 UPDATE specialite:', idSpecialite, payload);
    return api.put(`${BASE_URL}${idSpecialite}/`, payload);
  },

  // ============================================================
  // SUPPRIMER UNE SPÉCIALITÉ
  // ============================================================
  delete: (idSpecialite) => {
    console.log('🗑️ DELETE specialite:', idSpecialite);
    return api.delete(`${BASE_URL}${idSpecialite}/`);
  },
};
