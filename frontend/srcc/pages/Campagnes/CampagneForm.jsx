import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Target, Users, Mail, Smartphone, Phone } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useFormValidation, validators } from '../../hooks/useFormValidation';
import '../Prospects/Prospects.css';

const CampagneForm = () => {
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

  const types = ['Email', 'SMS', 'Appel'];
  const statuses = ['Planifiée', 'En cours', 'Terminée'];
  const agents = ['Jean M.', 'David P.', 'Sophie A.', 'Marie L.'];

  const validationRules = {
    name: [validators.required('Le nom de la campagne est requis')],
    dateDebut: [validators.required('La date de début est requise')],
    dateFin: [validators.required('La date de fin est requise')],
    agent: [validators.required('Veuillez sélectionner un agent')]
  };

  const { values, errors, touched, handleChange, handleBlur, validateForm } = useFormValidation(
    { name: '', type: 'Email', status: 'Planifiée', dateDebut: '', dateFin: '', agent: '', objectif: '', description: '' },
    validationRules
  );

  // Validation personnalisée pour les dates
  const validateDates = () => {
    if (values.dateDebut && values.dateFin && new Date(values.dateDebut) > new Date(values.dateFin)) {
      return false;
    }
    return true;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validateForm() && validateDates()) {
      addToast(isEdit ? 'Campagne modifiée avec succès' : 'Campagne créée avec succès', 'success');
      setTimeout(() => navigate('/campagnes'), 1500);
    } else {
      if (!validateDates()) {
        addToast('La date de fin doit être postérieure à la date de début', 'error');
      } else {
        addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      }
    }
  };

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Email': return <Mail size={18} />;
      case 'SMS': return <Smartphone size={18} />;
      case 'Appel': return <Phone size={18} />;
      default: return <Mail size={18} />;
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la campagne' : 'Nouvelle campagne'}</h1>
          <p className="page-description">{isEdit ? 'Modifiez les informations de la campagne.' : 'Créez une nouvelle campagne marketing.'}</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/campagnes')}><ArrowLeft size={18} /> Retour</button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de la campagne <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <input type="text" name="name" value={values.name} onChange={handleChange} onBlur={handleBlur} className={errors.name && touched.name ? 'error' : ''} />
            </div>
            {errors.name && touched.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Type de campagne</label>
            <div className="input-icon">
              {getTypeIcon(values.type)}
              <select name="type" value={values.type} onChange={handleChange}>
                {types.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Statut</label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="status" value={values.status} onChange={handleChange}>
                {statuses.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Date de début <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateDebut" value={values.dateDebut} onChange={handleChange} onBlur={handleBlur} className={errors.dateDebut && touched.dateDebut ? 'error' : ''} />
            </div>
            {errors.dateDebut && touched.dateDebut && <span className="error-message"><AlertCircle size={12} /> {errors.dateDebut}</span>}
          </div>

          <div className="form-group">
            <label>Date de fin <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="date" name="dateFin" value={values.dateFin} onChange={handleChange} onBlur={handleBlur} className={errors.dateFin && touched.dateFin ? 'error' : ''} />
            </div>
            {errors.dateFin && touched.dateFin && <span className="error-message"><AlertCircle size={12} /> {errors.dateFin}</span>}
          </div>

          <div className="form-group">
            <label>Agent responsable <span className="required">*</span></label>
            <div className="input-icon">
              <Users size={18} />
              <select name="agent" value={values.agent} onChange={handleChange} onBlur={handleBlur}>
                <option value="">Sélectionner un agent</option>
                {agents.map(a => <option key={a} value={a}>{a}</option>)}
              </select>
            </div>
            {errors.agent && touched.agent && <span className="error-message"><AlertCircle size={12} /> {errors.agent}</span>}
          </div>

          <div className="form-group">
            <label>Objectif (nombre de prospects)</label>
            <div className="input-icon">
              <Target size={18} />
              <input type="number" name="objectif" value={values.objectif} onChange={handleChange} placeholder="Ex: 500" />
            </div>
          </div>

          <div className="form-group full-width">
            <label>Description</label>
            <textarea name="description" rows="4" value={values.description} onChange={handleChange} placeholder="Description de la campagne..." />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/campagnes')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer'}</button>
        </div>
      </form>
    </div>
  );
};

export default CampagneForm;
