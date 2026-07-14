import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Building, MapPin, Phone, Mail, User } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useFormValidation, validators } from '../../hooks/useFormValidation';
import '../Prospects/Prospects.css';
import { useTranslation } from '../../hooks/useTranslation';

const EtablissementForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = React.useState([]);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const types = ['Lycée', 'Lycée Technique', 'Université', 'Institut', 'Collège'];
  const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Maroua', 'Bertoua'];

  const validationRules = {
    name: [validators.required('Le nom de l\'établissement est requis')],
    ville: [validators.required('La ville est requise')],
    adresse: [validators.required('L\'adresse est requise')]
  };

  const { values, errors, touched, handleChange, handleBlur, validateForm } = useFormValidation(
    { name: '', type: 'Lycée', ville: '', adresse: '', telephone: '', email: '', contactNom: '', contactPoste: '', notes: '' },
    validationRules
  );

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validateForm()) {
      addToast(isEdit ? 'Établissement modifié avec succès' : 'Établissement créé avec succès', 'success');
      setTimeout(() => navigate('/etablissements'), 1500);
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
          <p className="page-description">{isEdit ? 'Modifiez les informations de l\'établissement.' : 'Ajoutez un nouvel établissement partenaire.'}</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/etablissements')}><ArrowLeft size={18} /> Retour</button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de l'établissement <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <input type="text" name="name" value={values.name} onChange={handleChange} onBlur={handleBlur} className={errors.name && touched.name ? 'error' : ''} />
            </div>
            {errors.name && touched.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Type d'établissement</label>
            <div className="input-icon">
              <Building size={18} />
              <select name="type" value={values.type} onChange={handleChange}>
                {types.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <select name="ville" value={values.ville} onChange={handleChange} onBlur={handleBlur}>
                <option value="">Sélectionner une ville</option>
                {villes.map(v => <option key={v} value={v}>{v}</option>)}
              </select>
            </div>
            {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          <div className="form-group full-width">
            <label>Adresse <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="adresse" value={values.adresse} onChange={handleChange} onBlur={handleBlur} className={errors.adresse && touched.adresse ? 'error' : ''} />
            </div>
            {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone</label>
            <div className="input-icon">
              <Phone size={18} />
              <input type="tel" name="telephone" value={values.telephone} onChange={handleChange} placeholder="Téléphone" />
            </div>
          </div>

          <div className="form-group">
            <label>Email</label>
            <div className="input-icon">
              <Mail size={18} />
              <input type="email" name="email" value={values.email} onChange={handleChange} placeholder="contact@etablissement.com" />
            </div>
          </div>

          <div className="form-group">
            <label>Nom du contact</label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="contactNom" value={values.contactNom} onChange={handleChange} placeholder="Personne de contact" />
            </div>
          </div>

          <div className="form-group">
            <label>Poste du contact</label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="contactPoste" value={values.contactPoste} onChange={handleChange} placeholder="Proviseur, Directeur..." />
            </div>
          </div>

          <div className="form-group full-width">
            <label>Notes</label>
            <textarea name="notes" rows="4" value={values.notes} onChange={handleChange} placeholder="Informations complémentaires..." />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/etablissements')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer'}</button>
        </div>
      </form>
    </div>
  );
};

export default EtablissementForm;
