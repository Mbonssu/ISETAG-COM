import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, MapPin, GraduationCap, Users } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useFormValidation, validators } from '../../hooks/useFormValidation';
import { prospectService } from '../../services/prospectService';
import '../Prospects/Prospects.css';

const ProspectForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [loadError, setLoadError] = useState(null);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (toastId) => {
    setToasts(prev => prev.filter(t => t.id !== toastId));
  };

  const niveauxEtude = ['Terminale', 'Bac+1', 'Bac+2', 'Bac+3', 'Master', 'Doctorat'];
  const typesProspect = ['Etudiant', 'Parent', 'Professionnel', 'Autre'];
  const sexes = [{ value: 'M', label: 'Masculin' }, { value: 'F', label: 'Féminin' }];

  // Règles de validation alignées sur les VRAIS champs requis du modèle
  // Prospect (prospect_api/models.py) : seuls nomComplet, email, telephone,
  // adresse, ville, codePostal, pays, sexe, niveauEtude, domaineEtude et
  // typeProspect sont des CharField/EmailField sans null=True.
  const validationRules = {
    nomComplet: [validators.required('Le nom complet est requis')],
    telephone: [validators.required('Le téléphone est requis'), validators.phone()],
    email: [validators.required('L\'email est requis'), validators.email()],
    niveauEtude: [validators.required('Le niveau d\'étude est requis')],
    domaineEtude: [validators.required('Le domaine d\'étude est requis')],
    adresse: [validators.required('L\'adresse est requise')],
    ville: [validators.required('La ville est requise')],
    pays: [validators.required('Le pays est requis')],
  };

  const { values, errors, touched, handleChange, handleBlur, validateForm, setValues } = useFormValidation(
    {
      nomComplet: '',
      telephone: '',
      email: '',
      niveauEtude: 'Terminale',
      domaineEtude: '',
      adresse: '',
      ville: '',
      codePostal: '',
      pays: 'Cameroun',
      sexe: 'M',
      typeProspect: 'Etudiant',
      dateNaissance: '',
      nomParent: '',
      numeroParent: '',
    },
    validationRules
  );

  // En mode édition, on charge le prospect réel depuis l'API.
  useEffect(() => {
    if (!isEdit) return;
    prospectService.getById(id)
      .then((data) => {
        setValues({
          nomComplet: data.nomComplet || '',
          telephone: data.telephone || '',
          email: data.email || '',
          niveauEtude: data.niveauEtude || 'Terminale',
          domaineEtude: data.domaineEtude || '',
          adresse: data.adresse || '',
          ville: data.ville || '',
          codePostal: data.codePostal || '',
          pays: data.pays || 'Cameroun',
          sexe: data.sexe || 'M',
          typeProspect: data.typeProspect || 'Etudiant',
          dateNaissance: data.dateNaissance || '',
          nomParent: data.nomParent || '',
          numeroParent: data.numeroParent || '',
        });
      })
      .catch((err) => setLoadError(err.message))
      .finally(() => setLoading(false));
  }, [id, isEdit, setValues]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setSaving(true);
    try {
      // dateNaissance, nomParent et numeroParent sont nullable côté
      // backend : on envoie null plutôt qu'une chaîne vide pour éviter
      // toute ambiguïté de validation.
      const payload = {
        ...values,
        dateNaissance: values.dateNaissance || null,
        nomParent: values.nomParent || null,
        numeroParent: values.numeroParent || null,
      };

      if (isEdit) {
        await prospectService.update(id, payload);
      } else {
        await prospectService.create(payload);
      }
      addToast(isEdit ? 'Prospect modifié avec succès' : 'Prospect créé avec succès', 'success');
      setTimeout(() => navigate('/prospects'), 1000);
    } catch (error) {
      addToast(error.message || 'Erreur lors de l\'enregistrement', 'error');
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <p className="page-loading">Chargement du prospect…</p>;

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

      {loadError && <p className="form-error">{loadError}</p>}

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
            <label>Date de naissance</label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="date"
                name="dateNaissance"
                value={values.dateNaissance}
                onChange={handleChange}
              />
            </div>
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
            <label>Domaine d'étude <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <input
                type="text"
                name="domaineEtude"
                value={values.domaineEtude}
                onChange={handleChange}
                onBlur={handleBlur}
                placeholder="Ex: Génie Logiciel"
                className={errors.domaineEtude && touched.domaineEtude ? 'error' : ''}
              />
            </div>
            {errors.domaineEtude && touched.domaineEtude && <span className="error-message"><AlertCircle size={12} /> {errors.domaineEtude}</span>}
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
                {typesProspect.map(tp => <option key={tp} value={tp}>{tp}</option>)}
              </select>
            </div>
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

          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text"
                name="ville"
                value={values.ville}
                onChange={handleChange}
                onBlur={handleBlur}
                placeholder="Ex: Yaoundé"
                className={errors.ville && touched.ville ? 'error' : ''}
              />
            </div>
            {errors.ville && touched.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          <div className="form-group">
            <label>Code postal</label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text"
                name="codePostal"
                value={values.codePostal}
                onChange={handleChange}
                placeholder="Ex: 00237"
              />
            </div>
          </div>

          <div className="form-group">
            <label>Pays <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input
                type="text"
                name="pays"
                value={values.pays}
                onChange={handleChange}
                onBlur={handleBlur}
                className={errors.pays && touched.pays ? 'error' : ''}
              />
            </div>
            {errors.pays && touched.pays && <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
          </div>

          <div className="form-group">
            <label>Nom du parent</label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="nomParent"
                value={values.nomParent}
                onChange={handleChange}
                placeholder="Si le prospect est mineur"
              />
            </div>
          </div>

          <div className="form-group">
            <label>Téléphone du parent</label>
            <div className="input-icon">
              <Phone size={18} />
              <input
                type="tel"
                name="numeroParent"
                value={values.numeroParent}
                onChange={handleChange}
                placeholder="6XXXXXXXX"
              />
            </div>
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/prospects')} disabled={saving}>Annuler</button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />{saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default ProspectForm;