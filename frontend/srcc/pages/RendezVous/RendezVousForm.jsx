import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Clock, MapPin, User } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';
import { useTranslation } from '../../hooks/useTranslation';

const RendezVousForm = () => {
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
    dateRv: '',
    heureRv: '',
    lieuRv: '',
    statutRv: 'Planifié',
    commentaire: '',
    agent: ''
  });

  const statusRv = ['Planifié', 'Confirmé', 'Effectué', 'Annulé', 'Reporté'];
  const prospects = ['Marie L.', 'David P.', 'Anne S.', 'Junior B.', 'Luc M.'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.', 'Paul K.'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.prospect) newErrors.prospect = 'Veuillez sélectionner un prospect';
    if (!formData.dateRv) newErrors.dateRv = 'La date est requise';
    if (!formData.heureRv) newErrors.heureRv = 'L\'heure est requise';
    if (!formData.lieuRv.trim()) newErrors.lieuRv = 'Le lieu est requis';
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
      addToast(isEdit ? 'Rendez-vous modifié avec succès' : 'Rendez-vous créé avec succès', 'success');
      setTimeout(() => navigate('/rendezvous'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier le rendez-vous' : 'Nouveau rendez-vous'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations du rendez-vous.' : 'Planifiez un nouveau rendez-vous avec un prospect.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/rendezvous')}>
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
            <label>Date <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateRv" value={formData.dateRv} onChange={handleChange} className={errors.dateRv ? 'error' : ''} />
            </div>
            {errors.dateRv && <span className="error-message"><AlertCircle size={12} /> {errors.dateRv}</span>}
          </div>

          <div className="form-group">
            <label>Heure <span className="required">*</span></label>
            <div className="input-icon">
              <Clock size={18} />
              <input type="time" name="heureRv" value={formData.heureRv} onChange={handleChange} className={errors.heureRv ? 'error' : ''} />
            </div>
            {errors.heureRv && <span className="error-message"><AlertCircle size={12} /> {errors.heureRv}</span>}
          </div>

          <div className="form-group">
            <label>Lieu <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="lieuRv" value={formData.lieuRv} onChange={handleChange} placeholder="Ex: Lycée de Biyem-Assi" className={errors.lieuRv ? 'error' : ''} />
            </div>
            {errors.lieuRv && <span className="error-message"><AlertCircle size={12} /> {errors.lieuRv}</span>}
          </div>

          <div className="form-group">
            <label>Statut</label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="statutRv" value={formData.statutRv} onChange={handleChange}>
                {statusRv.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
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
            <textarea name="commentaire" rows="3" value={formData.commentaire} onChange={handleChange} placeholder="Informations complémentaires..." />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/rendezvous')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer le rendez-vous'}</button>
        </div>
      </form>
    </div>
  );
};

export default RendezVousForm;
