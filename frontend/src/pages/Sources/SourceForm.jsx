import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Globe } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const SourceForm = () => {
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
    description: '',
    couleur: '#4ECDC4',
    actif: true
  });

  const couleurs = [
    { name: 'Rouge', value: '#FF6B6B' },
    { name: 'Vert', value: '#4ECDC4' },
    { name: 'Jaune', value: '#FFE66D' },
    { name: 'Violet', value: '#A78BFA' },
    { name: 'Orange', value: '#F9A26C' },
    { name: 'Bleu', value: '#845EC2' },
  ];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Le nom de la source est requis';
    
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
      addToast(isEdit ? 'Source modifiée avec succès' : 'Source créée avec succès', 'success');
      setTimeout(() => {
        navigate('/sources');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier la source' : 'Nouvelle source'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la source.' : 'Ajoutez une nouvelle source de prospects.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/sources')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de la source <span className="required">*</span></label>
            <div className="input-icon">
              <Globe size={18} />
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ex: Terrain, Lycée..."
                className={errors.name ? 'error' : ''}
              />
            </div>
            {errors.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Couleur</label>
            <div className="color-selector">
              {couleurs.map(c => (
                <button
                  key={c.value}
                  type="button"
                  className={`color-option ${formData.couleur === c.value ? 'selected' : ''}`}
                  style={{ backgroundColor: c.value }}
                  onClick={() => setFormData({ ...formData, couleur: c.value })}
                  title={c.name}
                />
              ))}
              <input
                type="color"
                name="couleur"
                value={formData.couleur}
                onChange={handleChange}
                className="color-picker"
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
              placeholder="Description de la source..."
            />
          </div>

          <div className="form-group">
            <label>Statut</label>
            <select name="actif" value={formData.actif} onChange={(e) => setFormData({ ...formData, actif: e.target.value === 'true' })}>
              <option value="true">Actif</option>
              <option value="false">Inactif</option>
            </select>
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/sources')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer la source'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default SourceForm;
