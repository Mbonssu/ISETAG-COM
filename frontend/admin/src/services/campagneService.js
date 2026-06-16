import { api } from './api';

const BASE_URL = '/campagnes';

export const campagneService = {
  getAll: (params = {}) => {
    const queryString = new URLSearchParams(params).toString();
    return api.get(`${BASE_URL}?${queryString}`);
  },
  getById: (id) => api.get(`${BASE_URL}/${id}`),
  create: (data) => api.post(BASE_URL, data),
  update: (id, data) => api.put(`${BASE_URL}/${id}`, data),
  delete: (id) => api.delete(`${BASE_URL}/${id}`),
  getParticipations: (campagneId) => api.get(`${BASE_URL}/${campagneId}/participations`),
  addParticipation: (campagneId, data) => api.post(`${BASE_URL}/${campagneId}/participations`, data),
  getStats: (id) => api.get(`${BASE_URL}/${id}/stats`)
};
