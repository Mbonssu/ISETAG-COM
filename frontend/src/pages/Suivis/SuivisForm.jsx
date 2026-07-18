// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { Save, ArrowLeft, AlertCircle, Calendar, MessageSquare, User, Loader } from 'lucide-react';
// import { ToastContainer } from '../../components/common/Toast';
// import { suiviService } from '../../services/suiviService';
// import { prospectService } from '../../services/prospectService';
// import '../Prospects/Prospects.css';

// //  CORRIGÉ : le backend (schéma SuiviProspectRequest) n'a QUE
// // idProspect, libeleSuivi, dateSuivi, commentaire. Les champs
// // typeSuivi / idAgent / statut / prochainAction ont été retirés :
// // ils n'existent pas côté serveur et n'étaient jamais sauvegardés.

// const SuivisForm = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const isEdit = !!id;
//   const [loading, setLoading] = useState(false);
//   const [loadingData, setLoadingData] = useState(true);
//   const [toasts, setToasts] = useState([]);
//   const [errors, setErrors] = useState({});
//   const [prospects, setProspects] = useState([]);

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   const [formData, setFormData] = useState({
//     idProspect: '',
//     libeleSuivi: '',
//     dateSuivi: '',   // format attendu par <input type="datetime-local"> : "YYYY-MM-DDTHH:mm"
//     commentaire: '',
//   });

//   useEffect(() => {
//     const fetchData = async () => {
//       try {
//         setLoadingData(true);

//         const prospectsData = await prospectService.getAll();
//         ('📥 Prospects chargés:', prospectsData);
//         const prospectsList = Array.isArray(prospectsData) ? prospectsData : (prospectsData?.results ?? []);
//         setProspects(prospectsList);

//         if (isEdit && id) {
//           const suiviData = await suiviService.getById(id);
//           ('📥 Suivi à modifier:', suiviData);
//           setFormData({
//             idProspect: suiviData.idProspect || '',
//             libeleSuivi: suiviData.libeleSuivi || '',
//             // On tronque le datetime ISO complet ("2026-06-18T10:00:00Z")
//             // au format attendu par l'input datetime-local ("2026-06-18T10:00")
//             dateSuivi: suiviData.dateSuivi ? suiviData.dateSuivi.slice(0, 16) : '',
//             commentaire: suiviData.commentaire || '',
//           });
//         }
//       } catch (error) {
//         console.error(' Erreur de chargement:', error);
//         addToast('Erreur lors du chargement des données', 'error');
//       } finally {
//         setLoadingData(false);
//       }
//     };

//     fetchData();
//   }, [id, isEdit]);

//   const validateForm = () => {
//     const newErrors = {};
//     if (!formData.idProspect) newErrors.idProspect = 'Veuillez sélectionner un prospect';
//     if (!formData.libeleSuivi.trim()) newErrors.libeleSuivi = 'Le libellé du suivi est requis';
//     if (!formData.dateSuivi) newErrors.dateSuivi = 'La date est requise';
//     if (!formData.commentaire.trim()) newErrors.commentaire = 'Le commentaire est requis';

//     setErrors(newErrors);
//     return Object.keys(newErrors).length === 0;
//   };

//   const handleChange = (e) => {
//     setFormData({ ...formData, [e.target.name]: e.target.value });
//     if (errors[e.target.name]) {
//       setErrors({ ...errors, [e.target.name]: '' });
//     }
//   };

//   const handleSubmit = async (e) => {
//     e.preventDefault();
//     if (!validateForm()) {
//       addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
//       return;
//     }

//     setLoading(true);
//     try {
//       const data = {
//         idProspect: formData.idProspect,
//         libeleSuivi: formData.libeleSuivi,
//         // Le backend attend un date-time complet (ISO 8601).
//         // datetime-local donne "2026-06-18T10:00", on complète les secondes.
//         dateSuivi: formData.dateSuivi.length === 16 ? `${formData.dateSuivi}:00` : formData.dateSuivi,
//         commentaire: formData.commentaire,
//       };

//       ('📤 Envoi des données:', data);

//       if (isEdit) {
//         await suiviService.update(id, { idSuivi: id, ...data });
//         addToast('Suivi modifié avec succès', 'success');
//       } else {
//         await suiviService.create(data);
//         addToast('Suivi créé avec succès', 'success');
//       }

//       setTimeout(() => navigate('/suivis'), 1500);
//     } catch (error) {
//       console.error(' Erreur:', error);
//       addToast(error.message || 'Erreur lors de l\'enregistrement', 'error');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const getProspectName = (prospect) => {
//     if (!prospect) return 'Prospect inconnu';
//     return prospect.nomComplet || prospect.email || prospect.telephone || 'Prospect inconnu';
//   };

//   if (loadingData) {
//     return (
//       <div className="page-container">
//         <div className="loading-container">
//           <Loader size={48} className="spin" />
//           <p>Chargement...</p>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />

//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">{isEdit ? 'Modifier le suivi' : 'Nouveau suivi'}</h1>
//           <p className="page-description">
//             {isEdit ? 'Modifiez les informations du suivi.' : 'Ajoutez un nouveau suivi pour un prospect.'}
//           </p>
//         </div>
//         <button className="btn-outline" onClick={() => navigate('/suivis')}>
//           <ArrowLeft size={18} />
//           Retour à la liste
//         </button>
//       </div>

//       <form onSubmit={handleSubmit} className="form-container">
//         <div className="form-grid">
//           {/* Prospect */}
//           <div className="form-group full-width">
//             <label>Prospect <span className="required">*</span></label>
//             <div className="input-icon">
//               <User size={18} />
//               <select
//                 name="idProspect"
//                 value={formData.idProspect}
//                 onChange={handleChange}
//                 className={errors.idProspect ? 'error' : ''}
//               >
//                 <option value="">Sélectionner un prospect</option>
//                 {prospects.map(p => {
//                   const pid = p.idProspect || p.id;
//                   return (
//                     <option key={pid} value={pid}>
//                       {getProspectName(p)}
//                     </option>
//                   );
//                 })}
//               </select>
//             </div>
//             {errors.idProspect && <span className="error-message"><AlertCircle size={12} /> {errors.idProspect}</span>}
//           </div>

//           {/* Libellé du suivi */}
//           <div className="form-group full-width">
//             <label>Libellé du suivi <span className="required">*</span></label>
//             <div className="input-icon">
//               <MessageSquare size={18} />
//               <input
//                 type="text"
//                 name="libeleSuivi"
//                 value={formData.libeleSuivi}
//                 onChange={handleChange}
//                 placeholder="Ex: Appel de suivi, Email de relance, Visite..."
//                 className={errors.libeleSuivi ? 'error' : ''}
//               />
//             </div>
//             {errors.libeleSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.libeleSuivi}</span>}
//           </div>

//           {/* Date et heure du suivi */}
//           <div className="form-group">
//             <label>Date et heure <span className="required">*</span></label>
//             <div className="input-icon">
//               <Calendar size={18} />
//               <input
//                 type="datetime-local"
//                 name="dateSuivi"
//                 value={formData.dateSuivi}
//                 onChange={handleChange}
//                 className={errors.dateSuivi ? 'error' : ''}
//               />
//             </div>
//             {errors.dateSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.dateSuivi}</span>}
//           </div>

//           {/* Commentaire */}
//           <div className="form-group full-width">
//             <label>Commentaire <span className="required">*</span></label>
//             <textarea
//               name="commentaire"
//               rows="4"
//               value={formData.commentaire}
//               onChange={handleChange}
//               placeholder="Détails du suivi..."
//               className={errors.commentaire ? 'error' : ''}
//             />
//             {errors.commentaire && <span className="error-message"><AlertCircle size={12} /> {errors.commentaire}</span>}
//           </div>
//         </div>

//         <div className="form-actions">
//           <button type="button" className="btn-outline" onClick={() => navigate('/suivis')}>
//             Annuler
//           </button>
//           <button type="submit" className="btn-primary" disabled={loading}>
//             <Save size={18} />
//             {loading ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer le suivi')}
//           </button>
//         </div>
//       </form>
//     </div>
//   );
// };

// export default SuivisForm;



import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, MessageSquare, User, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { suiviService } from '../../services/suiviService';
import { prospectService } from '../../services/prospectService';
import '../Prospects/Prospects.css';

//  CORRIGÉ : le backend (schéma SuiviProspectRequest) n'a QUE
// idProspect, libeleSuivi, dateSuivi, commentaire. Les champs
// typeSuivi / idAgent / statut / prochainAction ont été retirés :
// ils n'existent pas côté serveur et n'étaient jamais sauvegardés.

// Catégories proposées pour "libeleSuivi" (texte libre côté backend,
// mais on encadre la saisie avec une liste prédéfinie côté UI).
const LIBELES_SUIVI = ['Par Appel', 'Par Email', 'Par SMS'];

const SuivisForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [loading, setLoading] = useState(false);
  const [loadingData, setLoadingData] = useState(true);
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [prospects, setProspects] = useState([]);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const [formData, setFormData] = useState({
    idProspect: '',
    libeleSuivi: '',
    dateSuivi: '',   // format attendu par <input type="datetime-local"> : "YYYY-MM-DDTHH:mm"
    commentaire: '',
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoadingData(true);

        const prospectsData = await prospectService.getAll();
        ('📥 Prospects chargés:', prospectsData);
        const prospectsList = Array.isArray(prospectsData) ? prospectsData : (prospectsData?.results ?? []);
        setProspects(prospectsList);

        if (isEdit && id) {
          const suiviData = await suiviService.getById(id);
          ('📥 Suivi à modifier:', suiviData);
          setFormData({
            idProspect: suiviData.idProspect || '',
            libeleSuivi: suiviData.libeleSuivi || '',
            // On tronque le datetime ISO complet ("2026-06-18T10:00:00Z")
            // au format attendu par l'input datetime-local ("2026-06-18T10:00")
            dateSuivi: suiviData.dateSuivi ? suiviData.dateSuivi.slice(0, 16) : '',
            commentaire: suiviData.commentaire || '',
          });
        }
      } catch (error) {
        console.error(' Erreur de chargement:', error);
        addToast('Erreur lors du chargement des données', 'error');
      } finally {
        setLoadingData(false);
      }
    };

    fetchData();
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.idProspect) newErrors.idProspect = 'Veuillez sélectionner un prospect';
    if (!formData.libeleSuivi.trim()) newErrors.libeleSuivi = 'Le libellé du suivi est requis';
    if (!formData.dateSuivi) newErrors.dateSuivi = 'La date est requise';
    if (!formData.commentaire.trim()) newErrors.commentaire = 'Le commentaire est requis';

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) {
      setErrors({ ...errors, [e.target.name]: '' });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setLoading(true);
    try {
      const data = {
        idProspect: formData.idProspect,
        libeleSuivi: formData.libeleSuivi,
        // Le backend attend un date-time complet (ISO 8601).
        // datetime-local donne "2026-06-18T10:00", on complète les secondes.
        dateSuivi: formData.dateSuivi.length === 16 ? `${formData.dateSuivi}:00` : formData.dateSuivi,
        commentaire: formData.commentaire,
      };

      ('📤 Envoi des données:', data);

      if (isEdit) {
        await suiviService.update(id, { idSuivi: id, ...data });
        addToast('Suivi modifié avec succès', 'success');
      } else {
        await suiviService.create(data);
        addToast('Suivi créé avec succès', 'success');
      }

      setTimeout(() => navigate('/suivis'), 1500);
    } catch (error) {
      console.error(' Erreur:', error);
      addToast(error.message || 'Erreur lors de l\'enregistrement', 'error');
    } finally {
      setLoading(false);
    }
  };

  const getProspectName = (prospect) => {
    if (!prospect) return 'Prospect inconnu';
    return prospect.nomComplet || prospect.email || prospect.telephone || 'Prospect inconnu';
  };

  if (loadingData) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier le suivi' : 'Nouveau suivi'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations du suivi.' : 'Ajoutez un nouveau suivi pour un prospect.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/suivis')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          {/* Prospect */}
          <div className="form-group full-width">
            <label>Prospect <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select
                name="idProspect"
                value={formData.idProspect}
                onChange={handleChange}
                className={errors.idProspect ? 'error' : ''}
              >
                <option value="">Sélectionner un prospect</option>
                {prospects.map(p => {
                  const pid = p.idProspect || p.id;
                  return (
                    <option key={pid} value={pid}>
                      {getProspectName(p)}
                    </option>
                  );
                })}
              </select>
            </div>
            {errors.idProspect && <span className="error-message"><AlertCircle size={12} /> {errors.idProspect}</span>}
          </div>

          {/* Libellé du suivi */}
          <div className="form-group full-width">
            <label>Libellé du suivi <span className="required">*</span></label>
            <div className="input-icon">
              <MessageSquare size={18} />
              <select
                name="libeleSuivi"
                value={formData.libeleSuivi}
                onChange={handleChange}
                className={errors.libeleSuivi ? 'error' : ''}
              >
                <option value="">— Choisir un libellé —</option>
                {LIBELES_SUIVI.map(l => <option key={l} value={l}>{l}</option>)}
              </select>
            </div>
            {errors.libeleSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.libeleSuivi}</span>}
          </div>

          {/* Date et heure du suivi */}
          <div className="form-group">
            <label>Date et heure prévues du suivi <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="datetime-local"
                name="dateSuivi"
                value={formData.dateSuivi}
                onChange={handleChange}
                className={errors.dateSuivi ? 'error' : ''}
              />
            </div>
            {errors.dateSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.dateSuivi}</span>}
          </div>

          {/* Commentaire */}
          <div className="form-group full-width">
            <label>Commentaire <span className="required">*</span></label>
            <textarea
              name="commentaire"
              rows="4"
              value={formData.commentaire}
              onChange={handleChange}
              placeholder="Détails du suivi..."
              className={errors.commentaire ? 'error' : ''}
            />
            {errors.commentaire && <span className="error-message"><AlertCircle size={12} /> {errors.commentaire}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/suivis')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary" disabled={loading}>
            <Save size={18} />
            {loading ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer le suivi')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default SuivisForm;