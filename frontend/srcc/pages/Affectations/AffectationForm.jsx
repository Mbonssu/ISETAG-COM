import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Building, Calendar, MapPin, Target } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';
import { useTranslation } from '../../hooks/useTranslation';

const AffectationForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const [formData, setFormData] = useState({
    agent: '',
    etablissement: '',
    zone: '',
    dateDebut: '',
    dateFin: '',
    objectif: '',
    notes: ''
  });

  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.', 'Paul K.'];
  const etablissements = [
    'Lycée de Biyem-Assi', 'Lycée Technique d\'Efouan', 'Université de Douala',
    'Institut Supérieur de l\'Information', 'Collège de la Salle', 'Lycée Classique de Garoua'
  ];
  const zones = ['Yaoundé Centre', 'Yaoundé Sud', 'Douala Nord', 'Douala Sud', 'Bafoussam', 'Garoua'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.agent) newErrors.agent = 'Veuillez sélectionner un agent';
    if (!formData.etablissement) newErrors.etablissement = 'Veuillez sélectionner un établissement';
    if (!formData.zone) newErrors.zone = 'Veuillez sélectionner une zone';
    if (!formData.dateDebut) newErrors.dateDebut = 'La date de début est requise';
    if (!formData.dateFin) newErrors.dateFin = 'La date de fin est requise';
    if (formData.dateDebut && formData.dateFin && new Date(formData.dateDebut) > new Date(formData.dateFin)) {
      newErrors.dateFin = 'La date de fin doit être postérieure à la date de début';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) {
      setErrors({ ...errors, [e.target.name]: '' });
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validateForm()) {
      addToast(isEdit ? 'Affectation modifiée avec succès' : 'Affectation créée avec succès', 'success');
      setTimeout(() => {
        navigate('/affectations');
      }, 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier l\'affectation' : 'Nouvelle affectation'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de l\'affectation.' : 'Affectez un agent à un établissement.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/affectations')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Agent <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select name="agent" value={formData.agent} onChange={handleChange} className={errors.agent ? 'error' : ''}>
                <option value="">Sélectionner un agent</option>
                {agents.map(a => <option key={a} value={a}>{a}</option>)}
              </select>
            </div>
            {errors.agent && <span className="error-message"><AlertCircle size={12} /> {errors.agent}</span>}
          </div>

          <div className="form-group">
            <label>Établissement <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <select name="etablissement" value={formData.etablissement} onChange={handleChange} className={errors.etablissement ? 'error' : ''}>
                <option value="">Sélectionner un établissement</option>
                {etablissements.map(e => <option key={e} value={e}>{e}</option>)}
              </select>
            </div>
            {errors.etablissement && <span className="error-message"><AlertCircle size={12} /> {errors.etablissement}</span>}
          </div>

          <div className="form-group">
            <label>Zone <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <select name="zone" value={formData.zone} onChange={handleChange} className={errors.zone ? 'error' : ''}>
                <option value="">Sélectionner une zone</option>
                {zones.map(z => <option key={z} value={z}>{z}</option>)}
              </select>
            </div>
            {errors.zone && <span className="error-message"><AlertCircle size={12} /> {errors.zone}</span>}
          </div>

          <div className="form-group">
            <label>Date de début <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="date"
                name="dateDebut"
                value={formData.dateDebut}
                onChange={handleChange}
                className={errors.dateDebut ? 'error' : ''}
              />
            </div>
            {errors.dateDebut && <span className="error-message"><AlertCircle size={12} /> {errors.dateDebut}</span>}
          </div>

          <div className="form-group">
            <label>Date de fin <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="date"
                name="dateFin"
                value={formData.dateFin}
                onChange={handleChange}
                className={errors.dateFin ? 'error' : ''}
              />
            </div>
            {errors.dateFin && <span className="error-message"><AlertCircle size={12} /> {errors.dateFin}</span>}
          </div>

          <div className="form-group">
            <label>Objectif (nombre de prospects)</label>
            <div className="input-icon">
              <Target size={18} />
              <input
                type="number"
                name="objectif"
                value={formData.objectif}
                onChange={handleChange}
                placeholder="Ex: 50"
              />
            </div>
          </div>

          <div className="form-group full-width">
            <label>Notes</label>
            <textarea
              name="notes"
              rows="4"
              value={formData.notes}
              onChange={handleChange}
              placeholder="Instructions ou informations complémentaires..."
            />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/affectations')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer l\'affectation'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default AffectationForm;
