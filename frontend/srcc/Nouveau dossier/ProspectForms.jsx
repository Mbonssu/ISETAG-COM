// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin, GraduationCap, Users, Plus, X } from 'lucide-react';
// import { ToastContainer } from '../../components/common/Toast';
// import { useFormValidation, validators } from '../../hooks/useFormValidation';
// import { interetService } from '../../services/interetService';
// import { prospectService } from '../../services/prospectService';
// import { specialiteService } from '../../services/filiereService';
// import StarRating from '../../components/StarRating';
// import './Prospects.css';

// const ProspectForm = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const isEdit = !!id;
//   const [toasts, setToasts] = useState([]);
//   const [loading, setLoading] = useState(isEdit);
//   const [saving, setSaving] = useState(false);
//   const [loadError, setLoadError] = useState(null);
//   const [prospectId, setProspectId] = useState(null);
//   const [currentUser, setCurrentUser] = useState(null);
//   const [specialites, setSpecialites] = useState([]);
//   const [loadingSpecialites, setLoadingSpecialites] = useState(false);

//   // ============================================================
//   // 1. ÉTAT DES INTÉRÊTS DU PROSPECT
//   // ============================================================

//   const [interets, setInterets] = useState([
//     { idSpecialite: '', libeleSpecialite: '', niveauInteret: 1 }
//   ]);

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (toastId) => {
//     setToasts(prev => prev.filter(t => t.id !== toastId));
//   };

//   const niveauxEtude = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master 1'];
//   const typesProspect = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
//   const sexes = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];

//   const { values, errors, touched, handleChange, handleBlur, validateForm, setValues } = useFormValidation(
//     {
//       id: null,
//       nomComplet: '',
//       telephone: '',
//       email: null,
//       niveauEtude: 'Terminale',
//       domaineEtude: null,
//       adresse: null,
//       ville: 'Douala',
//       codePostal: '',
//       pays: 'Cameroun',
//       sexe: 'M',
//       typeProspect: 'Etudiant',
//       nomParent: null,
//       numeroParent: null,
//       utilisateurId: null,
//     },
//     // validationRules
//   );

//   // ============================================================
//   // 2. CHARGEMENT DES SPÉCIALITÉS DISPONIBLES
//   // ============================================================

//   useEffect(() => {
//     loadAvailableSpecialites();
//   }, []);

//   const loadAvailableSpecialites = async () => {
//     setLoadingSpecialites(true);
//     try {
//       const data = await specialiteService.getAll();
//       setSpecialites(Array.isArray(data) ? data : []);
//     } catch (err) {
//       console.error('❌ Erreur chargement spécialités:', err);
//     } finally {
//       setLoadingSpecialites(false);
//     }
//   };

//   // ============================================================
//   // 3. GESTION DES INTÉRÊTS
//   // ============================================================

//   const addInteret = () => {
//     setInterets([
//       ...interets,
//       { idSpecialite: '', libeleSpecialite: '', niveauInteret: 1 }
//     ]);
//   };

//   const removeInteret = (index) => {
//     if (interets.length <= 1) {
//       addToast('Vous devez avoir au moins une spécialité', 'warning');
//       return;
//     }
//     const newInterets = interets.filter((_, i) => i !== index);
//     setInterets(newInterets);
//   };

//   const updateInteret = (index, field, value) => {
//     const newInterets = [...interets];
//     newInterets[index][field] = value;
//     setInterets(newInterets);
//   };

//   const updateInteretNiveau = (index, value) => {
//     const newInterets = [...interets];
//     newInterets[index].niveauInteret = value;
//     setInterets(newInterets);
//   };

//   // ============================================================
//   // 4. RÉCUPÉRATION DE L'UTILISATEUR CONNECTÉ
//   // ============================================================
  
//   const getCurrentUser = async () => {
//     try {
//       console.log('🔍 Récupération de l\'utilisateur connecté...');
      
//       const storedUser = localStorage.getItem('currentUser');
//       if (storedUser) {
//         const user = JSON.parse(storedUser);
//         console.log('✅ Utilisateur récupéré depuis localStorage:', user);
//         setCurrentUser(user);
//         setValues(prev => ({ ...prev, utilisateurId: user.idUtilisateur || user.id }));
//         return;
//       }

//       try {
//         const token = localStorage.getItem('auth_token');
//         if (token) {
//           const payload = JSON.parse(atob(token.split('.')[1]));
//           console.log('📋 Token décodé:', payload);
//           const userId = payload.user_id || payload.sub || payload.id;
//           if (userId) {
//             setValues(prev => ({ ...prev, utilisateurId: userId }));
//             setCurrentUser({ id: userId });
//           }
//         }
//       } catch (decodeError) {
//         console.warn('⚠️ Impossible de décoder le token:', decodeError);
//       }
      
//     } catch (error) {
//       console.warn('⚠️ Impossible de récupérer l\'utilisateur connecté:', error);
//     }
//   };

//   // ============================================================
//   // 5. CHARGEMENT DU PROSPECT (MODE ÉDITION)
//   // ============================================================

//   useEffect(() => {
//     getCurrentUser();
    
//     if (isEdit) {
//       prospectService.getById(id)
//         .then(async (data) => {
//           console.log('📥 Prospect chargé:', data);
          
//           const idProspect = data.id || data.idProspect || data.id_Prospect;
          
//           if (!idProspect) {
//             console.warn('⚠️ L\'ID du prospect est null ou undefined');
//             setLoadError('L\'ID du prospect est manquant');
//             addToast('Erreur: ID du prospect introuvable', 'error');
//             return;
//           }
          
//           setProspectId(idProspect);
//           console.log('✅ ID Prospect récupéré:', idProspect);
          
//           const utilisateurId = data.utilisateurId || data.userId || values.utilisateurId || null;
          
//           setValues({
//             id: idProspect,
//             nomComplet: data.nomComplet || '',
//             telephone: data.telephone || '',
//             email: data.email || '',
//             niveauEtude: data.niveauEtude || 'Terminale',
//             domaineEtude: data.domaineEtude || '',
//             adresse: data.adresse || '',
//             ville: data.ville || 'Douala',
//             codePostal: data.codePostal || '',
//             pays: data.pays || 'Cameroun',
//             sexe: data.sexe || 'M',
//             typeProspect: data.typeProspect || 'Etudiant',
//             nomParent: data.nomParent || '',
//             numeroParent: data.numeroParent || '',
//             utilisateurId: utilisateurId,
//           });

//           // Charger les niveaux d'intérêt du prospect
//           try {
//             const interetsData = await interetService.getByProspect(idProspect);
//             if (Array.isArray(interetsData) && interetsData.length > 0) {
//               const interetsWithLibele = await Promise.all(
//                 interetsData.map(async (interet) => {
//                   try {
//                     const specialite = await specialiteService.getById(interet.idSpecialite);
//                     return {
//                       idInteret: interet.idInteret,
//                       idSpecialite: interet.idSpecialite,
//                       libeleSpecialite: specialite.libeleSpecialite || specialite.libele || '',
//                       niveauInteret: parseInt(interet.niveauInteret) || 1
//                     };
//                   } catch (err) {
//                     return {
//                       idInteret: interet.idInteret,
//                       idSpecialite: interet.idSpecialite,
//                       libeleSpecialite: '',
//                       niveauInteret: parseInt(interet.niveauInteret) || 1
//                     };
//                   }
//                 })
//               );
//               setInterets(interetsWithLibele);
//             }
//           } catch (err) {
//             console.warn('⚠️ Aucun niveau d\'intérêt trouvé:', err);
//           }
//         })
//         .catch((err) => {
//           console.error('❌ Erreur chargement prospect:', err);
//           setLoadError(err.message);
//           addToast(`Erreur: ${err.message}`, 'error');
//         })
//         .finally(() => setLoading(false));
//     }
//   }, [id, isEdit]);

//   // ============================================================
//   // 6. SOUMISSION DU FORMULAIRE
//   // ============================================================

//   const handleSubmit = async (e) => {
//     e.preventDefault();
    
//     // Vérifier qu'il y a au moins une spécialité valide
//     const hasValidInteret = interets.some(i => i.idSpecialite && i.idSpecialite.trim() !== '');
//     if (!hasValidInteret) {
//       addToast('Veuillez sélectionner au moins une spécialité', 'error');
//       return;
//     }

//     if (!validateForm()) {
//       addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
//       return;
//     }

//     setSaving(true);
//     try {
//       const userId = values.utilisateurId || currentUser?.id || null;
      
//       // Construction du payload du prospect
//       const payload = {
//         nomComplet: values.nomComplet,
//         telephone: values.telephone,
//         email: values.email || null,
//         niveauEtude: values.niveauEtude,
//         domaineEtude: values.domaineEtude,
//         adresse: values.adresse,
//         ville: values.ville,
//         codePostal: values.codePostal || null,
//         pays: values.pays,
//         sexe: values.sexe,
//         typeProspect: values.typeProspect,
//         nomParent: values.nomParent || null,
//         numeroParent: values.numeroParent || null,
//         utilisateurId: userId,
//       };

//       if (isEdit) {
//         payload.idProspect = prospectId || id;
//       }

//       console.log('📤 Envoi des données prospect:', payload);

//       let response;
//       if (isEdit) {
//         response = await prospectService.update(prospectId || id, payload);
//         console.log('✅ Prospect mis à jour:', response);
//       } else {
//         response = await prospectService.create(payload);
//         console.log('✅ Prospect créé:', response);
//       }

//       const finalProspectId = response.id || response.idProspect || prospectId || id;

//       // 2. Gérer les niveaux d'intérêt
//       // Supprimer les anciens intérêts si édition
//       if (isEdit) {
//         try {
//           await interetService.deleteByProspect(finalProspectId);
//         } catch (err) {
//           console.warn('⚠️ Erreur suppression anciens intérêts:', err);
//         }
//       }

//       // Créer les nouveaux intérêts
//       const interetPromises = interets
//         .filter(i => i.idSpecialite && i.idSpecialite.trim() !== '')
//         .map((interet) => {
//           return interetService.create({
//             idSpecialite: interet.idSpecialite,
//             idProspect: finalProspectId,
//             niveauInteret: String(interet.niveauInteret || 1),
//           });
//         });

//       await Promise.all(interetPromises);
//       console.log('✅ Niveaux d\'intérêt enregistrés');

//       addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès', 'success');
//       setTimeout(() => navigate('/prospects'), 1500);
//     } catch (error) {
//       console.error('❌ Erreur enregistrement:', error);
      
//       if (error.response?.data) {
//         const errorData = error.response.data;
//         let errorMessage = '';
        
//         if (typeof errorData === 'object') {
//           errorMessage = Object.entries(errorData)
//             .map(([key, value]) => `${key}: ${Array.isArray(value) ? value.join(', ') : value}`)
//             .join(' | ');
//         } else {
//           errorMessage = errorData || error.message;
//         }
        
//         addToast(`Erreur: ${errorMessage}`, 'error');
//       } else {
//         addToast(error.message || 'Erreur lors de l\'enregistrement', 'error');
//       }
//     } finally {
//       setSaving(false);
//     }
//   };

//   // ============================================================
//   // 7. RENDER
//   // ============================================================

//   if (loading) {
//     return (
//       <div className="page-container">
//         <div className="text-center py-5">
//           <div className="spinner-border text-primary" role="status">
//             <span className="visually-hidden">Chargement...</span>
//           </div>
//           <p className="mt-3">Chargement du prospect…</p>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />

//       {loadError && (
//         <div className="alert alert-danger">
//           <AlertCircle size={18} />
//           <span>{loadError}</span>
//         </div>
//       )}

//       <form onSubmit={handleSubmit} className="form-container">
//         <div className="form-grid">
//           <input type="hidden" name="id" value={values.id || ''} />
//           <input type="hidden" name="utilisateurId" value={values.utilisateurId || ''} />

//           <div className="form-group full-width">
//             <label>Nom complet de l'etudiant</label>
//             <div className="input-icon">
//               <User size={18} />
//               <input
//                 type="text"
//                 name="nomComplet"
//                 value={values.nomComplet}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Ex: Jean Dupont"
//                 className={errors.nomComplet && touched.nomComplet ? 'error' : ''}
//               />
//             </div>
//             {errors.nomComplet && touched.nomComplet && <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
//           </div>

//           <div className="form-group">
//             <label>Téléphone</label>
//             <div className="input-icon">
//               <Phone size={18} />
//               <input
//                 type="tel"
//                 name="telephone"
//                 value={values.telephone}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="6XXXXXXXX"
//                 className={errors.telephone && touched.telephone ? 'error' : ''}
//               />
//             </div>
//             {errors.telephone && touched.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
//           </div>

//           <div className="form-group">
//             <label>Email</label>
//             <div className="input-icon">
//               <Mail size={18} />
//               <input
//                 type="email"
//                 name="email"
//                 value={values.email}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="exemple@email.com"
//                 className={errors.email && touched.email ? 'error' : ''}
//               />
//             </div>
//             {errors.email && touched.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
//           </div>

//           {/* ============================================================
//               SPÉCIALITÉS ET NIVEAUX D'INTÉRÊT
//               ============================================================ */}

//           <div className="form-group full-width">
//             <label style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
//               <span>Spécialités et niveaux d'intérêt</span>
//               <button 
//                 type="button" 
//                 className="btn-add-spec" 
//                 onClick={addInteret}
//                 disabled={saving}
//                 style={{ padding: '4px 12px', fontSize: '13px' }}
//               >
//                 <Plus size={16} /> Ajouter
//               </button>
//             </label>

//             {interets.map((interet, index) => (
//               <div key={index} className="specialite-item">
//                 <div className="specialite-input">
//                   <select
//                     value={interet.idSpecialite}
//                     onChange={(e) => {
//                       const selectedId = e.target.value;
//                       const selected = specialites.find(s => s.idSpecialite === selectedId);
//                       updateInteret(index, 'idSpecialite', selectedId);
//                       updateInteret(index, 'libeleSpecialite', selected?.libeleSpecialite || '');
//                     }}
//                     disabled={saving || loadingSpecialites}
//                     style={{ width: '100%', padding: '8px 12px', borderRadius: '4px', border: '1px solid #ddd' }}
//                   >
//                     <option value="">Sélectionner une spécialité</option>
//                     {specialites.map((spec) => (
//                       <option key={spec.idSpecialite} value={spec.idSpecialite}>
//                         {spec.libeleSpecialite} {spec.acronyme ? `(${spec.acronyme})` : ''}
//                       </option>
//                     ))}
//                   </select>
//                 </div>
//                 <div className="rating-input">
//                   <span className="rating-label">Intérêt:</span>
//                   <StarRating
//                     value={interet.niveauInteret}
//                     onChange={(value) => updateInteretNiveau(index, value)}
//                     size={22}
//                     readonly={saving}
//                   />
//                 </div>
//                 <button
//                   type="button"
//                   className="remove-btn"
//                   onClick={() => removeInteret(index)}
//                   disabled={saving}
//                   title="Supprimer cette spécialité"
//                 >
//                   <X size={18} />
//                 </button>
//               </div>
//             ))}
//             <small className="text-muted">
//               Sélectionnez les spécialités qui intéressent le prospect et notez son niveau d'intérêt de 1 à 5
//             </small>
//           </div>

//           <div className="form-group">
//             <label>Niveau d'étude</label>
//             <div className="input-icon">
//               <GraduationCap size={18} />
//               <select name="niveauEtude" value={values.niveauEtude} onChange={handleChange} onBlur={handleBlur}>
//                 {niveauxEtude.map(n => <option key={n} value={n}>{n}</option>)}
//               </select>
//             </div>
//             {errors.niveauEtude && touched.niveauEtude && <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
//           </div>

//           <div className="form-group">
//             <label>Série ou domaine d'étude</label>
//             <div className="input-icon">
//               <GraduationCap size={18} />
//               <input
//                 type="text"
//                 name="domaineEtude"
//                 value={values.domaineEtude}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Ex: A, C, D / Génie Logiciel ..."
//                 className={errors.domaineEtude && touched.domaineEtude ? 'error' : ''}
//               />
//             </div>
//             {errors.domaineEtude && touched.domaineEtude && <span className="error-message"><AlertCircle size={12} /> {errors.domaineEtude}</span>}
//           </div>

//           <div className="form-group">
//             <label>Sexe</label>
//             <div className="input-icon">
//               <Users size={18} />
//               <select name="sexe" value={values.sexe} onChange={handleChange}>
//                 {sexes.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
//               </select>
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Type de prospect</label>
//             <div className="input-icon">
//               <Users size={18} />
//               <select name="typeProspect" value={values.typeProspect} onChange={handleChange}>
//                 {typesProspect.map(tp => <option key={tp} value={tp}>{tp}</option>)}
//               </select>
//             </div>
//           </div>

//           <div className="form-group full-width">
//             <label>Adresse</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="adresse"
//                 value={values.adresse}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Adresse complète"
//                 className={errors.adresse && touched.adresse ? 'error' : ''}
//               />
//             </div>
//             {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
//           </div>

//           <div className="form-group">
//             <label>Ville</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="ville"
//                 value={values.ville}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Ex: Yaoundé"
//                 className={errors.ville && touched.ville ? 'error' : ''}
//               />
//             </div>
//             {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
//           </div>

//           <div className="form-group">
//             <label>Code postal</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="codePostal"
//                 value={values.codePostal}
//                 onChange={handleChange}
//                 placeholder="Ex: 00237"
//               />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Pays</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="pays"
//                 value={values.pays}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 className={errors.pays && touched.pays ? 'error' : ''}
//               />
//             </div>
//             {errors.pays && touched.pays && <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
//           </div>

//           <div className="form-group">
//             <label>Nom du parent</label>
//             <div className="input-icon">
//               <User size={18} />
//               <input
//                 type="text"
//                 name="nomParent"
//                 value={values.nomParent}
//                 onChange={handleChange}
//                 placeholder="Si le prospect est mineur"
//               />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Téléphone du parent</label>
//             <div className="input-icon">
//               <Phone size={18} />
//               <input
//                 type="tel"
//                 name="numeroParent"
//                 value={values.numeroParent}
//                 onChange={handleChange}
//                 placeholder="6XXXXXXXX"
//               />
//             </div>
//           </div>
//         </div> 

//         <div className="form-actions">
//           <button type="button" className="btn-outline" onClick={() => navigate('/prospects')} disabled={saving}>
//             Annuler
//           </button>
//           <button type="submit" className="btn-primary" disabled={saving}>
//             <Save size={18} />
//             {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer')}
//           </button>
//         </div>
//       </form>
//     </div>
//   );
// };

// export default ProspectForm;

// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin, GraduationCap, Users, Plus, X } from 'lucide-react';
// import { ToastContainer } from '../../components/common/Toast';
// import { useFormValidation, validators } from '../../hooks/useFormValidation';
// import { interetService } from '../../services/interetService';
// import { prospectService } from '../../services/prospectService';
// import { specialiteService } from '../../services/filiereService'; // ← CORRECTION ICI
// import StarRating from '../../components/StarRating';
// import './Prospects.css';

// const ProspectForm = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const isEdit = !!id;
//   const [toasts, setToasts] = useState([]);
//   const [loading, setLoading] = useState(isEdit);
//   const [saving, setSaving] = useState(false);
//   const [loadError, setLoadError] = useState(null);
//   const [prospectId, setProspectId] = useState(null);
//   const [currentUser, setCurrentUser] = useState(null);
//   const [specialites, setSpecialites] = useState([]);
//   const [loadingSpecialites, setLoadingSpecialites] = useState(false);

//   // ============================================================
//   // 1. ÉTAT DES INTÉRÊTS DU PROSPECT
//   // ============================================================

//   const [interets, setInterets] = useState([
//     { idSpecialite: '', libeleSpecialite: '', niveauInteret: 1 }
//   ]);

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (toastId) => {
//     setToasts(prev => prev.filter(t => t.id !== toastId));
//   };

//   const niveauxEtude = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master 1'];
//   const typesProspect = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
//   const sexes = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];

//   const { values, errors, touched, handleChange, handleBlur, validateForm, setValues } = useFormValidation(
//     {
//       id: null,
//       nomComplet: '',
//       telephone: '',
//       email: null,
//       niveauEtude: 'Terminale',
//       domaineEtude: null,
//       adresse: null,
//       ville: 'Douala',
//       codePostal: '',
//       pays: 'Cameroun',
//       sexe: 'M',
//       typeProspect: 'Etudiant',
//       nomParent: null,
//       numeroParent: null,
//       utilisateurId: null,
//     },
//     // validationRules
//   );

//   // ============================================================
//   // 2. CHARGEMENT DES SPÉCIALITÉS DISPONIBLES
//   // ============================================================

//   useEffect(() => {
//     loadAvailableSpecialites();
//   }, []);

//   const loadAvailableSpecialites = async () => {
//     setLoadingSpecialites(true);
//     try {
//       const data = await specialiteService.getAll();
//       console.log('📋 Spécialités disponibles:', data);
//       setSpecialites(Array.isArray(data) ? data : []);
//     } catch (err) {
//       console.error('❌ Erreur chargement spécialités:', err);
//     } finally {
//       setLoadingSpecialites(false);
//     }
//   };

//   // ============================================================
//   // 3. GESTION DES INTÉRÊTS
//   // ============================================================

//   const addInteret = () => {
//     setInterets([
//       ...interets,
//       { idSpecialite: '', libeleSpecialite: '', niveauInteret: 1 }
//     ]);
//   };

//   const removeInteret = (index) => {
//     if (interets.length <= 1) {
//       addToast('Vous devez avoir au moins une spécialité', 'warning');
//       return;
//     }
//     const newInterets = interets.filter((_, i) => i !== index);
//     setInterets(newInterets);
//   };

//   const updateInteret = (index, field, value) => {
//     const newInterets = [...interets];
//     newInterets[index][field] = value;
//     setInterets(newInterets);
//   };

//   const updateInteretNiveau = (index, value) => {
//     const newInterets = [...interets];
//     newInterets[index].niveauInteret = value;
//     setInterets(newInterets);
//   };

//   // ============================================================
//   // 4. RÉCUPÉRATION DE L'UTILISATEUR CONNECTÉ
//   // ============================================================
  
//   const getCurrentUser = async () => {
//     try {
//       console.log('🔍 Récupération de l\'utilisateur connecté...');
      
//       const storedUser = localStorage.getItem('currentUser');
//       if (storedUser) {
//         const user = JSON.parse(storedUser);
//         console.log('✅ Utilisateur récupéré depuis localStorage:', user);
//         setCurrentUser(user);
//         setValues(prev => ({ ...prev, utilisateurId: user.idUtilisateur || user.id }));
//         return;
//       }

//       try {
//         const token = localStorage.getItem('auth_token');
//         if (token) {
//           const payload = JSON.parse(atob(token.split('.')[1]));
//           console.log('📋 Token décodé:', payload);
//           const userId = payload.user_id || payload.sub || payload.id;
//           if (userId) {
//             setValues(prev => ({ ...prev, utilisateurId: userId }));
//             setCurrentUser({ id: userId });
//           }
//         }
//       } catch (decodeError) {
//         console.warn('⚠️ Impossible de décoder le token:', decodeError);
//       }
      
//     } catch (error) {
//       console.warn('⚠️ Impossible de récupérer l\'utilisateur connecté:', error);
//     }
//   };

//   // ============================================================
//   // 5. CHARGEMENT DU PROSPECT (MODE ÉDITION)
//   // ============================================================

//   useEffect(() => {
//     getCurrentUser();
    
//     if (isEdit) {
//       prospectService.getById(id)
//         .then(async (data) => {
//           console.log('📥 Prospect chargé:', data);
          
//           const idProspect = data.id || data.idProspect || data.id_Prospect;
          
//           if (!idProspect) {
//             console.warn('⚠️ L\'ID du prospect est null ou undefined');
//             setLoadError('L\'ID du prospect est manquant');
//             addToast('Erreur: ID du prospect introuvable', 'error');
//             return;
//           }
          
//           setProspectId(idProspect);
//           console.log('✅ ID Prospect récupéré:', idProspect);
          
//           const utilisateurId = data.utilisateurId || data.userId || values.utilisateurId || null;
          
//           setValues({
//             id: idProspect,
//             nomComplet: data.nomComplet || '',
//             telephone: data.telephone || '',
//             email: data.email || '',
//             niveauEtude: data.niveauEtude || 'Terminale',
//             domaineEtude: data.domaineEtude || '',
//             adresse: data.adresse || '',
//             ville: data.ville || 'Douala',
//             codePostal: data.codePostal || '',
//             pays: data.pays || 'Cameroun',
//             sexe: data.sexe || 'M',
//             typeProspect: data.typeProspect || 'Etudiant',
//             nomParent: data.nomParent || '',
//             numeroParent: data.numeroParent || '',
//             utilisateurId: utilisateurId,
//           });

//           // Charger les niveaux d'intérêt du prospect
//           try {
//             const interetsData = await interetService.getByProspect(idProspect);
//             console.log('📋 Intérêts chargés pour le prospect:', interetsData);
            
//             if (Array.isArray(interetsData) && interetsData.length > 0) {
//               const interetsWithLibele = await Promise.all(
//                 interetsData.map(async (interet) => {
//                   try {
//                     const specialite = await specialiteService.getById(interet.idSpecialite);
//                     return {
//                       idInteret: interet.idInteret,
//                       idSpecialite: interet.idSpecialite,
//                       libeleSpecialite: specialite.libeleSpecialite || specialite.libele || '',
//                       niveauInteret: parseInt(interet.niveauInteret) || 1
//                     };
//                   } catch (err) {
//                     return {
//                       idInteret: interet.idInteret,
//                       idSpecialite: interet.idSpecialite,
//                       libeleSpecialite: '',
//                       niveauInteret: parseInt(interet.niveauInteret) || 1
//                     };
//                   }
//                 })
//               );
//               setInterets(interetsWithLibele);
//             }
//           } catch (err) {
//             console.warn('⚠️ Aucun niveau d\'intérêt trouvé:', err);
//           }
//         })
//         .catch((err) => {
//           console.error('❌ Erreur chargement prospect:', err);
//           setLoadError(err.message);
//           addToast(`Erreur: ${err.message}`, 'error');
//         })
//         .finally(() => setLoading(false));
//     }
//   }, [id, isEdit]);

//   // ============================================================
//   // 6. SOUMISSION DU FORMULAIRE
//   // ============================================================

//   const handleSubmit = async (e) => {
//     e.preventDefault();
    
//     // Vérifier qu'il y a au moins une spécialité valide
//     const hasValidInteret = interets.some(i => i.idSpecialite && i.idSpecialite.trim() !== '');
//     if (!hasValidInteret) {
//       addToast('Veuillez sélectionner au moins une spécialité', 'error');
//       return;
//     }

//     if (!validateForm()) {
//       addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
//       return;
//     }

//     setSaving(true);
//     try {
//       const userId = values.utilisateurId || currentUser?.id || null;
      
//       // Construction du payload du prospect
//       const payload = {
//         nomComplet: values.nomComplet,
//         telephone: values.telephone,
//         email: values.email || null,
//         niveauEtude: values.niveauEtude,
//         domaineEtude: values.domaineEtude,
//         adresse: values.adresse,
//         ville: values.ville,
//         codePostal: values.codePostal || null,
//         pays: values.pays,
//         sexe: values.sexe,
//         typeProspect: values.typeProspect,
//         nomParent: values.nomParent || null,
//         numeroParent: values.numeroParent || null,
//         utilisateurId: userId,
//       };

//       if (isEdit) {
//         payload.idProspect = prospectId || id;
//       }

//       console.log('📤 Envoi des données prospect:', payload);

//       let response;
//       if (isEdit) {
//         response = await prospectService.update(prospectId || id, payload);
//         console.log('✅ Prospect mis à jour:', response);
//       } else {
//         response = await prospectService.create(payload);
//         console.log('✅ Prospect créé:', response);
//       }

//       const finalProspectId = response.id || response.idProspect || prospectId || id;
//       console.log('📌 ID Prospect final pour les intérêts:', finalProspectId);

//       // 2. Gérer les niveaux d'intérêt
//       // Supprimer les anciens intérêts si édition
//       if (isEdit) {
//         try {
//           await interetService.deleteByProspect(finalProspectId);
//           console.log('🗑️ Anciens intérêts supprimés pour le prospect:', finalProspectId);
//         } catch (err) {
//           console.warn('⚠️ Erreur suppression anciens intérêts:', err);
//         }
//       }

//       // Créer les nouveaux intérêts
//       const interetsToSave = interets.filter(i => i.idSpecialite && i.idSpecialite.trim() !== '');
//       console.log('📝 Intérêts à enregistrer:', interetsToSave);

//       const interetPromises = interetsToSave.map((interet) => {
//         return interetService.create({
//           idSpecialite: interet.idSpecialite,
//           idProspect: finalProspectId,
//           niveauInteret: String(interet.niveauInteret || 1),
//         });
//       });

//       await Promise.all(interetPromises);
//       console.log('✅ Niveaux d\'intérêt enregistrés');

//       addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès', 'success');
//       setTimeout(() => navigate('/prospects'), 1500);
//     } catch (error) {
//       console.error('❌ Erreur enregistrement:', error);
      
//       if (error.response?.data) {
//         const errorData = error.response.data;
//         let errorMessage = '';
        
//         if (typeof errorData === 'object') {
//           errorMessage = Object.entries(errorData)
//             .map(([key, value]) => `${key}: ${Array.isArray(value) ? value.join(', ') : value}`)
//             .join(' | ');
//         } else {
//           errorMessage = errorData || error.message;
//         }
        
//         addToast(`Erreur: ${errorMessage}`, 'error');
//       } else {
//         addToast(error.message || 'Erreur lors de l\'enregistrement', 'error');
//       }
//     } finally {
//       setSaving(false);
//     }
//   };

//   // ============================================================
//   // 7. RENDER
//   // ============================================================

//   if (loading) {
//     return (
//       <div className="page-container">
//         <div className="text-center py-5">
//           <div className="spinner-border text-primary" role="status">
//             <span className="visually-hidden">Chargement...</span>
//           </div>
//           <p className="mt-3">Chargement du prospect…</p>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />

//       {loadError && (
//         <div className="alert alert-danger">
//           <AlertCircle size={18} />
//           <span>{loadError}</span>
//         </div>
//       )}

//       <form onSubmit={handleSubmit} className="form-container">
//         <div className="form-grid">
//           <input type="hidden" name="id" value={values.id || ''} />
//           <input type="hidden" name="utilisateurId" value={values.utilisateurId || ''} />

//           <div className="form-group full-width">
//             <label>Nom complet de l'étudiant</label>
//             <div className="input-icon">
//               <User size={18} />
//               <input
//                 type="text"
//                 name="nomComplet"
//                 value={values.nomComplet}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Ex: Jean Dupont"
//                 className={errors.nomComplet && touched.nomComplet ? 'error' : ''}
//               />
//             </div>
//             {errors.nomComplet && touched.nomComplet && <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
//           </div>

//           <div className="form-group">
//             <label>Téléphone</label>
//             <div className="input-icon">
//               <Phone size={18} />
//               <input
//                 type="tel"
//                 name="telephone"
//                 value={values.telephone}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="6XXXXXXXX"
//                 className={errors.telephone && touched.telephone ? 'error' : ''}
//               />
//             </div>
//             {errors.telephone && touched.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
//           </div>

//           <div className="form-group">
//             <label>Email</label>
//             <div className="input-icon">
//               <Mail size={18} />
//               <input
//                 type="email"
//                 name="email"
//                 value={values.email}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="exemple@email.com"
//                 className={errors.email && touched.email ? 'error' : ''}
//               />
//             </div>
//             {errors.email && touched.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
//           </div>

//           {/* ============================================================
//               SPÉCIALITÉS ET NIVEAUX D'INTÉRÊT
//               ============================================================ */}

//           <div className="form-group full-width">
//             <label style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
//               <span>Spécialités et niveaux d'intérêt</span>
//               <button 
//                 type="button" 
//                 className="btn-add-spec" 
//                 onClick={addInteret}
//                 disabled={saving}
//                 style={{ padding: '4px 12px', fontSize: '13px' }}
//               >
//                 <Plus size={16} /> Ajouter
//               </button>
//             </label>

//             {interets.map((interet, index) => (
//               <div key={index} className="specialite-item">
//                 <div className="specialite-input">
//                   <select
//                     value={interet.idSpecialite}
//                     onChange={(e) => {
//                       const selectedId = e.target.value;
//                       const selected = specialites.find(s => s.idSpecialite === selectedId);
//                       updateInteret(index, 'idSpecialite', selectedId);
//                       updateInteret(index, 'libeleSpecialite', selected?.libeleSpecialite || '');
//                     }}
//                     disabled={saving || loadingSpecialites}
//                     style={{ width: '100%', padding: '8px 12px', borderRadius: '4px', border: '1px solid #ddd' }}
//                   >
//                     <option value="">Sélectionner une spécialité</option>
//                     {specialites.map((spec) => (
//                       <option key={spec.idSpecialite} value={spec.idSpecialite}>
//                         {spec.libeleSpecialite} {spec.acronyme ? `(${spec.acronyme})` : ''}
//                       </option>
//                     ))}
//                   </select>
//                 </div>
//                 <div className="rating-input">
//                   <span className="rating-label">Intérêt:</span>
//                   <StarRating
//                     value={interet.niveauInteret}
//                     onChange={(value) => updateInteretNiveau(index, value)}
//                     size={22}
//                     readonly={saving}
//                   />
//                 </div>
//                 <button
//                   type="button"
//                   className="remove-btn"
//                   onClick={() => removeInteret(index)}
//                   disabled={saving}
//                   title="Supprimer cette spécialité"
//                 >
//                   <X size={18} />
//                 </button>
//               </div>
//             ))}
//             <small className="text-muted">
//               Sélectionnez les spécialités qui intéressent le prospect et notez son niveau d'intérêt de 1 à 5
//             </small>
//           </div>

//           <div className="form-group">
//             <label>Niveau d'étude</label>
//             <div className="input-icon">
//               <GraduationCap size={18} />
//               <select name="niveauEtude" value={values.niveauEtude} onChange={handleChange} onBlur={handleBlur}>
//                 {niveauxEtude.map(n => <option key={n} value={n}>{n}</option>)}
//               </select>
//             </div>
//             {errors.niveauEtude && touched.niveauEtude && <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
//           </div>

//           <div className="form-group">
//             <label>Série ou domaine d'étude</label>
//             <div className="input-icon">
//               <GraduationCap size={18} />
//               <input
//                 type="text"
//                 name="domaineEtude"
//                 value={values.domaineEtude}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Ex: A, C, D / Génie Logiciel ..."
//                 className={errors.domaineEtude && touched.domaineEtude ? 'error' : ''}
//               />
//             </div>
//             {errors.domaineEtude && touched.domaineEtude && <span className="error-message"><AlertCircle size={12} /> {errors.domaineEtude}</span>}
//           </div>

//           <div className="form-group">
//             <label>Sexe</label>
//             <div className="input-icon">
//               <Users size={18} />
//               <select name="sexe" value={values.sexe} onChange={handleChange}>
//                 {sexes.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
//               </select>
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Type de prospect</label>
//             <div className="input-icon">
//               <Users size={18} />
//               <select name="typeProspect" value={values.typeProspect} onChange={handleChange}>
//                 {typesProspect.map(tp => <option key={tp} value={tp}>{tp}</option>)}
//               </select>
//             </div>
//           </div>

//           <div className="form-group full-width">
//             <label>Adresse</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="adresse"
//                 value={values.adresse}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Adresse complète"
//                 className={errors.adresse && touched.adresse ? 'error' : ''}
//               />
//             </div>
//             {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
//           </div>

//           <div className="form-group">
//             <label>Ville</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="ville"
//                 value={values.ville}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 placeholder="Ex: Yaoundé"
//                 className={errors.ville && touched.ville ? 'error' : ''}
//               />
//             </div>
//             {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
//           </div>

//           <div className="form-group">
//             <label>Code postal</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="codePostal"
//                 value={values.codePostal}
//                 onChange={handleChange}
//                 placeholder="Ex: 00237"
//               />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Pays</label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input
//                 type="text"
//                 name="pays"
//                 value={values.pays}
//                 onChange={handleChange}
//                 onBlur={handleBlur}
//                 className={errors.pays && touched.pays ? 'error' : ''}
//               />
//             </div>
//             {errors.pays && touched.pays && <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
//           </div>

//           <div className="form-group">
//             <label>Nom du parent</label>
//             <div className="input-icon">
//               <User size={18} />
//               <input
//                 type="text"
//                 name="nomParent"
//                 value={values.nomParent}
//                 onChange={handleChange}
//                 placeholder="Si le prospect est mineur"
//               />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Téléphone du parent</label>
//             <div className="input-icon">
//               <Phone size={18} />
//               <input
//                 type="tel"
//                 name="numeroParent"
//                 value={values.numeroParent}
//                 onChange={handleChange}
//                 placeholder="6XXXXXXXX"
//               />
//             </div>
//           </div>
//         </div> 

//         <div className="form-actions">
//           <button type="button" className="btn-outline" onClick={() => navigate('/prospects')} disabled={saving}>
//             Annuler
//           </button>
//           <button type="submit" className="btn-primary" disabled={saving}>
//             <Save size={18} />
//             {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer')}
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
import { prospectService } from '../../services/prospectService';
// 🔧 ROUTE — modifier BASE_URL dans src/services/specialiteService.js
import { specialiteService } from '../../services/filiereService';
import '../Prospects/Prospects.css';

// ─── Constantes ───────────────────────────────────────────────────────────────
const NIVEAUX_ETUDE    = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master', 'Doctorat'];
const TYPES_PROSPECT   = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
const SEXES            = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];
const NIVEAUX_INTERET  = ['Faible', 'Moyen', 'Élevé', 'Très élevé'];

// ─── Étoiles de niveau d'intérêt ─────────────────────────────────────────────
const niveauToStars = { 'Faible': 1, 'Moyen': 2, 'Élevé': 3, 'Très élevé': 4 };
const NiveauStars = ({ niveau }) => {
  const stars = niveauToStars[niveau] ?? 0;
  return (
    <span className="interet-stars">
      {Array.from({ length: 4 }, (_, i) => (
        <Star
          key={i}
          size={14}
          fill={i < stars ? '#f5c842' : 'none'}
          color={i < stars ? '#f5c842' : '#d1d5db'}
        />
      ))}
    </span>
  );
};

// ─── Composant principal ──────────────────────────────────────────────────────
const ProspectForm = () => {
  const navigate = useNavigate();
  const { id }   = useParams();
  const isEdit   = !!id;

  const [toasts, setToasts]   = useState([]);
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving]   = useState(false);
  const [loadError, setLoadError] = useState(null);

  // ── État des filières d'intérêt ──────────────────────────────────────────
  // Liste des filières disponibles (chargées depuis l'API)
  const [filieresDisponibles, setFilieresDisponibles] = useState([]);
  // Filières sélectionnées POUR CE PROSPECT : [{ idFiliere, nomFiliere, niveauInteret, idInteret? }]
  const [filieresSelectionnees, setFilieresSelectionnees] = useState([]);
  // Pour la ligne d'ajout
  const [nouvelleFiliere, setNouvelleFiliere]     = useState('');
  const [nouveauNiveau, setNouveauNiveau]         = useState('Moyen');

  // ── Toasts ───────────────────────────────────────────────────────────────
  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== toastId)), 3000);
  };

  // ── Validation du formulaire principal ───────────────────────────────────
  const validationRules = {
    nomComplet:  [validators.required('Le nom complet est requis')],
    telephone:   [validators.required('Le téléphone est requis'), validators.phone()],
    email:       [validators.required("L'email est requis"), validators.email()],
    niveauEtude: [validators.required("Le niveau d'étude est requis")],
    domaineEtude:[validators.required("Le domaine d'étude est requis")],
    adresse:     [validators.required("L'adresse est requise")],
    ville:       [validators.required('La ville est requise')],
    pays:        [validators.required('Le pays est requis')],
  };

  const {
    values, errors, touched,
    handleChange, handleBlur, validateForm, setValues,
  } = useFormValidation(
    {
      nomComplet: '', telephone: '', email: '',
      niveauEtude: 'Terminale', domaineEtude: '',
      adresse: '', ville: '', codePostal: '', pays: 'Cameroun',
      sexe: 'M', typeProspect: 'Etudiant',
      dateNaissance: '', nomParent: '', numeroParent: '',
    },
    validationRules
  );

  // ── Chargement des filières disponibles ──────────────────────────────────
  useEffect(() => {
    specialiteService.getAll()
      .then(data => {
        const list = Array.isArray(data) ? data : (data?.results ?? []);
        setFilieresDisponibles(list);
      })
      .catch(() => {
        setFilieresDisponibles([]);
      });
  }, []);

  // ── Chargement du prospect en mode édition ───────────────────────────────
  // ⚠️  FIX : on charge les interets DEPUIS CE PROSPECT PRÉCIS via son ID.
  //     Avant le fix, l'appel n'incluait pas l'ID dans l'URL, ce qui
  //     renvoyait les interets de TOUS les prospects.
  const loadProspect = useCallback(async () => {
    if (!isEdit) return;
    try {
      // 1. Charger le prospect (infos de base)
      const data = await prospectService.getById(id);
      setValues({
        nomComplet:   data.nomComplet    || '',
        telephone:    data.telephone     || '',
        email:        data.email         || '',
        niveauEtude:  data.niveauEtude   || 'Terminale',
        domaineEtude: data.domaineEtude  || '',
        adresse:      data.adresse       || '',
        ville:        data.ville         || '',
        codePostal:   data.codePostal    || '',
        pays:         data.pays          || 'Cameroun',
        sexe:         data.sexe          || 'M',
        typeProspect: data.typeProspect  || 'Etudiant',
        dateNaissance:data.dateNaissance || '',
        nomParent:    data.nomParent     || '',
        numeroParent: data.numeroParent  || '',
      });

      // 2. Charger les filières d'intérêt DE CE PROSPECT UNIQUEMENT
      //    via /prospect_api/ISETAG_COM.prospects/<id>/interets/
      //
      // ⚠️  C'est ici que se trouvait le bug : l'endpoint appelé
      //     n'incluait pas l'ID du prospect → toutes les lignes
      //     ManyToMany de tous les prospects étaient renvoyées.
      let interets = [];

      // Cas A : le backend renvoie les interets dans le GET du prospect
      if (Array.isArray(data.specialiteInteret) && data.specialiteInteret.length > 0) {
        interets = data.specialiteInteret;
      }
      // Cas B : endpoint dédié /interets/ (🔧 route à confirmer avec ton ami)
      else {
        try {
          const raw = await prospectService.getInterets(id);
          interets  = Array.isArray(raw) ? raw : (raw?.results ?? []);
        } catch {
          interets = [];
        }
      }

      // Normaliser le format en utilisant les vrais champs de specialiteService
      // idSpecialite = clé primaire, libeleSpecialite = libellé affiché
      setFilieresSelectionnees(
        interets.map(item => ({
          idInteret:     item.idInteret      ?? item.id          ?? null,
          idFiliere:     item.idSpecialite   ?? item.idFiliere   ?? '',
          nomFiliere:    item.libeleSpecialite ?? item.nomFiliere ?? item.libele ?? '',
          niveauInteret: item.niveauInteret  ?? item.niveau      ?? 'Moyen',
        }))
      );
    } catch (err) {
      setLoadError(err.message);
    } finally {
      setLoading(false);
    }
  }, [id, isEdit, setValues]);

  useEffect(() => { loadProspect(); }, [loadProspect]);

  // ── Ajout d'une filière dans la liste locale ─────────────────────────────
  const handleAjouterFiliere = () => {
    if (!nouvelleFiliere) {
      addToast('Veuillez sélectionner une filière', 'error');
      return;
    }
    // Empêcher les doublons
    const dejaPresente = filieresSelectionnees.some(f => f.idFiliere === nouvelleFiliere);
    if (dejaPresente) {
      addToast('Cette filière est déjà dans la liste', 'error');
      return;
    }
    const filiereObj = filieresDisponibles.find(
      f => f.idSpecialite === nouvelleFiliere
    );
    setFilieresSelectionnees(prev => [
      ...prev,
      {
        idInteret:     null,
        idFiliere:     nouvelleFiliere,
        nomFiliere:    filiereObj?.libeleSpecialite ?? filiereObj?.libele ?? nouvelleFiliere,
        niveauInteret: nouveauNiveau,
      },
    ]);
    // Reset du sélecteur
    setNouvelleFiliere('');
    setNouveauNiveau('Moyen');
  };

  // ── Suppression d'une filière de la liste locale ─────────────────────────
  const handleSupprimerFiliere = (index) => {
    setFilieresSelectionnees(prev => prev.filter((_, i) => i !== index));
  };

  // ── Changement du niveau d'intérêt d'une filière existante ───────────────
  const handleChangerNiveau = (index, newNiveau) => {
    setFilieresSelectionnees(prev =>
      prev.map((f, i) => i === index ? { ...f, niveauInteret: newNiveau } : f)
    );
  };

  // ── Soumission ────────────────────────────────────────────────────────────
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setSaving(true);
    try {
      const payload = {
        ...values,
        dateNaissance: values.dateNaissance || null,
        nomParent:     values.nomParent     || null,
        numeroParent:  values.numeroParent  || null,
        // On inclut les filières dans le payload principal.
        // 🔧 Le serializer Django doit faire instance.specialiteInteret.set(...)
        //    dans sa méthode update(). Si ce n'est pas encore implémenté,
        //    utilise setInterets() séparément ci-dessous.
        specialiteInteret: filieresSelectionnees.map(f => ({
          idFiliere:     f.idFiliere,
          niveauInteret: f.niveauInteret,
        })),
      };

      if (isEdit) {
        // ⚠️  FIX : l'ID du prospect est TOUJOURS dans l'URL du PUT.
        //     Avant le fix, cet ID était parfois absent, ce qui faisait
        //     que Django créait un nouvel enregistrement au lieu de
        //     mettre à jour le bon prospect.
        await prospectService.update(id, payload);

        // 🔧 OPTION B : si le backend ne gère pas specialiteInteret dans le PUT,
        //    décommente les lignes ci-dessous pour gérer les interets séparément.
        //    setInterets() supprime d'abord TOUS les interets existants de CE
        //    prospect (via /<pk>/interets/<id>/), puis recrée les nouveaux.
        //
        // await prospectService.setInterets(id, filieresSelectionnees.map(f => ({
        //   idFiliere:     f.idFiliere,
        //   niveauInteret: f.niveauInteret,
        // })));

      } else {
        const created = await prospectService.create(payload);

        // 🔧 OPTION B (création) : si le backend ne gère pas specialiteInteret
        //    dans le POST, ajoute les interets après la création :
        //
        // const newId = created.idProspect ?? created.id;
        // if (newId && filieresSelectionnees.length > 0) {
        //   await prospectService.setInterets(newId, filieresSelectionnees.map(f => ({
        //     idFiliere:     f.idFiliere,
        //     niveauInteret: f.niveauInteret,
        //   })));
        // }
      }

      addToast(
        isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès',
        'success'
      );
      setTimeout(() => navigate('/prospects'), 1000);
    } catch (error) {
      addToast(error.message || "Erreur lors de l'enregistrement", 'error');
    } finally {
      setSaving(false);
    }
  };

  // ── Rendu ─────────────────────────────────────────────────────────────────
  if (loading) return <p className="page-loading">Chargement du prospect…</p>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">
            {isEdit ? 'Modifier le prospect' : 'Nouveau prospect'}
          </h1>
          <p className="page-description">
            {isEdit
              ? 'Modifiez les informations du prospect.'
              : 'Ajoutez un nouveau prospect à la base de données.'}
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
            <div className="input-icon">
              <User size={18} />
              <input
                type="text" name="nomComplet" value={values.nomComplet}
                onChange={handleChange} onBlur={handleBlur}
                placeholder="Ex: Jean Dupont"
                className={errors.nomComplet && touched.nomComplet ? 'error' : ''}
              />
            </div>
            {errors.nomComplet && touched.nomComplet &&
              <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
          </div>

          {/* ── Téléphone ── */}
          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel" name="telephone" value={values.telephone}
                onChange={handleChange} onBlur={handleBlur}
                placeholder="6XXXXXXXX"
                className={errors.telephone && touched.telephone ? 'error' : ''}
              />
            </div>
            {errors.telephone && touched.telephone &&
              <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
          </div>

          {/* ── Email ── */}
          <div className="form-group">
            <label>Email <span className="required">*</span></label>
            <div className="input-icon">
              <Mail size={18} />
              <input
                type="email" name="email" value={values.email}
                onChange={handleChange} onBlur={handleBlur}
                placeholder="exemple@email.com"
                className={errors.email && touched.email ? 'error' : ''}
              />
            </div>
            {errors.email && touched.email &&
              <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          {/* ── Date de naissance ── */}
          <div className="form-group">
            <label>Date de naissance</label>
            <div className="input-icon">
              <User size={18} />
              <input type="date" name="dateNaissance" value={values.dateNaissance} onChange={handleChange} />
            </div>
          </div>

          {/* ── Niveau d'étude ── */}
          <div className="form-group">
            <label>Niveau d'étude <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <select name="niveauEtude" value={values.niveauEtude} onChange={handleChange} onBlur={handleBlur}>
                {NIVEAUX_ETUDE.map(n => <option key={n} value={n}>{n}</option>)}
              </select>
            </div>
            {errors.niveauEtude && touched.niveauEtude &&
              <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
          </div>

          {/* ── Domaine d'étude ── */}
          <div className="form-group">
            <label>Domaine d'étude <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <input
                type="text" name="domaineEtude" value={values.domaineEtude}
                onChange={handleChange} onBlur={handleBlur}
                placeholder="Ex: Génie Logiciel"
                className={errors.domaineEtude && touched.domaineEtude ? 'error' : ''}
              />
            </div>
            {errors.domaineEtude && touched.domaineEtude &&
              <span className="error-message"><AlertCircle size={12} /> {errors.domaineEtude}</span>}
          </div>

          {/* ── Sexe ── */}
          <div className="form-group">
            <label>Sexe</label>
            <div className="input-icon">
              <Users size={18} />
              <select name="sexe" value={values.sexe} onChange={handleChange}>
                {SEXES.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
            </div>
          </div>

          {/* ── Type de prospect ── */}
          <div className="form-group">
            <label>Type de prospect</label>
            <div className="input-icon">
              <Users size={18} />
              <select name="typeProspect" value={values.typeProspect} onChange={handleChange}>
                {TYPES_PROSPECT.map(tp => <option key={tp} value={tp}>{tp}</option>)}
              </select>
            </div>
          </div>

          {/* ── Adresse ── */}
          <div className="form-group full-width">
            <label>Adresse <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text" name="adresse" value={values.adresse}
                onChange={handleChange} onBlur={handleBlur}
                placeholder="Adresse complète"
                className={errors.adresse && touched.adresse ? 'error' : ''}
              />
            </div>
            {errors.adresse && touched.adresse &&
              <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
          </div>

          {/* ── Ville ── */}
          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text" name="ville" value={values.ville}
                onChange={handleChange} onBlur={handleBlur}
                placeholder="Ex: Yaoundé"
                className={errors.ville && touched.ville ? 'error' : ''}
              />
            </div>
            {errors.ville && touched.ville &&
              <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          {/* ── Code postal ── */}
          <div className="form-group">
            <label>Code postal</label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="codePostal" value={values.codePostal} onChange={handleChange} placeholder="Ex: 00237" />
            </div>
          </div>

          {/* ── Pays ── */}
          <div className="form-group">
            <label>Pays <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text" name="pays" value={values.pays}
                onChange={handleChange} onBlur={handleBlur}
                className={errors.pays && touched.pays ? 'error' : ''}
              />
            </div>
            {errors.pays && touched.pays &&
              <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
          </div>

          {/* ── Nom du parent ── */}
          <div className="form-group">
            <label>Nom du parent</label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="nomParent" value={values.nomParent} onChange={handleChange} placeholder="Si le prospect est mineur" />
            </div>
          </div>

          {/* ── Téléphone du parent ── */}
          <div className="form-group">
            <label>Téléphone du parent</label>
            <div className="input-icon">
              <Phone size={18} />
              <input type="tel" name="numeroParent" value={values.numeroParent} onChange={handleChange} placeholder="6XXXXXXXX" />
            </div>
          </div>
        </div>

        {/* ══════════════════════════════════════════════════════════
            Section Filières d'intérêt
            Chaque modification est individuelle et ciblée sur
            CE prospect uniquement via son ID dans l'URL.
        ══════════════════════════════════════════════════════════ */}
        <div className="form-section">
          <h3 className="form-section-title">
            <GraduationCap size={18} />
            Filières d'intérêt &amp; niveaux d'intérêt
          </h3>

          {/* ── Liste des filières déjà sélectionnées ── */}
          {filieresSelectionnees.length > 0 && (
            <div className="interets-list">
              {filieresSelectionnees.map((f, index) => (
                <div key={index} className="interet-row">
                  <div className="interet-filiere">
                    <GraduationCap size={14} />
                    <strong>{f.nomFiliere || f.idFiliere}</strong>
                  </div>

                  {/* Niveau d'intérêt — modifiable directement sur la ligne */}
                  <div className="interet-niveau">
                    <select
                      value={f.niveauInteret}
                      onChange={e => handleChangerNiveau(index, e.target.value)}
                      className="niveau-select"
                    >
                      {NIVEAUX_INTERET.map(n => <option key={n} value={n}>{n}</option>)}
                    </select>
                    <NiveauStars niveau={f.niveauInteret} />
                  </div>

                  <button
                    type="button"
                    className="action-btn delete"
                    onClick={() => handleSupprimerFiliere(index)}
                    title="Retirer cette filière"
                  >
                    <Trash2 size={14} />
                  </button>
                </div>
              ))}
            </div>
          )}

          {/* ── Ligne d'ajout d'une nouvelle filière ── */}
          <div className="interet-add-row">
            <div className="input-icon" style={{ flex: 2 }}>
              <GraduationCap size={18} />
              <select
                value={nouvelleFiliere}
                onChange={e => setNouvelleFiliere(e.target.value)}
                className="interet-filiere-select"
              >
                <option value="">— Choisir une filière —</option>
                {filieresDisponibles
                  .filter(f => !filieresSelectionnees.some(sel => sel.idFiliere === f.idSpecialite))
                  .map(f => (
                    <option key={f.idSpecialite} value={f.idSpecialite}>
                      {f.libeleSpecialite ?? f.libele ?? f.acronyme ?? f.idSpecialite}
                    </option>
                  ))
                }
              </select>
            </div>

            <div className="input-icon" style={{ flex: 1 }}>
              <Star size={18} />
              <select
                value={nouveauNiveau}
                onChange={e => setNouveauNiveau(e.target.value)}
              >
                {NIVEAUX_INTERET.map(n => <option key={n} value={n}>{n}</option>)}
              </select>
            </div>

            <button
              type="button"
              className="btn-outline btn-add-filiere"
              onClick={handleAjouterFiliere}
            >
              <Plus size={16} /> Ajouter
            </button>
          </div>

          {filieresDisponibles.length === 0 && (
            <p className="form-hint">
              ⚠️ Les spécialités ne sont pas encore chargées — vérifier la route de specialiteService.
            </p>
          )}
        </div>

        {/* ── Boutons de soumission ── */}
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