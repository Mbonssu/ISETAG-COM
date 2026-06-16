import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, MapPin, Building, Globe } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const ZonesForm = () => {
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
    code: '',
    quartier: '',
    ville: 'Yaoundé',
    region: 'Centre',
    pays: 'Cameroun',
    lieuDepart: '',
    lieuFin: '',
    description: ''
  });

  const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Maroua', 'Bertoua'];
  const regions = ['Centre', 'Littoral', 'Ouest', 'Nord', 'Extrême-Nord', 'Sud', 'Est', 'Adamawa'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.code.trim()) newErrors.code = 'Le code est requis';
    if (!formData.quartier.trim()) newErrors.quartier = 'Le quartier est requis';
    if (!formData.ville) newErrors.ville = 'La ville est requise';
    if (!formData.region) newErrors.region = 'La région est requise';
    
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
      addToast(isEdit ? 'Zone modifiée avec succès' : 'Zone créée avec succès', 'success');
      setTimeout(() => navigate('/zones'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la zone' : 'Nouvelle zone'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la zone.' : 'Ajoutez une nouvelle zone géographique.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/zones')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Code zone <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="code" value={formData.code} onChange={handleChange} placeholder="Ex: Z001" className={errors.code ? 'error' : ''} />
            </div>
            {errors.code && <span className="error-message"><AlertCircle size={12} /> {errors.code}</span>}
          </div>

          <div className="form-group">
            <label>Quartier <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <input type="text" name="quartier" value={formData.quartier} onChange={handleChange} className={errors.quartier ? 'error' : ''} />
            </div>
            {errors.quartier && <span className="error-message"><AlertCircle size={12} /> {errors.quartier}</span>}
          </div>

          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <select name="ville" value={formData.ville} onChange={handleChange} className={errors.ville ? 'error' : ''}>
                {villes.map(v => <option key={v} value={v}>{v}</option>)}
              </select>
            </div>
            {errors.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          <div className="form-group">
            <label>Région <span className="required">*</span></label>
            <div className="input-icon">
              <Globe size={18} />
              <select name="region" value={formData.region} onChange={handleChange} className={errors.region ? 'error' : ''}>
                {regions.map(r => <option key={r} value={r}>{r}</option>)}
              </select>
            </div>
            {errors.region && <span className="error-message"><AlertCircle size={12} /> {errors.region}</span>}
          </div>

          <div className="form-group">
            <label>Pays</label>
            <div className="input-icon">
              <Globe size={18} />
              <input type="text" name="pays" value={formData.pays} onChange={handleChange} />
            </div>
          </div>

          <div className="form-group">
            <label>Lieu de départ</label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="lieuDepart" value={formData.lieuDepart} onChange={handleChange} placeholder="Point de départ" />
            </div>
          </div>

          <div className="form-group">
            <label>Lieu de fin</label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="lieuFin" value={formData.lieuFin} onChange={handleChange} placeholder="Point d'arrivée" />
            </div>
          </div>

          <div className="form-group full-width">
            <label>Description</label>
            <textarea name="description" rows="3" value={formData.description} onChange={handleChange} placeholder="Description de la zone..." />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/zones')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer la zone'}</button>
        </div>
      </form>
    </div>
  );
};

export default ZonesForm;
