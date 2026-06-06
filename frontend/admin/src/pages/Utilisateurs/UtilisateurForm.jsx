import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, Key, Shield, Calendar } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';
import './Utilisateurs.css';

const UtilisateurForm = () => {
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
    role: 'Agent',
    status: 'actif',
    password: '',
    confirmPassword: ''
  });

  const roles = [
    { value: 'Administrateur', label: 'Administrateur - Accès total' },
    { value: 'Manager', label: 'Manager - Gestion des équipes' },
    { value: 'Agent', label: 'Agent - Gestion des prospects' },
    { value: 'Viewer', label: 'Viewer - Consultation uniquement' }
  ];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Le nom est requis';
    if (!formData.email.trim()) newErrors.email = 'L\'email est requis';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) newErrors.email = 'Email invalide';
    if (!formData.phone.trim()) newErrors.phone = 'Le téléphone est requis';
    if (!isEdit && !formData.password) newErrors.password = 'Le mot de passe est requis';
    if (!isEdit && formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Les mots de passe ne correspondent pas';
    }
    if (formData.password && formData.password.length < 6) {
      newErrors.password = 'Le mot de passe doit faire au moins 6 caractères';
    }
    
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
      addToast(isEdit ? 'Utilisateur modifié avec succès' : 'Utilisateur créé avec succès', 'success');
      setTimeout(() => {
        navigate('/utilisateurs');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de l\'utilisateur.' : 'Ajoutez un nouvel utilisateur à la plateforme.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/utilisateurs')}>
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
                placeholder="Nom de l'utilisateur"
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
                placeholder="utilisateur@isetag.com"
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
            <label>Rôle</label>
            <div className="input-icon">
              <Shield size={18} />
              <select name="role" value={formData.role} onChange={handleChange}>
                {roles.map(r => <option key={r.value} value={r.value}>{r.label}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Statut</label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="status" value={formData.status} onChange={handleChange}>
                <option value="actif">Actif</option>
                <option value="inactif">Inactif</option>
              </select>
            </div>
          </div>

          {!isEdit && (
            <>
              <div className="form-group">
                <label>Mot de passe <span className="required">*</span></label>
                <div className="input-icon">
                  <Key size={18} />
                  <input
                    type="password"
                    name="password"
                    value={formData.password}
                    onChange={handleChange}
                    placeholder="Min 6 caractères"
                    className={errors.password ? 'error' : ''}
                  />
                </div>
                {errors.password && <span className="error-message"><AlertCircle size={12} /> {errors.password}</span>}
              </div>

              <div className="form-group">
                <label>Confirmer le mot de passe <span className="required">*</span></label>
                <div className="input-icon">
                  <Key size={18} />
                  <input
                    type="password"
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    placeholder="Confirmer le mot de passe"
                    className={errors.confirmPassword ? 'error' : ''}
                  />
                </div>
                {errors.confirmPassword && <span className="error-message"><AlertCircle size={12} /> {errors.confirmPassword}</span>}
              </div>
            </>
          )}
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/utilisateurs')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer l\'utilisateur'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default UtilisateurForm;
