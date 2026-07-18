import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Target, Mail, Smartphone, Phone, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { campagneService } from '../../services/campagneService';
import '../Prospects/Prospects.css';

//  CORRIGÉ : le backend (CampagneProspectionRequest) n'a NI "statut" NI
// "agent" — ces champs ont été retirés (ils n'existaient pas côté serveur).
// Champs réels : idCampagne, libele, description, dateDebut, dateFin,
// objectif (texte libre, pas un nombre), type.

const types = ['Email', 'SMS', 'Appel'];

const CampagneForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  const [formData, setFormData] = useState({
    libele: '', type: 'Email', dateDebut: '', dateFin: '', objectif: '', description: '',
  });

  useEffect(() => {
    if (isEdit && id) {
      campagneService.getById(id)
        .then((raw) => {
          ('📥 Campagne chargée:', raw);
          const data = Array.isArray(raw) ? raw[0] : raw;
          setFormData({
            libele: data?.libele || '',
            type: data?.type || 'Email',
            dateDebut: data?.dateDebut ? data.dateDebut.slice(0, 16) : '',
            dateFin: data?.dateFin ? data.dateFin.slice(0, 16) : '',
            objectif: data?.objectif || '',
            description: data?.description || '',
          });
        })
        .catch((err) => addToast(`Erreur: ${err.message}`, 'error'))
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.libele.trim()) newErrors.libele = 'Le nom de la campagne est requis';
    if (!formData.dateDebut) newErrors.dateDebut = 'La date de début est requise';
    if (!formData.dateFin) newErrors.dateFin = 'La date de fin est requise';
    if (formData.dateDebut && formData.dateFin && new Date(formData.dateDebut) > new Date(formData.dateFin)) {
      newErrors.dateFin = 'La date de fin doit être postérieure à la date de début';
    }
    if (!formData.objectif.trim()) newErrors.objectif = "L'objectif est requis";
    if (!formData.description.trim()) newErrors.description = 'La description est requise';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) setErrors({ ...errors, [e.target.name]: '' });
  };

  const toIso = (dt) => (dt.length === 16 ? `${dt}:00` : dt);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }
    setSaving(true);
    try {
      const payload = {
        libele: formData.libele,
        type: formData.type,
        dateDebut: toIso(formData.dateDebut),
        dateFin: toIso(formData.dateFin),
        objectif: formData.objectif,
        description: formData.description,
      };
      ('📤 Envoi des données:', payload);

      if (isEdit) {
        await campagneService.update(id, { idCampagne: id, ...payload });
        addToast('Campagne modifiée avec succès', 'success');
      } else {
        await campagneService.create({ idCampagne: `TEMP-${Date.now()}`, ...payload });
        addToast('Campagne créée avec succès', 'success');
      }
      setTimeout(() => navigate('/campagnes'), 1500);
    } catch (err) {
      console.error(' Erreur:', err);
      addToast(err.message || "Erreur lors de l'enregistrement", 'error');
    } finally {
      setSaving(false);
    }
  };

  const getTypeIcon = (type) => {
    switch (type) {
      case 'Email': return <Mail size={18} />;
      case 'SMS': return <Smartphone size={18} />;
      case 'Appel': return <Phone size={18} />;
      default: return <Mail size={18} />;
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier la campagne' : 'Nouvelle campagne'}</h1>
          <p className="page-description">{isEdit ? 'Modifiez les informations de la campagne.' : 'Créez une nouvelle campagne de prospection.'}</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/campagnes')}><ArrowLeft size={18} /> Retour</button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de la campagne <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <input type="text" name="libele" value={formData.libele} onChange={handleChange} className={errors.libele ? 'error' : ''} disabled={saving} />
            </div>
            {errors.libele && <span className="error-message"><AlertCircle size={12} /> {errors.libele}</span>}
          </div>

          <div className="form-group">
            <label>Type de campagne</label>
            <div className="input-icon">
              {getTypeIcon(formData.type)}
              <select name="type" value={formData.type} onChange={handleChange} disabled={saving}>
                {types.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Date de début <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="datetime-local" name="dateDebut" value={formData.dateDebut} onChange={handleChange} className={errors.dateDebut ? 'error' : ''} disabled={saving} />
            </div>
            {errors.dateDebut && <span className="error-message"><AlertCircle size={12} /> {errors.dateDebut}</span>}
          </div>

          <div className="form-group">
            <label>Date de fin <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="datetime-local" name="dateFin" value={formData.dateFin} onChange={handleChange} className={errors.dateFin ? 'error' : ''} disabled={saving} />
            </div>
            {errors.dateFin && <span className="error-message"><AlertCircle size={12} /> {errors.dateFin}</span>}
          </div>

          <div className="form-group full-width">
            <label>Objectif <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <input type="text" name="objectif" value={formData.objectif} onChange={handleChange} placeholder="Ex: 500 prospects" className={errors.objectif ? 'error' : ''} disabled={saving} />
            </div>
            {errors.objectif && <span className="error-message"><AlertCircle size={12} /> {errors.objectif}</span>}
          </div>

          <div className="form-group full-width">
            <label>Description <span className="required">*</span></label>
            <textarea name="description" rows="4" value={formData.description} onChange={handleChange} placeholder="Description de la campagne..." className={errors.description ? 'error' : ''} disabled={saving} />
            {errors.description && <span className="error-message"><AlertCircle size={12} /> {errors.description}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/campagnes')} disabled={saving}>Annuler</button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default CampagneForm;