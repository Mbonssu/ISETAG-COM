import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Bell, Calendar, Clock, User, Mail, Phone, MessageSquare } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { relanceService } from '../../services/relanceService';
import { prospectService } from '../../services/prospectService';
import '../Prospects/Prospects.css';

const RelanceForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [prospects, setProspects] = useState([]);
  const [loadingProspects, setLoadingProspects] = useState(false);
  const [relance, setRelance] = useState(null);

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
    dateRelance: '',
    sujet: '',
    description: '',
  });

  // Charger les prospects disponibles
  useEffect(() => {
    loadProspects();
  }, []);

  const loadProspects = async () => {
    setLoadingProspects(true);
    try {
      const data = await prospectService.getAll();
      setProspects(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error(' Erreur chargement prospects:', err);
      addToast('Erreur lors du chargement des prospects', 'error');
    } finally {
      setLoadingProspects(false);
    }
  };

  // Charger la relance en mode édition
  useEffect(() => {
    if (isEdit && id) {
      relanceService.getById(id)
        .then((data) => {
          ('📥 Relance chargée:', data);
          setRelance(data);
          setFormData({
            idProspect: data.idProspect || '',
            dateRelance: data.dateRelance ? new Date(data.dateRelance).toISOString().slice(0, 16) : '',
            sujet: data.sujet || '',
            description: data.description || '',
          });
        })
        .catch((err) => {
          console.error(' Erreur chargement relance:', err);
          addToast(`Erreur: ${err.message}`, 'error');
        })
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.idProspect) newErrors.idProspect = 'Veuillez sélectionner un prospect';
    if (!formData.dateRelance) newErrors.dateRelance = 'La date est requise';
    if (!formData.sujet.trim()) newErrors.sujet = 'Le sujet est requis';
    if (!formData.description.trim()) newErrors.description = 'La description est requise';
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
    if (errors[name]) {
      setErrors({ ...errors, [name]: '' });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setSaving(true);
    try {
      const payload = {
        idProspect: formData.idProspect,
        dateRelance: new Date(formData.dateRelance).toISOString(),
        sujet: formData.sujet,
        description: formData.description,
      };

      ('📤 Envoi des données:', payload);

      if (isEdit) {
        await relanceService.update(id, payload);
        addToast('Relance modifiée avec succès', 'success');
      } else {
        await relanceService.create(payload);
        addToast('Relance créée avec succès', 'success');
      }
      
      setTimeout(() => navigate('/relances'), 1500);
    } catch (err) {
      console.error(' Erreur:', err);
      if (err.response?.data) {
        const errorData = err.response.data;
        let errorMessage = '';
        if (typeof errorData === 'object') {
          errorMessage = Object.entries(errorData)
            .map(([key, value]) => `${key}: ${Array.isArray(value) ? value.join(', ') : value}`)
            .join(' | ');
        } else {
          errorMessage = errorData || err.message;
        }
        addToast(`Erreur: ${errorMessage}`, 'error');
      } else {
        addToast(err.message || 'Erreur lors de l\'enregistrement', 'error');
      }
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="page-container">
        <div className="text-center py-5">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Chargement...</span>
          </div>
          <p className="mt-3">Chargement de la relance…</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la relance' : 'Nouvelle relance'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la relance.' : 'Planifiez une nouvelle relance pour un prospect.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/relances')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Prospect <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select 
                name="idProspect" 
                value={formData.idProspect} 
                onChange={handleChange} 
                className={errors.idProspect ? 'error' : ''}
                disabled={saving || loadingProspects}
              >
                <option value="">Sélectionner un prospect</option>
                {prospects.map(p => (
                  <option key={p.idProspect} value={p.idProspect}>
                    {p.nomComplet}
                  </option>
                ))}
              </select>
            </div>
            {errors.idProspect && <span className="error-message"><AlertCircle size={12} /> {errors.idProspect}</span>}
          </div>

          <div className="form-group">
            <label>Date et heure <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="datetime-local"
                name="dateRelance"
                value={formData.dateRelance}
                onChange={handleChange}
                className={errors.dateRelance ? 'error' : ''}
                disabled={saving}
              />
            </div>
            {errors.dateRelance && <span className="error-message"><AlertCircle size={12} /> {errors.dateRelance}</span>}
          </div>

          <div className="form-group full-width">
            <label>Sujet <span className="required">*</span></label>
            <div className="input-icon">
              <Bell size={18} />
              <input
                type="text"
                name="sujet"
                value={formData.sujet}
                onChange={handleChange}
                placeholder="Ex: Relance inscription formation"
                className={errors.sujet ? 'error' : ''}
                disabled={saving}
              />
            </div>
            {errors.sujet && <span className="error-message"><AlertCircle size={12} /> {errors.sujet}</span>}
          </div>

          <div className="form-group full-width">
            <label>Description <span className="required">*</span></label>
            <textarea
              name="description"
              rows="4"
              value={formData.description}
              onChange={handleChange}
              placeholder="Détail du message de relance..."
              className={errors.description ? 'error' : ''}
              disabled={saving}
            />
            {errors.description && <span className="error-message"><AlertCircle size={12} /> {errors.description}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/relances')} disabled={saving}>
            Annuler
          </button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer la relance')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default RelanceForm;