// import React, { useState } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { Save, ArrowLeft, AlertCircle, Globe } from 'lucide-react';
// import { ToastContainer } from '../../components/common/Toast';
// import '../Prospects/Prospects.css';

// const SourceForm = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const isEdit = !!id;
//   const [toasts, setToasts] = useState([]);
//   const [errors, setErrors] = useState({});

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   const [formData, setFormData] = useState({
//     name: '',
//     description: '',
//     couleur: '#4ECDC4',
//     actif: true
//   });

//   const couleurs = [
//     { name: 'Rouge', value: '#FF6B6B' },
//     { name: 'Vert', value: '#4ECDC4' },
//     { name: 'Jaune', value: '#FFE66D' },
//     { name: 'Violet', value: '#A78BFA' },
//     { name: 'Orange', value: '#F9A26C' },
//     { name: 'Bleu', value: '#845EC2' },
//   ];

//   const validateForm = () => {
//     const newErrors = {};
//     if (!formData.name.trim()) newErrors.name = 'Le nom de la source est requis';
    
//     setErrors(newErrors);
//     return Object.keys(newErrors).length === 0;
//   };

//   const handleChange = (e) => {
//     setFormData({ ...formData, [e.target.name]: e.target.value });
//     if (errors[e.target.name]) {
//       setErrors({ ...errors, [e.target.name]: '' });
//     }
//   };

//   const handleSubmit = (e) => {
//     e.preventDefault();
//     if (validateForm()) {
//       addToast(isEdit ? 'Source modifiée avec succès' : 'Source créée avec succès', 'success');
//       setTimeout(() => {
//         navigate('/sources');
//       }, 1500);
//     } else {
//       addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
//     }
//   };

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />
      
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">{isEdit ? 'Modifier la source' : 'Nouvelle source'}</h1>
//           <p className="page-description">
//             {isEdit ? 'Modifiez les informations de la source.' : 'Ajoutez une nouvelle source de prospects.'}
//           </p>
//         </div>
//         <button className="btn-outline" onClick={() => navigate('/sources')}>
//           <ArrowLeft size={18} />
//           Retour à la liste
//         </button>
//       </div>

//       <form onSubmit={handleSubmit} className="form-container">
//         <div className="form-grid">
//           <div className="form-group full-width">
//             <label>Nom de la source <span className="required">*</span></label>
//             <div className="input-icon">
//               <Globe size={18} />
//               <input
//                 type="text"
//                 name="name"
//                 value={formData.name}
//                 onChange={handleChange}
//                 placeholder="Ex: Terrain, Lycée..."
//                 className={errors.name ? 'error' : ''}
//               />
//             </div>
//             {errors.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
//           </div>

//           <div className="form-group">
//             <label>Couleur</label>
//             <div className="color-selector">
//               {couleurs.map(c => (
//                 <button
//                   key={c.value}
//                   type="button"
//                   className={`color-option ${formData.couleur === c.value ? 'selected' : ''}`}
//                   style={{ backgroundColor: c.value }}
//                   onClick={() => setFormData({ ...formData, couleur: c.value })}
//                   title={c.name}
//                 />
//               ))}
//               <input
//                 type="color"
//                 name="couleur"
//                 value={formData.couleur}
//                 onChange={handleChange}
//                 className="color-picker"
//               />
//             </div>
//           </div>

//           <div className="form-group full-width">
//             <label>Description</label>
//             <textarea
//               name="description"
//               rows="4"
//               value={formData.description}
//               onChange={handleChange}
//               placeholder="Description de la source..."
//             />
//           </div>

//           <div className="form-group">
//             <label>Statut</label>
//             <select name="actif" value={formData.actif} onChange={(e) => setFormData({ ...formData, actif: e.target.value === 'true' })}>
//               <option value="true">Actif</option>
//               <option value="false">Inactif</option>
//             </select>
//           </div>
//         </div>

//         <div className="form-actions">
//           <button type="button" className="btn-outline" onClick={() => navigate('/sources')}>
//             Annuler
//           </button>
//           <button type="submit" className="btn-primary">
//             <Save size={18} />
//             {isEdit ? 'Mettre à jour' : 'Créer la source'}
//           </button>
//         </div>
//       </form>
//     </div>
//   );
// };

// export default SourceForm;


import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Tag, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { sourceService } from '../../services/sourceService';
import '../Prospects/Prospects.css';

const SourceForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [formData, setFormData] = useState({ libele: '', description: '' });

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  useEffect(() => {
    if (isEdit && id) {
      sourceService.getById(id)
        .then((raw) => {
          console.log('📥 Source chargée:', raw);
          const data = Array.isArray(raw) ? raw[0] : raw;
          setFormData({ libele: data?.libele || '', description: data?.description || '' });
        })
        .catch((err) => addToast(`Erreur: ${err.message}`, 'error'))
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.libele.trim()) newErrors.libele = 'Le nom est requis';
    if (!formData.description.trim()) newErrors.description = 'La description est requise';
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
        await sourceService.update(id, { idSource: id, ...formData });
        addToast('Source modifiée avec succès', 'success');
      } else {
        await sourceService.create(formData);
        addToast('Source créée avec succès', 'success');
      }
      setTimeout(() => navigate('/sources'), 1500);
    } catch (err) {
      console.error('❌ Erreur:', err);
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier la source' : 'Nouvelle source'}</h1>
          <p className="page-description">{isEdit ? 'Modifiez les informations de la source.' : "Ajoutez une nouvelle source d'acquisition."}</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/sources')}><ArrowLeft size={18} /> Retour à la liste</button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de la source <span className="required">*</span></label>
            <div className="input-icon">
              <Tag size={18} />
              <input type="text" name="libele" value={formData.libele} onChange={handleChange} placeholder="Ex: Facebook Ads, Bouche-à-oreille..." className={errors.libele ? 'error' : ''} disabled={saving} />
            </div>
            {errors.libele && <span className="error-message"><AlertCircle size={12} /> {errors.libele}</span>}
          </div>

          <div className="form-group full-width">
            <label>Description <span className="required">*</span></label>
            <textarea name="description" rows="4" value={formData.description} onChange={handleChange} placeholder="Description de la source..." className={errors.description ? 'error' : ''} disabled={saving} />
            {errors.description && <span className="error-message"><AlertCircle size={12} /> {errors.description}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/sources')} disabled={saving}>Annuler</button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer la source')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default SourceForm;