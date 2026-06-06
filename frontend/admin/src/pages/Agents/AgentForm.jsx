import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const AgentForm = () => {
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
    email: '',
    phone: '',
    zone: '',
    status: 'actif'
  });

  const zones = ['Yaoundé Centre', 'Yaoundé Sud', 'Douala Nord', 'Douala Sud', 'Bafoussam', 'Garoua', 'Maroua', 'Bertoua'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Le nom est requis';
    if (!formData.email.trim()) newErrors.email = 'L\'email est requis';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) newErrors.email = 'Email invalide';
    if (!formData.phone.trim()) newErrors.phone = 'Le téléphone est requis';
    else if (!/^[0-9]{9,10}$/.test(formData.phone.replace(/\s/g, ''))) newErrors.phone = 'Téléphone invalide (9-10 chiffres)';
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
      addToast(isEdit ? 'Agent modifié avec succès' : 'Agent créé avec succès', 'success');
      setTimeout(() => {
        navigate('/agents');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier l\'agent' : 'Nouvel agent'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de l\'agent.' : 'Ajoutez un nouvel agent commercial.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/agents')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Nom complet <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ex: Jean Dupont"
                className={errors.name ? 'error' : ''}
              />
            </div>
            {errors.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Email <span className="required">*</span></label>
            <div className="input-icon">
              <Mail size={18} />
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="agent@isetag.com"
                className={errors.email ? 'error' : ''}
              />
            </div>
            {errors.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel"
                name="phone"
                value={formData.phone}
                onChange={handleChange}
                placeholder="6XXXXXXXX"
                className={errors.phone ? 'error' : ''}
              />
            </div>
            {errors.phone && <span className="error-message"><AlertCircle size={12} /> {errors.phone}</span>}
          </div>

          <div className="form-group">
            <label>Zone d'affectation <span className="required">*</span></label>
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
            <label>Statut</label>
            <select name="status" value={formData.status} onChange={handleChange}>
              <option value="actif">Actif</option>
              <option value="inactif">Inactif</option>
            </select>
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/agents')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer l\'agent'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default AgentForm;
