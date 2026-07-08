// /**
//  * Service de gestion des prospects.
//  *
//  * IMPORTANT : ce fichier cible les VRAIES routes exposées par
//  * backend/ISETAG_COM_API/prospect_api/urls.py, à savoir :
//  *   /prospect_api/ISETAG_COM.prospects/        (GET liste, POST création)
//  *   /prospect_api/ISETAG_COM.prospects/<pk>/   (GET un, PUT, DELETE)
//  *
//  * Les fonctions getInterets/addInteret/deleteInteret/export qui existaient
//  * dans une version précédente de ce fichier ont été retirées : elles
//  * appelaient des endpoints qui n'existent pas du tout côté Django.
//  * Le modèle Prospect a bien une relation ManyToMany `specialiteInteret`,
//  * mais elle n'est exposée par aucune route pour l'instant — ce sera à
//  * ajouter côté backend avant de pouvoir la consommer ici.
//  */

// import { api } from './api';

// const BASE_URL = '/prospect_api/ISETAG_COM.prospects/';

// export const prospectService = {
//   /**
//    * GET /prospect_api/ISETAG_COM.prospects/ -> liste de tous les prospects
//    * (tableau JSON direct, sans pagination ni filtre côté serveur pour
//    * l'instant : ProspectView.get() fait juste Prospect.objects.all()).
//    */
//   getAll: () => {
//     console.log('📡 GET all prospects');
//     return api.get(BASE_URL);
//   },

//   /** GET /prospect_api/ISETAG_COM.prospects/<pk>/ -> un prospect précis */
//   getById: (idProspect) => {
//     console.log('📡 GET prospect by ID:', idProspect);
//     return api.get(`${BASE_URL}${idProspect}/`);
//   },

//   /**
//    * POST /prospect_api/ISETAG_COM.prospects/ -> créer un prospect.
//    *
//    * idProspect est en théorie généré côté backend (ProspectSerializer.create
//    * fait validated_data['idProspect'] = f"PROS-{uuid...}"). MAIS comme
//    * idProspect est la primary key du modèle et que le serializer utilise
//    * fields = '__all__' sans extra_kwargs, DRF l'exige quand même au moment
//    * de la validation d'entrée, avant même d'atteindre create(). On envoie
//    * donc une valeur temporaire, purement pour satisfaire cette validation ;
//    * le backend la remplace systématiquement par la vraie valeur générée.
//    *
//    * ⚠️ Ceci est un contournement front (même bug que idUtilisateur côté
//    * UtilisateurForm). La vraie correction est côté backend : ajouter dans
//    * ProspectSerializer.Meta : extra_kwargs = { 'idProspect': { 'required': False } }
//    */
//   create: (data) => {
//     const payload = { idProspect: `TEMP-${Date.now()}`, ...data };
//     console.log('📝 CREATE prospect:', payload);
//     return api.post(BASE_URL, payload);
//   },

//   /** PUT /prospect_api/ISETAG_COM.prospects/<pk>/ -> mise à jour complète */
//   update: (idProspect, data) => {
//     console.log('📝 UPDATE prospect:', idProspect, data);
//     return api.put(`${BASE_URL}${idProspect}/`, data);
//   },

//   /** DELETE /prospect_api/ISETAG_COM.prospects/<pk>/ */
//   delete: (idProspect) => {
//     console.log('🗑️ DELETE prospect:', idProspect);
//     return api.delete(`${BASE_URL}${idProspect}/`);
//   },
// };


/**
 * Service de gestion des prospects.
 *
 * Routes ciblées (prospect_api/urls.py) :
 *   /prospect_api/ISETAG_COM.prospects/           GET liste, POST création
 *   /prospect_api/ISETAG_COM.prospects/<pk>/      GET un, PUT mise à jour, DELETE
 *
 * Routes pour les filières d'intérêt (ManyToMany) :
 * 🔧 Ces routes doivent être exposées par ton ami côté Django.
 *    Si elles n'existent pas encore, utilise l'approche "inclusion dans le PUT" :
 *    envoie specialiteInteret: [...] dans le body du PUT principal.
 *
 *   /prospect_api/ISETAG_COM.prospects/<pk>/interets/        GET liste, POST ajout
 *   /prospect_api/ISETAG_COM.prospects/<pk>/interets/<id>/   DELETE suppression
 */

import { api } from './api';

const BASE_URL = '/prospect_api/ISETAG_COM.prospects/';

export const prospectService = {

  // ─── CRUD principal ──────────────────────────────────────

  getAll: (params = {}) => {
    const cleanParams = {};
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null && params[key] !== '') {
        cleanParams[key] = params[key];
      }
    });
    const queryString = new URLSearchParams(cleanParams).toString();
    console.log('📡 GET all prospects');
    return api.get(queryString ? `${BASE_URL}?${queryString}` : BASE_URL);
  },

  getById: (idProspect) => {
    console.log('📡 GET prospect by ID:', idProspect);
    return api.get(`${BASE_URL}${idProspect}/`);
  },

  /**
   * POST /prospect_api/ISETAG_COM.prospects/ → créer un prospect
   *
   * Le champ specialiteInteret accepte un tableau d'objets :
   *   [{ idFiliere: "FIL-xxx", niveauInteret: "Élevé" }, ...]
   *
   * 🔧 Si le backend ne gère pas specialiteInteret dans le POST,
   *    appelle setInterets() juste après la création.
   */
  create: (data) => {
    const payload = { idProspect: `TEMP-${Date.now()}`, ...data };
    console.log('📝 CREATE prospect:', payload);
    return api.post(BASE_URL, payload);
  },

  /**
   * PUT /prospect_api/ISETAG_COM.prospects/<pk>/ → mise à jour complète
   *
   * IMPORTANT : on inclut specialiteInteret dans le payload principal.
   * Côté Django, le serializer doit faire :
   *   instance.specialiteInteret.set(validated_data.pop('specialiteInteret', []))
   *
   * 🔧 Si ton ami n'a pas encore implémenté ça dans le serializer,
   *    utilise la méthode setInterets() séparément après le PUT.
   */
  update: (idProspect, data) => {
    console.log('📝 UPDATE prospect:', idProspect, data);
    // On s'assure que l'ID dans l'URL correspond TOUJOURS au prospect ciblé
    return api.put(`${BASE_URL}${idProspect}/`, data);
  },

  delete: (idProspect) => {
    console.log('🗑️ DELETE prospect:', idProspect);
    return api.delete(`${BASE_URL}${idProspect}/`);
  },

  // ─── Gestion des filières d'intérêt (ManyToMany) ────────
  //
  // Ces méthodes ciblent TOUJOURS un prospect précis via son ID dans l'URL.
  // C'est le bug principal à éviter : ne jamais appeler un endpoint global
  // sans inclure l'idProspect dans le chemin.

  /**
   * GET /prospect_api/ISETAG_COM.prospects/<pk>/interets/
   * → Récupère les filières d'intérêt du prospect <pk> uniquement.
   *
   * 🔧 ROUTE — changer l'URL si ton ami expose l'endpoint différemment.
   */
  getInterets: (idProspect) => {
    console.log('📡 GET interets for prospect:', idProspect);
    return api.get(`${BASE_URL}${idProspect}/interets/`);
  },

  /**
   * POST /prospect_api/ISETAG_COM.prospects/<pk>/interets/
   * → Ajoute UNE filière d'intérêt au prospect <pk>.
   *
   * @param {string} idProspect - ID du prospect ciblé (dans l'URL)
   * @param {{ idFiliere: string, niveauInteret: string }} interet
   *
   * 🔧 ROUTE — changer l'URL si ton ami expose l'endpoint différemment.
   */
  addInteret: (idProspect, interet) => {
    console.log('📝 ADD interet to prospect:', idProspect, interet);
    return api.post(`${BASE_URL}${idProspect}/interets/`, interet);
  },

  /**
   * DELETE /prospect_api/ISETAG_COM.prospects/<pk>/interets/<interet_pk>/
   * → Supprime UNE filière d'intérêt du prospect <pk>.
   *
   * @param {string} idProspect - ID du prospect ciblé (dans l'URL)
   * @param {string} idInteret  - ID de la relation à supprimer
   *
   * 🔧 ROUTE — changer l'URL si ton ami expose l'endpoint différemment.
   */
  deleteInteret: (idProspect, idInteret) => {
    console.log('🗑️ DELETE interet', idInteret, 'from prospect:', idProspect);
    return api.delete(`${BASE_URL}${idProspect}/interets/${idInteret}/`);
  },

  /**
   * Méthode de REMPLACEMENT COMPLET des filières d'intérêt.
   *
   * C'est la méthode principale à utiliser lors d'une modification de prospect.
   * Elle résout le bug "ça ajoute au lieu de modifier" en faisant :
   *   1. Récupère les interets existants du prospect
   *   2. Supprime TOUS les existants (DELETE ciblé sur ce prospect)
   *   3. Recrée les nouveaux (POST ciblé sur ce prospect)
   *
   * ⚠️ Tout est toujours ciblé via l'URL /<pk>/interets/ pour n'affecter
   *    QUE le prospect passé en paramètre.
   *
   * 🔧 Alternative : si ton ami implémente un PUT /interets/ qui fait un .set(),
   *    remplace cette méthode par un simple api.put(`${BASE_URL}${id}/interets/`, newList)
   *
   * @param {string}   idProspect - ID du prospect à mettre à jour
   * @param {Array}    newInterets - Nouvelle liste : [{ idFiliere, niveauInteret }]
   */
  setInterets: async (idProspect, newInterets) => {
    console.log('🔄 SET interets for prospect:', idProspect, newInterets);

    // Étape 1 : récupérer les interets actuels de CE prospect
    let existing = [];
    try {
      existing = await prospectService.getInterets(idProspect);
      if (!Array.isArray(existing)) existing = existing?.results ?? [];
    } catch {
      // Si l'endpoint n'existe pas encore, on continue avec une liste vide
      existing = [];
    }

    // Étape 2 : supprimer TOUS les existants (ciblés sur CE prospect)
    await Promise.allSettled(
      existing.map(interet =>
        prospectService.deleteInteret(idProspect, interet.id ?? interet.idInteret)
      )
    );

    // Étape 3 : ajouter les nouveaux (ciblés sur CE prospect)
    await Promise.allSettled(
      newInterets.map(interet =>
        prospectService.addInteret(idProspect, {
          idFiliere:     interet.idFiliere,
          niveauInteret: interet.niveauInteret,
        })
      )
    );

    console.log('✅ Interets replaced for prospect:', idProspect);
  },
};