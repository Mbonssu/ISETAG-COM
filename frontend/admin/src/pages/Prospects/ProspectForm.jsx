import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin, GraduationCap, Building, Users } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const ProspectForm = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
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
    nomComplet: '',
    telephone: '',
    email: '',
    niveauEtude: 'Terminale',
    concerne: '',
    adresse: '',
    sexe: 'M',
    typeProspect: 'Etudiant',
    commentaire: ''
  });

  const niveauxEtude = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master', 'Doctorat'];
  const typesProspect = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
  const sexes = [
    { value: 'M', label: t('masculin') },
    { value: 'F', label: t('feminin') }
  ];
  const etablissements = ['Lycée de Biyem-Assi', 'Lycée Technique d\'Efouan', 'Université de Douala', 'Institut Supérieur', 'Collège de la Salle'];

  const validateForm = () => {
    const newErrors = {};
    if (!formData.nomComplet.trim()) newErrors.nomComplet = 'Le nom complet est requis';
    if (!formData.telephone.trim()) newErrors.telephone = 'Le téléphone est requis';
    else if (!/^[0-9]{9,10}$/.test(formData.telephone.replace(/\s/g, ''))) newErrors.telephone = 'Téléphone invalide (9-10 chiffres)';
    if (!formData.email.trim()) newErrors.email = 'L\'email est requis';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) newErrors.email = 'Email invalide';
    if (!formData.niveauEtude) newErrors.niveauEtude = 'Le niveau d\'étude est requis';
    if (!formData.concerne) newErrors.concerne = 'L\'établissement est requis';
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
      addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès', 'success');
      setTimeout(() => {
        navigate('/prospects');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier le prospect' : 'Nouveau prospect'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations du prospect.' : 'Ajoutez un nouveau prospect à la base de données.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/prospects')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom complet <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="nomComplet"
                value={formData.nomComplet}
                onChange={handleChange}
                placeholder="Ex: Jean Dupont"
                className={errors.nomComplet ? 'error' : ''}
              />
            </div>
            {errors.nomComplet && <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel"
                name="telephone"
                value={formData.telephone}
                onChange={handleChange}
                placeholder="6XXXXXXXX"
                className={errors.telephone ? 'error' : ''}
              />
            </div>
            {errors.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
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
                placeholder="exemple@email.com"
                className={errors.email ? 'error' : ''}
              />
            </div>
            {errors.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          <div className="form-group">
            <label>Niveau d'étude <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <select name="niveauEtude" value={formData.niveauEtude} onChange={handleChange} className={errors.niveauEtude ? 'error' : ''}>
                {niveauxEtude.map(n => <option key={n} value={n}>{n}</option>)}
              </select>
            </div>
            {errors.niveauEtude && <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
          </div>

          <div className="form-group">
            <label>Sexe</label>
            <div className="input-icon">
              <Users size={18} />
              <select name="sexe" value={formData.sexe} onChange={handleChange}>
                {sexes.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Type de prospect</label>
            <div className="input-icon">
              <Users size={18} />
              <select name="typeProspect" value={formData.typeProspect} onChange={handleChange}>
                {typesProspect.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Établissement concerné <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <select name="concerne" value={formData.concerne} onChange={handleChange} className={errors.concerne ? 'error' : ''}>
                <option value="">Sélectionner un établissement</option>
                {etablissements.map(e => <option key={e} value={e}>{e}</option>)}
              </select>
            </div>
            {errors.concerne && <span className="error-message"><AlertCircle size={12} /> {errors.concerne}</span>}
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

          <div className="form-group full-width">
            <label>Commentaire</label>
            <textarea
              name="commentaire"
              rows="4"
              value={formData.commentaire}
              onChange={handleChange}
              placeholder="Informations complémentaires sur le prospect..."
            />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/prospects')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer le prospect'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default ProspectForm;
