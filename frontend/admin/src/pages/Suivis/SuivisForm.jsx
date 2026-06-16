import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Phone, Mail, MessageSquare, User, Clock } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const SuivisForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const [formData, setFormData] = useState({
    prospect: '',
    dateSuivi: '',
    typeSuivi: 'Appel',
    commentaire: '',
    prochainAction: '',
    agent: ''
  });

  const typesSuivi = ['Appel', 'Email', 'Visite', 'SMS', 'Autre'];
  const prospects = ['Marie L.', 'David P.', 'Anne S.', 'Junior B.', 'Luc M.'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.', 'Paul K.'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.prospect) newErrors.prospect = 'Veuillez sélectionner un prospect';
    if (!formData.dateSuivi) newErrors.dateSuivi = 'La date est requise';
    if (!formData.typeSuivi) newErrors.typeSuivi = 'Le type de suivi est requis';
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
      addToast(isEdit ? 'Suivi modifié avec succès' : 'Suivi créé avec succès', 'success');
      setTimeout(() => navigate('/suivis'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

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
          <div className="form-group">
            <label>Prospect <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select name="prospect" value={formData.prospect} onChange={handleChange} className={errors.prospect ? 'error' : ''}>
                <option value="">Sélectionner un prospect</option>
                {prospects.map(p => <option key={p} value={p}>{p}</option>)}
              </select>
            </div>
            {errors.prospect && <span className="error-message"><AlertCircle size={12} /> {errors.prospect}</span>}
          </div>

          <div className="form-group">
            <label>Date de suivi <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateSuivi" value={formData.dateSuivi} onChange={handleChange} className={errors.dateSuivi ? 'error' : ''} />
            </div>
            {errors.dateSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.dateSuivi}</span>}
          </div>

          <div className="form-group">
            <label>Type de suivi <span className="required">*</span></label>
            <div className="input-icon">
              <MessageSquare size={18} />
              <select name="typeSuivi" value={formData.typeSuivi} onChange={handleChange} className={errors.typeSuivi ? 'error' : ''}>
                {typesSuivi.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            {errors.typeSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.typeSuivi}</span>}
          </div>

          <div className="form-group">
            <label>Agent responsable <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select name="agent" value={formData.agent} onChange={handleChange} className={errors.agent ? 'error' : ''}>
                <option value="">Sélectionner un agent</option>
                {agents.map(a => <option key={a} value={a}>{a}</option>)}
              </select>
            </div>
            {errors.agent && <span className="error-message"><AlertCircle size={12} /> {errors.agent}</span>}
          </div>

          <div className="form-group full-width">
            <label>Commentaire</label>
            <textarea name="commentaire" rows="3" value={formData.commentaire} onChange={handleChange} placeholder="Détails du suivi..." />
          </div>

          <div className="form-group full-width">
            <label>Prochaine action</label>
            <div className="input-icon">
              <Clock size={18} />
              <input type="text" name="prochainAction" value={formData.prochainAction} onChange={handleChange} placeholder="Ex: Rappeler dans 3 jours" />
            </div>
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/suivis')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer le suivi'}</button>
        </div>
      </form>
    </div>
  );
};

export default SuivisForm;
