import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Users, Target, Mail, Smartphone, Phone } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const CampagneForm = () => {
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
    name: '',
    type: 'Email',
    status: 'Planifiée',
    dateDebut: '',
    dateFin: '',
    agent: '',
    objectif: '',
    description: ''
  });

  const types = ['Email', 'SMS', 'Appel'];
  const statuses = ['Planifiée', 'En cours', 'Terminée'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.'];

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Email': return <Mail size={18} />;
      case 'SMS': return <Smartphone size={18} />;
      case 'Appel': return <Phone size={18} />;
      default: return <Mail size={18} />;
    }
  };

  const validateForm = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Le nom de la campagne est requis';
    if (!formData.dateDebut) newErrors.dateDebut = 'La date de début est requise';
    if (!formData.dateFin) newErrors.dateFin = 'La date de fin est requise';
    if (formData.dateDebut && formData.dateFin && new Date(formData.dateDebut) > new Date(formData.dateFin)) {
      newErrors.dateFin = 'La date de fin doit être postérieure à la date de début';
    }
    if (!formData.agent) newErrors.agent = 'Veuillez sélectionner un agent responsable';
    
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
      addToast(isEdit ? 'Campagne modifiée avec succès' : 'Campagne créée avec succès', 'success');
      setTimeout(() => {
        navigate('/campagnes');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier la campagne' : 'Nouvelle campagne'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la campagne.' : 'Créez une nouvelle campagne marketing.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/campagnes')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de la campagne <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ex: Campagne Mai 2025"
                className={errors.name ? 'error' : ''}
              />
            </div>
            {errors.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Type de campagne <span className="required">*</span></label>
            <div className="input-icon">
              {getTypeIcon(formData.type)}
              <select name="type" value={formData.type} onChange={handleChange}>
                {types.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Statut</label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="status" value={formData.status} onChange={handleChange}>
                {statuses.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
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
            <label>Agent responsable <span className="required">*</span></label>
            <div className="input-icon">
              <Users size={18} />
              <select name="agent" value={formData.agent} onChange={handleChange} className={errors.agent ? 'error' : ''}>
                <option value="">Sélectionner un agent</option>
                {agents.map(a => <option key={a} value={a}>{a}</option>)}
              </select>
            </div>
            {errors.agent && <span className="error-message"><AlertCircle size={12} /> {errors.agent}</span>}
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
                placeholder="Ex: 500"
              />
            </div>
          </div>

          <div className="form-group full-width">
            <label>Description</label>
            <textarea
              name="description"
              rows="4"
              value={formData.description}
              onChange={handleChange}
              placeholder="Description de la campagne, objectifs, cibles..."
            />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/campagnes')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer la campagne'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default CampagneForm;
