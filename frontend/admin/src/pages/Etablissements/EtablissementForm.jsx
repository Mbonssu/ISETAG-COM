// import React from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { Save, ArrowLeft, AlertCircle, Building, MapPin, Phone, Mail, User } from 'lucide-react';
// import { ToastContainer } from '../../components/common/Toast';
// import { useFormValidation, validators } from '../../hooks/useFormValidation';
// import '../Prospects/Prospects.css';

// const EtablissementForm = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const isEdit = !!id;
//   const [toasts, setToasts] = React.useState([]);

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   const types = ['Lycée', 'Lycée Technique', 'Université', 'Institut', 'Collège'];
//   const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Maroua', 'Bertoua'];

//   const validationRules = {
//     name: [validators.required('Le nom de l\'établissement est requis')],
//     ville: [validators.required('La ville est requise')],
//     adresse: [validators.required('L\'adresse est requise')]
//   };

//   const { values, errors, touched, handleChange, handleBlur, validateForm } = useFormValidation(
//     { name: '', type: 'Lycée', ville: '', adresse: '', telephone: '', email: '', contactNom: '', contactPoste: '', notes: '' },
//     validationRules
//   );

//   const handleSubmit = (e) => {
//     e.preventDefault();
//     if (validateForm()) {
//       addToast(isEdit ? 'Établissement modifié avec succès' : 'Établissement créé avec succès', 'success');
//       setTimeout(() => navigate('/etablissements'), 1500);
//     } else {
//       addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
//     }
//   };

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />
      
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">{isEdit ? 'Modifier l\'établissement' : 'Nouvel établissement'}</h1>
//           <p className="page-description">{isEdit ? 'Modifiez les informations de l\'établissement.' : 'Ajoutez un nouvel établissement partenaire.'}</p>
//         </div>
//         <button className="btn-outline" onClick={() => navigate('/etablissements')}><ArrowLeft size={18} /> Retour</button>
//       </div>

//       <form onSubmit={handleSubmit} className="form-container">
//         <div className="form-grid">
//           <div className="form-group full-width">
//             <label>Nom de l'établissement <span className="required">*</span></label>
//             <div className="input-icon">
//               <Building size={18} />
//               <input type="text" name="name" value={values.name} onChange={handleChange} onBlur={handleBlur} className={errors.name && touched.name ? 'error' : ''} />
//             </div>
//             {errors.name && touched.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
//           </div>

//           <div className="form-group">
//             <label>Type d'établissement</label>
//             <div className="input-icon">
//               <Building size={18} />
//               <select name="type" value={values.type} onChange={handleChange}>
//                 {types.map(t => <option key={t} value={t}>{t}</option>)}
//               </select>
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Ville <span className="required">*</span></label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <select name="ville" value={values.ville} onChange={handleChange} onBlur={handleBlur}>
//                 <option value="">Sélectionner une ville</option>
//                 {villes.map(v => <option key={v} value={v}>{v}</option>)}
//               </select>
//             </div>
//             {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
//           </div>

//           <div className="form-group full-width">
//             <label>Adresse <span className="required">*</span></label>
//             <div className="input-icon">
//               <MapPin size={18} />
//               <input type="text" name="adresse" value={values.adresse} onChange={handleChange} onBlur={handleBlur} className={errors.adresse && touched.adresse ? 'error' : ''} />
//             </div>
//             {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
//           </div>

//           <div className="form-group">
//             <label>Téléphone</label>
//             <div className="input-icon">
//               <Phone size={18} />
//               <input type="tel" name="telephone" value={values.telephone} onChange={handleChange} placeholder="Téléphone" />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Email</label>
//             <div className="input-icon">
//               <Mail size={18} />
//               <input type="email" name="email" value={values.email} onChange={handleChange} placeholder="contact@etablissement.com" />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Nom du contact</label>
//             <div className="input-icon">
//               <User size={18} />
//               <input type="text" name="contactNom" value={values.contactNom} onChange={handleChange} placeholder="Personne de contact" />
//             </div>
//           </div>

//           <div className="form-group">
//             <label>Poste du contact</label>
//             <div className="input-icon">
//               <User size={18} />
//               <input type="text" name="contactPoste" value={values.contactPoste} onChange={handleChange} placeholder="Proviseur, Directeur..." />
//             </div>
//           </div>

//           <div className="form-group full-width">
//             <label>Notes</label>
//             <textarea name="notes" rows="4" value={values.notes} onChange={handleChange} placeholder="Informations complémentaires..." />
//           </div>
//         </div>

//         <div className="form-actions">
//           <button type="button" className="btn-outline" onClick={() => navigate('/etablissements')}>Annuler</button>
//           <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer'}</button>
//         </div>
//       </form>
//     </div>
//   );
// };

// export default EtablissementForm;



import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Building, MapPin, Phone, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { etablissementService } from '../../services/etablissementService';
import '../Prospects/Prospects.css';

const typesEtablissement = ['Lycée', 'Collège', 'Université', 'Institut', 'Centre de formation', 'Autre'];

const EtablissementForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [formData, setFormData] = useState({
    nom: '', adresse: '', ville: '', region: '', type: 'Lycée', telephone: '',
  });

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  useEffect(() => {
    if (isEdit && id) {
      etablissementService.getById(id)
        .then((raw) => {
          const data = Array.isArray(raw) ? raw[0] : raw;
          setFormData({
            nom: data?.nom || '',
            adresse: data?.adresse || '',
            ville: data?.ville || '',
            region: data?.region || '',
            type: data?.type || 'Lycée',
            telephone: data?.telephone || '',
          });
        })
        .catch((err) => addToast(`Erreur: ${err.message}`, 'error'))
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.nom.trim()) newErrors.nom = 'Le nom est requis';
    if (!formData.adresse.trim()) newErrors.adresse = "L'adresse est requise";
    if (!formData.ville.trim()) newErrors.ville = 'La ville est requise';
    if (!formData.region.trim()) newErrors.region = 'La région est requise';
    if (!formData.type) newErrors.type = 'Le type est requis';
    if (!formData.telephone.trim()) newErrors.telephone = 'Le téléphone est requis';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) setErrors({ ...errors, [e.target.name]: '' });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }
    setSaving(true);
    try {
      if (isEdit) {
        await etablissementService.update(id, { idEtablissement: id, ...formData });
        addToast('Établissement modifié avec succès', 'success');
      } else {
        await etablissementService.create(formData);
        addToast('Établissement créé avec succès', 'success');
      }
      setTimeout(() => navigate('/etablissements'), 1500);
    } catch (err) {
      console.error(' Erreur:', err);
      addToast(err.message || "Erreur lors de l'enregistrement", 'error');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement...</p></div></div>;
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? "Modifier l'établissement" : 'Nouvel établissement'}</h1>
          <p className="page-description">{isEdit ? "Modifiez les informations de l'établissement." : 'Ajoutez un nouvel établissement partenaire.'}</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/etablissements')}><ArrowLeft size={18} /> Retour à la liste</button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de l'établissement <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <input type="text" name="nom" value={formData.nom} onChange={handleChange} className={errors.nom ? 'error' : ''} disabled={saving} />
            </div>
            {errors.nom && <span className="error-message"><AlertCircle size={12} /> {errors.nom}</span>}
          </div>

          <div className="form-group">
            <label>Type <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <select name="type" value={formData.type} onChange={handleChange} className={errors.type ? 'error' : ''} disabled={saving}>
                {typesEtablissement.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            {errors.type && <span className="error-message"><AlertCircle size={12} /> {errors.type}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input type="tel" name="telephone" value={formData.telephone} onChange={handleChange} placeholder="6XXXXXXXX" className={errors.telephone ? 'error' : ''} disabled={saving} />
            </div>
            {errors.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
          </div>

          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="ville" value={formData.ville} onChange={handleChange} className={errors.ville ? 'error' : ''} disabled={saving} />
            </div>
            {errors.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          <div className="form-group">
            <label>Région <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="region" value={formData.region} onChange={handleChange} className={errors.region ? 'error' : ''} disabled={saving} />
            </div>
            {errors.region && <span className="error-message"><AlertCircle size={12} /> {errors.region}</span>}
          </div>

          <div className="form-group full-width">
            <label>Adresse <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="adresse" value={formData.adresse} onChange={handleChange} placeholder="Adresse complète" className={errors.adresse ? 'error' : ''} disabled={saving} />
            </div>
            {errors.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/etablissements')} disabled={saving}>Annuler</button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : "Créer l'établissement")}
          </button>
        </div>
      </form>
    </div>
  );
};

export default EtablissementForm;