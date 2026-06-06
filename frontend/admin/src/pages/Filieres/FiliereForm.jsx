import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, GraduationCap, Plus, X } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const FiliereForm = () => {
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
    code: '',
    description: '',
    specialites: [''],
    actif: true
  });

  const validateForm = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Le nom de la filière est requis';
    if (!formData.code.trim()) newErrors.code = 'Le code est requis';
    if (formData.code.length > 5) newErrors.code = 'Le code doit faire moins de 5 caractères';
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) {
      setErrors({ ...errors, [e.target.name]: '' });
    }
  };

  const handleSpecialiteChange = (index, value) => {
    const newSpecialites = [...formData.specialites];
    newSpecialites[index] = value;
    setFormData({ ...formData, specialites: newSpecialites });
  };

  const addSpecialite = () => {
    setFormData({ ...formData, specialites: [...formData.specialites, ''] });
  };

  const removeSpecialite = (index) => {
    const newSpecialites = formData.specialites.filter((_, i) => i !== index);
    setFormData({ ...formData, specialites: newSpecialites });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (validateForm()) {
      addToast(isEdit ? 'Filière modifiée avec succès' : 'Filière créée avec succès', 'success');
      setTimeout(() => {
        navigate('/filieres');
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
          <h1 className="page-title-h1">{isEdit ? 'Modifier la filière' : 'Nouvelle filière'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la filière.' : 'Ajoutez une nouvelle filière de formation.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/filieres')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Nom de la filière <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Ex: Génie Logiciel"
                className={errors.name ? 'error' : ''}
              />
            </div>
            {errors.name && <span className="error-message"><AlertCircle size={12} /> {errors.name}</span>}
          </div>

          <div className="form-group">
            <label>Code <span className="required">*</span></label>
            <div className="input-icon">
              <GraduationCap size={18} />
              <input
                type="text"
                name="code"
                value={formData.code}
                onChange={handleChange}
                placeholder="Ex: GL"
                maxLength="5"
                className={errors.code ? 'error' : ''}
              />
            </div>
            {errors.code && <span className="error-message"><AlertCircle size={12} /> {errors.code}</span>}
          </div>

          <div className="form-group full-width">
            <label>Description</label>
            <textarea
              name="description"
              rows="3"
              value={formData.description}
              onChange={handleChange}
              placeholder="Description de la filière..."
            />
          </div>

          <div className="form-group full-width">
            <label>Spécialités</label>
            {formData.specialites.map((spec, index) => (
              <div key={index} className="specialite-input-group">
                <div className="input-icon" style={{ flex: 1 }}>
                  <GraduationCap size={18} />
                  <input
                    type="text"
                    value={spec}
                    onChange={(e) => handleSpecialiteChange(index, e.target.value)}
                    placeholder={`Spécialité ${index + 1}`}
                  />
                </div>
                {formData.specialites.length > 1 && (
                  <button type="button" className="remove-spec-btn" onClick={() => removeSpecialite(index)}>
                    <X size={16} />
                  </button>
                )}
              </div>
            ))}
            <button type="button" className="btn-add-spec" onClick={addSpecialite}>
              <Plus size={16} />
              Ajouter une spécialité
            </button>
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
          <button type="button" className="btn-outline" onClick={() => navigate('/filieres')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary">
            <Save size={18} />
            {isEdit ? 'Mettre à jour' : 'Créer la filière'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default FiliereForm;
