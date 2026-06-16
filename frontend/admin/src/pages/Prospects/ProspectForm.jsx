import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin, GraduationCap, Building, Users } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useFormValidation, validators } from '../../hooks/useFormValidation';
import '../Prospects/Prospects.css';

const ProspectForm = () => {
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

  const niveauxEtude = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master', 'Doctorat'];
  const typesProspect = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
  const sexes = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];
  const etablissements = ['Lycée de Biyem-Assi', 'Lycée Technique d\'Efouan', 'Université de Douala', 'Institut Supérieur', 'Collège de la Salle'];

  const validationRules = {
    nomComplet: [validators.required('Le nom complet est requis')],
    telephone: [validators.required('Le téléphone est requis'), validators.phone()],
    email: [validators.required('L\'email est requis'), validators.email()],
    niveauEtude: [validators.required('Le niveau d\'étude est requis')],
    concerne: [validators.required('L\'établissement est requis')],
    adresse: [validators.required('L\'adresse est requise')]
  };

  const { values, errors, touched, handleChange, handleBlur, validateForm } = useFormValidation(
    {
      nomComplet: '',
      telephone: '',
      email: '',
      niveauEtude: 'Terminale',
      concerne: '',
      adresse: '',
      sexe: 'M',
      typeProspect: 'Etudiant',
      commentaire: ''
    },
    validationRules
  );

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validateForm()) {
      addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès', 'success');
      setTimeout(() => navigate('/prospects'), 1500);
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
          Retour
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
                value={values.nomComplet}
                onChange={handleChange}
                onBlur={handleBlur}
                placeholder="Ex: Jean Dupont"
                className={errors.nomComplet && touched.nomComplet ? 'error' : ''}
              />
            </div>
            {errors.nomComplet && touched.nomComplet && <span className="error-message"><AlertCircle size={12} /> {errors.nomComplet}</span>}
          </div>

          <div className="form-group">
            <label>Téléphone <span className="required">*</span></label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel"
                name="telephone"
                value={values.telephone}
                onChange={handleChange}
                onBlur={handleBlur}
                placeholder="6XXXXXXXX"
                className={errors.telephone && touched.telephone ? 'error' : ''}
              />
            </div>
            {errors.telephone && touched.telephone && <span className="error-message"><AlertCircle size={12} /> {errors.telephone}</span>}
          </div>

          <div className="form-group">
            <label>Email <span className="required">*</span></label>
            <div className="input-icon">
              <Mail size={18} />
              <input
                type="email"
                name="email"
                value={values.email}
                onChange={handleChange}
                onBlur={handleBlur}
                placeholder="exemple@email.com"
                className={errors.email && touched.email ? 'error' : ''}
              />
            </div>
            {errors.email && touched.email && <span className="error-message"><AlertCircle size={12} /> {errors.email}</span>}
          </div>

          <div className="form-group">
            <label>Niveau d'étude <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <select name="niveauEtude" value={values.niveauEtude} onChange={handleChange} onBlur={handleBlur}>
                {niveauxEtude.map(n => <option key={n} value={n}>{n}</option>)}
              </select>
            </div>
            {errors.niveauEtude && touched.niveauEtude && <span className="error-message"><AlertCircle size={12} /> {errors.niveauEtude}</span>}
          </div>

          <div className="form-group">
            <label>Sexe</label>
            <div className="input-icon">
              <Users size={18} />
              <select name="sexe" value={values.sexe} onChange={handleChange}>
                {sexes.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Type de prospect</label>
            <div className="input-icon">
              <Users size={18} />
              <select name="typeProspect" value={values.typeProspect} onChange={handleChange}>
                {typesProspect.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Établissement concerné <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <select name="concerne" value={values.concerne} onChange={handleChange} onBlur={handleBlur}>
                <option value="">Sélectionner un établissement</option>
                {etablissements.map(e => <option key={e} value={e}>{e}</option>)}
              </select>
            </div>
            {errors.concerne && touched.concerne && <span className="error-message"><AlertCircle size={12} /> {errors.concerne}</span>}
          </div>

          <div className="form-group full-width">
            <label>Adresse <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text"
                name="adresse"
                value={values.adresse}
                onChange={handleChange}
                onBlur={handleBlur}
                placeholder="Adresse complète"
                className={errors.adresse && touched.adresse ? 'error' : ''}
              />
            </div>
            {errors.adresse && touched.adresse && <span className="error-message"><AlertCircle size={12} /> {errors.adresse}</span>}
          </div>

          <div className="form-group full-width">
            <label>Commentaire</label>
            <textarea
              name="commentaire"
              rows="4"
              value={values.commentaire}
              onChange={handleChange}
              placeholder="Informations complémentaires..."
            />
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/prospects')}>Annuler</button>
          <button type="submit" className="btn-primary"><Save size={18} />{isEdit ? 'Mettre à jour' : 'Créer'}</button>
        </div>
      </form>
    </div>
  );
};

export default ProspectForm;
