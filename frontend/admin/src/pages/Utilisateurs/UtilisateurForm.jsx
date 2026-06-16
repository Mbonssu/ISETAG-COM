import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, User, Mail, Phone, Key, Shield, Calendar, Eye, EyeOff } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import { userService } from '../../services/userService';
import '../Prospects/Prospects.css';
import './Utilisateurs.css';

const UtilisateurForm = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const { id } = useParams();
  const isEdit = !!id;
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
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
    role: 'Agent',
    actif: true,
    dateEmbauche: '',
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
    
    console.log('🔍 Validation du formulaire:', formData);
    
    if (!formData.nom.trim()) newErrors.nom = 'Le nom est requis';
    if (!formData.prenom.trim()) newErrors.prenom = 'Le prénom est requis';
    if (!formData.email.trim()) newErrors.email = 'L\'email est requis';
    else if (!/\S+@\S+\.\S+/.test(formData.email)) newErrors.email = 'Email invalide';
    if (!formData.telephone.trim()) newErrors.telephone = 'Le téléphone est requis';
    else if (!/^[0-9]{9,10}$/.test(formData.telephone.replace(/\s/g, ''))) {
      newErrors.telephone = 'Téléphone invalide (9-10 chiffres)';
    }
    if (!formData.role) newErrors.role = 'Le rôle est requis';
    
    if (!isEdit) {
      if (!formData.password) newErrors.password = 'Le mot de passe est requis';
      else if (formData.password.length < 6) newErrors.password = 'Minimum 6 caractères';
      if (formData.password !== formData.confirmPassword) {
        newErrors.confirmPassword = 'Les mots de passe ne correspondent pas';
      }
    }
    
    console.log('🔍 Erreurs de validation:', newErrors);
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    console.log(`✏️ Champ modifié: ${name} = ${type === 'checkbox' ? checked : value}`);
    
    setFormData(prev => {
      const newData = {
        ...prev,
        [name]: type === 'checkbox' ? checked : value
      };
      console.log('📝 Nouveau state du formulaire:', newData);
      return newData;
    });
    
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  useEffect(() => {
    if (isEdit) {
      const fetchUser = async () => {
        try {
          console.log('📡 Chargement de l\'utilisateur ID:', id);
          const response = await userService.getById(id);
          console.log('📥 Réponse du chargement:', response);
          
          const userData = response.data || response;
          console.log('📋 Données utilisateur reçues:', userData);
          
          setFormData({
            nom: userData.nom || '',
            prenom: userData.prenom || '',
            email: userData.email || '',
            telephone: userData.telephone || '',
            role: userData.role || 'Agent',
            actif: userData.actif !== undefined ? userData.actif : true,
            dateEmbauche: userData.dateEmbauche || '',
            password: '',
            confirmPassword: ''
          });
        } catch (error) {
          console.error('❌ Erreur de chargement:', error);
          addToast('Erreur lors du chargement des données', 'error');
          navigate('/utilisateurs');
        }
      };
      fetchUser();
    }
  }, [id, isEdit, navigate]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log('🚀 Soumission du formulaire');
    console.log('📋 Données actuelles du formulaire:', formData);
    
    if (!validateForm()) {
      console.log('❌ Formulaire invalide');
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setLoading(true);
    try {
      // Préparer les données pour l'API
      const userData = {
        nom: formData.nom,
        prenom: formData.prenom,
        email: formData.email,
        telephone: formData.telephone,
        role: formData.role,
        actif: formData.actif,
        dateEmbauche: formData.dateEmbauche || null,
      };

      // Ajouter le mot de passe uniquement pour la création ou s'il est rempli en édition
      if (!isEdit) {
        userData.password = formData.password;
        console.log('🔑 Mot de passe ajouté pour la création');
      } else if (formData.password) {
        userData.password = formData.password;
        console.log('🔑 Mot de passe mis à jour');
      }

      console.log('📤 Données envoyées à l\'API:', JSON.stringify(userData, null, 2));

      let response;
      if (isEdit) {
        console.log(`🔄 Mise à jour de l'utilisateur ID: ${id}`);
        response = await userService.update(id, userData);
        console.log('✅ Réponse de mise à jour:', response);
        addToast('Utilisateur modifié avec succès', 'success');
      } else {
        console.log('➕ Création d\'un nouvel utilisateur');
        response = await userService.create(userData);
        console.log('✅ Réponse de création:', response);
        addToast('Utilisateur créé avec succès', 'success');
      }

      console.log('📊 Réponse complète du serveur:', response);

      setTimeout(() => {
        navigate('/utilisateurs');
      }, 1500);

    } catch (error) {
      console.error('❌ Erreur complète:', error);
      console.error('❌ Message d\'erreur:', error.message);
      console.error('❌ Stack trace:', error.stack);
      
      let errorMessage = 'Erreur lors de l\'enregistrement';
      
      if (error.response) {
        console.error('❌ Réponse d\'erreur:', error.response);
        try {
          const errorData = await error.response.json();
          console.error('❌ Données d\'erreur:', errorData);
          errorMessage = errorData.message || errorData.detail || errorData.non_field_errors?.[0] || errorMessage;
        } catch (e) {
          console.error('❌ Erreur de parsing de la réponse:', e);
        }
      }
      
      addToast(errorMessage, 'error');
      
      // Afficher les erreurs de validation du backend
      if (error.response?.data) {
        const backendErrors = error.response.data;
        if (typeof backendErrors === 'object') {
          const fieldErrors = {};
          Object.keys(backendErrors).forEach(key => {
            if (Array.isArray(backendErrors[key])) {
              fieldErrors[key] = backendErrors[key][0];
            } else if (typeof backendErrors[key] === 'string') {
              fieldErrors[key] = backendErrors[key];
            }
          });
          setErrors(prev => ({ ...prev, ...fieldErrors }));
        }
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">
            {isEdit ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur'}
          </h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de l\'utilisateur.' : 'Ajoutez un nouvel utilisateur à la plateforme.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/utilisateurs')}>
          <ArrowLeft size={18} /> Retour
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          {/* Nom */}
          <div className="form-group">
            <label>Nom <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="nom"
                value={formData.nom}
                onChange={handleChange}
                placeholder="Nom de l'utilisateur"
                className={errors.nom ? 'error' : ''}
              />
            </div>
            {errors.nom && <span className="error-message"><AlertCircle size={12} /> {errors.nom}</span>}
          </div>

          {/* Prénom */}
          <div className="form-group">
            <label>Prénom <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <input
                type="text"
                name="prenom"
                value={formData.prenom}
                onChange={handleChange}
                placeholder="Prénom de l'utilisateur"
                className={errors.prenom ? 'error' : ''}
              />
            </div>
            {errors.prenom && <span className="error-message"><AlertCircle size={12} /> {errors.prenom}</span>}
          </div>

          {/* Email */}
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

          {/* Téléphone */}
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

          {/* Rôle */}
          <div className="form-group">
            <label>Rôle <span className="required">*</span></label>
            <div className="input-icon">
              <Shield size={18} />
              <select
                name="role"
                value={formData.role}
                onChange={handleChange}
                className={errors.role ? 'error' : ''}
              >
                {roles.map(r => (
                  <option key={r.value} value={r.value}>{r.label}</option>
                ))}
              </select>
            </div>
            {errors.role && <span className="error-message"><AlertCircle size={12} /> {errors.role}</span>}
          </div>

          {/* Date d'embauche */}
          <div className="form-group">
            <label>Date d'embauche</label>
            <div className="input-icon">
              <Calendar size={18} />
              <input
                type="date"
                name="dateEmbauche"
                value={formData.dateEmbauche}
                onChange={handleChange}
              />
            </div>
          </div>

          {/* Utilisateur actif */}
          <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: '12px', paddingTop: '8px' }}>
            <label style={{ marginBottom: 0, display: 'flex', alignItems: 'center', cursor: 'pointer' }}>
              <input
                type="checkbox"
                name="actif"
                checked={formData.actif}
                onChange={handleChange}
                style={{ width: '20px', height: '20px', marginRight: '10px', cursor: 'pointer' }}
              />
              <span style={{ fontSize: '14px', fontWeight: '500', color: '#374151' }}>
                Utilisateur actif
              </span>
            </label>
          </div>

          {/* Mot de passe - uniquement pour la création */}
          {!isEdit && (
            <>
              <div className="form-group">
                <label>Mot de passe <span className="required">*</span></label>
                <div className="input-icon" style={{ position: 'relative' }}>
                  <Key size={18} style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: '#9ca3af', zIndex: 1 }} />
                  <input
                    type={showPassword ? 'text' : 'password'}
                    name="password"
                    value={formData.password}
                    onChange={handleChange}
                    placeholder="Min 6 caractères"
                    className={errors.password ? 'error' : ''}
                    style={{ paddingLeft: '40px', paddingRight: '40px' }}
                  />
                  <button
                    type="button"
                    className="password-toggle"
                    onClick={() => setShowPassword(!showPassword)}
                    style={{
                      position: 'absolute',
                      right: '12px',
                      top: '50%',
                      transform: 'translateY(-50%)',
                      background: 'none',
                      border: 'none',
                      cursor: 'pointer',
                      color: '#9ca3af',
                      padding: '4px',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      zIndex: 1
                    }}
                  >
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
                {errors.password && <span className="error-message"><AlertCircle size={12} /> {errors.password}</span>}
              </div>

              <div className="form-group">
                <label>Confirmer le mot de passe <span className="required">*</span></label>
                <div className="input-icon" style={{ position: 'relative' }}>
                  <Key size={18} style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: '#9ca3af', zIndex: 1 }} />
                  <input
                    type={showPassword ? 'text' : 'password'}
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    placeholder="Confirmer le mot de passe"
                    className={errors.confirmPassword ? 'error' : ''}
                    style={{ paddingLeft: '40px' }}
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
          <button type="submit" className="btn-primary" disabled={loading}>
            <Save size={18} />
            {loading ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default UtilisateurForm;
