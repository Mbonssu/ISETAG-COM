import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, Calendar } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';
import { useTranslation } from '../../hooks/useTranslation';

const SuperviseursForm = () => {
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
    nom: '',
    prenom: '',
    email: '',
    telephone: '',
    matricule: '',
    dateEmbauche: '',
    actif: true
  });

  const validateForm = () => {
    const newErrors = {};
    if (!formData.nom.trim()) newErrors.nom = 'Le nom est requis';
    if (!formData.prenom.trim()) newErrors.prenom = 'Le prénom est requis';
    if (!formData.email.trim()) newErrors.email = 'L\'email est requis';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) newErrors.email = 'Email invalide';
    if (!formData.telephone.trim()) newErrors.telephone = 'Le téléphone est requis';
    if (!formData.matricule.trim()) newErrors.matricule = 'Le matricule est requis';
    if (!formData.dateEmbauche) newErrors.dateEmbauche = 'La date d\'embauche est requise';
    
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
      addToast(isEdit ? 'Superviseur modifié avec succès' : 'Superviseur créé avec succès', 'success');
      setTimeout(() => navigate('/superviseurs'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier le superviseur' : 'Nouveau superviseur'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations du superviseur.' : 'Ajoutez un nouveau superviseur.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/superviseurs')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Nom <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="nom" value={formData.nom} onChange={handleChange} className={errors.nom ? 'error' : ''} />
            </div>
            {errors.nom && <span className="error-message"><AlertCircle size={12} /> {errors.nom}</span>}
          </div>

          <div className="form-group">
            <label>Prénom <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="prenom" value={formData.prenom} onChange={handleChange} className={errors.prenom ? 'error' : ''} />
            </div>
            {errors.prenom && <span className="error-message"><AlertCircle size={12} /> {errors.prenom}</span>}
          </div>

          <div className="form-group">
            <label>Email <span className="required">*</span></label>
            <div className="input-icon">
              <Mail size={18} />
              <input type="email" name="email" value={formData.email} onChange={handleChange} className={errors.email ? 'error' : ''} />
            </div>
            {errors.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input type="tel" name="telephone" value={formData.telephone} onChange={handleChange} className={errors.telephone ? 'error' : ''} />
            </div>
            {errors.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
          </div>

          <div className="form-group">
            <label>Matricule <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="matricule" value={formData.matricule} onChange={handleChange} placeholder="Ex: SUP001" className={errors.matricule ? 'error' : ''} />
            </div>
            {errors.matricule && <span className="error-message"><AlertCircle size={12} /> {errors.matricule}</span>}
          </div>

          <div className="form-group">
            <label>Date d'embauche <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateEmbauche" value={formData.dateEmbauche} onChange={handleChange} className={errors.dateEmbauche ? 'error' : ''} />
            </div>
            {errors.dateEmbauche && <span className="error-message"><AlertCircle size={12} /> {errors.dateEmbauche}</span>}
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
          <button type="button" className="btn-outline" onClick={() => navigate('/superviseurs')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer le superviseur'}</button>
        </div>
      </form>
    </div>
  );
};

export default SuperviseursForm;
