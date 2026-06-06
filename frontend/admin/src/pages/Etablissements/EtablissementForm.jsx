import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Building, MapPin, Phone, Mail, User, Star } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const EtablissementForm = () => {
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
    type: 'Lycée',
    ville: '',
    adresse: '',
    telephone: '',
    email: '',
    contactNom: '',
    contactPoste: '',
    notes: ''
  });

  const types = ['Lycée', 'Lycée Technique', 'Université', 'Institut', 'Collège'];
  const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Maroua', 'Bertoua'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Le nom de l\'établissement est requis';
    if (!formData.ville) newErrors.ville = 'Veuillez sélectionner une ville';
    if (!formData.adresse.trim()) newErrors.adresse = 'L\'adresse est requise';
    
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
      addToast(isEdit ? 'Établissement modifié avec succès' : 'Établissement créé avec succès', 'success');
      setTimeout(() => {
        navigate('/etablissements');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier l\'établissement' : 'Nouvel établissement'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de l\'établissement.' : 'Ajoutez un nouvel établissement partenaire.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/etablissements')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de l'établissement <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ex: Lycée de Biyem-Assi"
                className={errors.name ? 'error' : ''}
              />
            </div>
            {errors.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Type d'établissement</label>
            <div className="input-icon">
              <Building size={18} />
              <select name="type" value={formData.type} onChange={handleChange}>
                {types.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <select name="ville" value={formData.ville} onChange={handleChange} className={errors.ville ? 'error' : ''}>
                <option value="">Sélectionner une ville</option>
                {villes.map(v => <option key={v} value={v}>{v}</option>)}
              </select>
            </div>
            {errors.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          <div className="form-group full-width">
            <label>Adresse <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text"
                name="adresse"
                value={formData.adresse}
                onChange={handleChange}
                placeholder="Adresse complète"
                className={errors.adresse ? 'error' : ''}
              />
            </div>
            {errors.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone</label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel"
                name="telephone"
                value={formData.telephone}
                onChange={handleChange}
                placeholder="Téléphone de l'établissement"
              />
            </div>
          </div>

          <div className="form-group">
            <label>Email</label>
            <div className="input-icon">
              <Mail size={18} />
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="contact@etablissement.com"
              />
            </div>
          </div>

          <div className="form-group">
            <label>Nom du contact</label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="contactNom"
                value={formData.contactNom}
                onChange={handleChange}
                placeholder="Personne de contact"
              />
            </div>
          </div>

          <div className="form-group">
            <label>Poste du contact</label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="contactPoste"
                value={formData.contactPoste}
                onChange={handleChange}
                placeholder="Proviseur, Directeur..."
              />
            </div>
          </div>

          <div className="form-group full-width">
            <label>Notes</label>
            <textarea
              name="notes"
              rows="4"
              value={formData.notes}
              onChange={handleChange}
              placeholder="Informations complémentaires sur l'établissement..."
            />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/etablissements')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer l\'établissement'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default EtablissementForm;
