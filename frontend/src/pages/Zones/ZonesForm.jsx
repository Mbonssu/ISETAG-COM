import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, MapPin, Building, Globe, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { zoneService } from '../../services/zoneService';
import '../Prospects/Prospects.css';

//  CORRIGÉ : ce formulaire n'appelait jamais l'API (juste un toast fake).
// Champs alignés sur le vrai schéma ZoneRequest : idZone, libele,
// description, quartier, ville, pays, region, lieuDepart, lieuArrivee.
// (le champ "code" n'existe pas côté backend, remplacé par "libele" ;
// "lieuFin" renommé "lieuArrivee")

const ZonesForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const [formData, setFormData] = useState({
    libele: '',
    quartier: '',
    ville: 'Yaoundé',
    region: 'Centre',
    pays: 'Cameroun',
    lieuDepart: '',
    lieuArrivee: '',
    description: '',
  });

  const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Maroua', 'Bertoua'];
  const regions = ['Centre', 'Littoral', 'Ouest', 'Nord', 'Extrême-Nord', 'Sud', 'Est', 'Adamawa'];

  useEffect(() => {
    if (isEdit && id) {
      zoneService.getById(id)
        .then((raw) => {
          ('📥 Zone chargée:', raw);
          //  Le backend renvoie parfois un tableau [{...}] au lieu d'un
          // objet direct pour getById (bug backend). On gère les deux cas.
          const data = Array.isArray(raw) ? raw[0] : raw;
          setFormData({
            libele: data?.libele || '',
            quartier: data?.quartier || '',
            ville: data?.ville || 'Yaoundé',
            region: data?.region || 'Centre',
            pays: data?.pays || 'Cameroun',
            lieuDepart: data?.lieuDepart || '',
            lieuArrivee: data?.lieuArrivee || '',
            description: data?.description || '',
          });
        })
        .catch((err) => {
          console.error(' Erreur chargement zone:', err);
          addToast(`Erreur: ${err.message}`, 'error');
        })
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.libele.trim()) newErrors.libele = 'Le nom de la zone est requis';
    if (!formData.quartier.trim()) newErrors.quartier = 'Le quartier est requis';
    if (!formData.ville) newErrors.ville = 'La ville est requise';
    if (!formData.region) newErrors.region = 'La région est requise';
    if (!formData.pays.trim()) newErrors.pays = 'Le pays est requis';
    if (!formData.lieuDepart.trim()) newErrors.lieuDepart = 'Le lieu de départ est requis';
    if (!formData.lieuArrivee.trim()) newErrors.lieuArrivee = "Le lieu d'arrivée est requis";
    if (!formData.description.trim()) newErrors.description = 'La description est requise';

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) {
      setErrors({ ...errors, [e.target.name]: '' });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setSaving(true);
    try {
      if (isEdit) {
        await zoneService.update(id, { idZone: id, ...formData });
        addToast('Zone modifiée avec succès', 'success');
      } else {
        await zoneService.create(formData);
        addToast('Zone créée avec succès', 'success');
      }
      setTimeout(() => navigate('/zones'), 1500);
    } catch (err) {
      console.error(' Erreur:', err);
      addToast(err.message || "Erreur lors de l'enregistrement", 'error');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement de la zone...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la zone' : 'Nouvelle zone'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la zone.' : 'Ajoutez une nouvelle zone géographique.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/zones')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group full-width">
            <label>Nom de la zone <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="libele" value={formData.libele} onChange={handleChange} placeholder="Ex: Zone Biyem-Assi" className={errors.libele ? 'error' : ''} disabled={saving} />
            </div>
            {errors.libele && <span className="error-message"><AlertCircle size={12} /> {errors.libele}</span>}
          </div>

          <div className="form-group">
            <label>Quartier <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <input type="text" name="quartier" value={formData.quartier} onChange={handleChange} className={errors.quartier ? 'error' : ''} disabled={saving} />
            </div>
            {errors.quartier && <span className="error-message"><AlertCircle size={12} /> {errors.quartier}</span>}
          </div>

          <div className="form-group">
            <label>Ville <span className="required">*</span></label>
            <div className="input-icon">
              <Building size={18} />
              <select name="ville" value={formData.ville} onChange={handleChange} className={errors.ville ? 'error' : ''} disabled={saving}>
                {villes.map(v => <option key={v} value={v}>{v}</option>)}
              </select>
            </div>
            {errors.ville && <span className="error-message"><AlertCircle size={12} /> {errors.ville}</span>}
          </div>

          <div className="form-group">
            <label>Région <span className="required">*</span></label>
            <div className="input-icon">
              <Globe size={18} />
              <select name="region" value={formData.region} onChange={handleChange} className={errors.region ? 'error' : ''} disabled={saving}>
                {regions.map(r => <option key={r} value={r}>{r}</option>)}
              </select>
            </div>
            {errors.region && <span className="error-message"><AlertCircle size={12} /> {errors.region}</span>}
          </div>

          <div className="form-group">
            <label>Pays <span className="required">*</span></label>
            <div className="input-icon">
              <Globe size={18} />
              <input type="text" name="pays" value={formData.pays} onChange={handleChange} className={errors.pays ? 'error' : ''} disabled={saving} />
            </div>
            {errors.pays && <span className="error-message"><AlertCircle size={12} /> {errors.pays}</span>}
          </div>

          <div className="form-group">
            <label>Lieu de départ <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="lieuDepart" value={formData.lieuDepart} onChange={handleChange} placeholder="Point de départ" className={errors.lieuDepart ? 'error' : ''} disabled={saving} />
            </div>
            {errors.lieuDepart && <span className="error-message"><AlertCircle size={12} /> {errors.lieuDepart}</span>}
          </div>

          <div className="form-group">
            <label>Lieu d'arrivée <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <input type="text" name="lieuArrivee" value={formData.lieuArrivee} onChange={handleChange} placeholder="Point d'arrivée" className={errors.lieuArrivee ? 'error' : ''} disabled={saving} />
            </div>
            {errors.lieuArrivee && <span className="error-message"><AlertCircle size={12} /> {errors.lieuArrivee}</span>}
          </div>

          <div className="form-group full-width">
            <label>Description <span className="required">*</span></label>
            <textarea name="description" rows="3" value={formData.description} onChange={handleChange} placeholder="Description de la zone..." className={errors.description ? 'error' : ''} disabled={saving} />
            {errors.description && <span className="error-message"><AlertCircle size={12} /> {errors.description}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/zones')} disabled={saving}>Annuler</button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer la zone')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default ZonesForm;