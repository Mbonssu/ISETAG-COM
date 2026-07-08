import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Calendar, Star, FileText } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const FichesForm = () => {
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
    source: '',
    dateCollecte: '',
    scoreInteret: 50,
    commentaire: '',
    campagne: '',
    agent: ''
  });

  const sources = ['Terrain', 'Lycée', 'Passage institut', 'Réseaux sociaux', 'Référence'];
  const prospects = ['Marie L.', 'David P.', 'Anne S.', 'Junior B.', 'Luc M.'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.', 'Paul K.'];
  const campagnes = ['Campagne Mai 2025', 'Campagne Lycées', 'Campagne Réseaux Sociaux', 'Campagne Téléphonique'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.prospect) newErrors.prospect = 'Veuillez sélectionner un prospect';
    if (!formData.source) newErrors.source = 'La source est requise';
    if (!formData.dateCollecte) newErrors.dateCollecte = 'La date est requise';
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
      addToast(isEdit ? 'Fiche modifiée avec succès' : 'Fiche créée avec succès', 'success');
      setTimeout(() => navigate('/fiches'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la fiche' : 'Nouvelle fiche'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la fiche.' : 'Créez une nouvelle fiche de collecte.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/fiches')}>
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
            <label>Source <span className="required">*</span></label>
            <div className="input-icon">
              <FileText size={18} />
              <select name="source" value={formData.source} onChange={handleChange} className={errors.source ? 'error' : ''}>
                <option value="">Sélectionner une source</option>
                {sources.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            {errors.source && <span className="error-message"><AlertCircle size={12} /> {errors.source}</span>}
          </div>

          <div className="form-group">
            <label>Date de collecte <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateCollecte" value={formData.dateCollecte} onChange={handleChange} className={errors.dateCollecte ? 'error' : ''} />
            </div>
            {errors.dateCollecte && <span className="error-message"><AlertCircle size={12} /> {errors.dateCollecte}</span>}
          </div>

          <div className="form-group">
            <label>Score d'intérêt</label>
            <div className="input-icon">
              <Star size={18} />
              <input type="range" name="scoreInteret" min="0" max="100" value={formData.scoreInteret} onChange={handleChange} />
              <span style={{ marginLeft: '10px', fontWeight: 'bold' }}>{formData.scoreInteret}%</span>
            </div>
          </div>

          <div className="form-group">
            <label>Campagne</label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="campagne" value={formData.campagne} onChange={handleChange}>
                <option value="">Sélectionner une campagne</option>
                {campagnes.map(c => <option key={c} value={c}>{c}</option>)}
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
            <textarea name="commentaire" rows="4" value={formData.commentaire} onChange={handleChange} placeholder="Informations complémentaires sur le prospect..." />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/fiches')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer la fiche'}</button>
        </div>
      </form>
    </div>
  );
};

export default FichesForm;
