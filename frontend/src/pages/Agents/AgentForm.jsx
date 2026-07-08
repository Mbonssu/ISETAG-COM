import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useFormValidation, validators } from '../../hooks/useFormValidation';
import '../Prospects/Prospects.css';

const AgentForm = () => {
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

  const zones = ['Yaoundé Centre', 'Yaoundé Sud', 'Douala Nord', 'Douala Sud', 'Bafoussam', 'Garoua'];

  const validationRules = {
    name: [validators.required('Le nom est requis')],
    email: [validators.required('L\'email est requis'), validators.email()],
    phone: [validators.required('Le téléphone est requis'), validators.phone()],
    zone: [validators.required('La zone est requise')]
  };

  const { values, errors, touched, handleChange, handleBlur, validateForm } = useFormValidation(
    { name: '', email: '', phone: '', zone: '', status: 'actif' },
    validationRules
  );

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validateForm()) {
      addToast(isEdit ? 'Agent modifié avec succès' : 'Agent créé avec succès', 'success');
      setTimeout(() => navigate('/agents'), 1500);
    } else {
      addToast('Veuillez corriger les erreurs', 'error');
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier l\'agent' : 'Nouvel agent'}</h1>
          <p className="page-description">{isEdit ? 'Modifiez les informations de l\'agent.' : 'Ajoutez un nouvel agent commercial.'}</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/agents')}><ArrowLeft size={18} /> Retour</button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom complet <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input type="text" name="name" value={values.name} onChange={handleChange} onBlur={handleBlur} className={errors.name && touched.name ? 'error' : ''} />
            </div>
            {errors.name && touched.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Email <span className="required">*</span></label>
            <div className="input-icon">
              <Mail size={18} />
              <input type="email" name="email" value={values.email} onChange={handleChange} onBlur={handleBlur} className={errors.email && touched.email ? 'error' : ''} />
            </div>
            {errors.email && touched.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input type="tel" name="phone" value={values.phone} onChange={handleChange} onBlur={handleBlur} className={errors.phone && touched.phone ? 'error' : ''} />
            </div>
            {errors.phone && touched.phone && <span className="error-message"><AlertCircle size={12} /> {errors.phone}</span>}
          </div>

          <div className="form-group">
            <label>Zone <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <select name="zone" value={values.zone} onChange={handleChange} onBlur={handleBlur}>
                <option value="">Sélectionner une zone</option>
                {zones.map(z => <option key={z} value={z}>{z}</option>)}
              </select>
            </div>
            {errors.zone && touched.zone && <span className="error-message"><AlertCircle size={12} /> {errors.zone}</span>}
          </div>

          <div className="form-group">
            <label>Statut</label>
            <select name="status" value={values.status} onChange={handleChange}>
              <option value="actif">Actif</option>
              <option value="inactif">Inactif</option>
            </select>
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/agents')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer'}</button>
        </div>
      </form>
    </div>
  );
};

export default AgentForm;
