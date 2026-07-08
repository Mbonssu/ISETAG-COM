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
    console.log('📡 GET all prospects');
    return api.get(BASE_URL);
  },

  /** GET /prospect_api/ISETAG_COM.prospects/<pk>/ -> un prospect précis */
  getById: (idProspect) => {
    console.log('📡 GET prospect by ID:', idProspect);
    return api.get(`${BASE_URL}${idProspect}/`);
  },

  /**
   * POST /prospect_api/ISETAG_COM.prospects/ -> créer un prospect.
   *
   * idProspect est en théorie généré côté backend (ProspectSerializer.create
   * fait validated_data['idProspect'] = f"PROS-{uuid...}"). MAIS comme
   * idProspect est la primary key du modèle et que le serializer utilise
   * fields = '__all__' sans extra_kwargs, DRF l'exige quand même au moment
   * de la validation d'entrée, avant même d'atteindre create(). On envoie
   * donc une valeur temporaire, purement pour satisfaire cette validation ;
   * le backend la remplace systématiquement par la vraie valeur générée.
   *
   * ⚠️ Ceci est un contournement front (même bug que idUtilisateur côté
   * UtilisateurForm). La vraie correction est côté backend : ajouter dans
   * ProspectSerializer.Meta : extra_kwargs = { 'idProspect': { 'required': False } }
   */
  create: (data) => {
    const payload = { idProspect: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE prospect:', payload);
    return api.post(BASE_URL, payload);
  },

  /** PUT /prospect_api/ISETAG_COM.prospects/<pk>/ -> mise à jour complète */
  update: (idProspect, data) => {
    console.log('📝 UPDATE prospect:', idProspect, data);
    return api.put(`${BASE_URL}${idProspect}/`, data);
  },

  /** DELETE /prospect_api/ISETAG_COM.prospects/<pk>/ */
  delete: (idProspect) => {
    console.log('🗑️ DELETE prospect:', idProspect);
    return api.delete(`${BASE_URL}${idProspect}/`);
  },
};

