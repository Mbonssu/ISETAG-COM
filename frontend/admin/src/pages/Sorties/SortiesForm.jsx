import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Target, User, MapPin } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const SortiesForm = () => {
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
    typeSortie: 'Prospection',
    dateSortie: '',
    statut: 'Planifiée',
    objectif: '',
    commentaire: '',
    agent: '',
    zone: ''
  });

  const typesSortie = ['Prospection', 'Suivi', 'Formation', 'Réunion', 'Autre'];
  const statutsSortie = ['Planifiée', 'En cours', 'Effectuée', 'Annulée', 'Reportée'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.', 'Paul K.'];
  const zones = ['Yaoundé Centre', 'Yaoundé Sud', 'Douala Nord', 'Douala Sud', 'Bafoussam', 'Garoua'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.typeSortie) newErrors.typeSortie = 'Le type est requis';
    if (!formData.dateSortie) newErrors.dateSortie = 'La date est requise';
    if (!formData.agent) newErrors.agent = 'Veuillez sélectionner un agent';
    if (!formData.zone) newErrors.zone = 'Veuillez sélectionner une zone';
    
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
      addToast(isEdit ? 'Sortie modifiée avec succès' : 'Sortie créée avec succès', 'success');
      setTimeout(() => navigate('/sorties'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la sortie' : 'Nouvelle sortie'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la sortie.' : 'Planifiez une nouvelle sortie terrain.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/sorties')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Type de sortie <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <select name="typeSortie" value={formData.typeSortie} onChange={handleChange} className={errors.typeSortie ? 'error' : ''}>
                {typesSortie.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            {errors.typeSortie && <span className="error-message"><AlertCircle size={12} /> {errors.typeSortie}</span>}
          </div>

          <div className="form-group">
            <label>Date de sortie <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateSortie" value={formData.dateSortie} onChange={handleChange} className={errors.dateSortie ? 'error' : ''} />
            </div>
            {errors.dateSortie && <span className="error-message"><AlertCircle size={12} /> {errors.dateSortie}</span>}
          </div>

          <div className="form-group">
            <label>Statut</label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="statut" value={formData.statut} onChange={handleChange}>
                {statutsSortie.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Objectif</label>
            <div className="input-icon">
              <Target size={18} />
              <input type="text" name="objectif" value={formData.objectif} onChange={handleChange} placeholder="Ex: 50 prospects" />
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

          <div className="form-group full-width">
            <label>Commentaire</label>
            <textarea name="commentaire" rows="4" value={formData.commentaire} onChange={handleChange} placeholder="Informations complémentaires sur la sortie..." />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/sorties')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer la sortie'}</button>
        </div>
      </form>
    </div>
  );
};

export default SortiesForm;
