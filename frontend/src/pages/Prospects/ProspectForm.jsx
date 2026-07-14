// import React, { useState, useEffect, useCallback } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import {
//   Save, ArrowLeft, AlertCircle, User, Mail, Phone,
//   MapPin, GraduationCap, Users, Plus, Trash2, Star,
// } from 'lucide-react';
// import { ToastContainer } from '../../components/common/Toast';
// import { useFormValidation, validators } from '../../hooks/useFormValidation';
// import { useTranslation } from '../../hooks/useTranslation';
// // Routes réelles issues de ISETAG_COM_API.yaml
// import { prospectService }   from '../../services/prospectService';
// import { specialiteService } from '../../services/filiereService';
// import { interetService }    from '../../services/interetService';
// import '../Prospects/Prospects.css';

// // ─── Constantes ───────────────────────────────────────────────────────────────
// const NIVEAUX_ETUDE   = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master'];
// const TYPES_PROSPECT  = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
// const SEXES           = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];
// const NIVEAUX_INTERET = ['Faible', 'Moyen', 'Élevé', 'Très élevé', 'excellent'];

// const niveauToStars = { 'Faible': 1, 'Moyen': 2, 'Élevé': 3, 'Très élevé': 4, 'excellent': 5 };

// const NiveauStars = ({ niveau }) => {
//   const stars = niveauToStars[niveau] ?? 0;
//   return (
//     <span className="interet-stars">
//       {Array.from({ length: 5 }, (_, i) => (
//         <Star key={i} size={14} fill={i < stars ? '#f5c842' : 'none'} color={i < stars ? '#f5c842' : '#d1d5db'} />
//       ))}
//     </span>
//   );
// };

// // ─── Composant ───────────────────────────────────────────────────────────────
// const ProspectForm = () => {
//   const navigate = useNavigate();
//   const { id }   = useParams();
//   const isEdit   = !!id;
//   const { t }    = useTranslation();

//   const [toasts, setToasts]   = useState([]);
//   const [loading, setLoading] = useState(isEdit);
//   const [saving, setSaving]   = useState(false);
//   const [loadError, setLoadError] = useState(null);

//   // ── Spécialités disponibles (depuis /specialite_api/ISETAG_COM.specialites/) ──
//   const [specialites, setSpecialites] = useState([]);

//   // ── Intérêts sélectionnés pour CE prospect ──────────────────────────────────
//   // Format : [{ idInteret: string|null, idFiliere: string, libeleFiliere: string, niveauInteret: string }]
//   // idInteret = null pour les nouveaux non encore enregistrés
//   const [interets, setInterets] = useState([]);

//   // ── Ligne d'ajout ───────────────────────────────────────────────────────────
//   const [newIdSpecialite, setNewIdSpecialite] = useState('');
//   const [newNiveau, setNewNiveau]             = useState('Moyen');

//   // ── Toasts ──────────────────────────────────────────────────────────────────
//   const addToast = (message, type = 'success') => {
//     const tid = Date.now();
//     setToasts(prev => [...prev, { id: tid, message, type }]);
//     setTimeout(() => setToasts(prev => prev.filter(t => t.id !== tid)), 3000);
//   };

//   // ── Validation ──────────────────────────────────────────────────────────────
//   const validationRules = {
//     nomComplet:   [validators.required('Le nom complet est requis')],
//     telephone:    [validators.required('Le téléphone est requis'), validators.phone()],
//     email:        [validators.required("L'email est requis"), validators.email()],
//     niveauEtude:  [validators.required("Le niveau d'étude est requis")],
//     domaineEtude: [validators.required("Le domaine d'étude est requis")],
//     adresse:      [validators.required("L'adresse est requise")],
//     ville:        [validators.required('La ville est requise')],
//     pays:         [validators.required('Le pays est requis')],
//   };

//   const {
//     values, errors, touched,
//     handleChange, handleBlur, validateForm, setValues,
//   } = useFormValidation({
//     nomComplet: '', telephone: '', email: '',
//     niveauEtude: 'Terminale', domaineEtude: '',
//     adresse: '', ville: '', codePostal: '', pays: 'Cameroun',
//     sexe: 'M', typeProspect: 'Etudiant',
//     nomParent: '', numeroParent: '',
//   }, validationRules);

//   // ── Chargement des spécialités disponibles ──────────────────────────────────
//   useEffect(() => {
//     // GET /specialite_api/ISETAG_COM.specialites/
//     specialiteService.getAll()
//       .then(data => setSpecialites(Array.isArray(data) ? data : (data?.results ?? [])))
//       .catch(() => setSpecialites([]));
//   }, []);

//   // ── Chargement du prospect + ses intérêts (mode édition) ───────────────────
//   const loadProspect = useCallback(async () => {
//     if (!isEdit) return;
//     try {
//       // 1. GET /prospect_api/ISETAG_COM.prospects/{id}/
//       const prospect = await prospectService.getById(id);
//       setValues({
//         nomComplet:    prospect.nomComplet    || '',
//         telephone:     prospect.telephone     || '',
//         email:         prospect.email         || '',
//         niveauEtude:   prospect.niveauEtude   || 'Terminale',
//         domaineEtude:  prospect.domaineEtude  || '',
//         adresse:       prospect.adresse       || '',
//         ville:         prospect.ville         || '',
//         codePostal:    prospect.codePostal    || '',
//         pays:          prospect.pays          || 'Cameroun',
//         sexe:          prospect.sexe          || 'M',
//         typeProspect:  prospect.typeProspect  || 'Etudiant',
//         nomParent:     prospect.nomParent     || '',
//         numeroParent:  prospect.numeroParent  || '',
//       });

//       // 2. GET /specialite_api/ISETAG_COM.interetspecialites/prospect/{prospect_id}/
//       //    ← Route dédiée qui retourne UNIQUEMENT les intérêts de CE prospect
//       try {
//         const raw = await interetService.getByProspect(id);
//         const list = Array.isArray(raw) ? raw : (raw?.results ?? []);
//         setInterets(list.map(item => ({
//           idInteret:     item.idInteret,
//           idFiliere:     item.idSpecialite,
//           libeleFiliere: item.specialite_details?.libeleSpecialite ?? item.idSpecialite,
//           niveauInteret: item.niveauInteret,
//         })));
//       } catch {
//         setInterets([]);
//       }
//     } catch (err) {
//       setLoadError(err.message);
//     } finally {
//       setLoading(false);
//     }
//   }, [id, isEdit, setValues]);

//   useEffect(() => { loadProspect(); }, [loadProspect]);

//   // ── Ajouter un intérêt dans la liste locale ─────────────────────────────────
//   const handleAjouter = () => {
//     console.log('➕ handleAjouter appelé — newIdSpecialite =', newIdSpecialite, '| newNiveau =', newNiveau);

//     if (!newIdSpecialite) {
//       addToast('Sélectionne une spécialité', 'error');
//       console.warn('⚠️ handleAjouter annulé : newIdSpecialite est vide');
//       return;
//     }
//     if (interets.some(i => i.idFiliere === newIdSpecialite)) {
//       addToast('Cette spécialité est déjà dans la liste', 'error');
//       console.warn('⚠️ handleAjouter annulé : spécialité déjà présente dans interets');
//       return;
//     }
//     const spec = specialites.find(s => s.idSpecialite === newIdSpecialite);
//     const nouvelInteret = {
//       idInteret:     null, // sera créé par le backend au submit
//       idFiliere:     newIdSpecialite,
//       libeleFiliere: spec?.libeleSpecialite ?? spec?.libele ?? newIdSpecialite,
//       niveauInteret: newNiveau,
//     };
//     setInterets(prev => {
//       const next = [...prev, nouvelInteret];
//       console.log('✅ interets après ajout:', next);
//       return next;
//     });
//     setNewIdSpecialite('');
//     setNewNiveau('Moyen');
//   };

//   // ── Supprimer un intérêt de la liste locale ─────────────────────────────────
//   const handleSupprimer = (index) => {
//     setInterets(prev => prev.filter((_, i) => i !== index));
//   };

//   // ── Changer le niveauInteret d'un intérêt ───────────────────────────────────
//   const handleChangerNiveau = (index, niveau) => {
//     setInterets(prev => prev.map((item, i) => i === index ? { ...item, niveauInteret: niveau } : item));
//   };

//   // ── Soumission ───────────────────────────────────────────────────────────────
//   const handleSubmit = async (e) => {
//     e.preventDefault();
//     if (!validateForm()) {
//       addToast('Corrige les erreurs dans le formulaire', 'error');
//       return;
//     }
//     setSaving(true);

//     // 🔍 DEBUG : état de la liste locale des intérêts juste avant le submit.
//     // Si ce tableau est vide ici alors que tu as bien cliqué sur "Ajouter",
//     // le souci vient d'un problème de state React (à investiguer plus loin) ;
//     // s'il est vide parce que tu n'as jamais cliqué "Ajouter", ce n'est pas
//     // un bug, il faut juste ajouter la spécialité avant de soumettre.
//     console.log('🔍 DEBUG - interets juste avant handleSubmit:', interets);

//     try {
//       let prospectId = id;

//       if (isEdit) {
//         // PUT /prospect_api/ISETAG_COM.prospects/{id}/
//         await prospectService.update(id, values);
//       } else {
//         // POST /prospect_api/ISETAG_COM.prospects/
//         const created = await prospectService.create(values);
//         prospectId = created.idProspect ?? created.id;
//       }

//       console.log('📌 ID Prospect final pour les intérêts:', prospectId);

//       // Sync des intérêts via :
//       //   POST   /specialite_api/ISETAG_COM.interetspecialites/          (nouveaux)
//       //   PUT    /specialite_api/ISETAG_COM.interetspecialites/{id}/     (modifiés)
//       //   DELETE /specialite_api/ISETAG_COM.interetspecialites/{id}/     (supprimés)
//       // syncInterets calcule le diff automatiquement — plus d'ajout en double
//       if (prospectId) {
//         await interetService.syncInterets(prospectId, interets);
//       } else {
//         console.warn('⚠️ Pas de prospectId disponible, syncInterets non appelé');
//       }

//       addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès');
//       setTimeout(() => navigate('/prospects'), 1000);
//     } catch (err) {
//       console.error('❌ Erreur handleSubmit:', err);
//       addToast(err.message || "Erreur lors de l'enregistrement", 'error');
//     } finally {
//       setSaving(false);
//     }
//   };

//   // ─── Rendu ────────────────────────────────────────────────────────────────────
//   if (loading) return <p className="page-loading">{t('chargement')}</p>;

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={rid => setToasts(p => p.filter(t => t.id !== rid))} />

//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">{isEdit ? 'Modifier le prospect' : 'Nouveau prospect'}</h1>
//           <p className="page-description">
//             {isEdit ? 'Modifiez les informations du prospect.' : 'Ajoutez un nouveau prospect.'}
//           </p>
//         </div>
//         <button className="btn-outline" onClick={() => navigate('/prospects')}>
//           <ArrowLeft size={18} /> Retour
//         </button>
//       </div>

//       {loadError && <p className="form-error">{loadError}</p>}

//       <form onSubmit={handleSubmit} className="form-container">
//         <div className="form-grid">

//           {/* ── Nom complet ── */}
//           <div className="form-group full-width">
//             <label>Nom complet <span className="required">*</span></label>
//             <div className="input-icon"><User size={18} />
//               <input type="text" name="nomComplet" value={values.nomComplet} onChange={handleChange} onBlur={handleBlur} placeholder="Jean Dupont" className={errors.nomComplet && touched.nomComplet ? 'error' : ''} />
//             </div>
//             {errors.nomComplet && touched.nomComplet && <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
//           </div>

//           {/* ── Téléphone ── */}
//           <div className="form-group">
//             <label>Téléphone <span className="required">*</span></label>
//             <div className="input-icon"><Phone size={18} />
//               <input type="tel" name="telephone" value={values.telephone} onChange={handleChange} onBlur={handleBlur} placeholder="6XXXXXXXX" className={errors.telephone && touched.telephone ? 'error' : ''} />
//             </div>
//             {errors.telephone && touched.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
//           </div>

//           {/* ── Email ── */}
//           <div className="form-group">
//             <label>Email <span className="required">*</span></label>
//             <div className="input-icon"><Mail size={18} />
//               <input type="email" name="email" value={values.email} onChange={handleChange} onBlur={handleBlur} placeholder="exemple@email.com" className={errors.email && touched.email ? 'error' : ''} />
//             </div>
//             {errors.email && touched.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
//           </div>

//           {/* ── Niveau d'étude ── */}
//           <div className="form-group">
//             <label>Niveau d'étude <span className="required">*</span></label>
//             <div className="input-icon"><GraduationCap size={18} />
//               <select name="niveauEtude" value={values.niveauEtude} onChange={handleChange} onBlur={handleBlur}>
//                 {NIVEAUX_ETUDE.map(n => <option key={n} value={n}>{n}</option>)}
//               </select>
//             </div>
//             {errors.niveauEtude && touched.niveauEtude && <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
//           </div>

//           {/* ── Domaine d'étude ── */}
//           <div className="form-group">
//             <label>Domaine d'étude <span className="required">*</span></label>
//             <div className="input-icon"><GraduationCap size={18} />
//               <input type="text" name="domaineEtude" value={values.domaineEtude} onChange={handleChange} onBlur={handleBlur} placeholder="Ex: Génie Logiciel" className={errors.domaineEtude && touched.domaineEtude ? 'error' : ''} />
//             </div>
//             {errors.domaineEtude && touched.domaineEtude && <span className="error-message"><AlertCircle size={12} /> {errors.domaineEtude}</span>}
//           </div>

//           {/* ── Sexe ── */}
//           <div className="form-group">
//             <label>Sexe</label>
//             <div className="input-icon"><Users size={18} />
//               <select name="sexe" value={values.sexe} onChange={handleChange}>
//                 {SEXES.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
//               </select>
//             </div>
//           </div>

//           {/* ── Type de prospect ── */}
//           <div className="form-group">
//             <label>Type de prospect</label>
//             <div className="input-icon"><Users size={18} />
//               <select name="typeProspect" value={values.typeProspect} onChange={handleChange}>
//                 {TYPES_PROSPECT.map(tp => <option key={tp} value={tp}>{tp}</option>)}
//               </select>
//             </div>
//           </div>

//           {/* ── Adresse ── */}
//           <div className="form-group full-width">
//             <label>Adresse <span className="required">*</span></label>
//             <div className="input-icon"><MapPin size={18} />
//               <input type="text" name="adresse" value={values.adresse} onChange={handleChange} onBlur={handleBlur} placeholder="Adresse complète" className={errors.adresse && touched.adresse ? 'error' : ''} />
//             </div>
//             {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
//           </div>

//           {/* ── Ville ── */}
//           <div className="form-group">
//             <label>Ville <span className="required">*</span></label>
//             <div className="input-icon"><MapPin size={18} />
//               <input type="text" name="ville" value={values.ville} onChange={handleChange} onBlur={handleBlur} placeholder="Yaoundé" className={errors.ville && touched.ville ? 'error' : ''} />
//             </div>
//             {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
//           </div>

//           {/* ── Code postal ── */}
//           <div className="form-group">
//             <label>Code postal</label>
//             <div className="input-icon"><MapPin size={18} />
//               <input type="text" name="codePostal" value={values.codePostal} onChange={handleChange} placeholder="00237" />
//             </div>
//           </div>

//           {/* ── Pays ── */}
//           <div className="form-group">
//             <label>Pays <span className="required">*</span></label>
//             <div className="input-icon"><MapPin size={18} />
//               <input type="text" name="pays" value={values.pays} onChange={handleChange} onBlur={handleBlur} className={errors.pays && touched.pays ? 'error' : ''} />
//             </div>
//             {errors.pays && touched.pays && <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
//           </div>

//           {/* ── Nom du parent ── */}
//           <div className="form-group">
//             <label>Nom du parent</label>
//             <div className="input-icon"><User size={18} />
//               <input type="text" name="nomParent" value={values.nomParent} onChange={handleChange} placeholder="Si le prospect est mineur" />
//             </div>
//           </div>

//           {/* ── Téléphone du parent ── */}
//           <div className="form-group">
//             <label>Téléphone du parent</label>
//             <div className="input-icon"><Phone size={18} />
//               <input type="tel" name="numeroParent" value={values.numeroParent} onChange={handleChange} placeholder="6XXXXXXXX" />
//             </div>
//           </div>
//         </div>

//         {/* ═══════════════════════════════════════════════════════════
//             Section Spécialités d'intérêt
//             Gestion individuelle par prospect via :
//               GET    .../interetspecialites/prospect/{id}/   ← chargement
//               POST   .../interetspecialites/                 ← ajout
//               PUT    .../interetspecialites/{idInteret}/     ← modif niveau
//               DELETE .../interetspecialites/{idInteret}/     ← suppression
//         ═══════════════════════════════════════════════════════════ */}
//         <div className="form-section">
//           <h3 className="form-section-title">
//             <GraduationCap size={18} />
//             Spécialités d'intérêt
//           </h3>

//           {/* ── Liste des intérêts sélectionnés ── */}
//           {interets.length > 0 && (
//             <div className="interets-list">
//               {interets.map((item, index) => (
//                 <div key={index} className="interet-row">
//                   <div className="interet-filiere">
//                     <GraduationCap size={14} />
//                     <strong>{item.libeleFiliere || item.idFiliere}</strong>
//                     {item.idInteret && <span className="badge-saved">✓ enregistré</span>}
//                   </div>
//                   <div className="interet-niveau">
//                     <select
//                       value={item.niveauInteret}
//                       onChange={e => handleChangerNiveau(index, e.target.value)}
//                       className="niveau-select"
//                     >
//                       {NIVEAUX_INTERET.map(n => <option key={n} value={n}>{n}</option>)}
//                     </select>
//                     <NiveauStars niveau={item.niveauInteret} />
//                   </div>
//                   <button type="button" className="action-btn delete" onClick={() => handleSupprimer(index)}>
//                     <Trash2 size={14} />
//                   </button>
//                 </div>
//               ))}
//             </div>
//           )}

//           {/* ── Ligne d'ajout ── */}
//           <div className="interet-add-row">
//             <div className="input-icon" style={{ flex: 2 }}>
//               <GraduationCap size={18} />
//               <select value={newIdSpecialite} onChange={e => setNewIdSpecialite(e.target.value)}>
//                 <option value="">— Choisir une spécialité —</option>
//                 {specialites
//                   .filter(s => !interets.some(i => i.idFiliere === s.idSpecialite))
//                   .map(s => (
//                     <option key={s.idSpecialite} value={s.idSpecialite}>
//                       {s.libeleSpecialite ?? s.libele ?? s.acronyme ?? s.idSpecialite}
//                     </option>
//                   ))
//                 }
//               </select>
//             </div>
//             <div className="input-icon" style={{ flex: 1 }}>
//               <Star size={18} />
//               <select value={newNiveau} onChange={e => setNewNiveau(e.target.value)}>
//                 {NIVEAUX_INTERET.map(n => <option key={n} value={n}>{n}</option>)}
//               </select>
//             </div>
//             <button type="button" className="btn-outline btn-add-filiere" onClick={handleAjouter}>
//               <Plus size={16} /> Ajouter
//             </button>
//           </div>

//           {specialites.length === 0 && (
//             <p className="form-hint">⚠️ Spécialités non chargées — vérifier /specialite_api/ISETAG_COM.specialites/</p>
//           )}
//         </div>

//         {/* ── Actions ── */}
//         <div className="form-actions">
//           <button type="button" className="btn-outline" onClick={() => navigate('/prospects')} disabled={saving}>
//             Annuler
//           </button>
//           <button type="submit" className="btn-primary" disabled={saving}>
//             <Save size={18} />
//             {saving ? 'Enregistrement…' : isEdit ? 'Mettre à jour' : 'Créer'}
//           </button>
//         </div>
//       </form>
//     </div>
//   );
// };

// export default ProspectForm;


import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import {
  Save, ArrowLeft, AlertCircle, User, Mail, Phone,
  MapPin, GraduationCap, Users, Plus, Trash2, Star,
} from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useFormValidation, validators } from '../../hooks/useFormValidation';
import { useTranslation } from '../../hooks/useTranslation';
// Routes réelles issues de ISETAG_COM_API.yaml
import { prospectService }   from '../../services/prospectService';
import { specialiteService } from '../../services/filiereService';
import { interetService }    from '../../services/interetService';
import '../Prospects/Prospects.css';

// ─── Constantes ───────────────────────────────────────────────────────────────
const NIVEAUX_ETUDE   = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master'];
const TYPES_PROSPECT  = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
const SEXES           = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];
const NIVEAUX_INTERET = ['Faible', 'Moyen', 'Élevé', 'Très élevé', 'Excellent'];

const niveauToStars = { 'Faible': 1, 'Moyen': 2, 'Élevé': 3, 'Très élevé': 4, 'Excellent': 5 };

const NiveauStars = ({ niveau }) => {
  const stars = niveauToStars[niveau] ?? 0;
  return (
    <span className="interet-stars">
      {Array.from({ length: 5 }, (_, i) => (
        <Star key={i} size={14} fill={i < stars ? '#f5c842' : 'none'} color={i < stars ? '#f5c842' : '#d1d5db'} />
      ))}
    </span>
  );
};

// ─── Composant ───────────────────────────────────────────────────────────────
const ProspectForm = () => {
  const navigate = useNavigate();
  const { id }   = useParams();
  const isEdit   = !!id;
  const { t }    = useTranslation();

  const [toasts, setToasts]   = useState([]);
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving]   = useState(false);
  const [loadError, setLoadError] = useState(null);

  // ── Spécialités disponibles (depuis /specialite_api/ISETAG_COM.specialites/) ──
  const [specialites, setSpecialites] = useState([]);

  // ── Intérêts sélectionnés pour CE prospect ──────────────────────────────────
  // Format : [{ idInteret: string|null, idFiliere: string, libeleFiliere: string, niveauInteret: string }]
  // idInteret = null pour les nouveaux non encore enregistrés
  const [interets, setInterets] = useState([]);

  // ── Ligne d'ajout ───────────────────────────────────────────────────────────
  const [newIdSpecialite, setNewIdSpecialite] = useState('');
  const [newNiveau, setNewNiveau]             = useState('Moyen');

  // ── Toasts ──────────────────────────────────────────────────────────────────
  const addToast = (message, type = 'success') => {
    const tid = Date.now();
    setToasts(prev => [...prev, { id: tid, message, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== tid)), 3000);
  };

  // ── Validation ──────────────────────────────────────────────────────────────
  const validationRules = {
    nomComplet:   [validators.required('Le nom complet est requis')],
    telephone:    [validators.required('Le téléphone est requis'), validators.phone()],
        // email:        [validators.required("L'email est requis"), validators.email()],
    niveauEtude:  [validators.required("Le niveau d'étude est requis")],
    domaineEtude: [validators.required("Le domaine d'étude est requis")],
    adresse:      [validators.required("L'adresse est requise")],
    ville:        [validators.required('La ville est requise')],
    pays:         [validators.required('Le pays est requis')],
  };

  const {
    values, errors, touched,
    handleChange, handleBlur, validateForm, setValues,
  } = useFormValidation({
    nomComplet: '', telephone: '', email: '',
    niveauEtude: 'Terminale', domaineEtude: '',
    adresse: '', ville: '', codePostal: '', pays: 'Cameroun',
    sexe: 'M', typeProspect: 'Etudiant',
    nomParent: '', numeroParent: '',
  }, validationRules);

  // ── Chargement des spécialités disponibles ──────────────────────────────────
  useEffect(() => {
    // GET /specialite_api/ISETAG_COM.specialites/
    specialiteService.getAll()
      .then(data => setSpecialites(Array.isArray(data) ? data : (data?.results ?? [])))
      .catch(() => setSpecialites([]));
  }, []);

  // ── Chargement du prospect + ses intérêts (mode édition) ───────────────────
  const loadProspect = useCallback(async () => {
    if (!isEdit) return;
    try {
      // 1. GET /prospect_api/ISETAG_COM.prospects/{id}/
      const prospect = await prospectService.getById(id);
      setValues({
        nomComplet:    prospect.nomComplet    || '',
        telephone:     prospect.telephone     || '',
        email:         prospect.email         || '',
        niveauEtude:   prospect.niveauEtude   || 'Terminale',
        domaineEtude:  prospect.domaineEtude  || '',
        adresse:       prospect.adresse       || '',
        ville:         prospect.ville         || '',
        codePostal:    prospect.codePostal    || '',
        pays:          prospect.pays          || 'Cameroun',
        sexe:          prospect.sexe          || 'M',
        typeProspect:  prospect.typeProspect  || 'Etudiant',
        nomParent:     prospect.nomParent     || '',
        numeroParent:  prospect.numeroParent  || '',
      });

      // 2. GET /specialite_api/ISETAG_COM.interetspecialites/prospect/{prospect_id}/
      //    ← Route dédiée qui retourne UNIQUEMENT les intérêts de CE prospect
      try {
        const raw = await interetService.getByProspect(id);
        const list = Array.isArray(raw) ? raw : (raw?.results ?? []);
        setInterets(list.map(item => ({
          idInteret:     item.idInteret,
          idFiliere:     item.idSpecialite,
          libeleFiliere: item.specialite_details?.libeleSpecialite ?? item.idSpecialite,
          niveauInteret: item.niveauInteret,
        })));
      } catch {
        setInterets([]);
      }
    } catch (err) {
      setLoadError(err.message);
    } finally {
      setLoading(false);
    }
  }, [id, isEdit, setValues]);

  useEffect(() => { loadProspect(); }, [loadProspect]);

  // ── Ajouter un intérêt dans la liste locale ─────────────────────────────────
  const handleAjouter = () => {
    console.log('➕ handleAjouter appelé — newIdSpecialite =', newIdSpecialite, '| newNiveau =', newNiveau);

    if (!newIdSpecialite) {
      addToast('Sélectionne une spécialité', 'error');
      console.warn('⚠️ handleAjouter annulé : newIdSpecialite est vide');
      return;
    }
    if (interets.some(i => i.idFiliere === newIdSpecialite)) {
      addToast('Cette spécialité est déjà dans la liste', 'error');
      console.warn('⚠️ handleAjouter annulé : spécialité déjà présente dans interets');
      return;
    }
    const spec = specialites.find(s => s.idSpecialite === newIdSpecialite);
    const nouvelInteret = {
      idInteret:     null, // sera créé par le backend au submit
      idFiliere:     newIdSpecialite,
      libeleFiliere: spec?.libeleSpecialite ?? spec?.libele ?? newIdSpecialite,
      niveauInteret: newNiveau,
    };
    setInterets(prev => {
      const next = [...prev, nouvelInteret];
      console.log('✅ interets après ajout:', next);
      return next;
    });
    setNewIdSpecialite('');
    setNewNiveau('Moyen');
  };

  // ── Supprimer un intérêt de la liste locale ─────────────────────────────────
  const handleSupprimer = (index) => {
    setInterets(prev => prev.filter((_, i) => i !== index));
  };

  // ── Changer le niveauInteret d'un intérêt ───────────────────────────────────
  const handleChangerNiveau = (index, niveau) => {
    setInterets(prev => prev.map((item, i) => i === index ? { ...item, niveauInteret: niveau } : item));
  };

  // ── Soumission ───────────────────────────────────────────────────────────────
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Corrige les erreurs dans le formulaire', 'error');
      return;
    }
    setSaving(true);

    // 🔍 DEBUG : état de la liste locale des intérêts juste avant le submit.
    // Si ce tableau est vide ici alors que tu as bien cliqué sur "Ajouter",
    // le souci vient d'un problème de state React (à investiguer plus loin) ;
    // s'il est vide parce que tu n'as jamais cliqué "Ajouter", ce n'est pas
    // un bug, il faut juste ajouter la spécialité avant de soumettre.
    console.log('🔍 DEBUG - interets juste avant handleSubmit:', interets);

    try {
      let prospectId = id;

      if (isEdit) {
        // PUT /prospect_api/ISETAG_COM.prospects/{id}/
        // ⚠️ idProspect est un champ REQUIS dans le corps de la requête
        // (schéma ProspectRequest), même si l'ID est déjà dans l'URL.
        // Sans lui, le backend rejette l'update.
        await prospectService.update(id, { idProspect: id, ...values });
      } else {
        // POST /prospect_api/ISETAG_COM.prospects/
        const created = await prospectService.create(values);
        prospectId = created.idProspect ?? created.id;
      }

      console.log('📌 ID Prospect final pour les intérêts:', prospectId);

      // Sync des intérêts via :
      //   POST   /specialite_api/ISETAG_COM.interetspecialites/          (nouveaux)
      //   PUT    /specialite_api/ISETAG_COM.interetspecialites/{id}/     (modifiés)
      //   DELETE /specialite_api/ISETAG_COM.interetspecialites/{id}/     (supprimés)
      // syncInterets calcule le diff automatiquement — plus d'ajout en double
      if (prospectId) {
        await interetService.syncInterets(prospectId, interets);
      } else {
        console.warn('⚠️ Pas de prospectId disponible, syncInterets non appelé');
      }

      addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès');
      setTimeout(() => navigate('/prospects'), 1000);
    } catch (err) {
      console.error('❌ Erreur handleSubmit:', err);
      addToast(err.message || "Erreur lors de l'enregistrement", 'error');
    } finally {
      setSaving(false);
    }
  };

  // ─── Rendu ────────────────────────────────────────────────────────────────────
  if (loading) return <p className="page-loading">{t('chargement')}</p>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={rid => setToasts(p => p.filter(t => t.id !== rid))} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier le prospect' : 'Nouveau prospect'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations du prospect.' : 'Ajoutez un nouveau prospect.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/prospects')}>
          <ArrowLeft size={18} /> Retour
        </button>
      </div>

      {loadError && <p className="form-error">{loadError}</p>}

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">

          {/* ── Nom complet ── */}
          <div className="form-group full-width">
            <label>Nom complet <span className="required">*</span></label>
            <div className="input-icon"><User size={18} />
              <input type="text" name="nomComplet" value={values.nomComplet} onChange={handleChange} onBlur={handleBlur} placeholder="Jean Dupont" className={errors.nomComplet && touched.nomComplet ? 'error' : ''} />
            </div>
            {errors.nomComplet && touched.nomComplet && <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
          </div>

          {/* ── Téléphone ── */}
          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon"><Phone size={18} />
              <input type="tel" name="telephone" value={values.telephone} onChange={handleChange} onBlur={handleBlur} placeholder="6XXXXXXXX" className={errors.telephone && touched.telephone ? 'error' : ''} />
            </div>
            {errors.telephone && touched.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
          </div>

          {/* ── Email ── */}
          <div className="form-group">
            <label>Email <span className="required">*</span></label>
            <div className="input-icon"><Mail size={18} />
              <input type="email" name="email" value={values.email} onChange={handleChange} onBlur={handleBlur} placeholder="exemple@email.com" className={errors.email && touched.email ? 'error' : ''} />
            </div>
            {errors.email && touched.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          {/* ── Niveau d'étude ── */}
          <div className="form-group">
            <label>Niveau d'étude <span className="required">*</span></label>
            <div className="input-icon"><GraduationCap size={18} />
              <select name="niveauEtude" value={values.niveauEtude} onChange={handleChange} onBlur={handleBlur}>
                {NIVEAUX_ETUDE.map(n => <option key={n} value={n}>{n}</option>)}
              </select>
            </div>
            {errors.niveauEtude && touched.niveauEtude && <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
          </div>

          {/* ── Domaine d'étude ── */}
          <div className="form-group">
            <label>Domaine d'étude <span className="required">*</span></label>
            <div className="input-icon"><GraduationCap size={18} />
              <input type="text" name="domaineEtude" value={values.domaineEtude} onChange={handleChange} onBlur={handleBlur} placeholder="Ex: Génie Logiciel" className={errors.domaineEtude && touched.domaineEtude ? 'error' : ''} />
            </div>
            {errors.domaineEtude && touched.domaineEtude && <span className="error-message"><AlertCircle size={12} /> {errors.domaineEtude}</span>}
          </div>

          {/* ── Sexe ── */}
          <div className="form-group">
            <label>Sexe</label>
            <div className="input-icon"><Users size={18} />
              <select name="sexe" value={values.sexe} onChange={handleChange}>
                {SEXES.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
            </div>
          </div>

          {/* ── Type de prospect ── */}
          <div className="form-group">
            <label>Type de prospect</label>
            <div className="input-icon"><Users size={18} />
              <select name="typeProspect" value={values.typeProspect} onChange={handleChange}>
                {TYPES_PROSPECT.map(tp => <option key={tp} value={tp}>{tp}</option>)}
              </select>
            </div>
          </div>

          {/* ── Adresse ── */}
          <div className="form-group full-width">
            <label>Adresse <span className="required">*</span></label>
            <div className="input-icon"><MapPin size={18} />
              <input type="text" name="adresse" value={values.adresse} onChange={handleChange} onBlur={handleBlur} placeholder="Adresse complète" className={errors.adresse && touched.adresse ? 'error' : ''} />
            </div>
            {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
          </div>

          {/* ── Ville ── */}
          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon"><MapPin size={18} />
              <input type="text" name="ville" value={values.ville} onChange={handleChange} onBlur={handleBlur} placeholder="Yaoundé" className={errors.ville && touched.ville ? 'error' : ''} />
            </div>
            {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          {/* ── Code postal ── */}
          <div className="form-group">
            <label>Code postal</label>
            <div className="input-icon"><MapPin size={18} />
              <input type="text" name="codePostal" value={values.codePostal} onChange={handleChange} placeholder="00237" />
            </div>
          </div>

          {/* ── Pays ── */}
          <div className="form-group">
            <label>Pays <span className="required">*</span></label>
            <div className="input-icon"><MapPin size={18} />
              <input type="text" name="pays" value={values.pays} onChange={handleChange} onBlur={handleBlur} className={errors.pays && touched.pays ? 'error' : ''} />
            </div>
            {errors.pays && touched.pays && <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
          </div>

          {/* ── Nom du parent ── */}
          <div className="form-group">
            <label>Nom du parent</label>
            <div className="input-icon"><User size={18} />
              <input type="text" name="nomParent" value={values.nomParent} onChange={handleChange} placeholder="Si le prospect est mineur" />
            </div>
          </div>

          {/* ── Téléphone du parent ── */}
          <div className="form-group">
            <label>Téléphone du parent</label>
            <div className="input-icon"><Phone size={18} />
              <input type="tel" name="numeroParent" value={values.numeroParent} onChange={handleChange} placeholder="6XXXXXXXX" />
            </div>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════
            Section Spécialités d'intérêt
            Gestion individuelle par prospect via :
              GET    .../interetspecialites/prospect/{id}/   ← chargement
              POST   .../interetspecialites/                 ← ajout
              PUT    .../interetspecialites/{idInteret}/     ← modif niveau
              DELETE .../interetspecialites/{idInteret}/     ← suppression
        ═══════════════════════════════════════════════════════════ */}
        <div className="form-section">
          <h3 className="form-section-title">
            <GraduationCap size={18} />
            Spécialités d'intérêt
          </h3>

          {/* ── Liste des intérêts sélectionnés ── */}
          {interets.length > 0 && (
            <div className="interets-list">
              {interets.map((item, index) => (
                <div key={index} className="interet-row">
                  <div className="interet-filiere">
                    <GraduationCap size={14} />
                    <strong>{item.libeleFiliere || item.idFiliere}</strong>
                    {item.idInteret && <span className="badge-saved">✓ enregistré</span>}
                  </div>
                  <div className="interet-niveau">
                    <select
                      value={item.niveauInteret}
                      onChange={e => handleChangerNiveau(index, e.target.value)}
                      className="niveau-select"
                    >
                      {NIVEAUX_INTERET.map(n => <option key={n} value={n}>{n}</option>)}
                    </select>
                    <NiveauStars niveau={item.niveauInteret} />
                  </div>
                  <button type="button" className="action-btn delete" onClick={() => handleSupprimer(index)}>
                    <Trash2 size={14} />
                  </button>
                </div>
              ))}
            </div>
          )}

          {/* ── Ligne d'ajout ── */}
          <div className="interet-add-row">
            <div className="input-icon" style={{ flex: 2 }}>
              <GraduationCap size={18} />
              <select value={newIdSpecialite} onChange={e => setNewIdSpecialite(e.target.value)}>
                <option value="">— Choisir une spécialité —</option>
                {specialites
                  .filter(s => !interets.some(i => i.idFiliere === s.idSpecialite))
                  .map(s => (
                    <option key={s.idSpecialite} value={s.idSpecialite}>
                      {s.libeleSpecialite ?? s.libele ?? s.acronyme ?? s.idSpecialite}
                    </option>
                  ))
                }
              </select>
            </div>
            <div className="input-icon" style={{ flex: 1 }}>
              <Star size={18} />
              <select value={newNiveau} onChange={e => setNewNiveau(e.target.value)}>
                {NIVEAUX_INTERET.map(n => <option key={n} value={n}>{n}</option>)}
              </select>
            </div>
            <button type="button" className="btn-outline btn-add-filiere" onClick={handleAjouter}>
              <Plus size={16} /> Ajouter
            </button>
          </div>

          {specialites.length === 0 && (
            <p className="form-hint">⚠️ Spécialités non chargées — vérifier /specialite_api/ISETAG_COM.specialites/</p>
          )}
        </div>

        {/* ── Actions ── */}
        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/prospects')} disabled={saving}>
            Annuler
          </button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : isEdit ? 'Mettre à jour' : 'Créer'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default ProspectForm;