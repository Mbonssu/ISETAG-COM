import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Bell, Phone, Mail, MessageSquare, Calendar, Clock, Flag } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const RelanceForm = () => {
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
    prospect: '',
    type: 'Email',
    date: '',
    heure: '',
    priorite: 'Moyenne',
    message: '',
    agent: ''
  });

  const types = ['Email', 'Appel', 'SMS', 'Message'];
  const priorites = ['Haute', 'Moyenne', 'Basse'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.'];
  const prospectsList = ['Marie L.', 'Junior B.', 'Paul D.', 'Anne S.', 'Luc M.', 'Sophie L.'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.prospect) newErrors.prospect = 'Veuillez sélectionner un prospect';
    if (!formData.date) newErrors.date = 'La date est requise';
    if (!formData.heure) newErrors.heure = 'L\'heure est requise';
    if (!formData.message.trim()) newErrors.message = 'Le message est requis';
    if (!formData.agent) newErrors.agent = 'Veuillez sélectionner un agent';
    
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
      addToast(isEdit ? 'Relance modifiée avec succès' : 'Relance créée avec succès', 'success');
      setTimeout(() => {
        navigate('/relances');
      }, 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Email': return <Mail size={18} />;
      case 'Appel': return <Phone size={18} />;
      default: return <MessageSquare size={18} />;
    }
  };

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
              <Bell size={18} />
              <select name="prospect" value={formData.prospect} onChange={handleChange} className={errors.prospect ? 'error' : ''}>
                <option value="">Sélectionner un prospect</option>
                {prospectsList.map(p => <option key={p} value={p}>{p}</option>)}
              </select>
            </div>
            {errors.prospect && <span className="error-message"><AlertCircle size={12} /> {errors.prospect}</span>}
          </div>

          <div className="form-group">
            <label>Type de relance</label>
            <div className="input-icon">
              {getTypeIcon(formData.type)}
              <select name="type" value={formData.type} onChange={handleChange}>
                {types.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Date <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="date"
                name="date"
                value={formData.date}
                onChange={handleChange}
                className={errors.date ? 'error' : ''}
              />
            </div>
            {errors.date && <span className="error-message"><AlertCircle size={12} /> {errors.date}</span>}
          </div>

          <div className="form-group">
            <label>Heure <span className="required">*</span></label>
            <div className="input-icon">
              <Clock size={18} />
              <input
                type="time"
                name="heure"
                value={formData.heure}
                onChange={handleChange}
                className={errors.heure ? 'error' : ''}
              />
            </div>
            {errors.heure && <span className="error-message"><AlertCircle size={12} /> {errors.heure}</span>}
          </div>

          <div className="form-group">
            <label>Priorité</label>
            <div className="input-icon">
              <Flag size={18} />
              <select name="priorite" value={formData.priorite} onChange={handleChange}>
                {priorites.map(p => <option key={p} value={p}>{p}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Agent responsable <span className="required">*</span></label>
            <div className="input-icon">
              <Bell size={18} />
              <select name="agent" value={formData.agent} onChange={handleChange} className={errors.agent ? 'error' : ''}>
                <option value="">Sélectionner un agent</option>
                {agents.map(a => <option key={a} value={a}>{a}</option>)}
              </select>
            </div>
            {errors.agent && <span className="error-message"><AlertCircle size={12} /> {errors.agent}</span>}
          </div>

          <div className="form-group full-width">
            <label>Message <span className="required">*</span></label>
            <textarea
              name="message"
              rows="4"
              value={formData.message}
              onChange={handleChange}
              placeholder="Contenu du message de relance..."
              className={errors.message ? 'error' : ''}
            />
            {errors.message && <span className="error-message"><AlertCircle size={12} /> {errors.message}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/relances')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer la relance'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default RelanceForm;
