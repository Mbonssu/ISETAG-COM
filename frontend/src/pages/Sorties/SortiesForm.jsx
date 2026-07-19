import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, Target, MapPin, Building, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { sortieService } from '../../services/sortieService';
import { zoneService } from '../../services/zoneService';
import { campagneService } from '../../services/campagneService';
import { etablissementService } from '../../services/etablissementService';
import '../Prospects/Prospects.css';

//  CORRIGÉ : le backend (schéma SortieRequest) n'a PAS de champ "agent"
// (l'agent est lié via la ressource Participation, séparée). "zone" en
// texte libre remplacé par idZone (vraie relation vers Zone). idCampagne
// ajouté (requis, absent du mock). idEtablissement ajouté (optionnel).

const typesSortie = ['Prospection', 'Suivi', 'Formation', 'Réunion', 'Autre'];
const statutsSortie = ['Planifiée', 'En cours', 'Effectuée', 'Annulée', 'Reportée'];

const SortiesForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [zones, setZones] = useState([]);
  const [campagnes, setCampagnes] = useState([]);
  const [etablissements, setEtablissements] = useState([]);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  const [formData, setFormData] = useState({
    idZone: '',
    idCampagne: '',
    idEtablissement: '',
    dateSortie: '',
    typeSortie: 'Prospection',
    statut: 'Planifiée',
    objectif: '',
    commentaire: '',
  });

  useEffect(() => {
    const fetchOptions = async () => {
      try {
        const [zonesData, campagnesData, etabsData] = await Promise.all([
          zoneService.getAll(),
          campagneService.getAll(),
          etablissementService.getAll(),
        ]);
        setZones(Array.isArray(zonesData) ? zonesData : (zonesData?.results ?? []));
        setCampagnes(Array.isArray(campagnesData) ? campagnesData : (campagnesData?.results ?? []));
        setEtablissements(Array.isArray(etabsData) ? etabsData : (etabsData?.results ?? []));
      } catch (err) {
        console.error(' Erreur chargement options:', err);
        addToast('Erreur lors du chargement des zones/campagnes', 'error');
      }
    };
    fetchOptions();
  }, []);

  useEffect(() => {
    if (isEdit && id) {
      sortieService.getById(id)
        .then((raw) => {
          ('📥 Sortie chargée:', raw);
          //  Comme pour Zone, le backend peut renvoyer un tableau [{...}]
          // au lieu d'un objet direct sur certains endpoints "détail".
          const data = Array.isArray(raw) ? raw[0] : raw;
          setFormData({
            idZone: data?.idZone || '',
            idCampagne: data?.idCampagne || '',
            idEtablissement: data?.idEtablissement || '',
            dateSortie: data?.dateSortie ? data.dateSortie.slice(0, 16) : '',
            typeSortie: data?.typeSortie || 'Prospection',
            statut: data?.statut || 'Planifiée',
            objectif: data?.objectif || '',
            commentaire: data?.commentaire || '',
          });
        })
        .catch((err) => {
          console.error(' Erreur chargement sortie:', err);
          addToast(`Erreur: ${err.message}`, 'error');
        })
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.idZone) newErrors.idZone = 'Veuillez sélectionner une zone';
    if (!formData.idCampagne) newErrors.idCampagne = 'Veuillez sélectionner une campagne';
    if (!formData.dateSortie) newErrors.dateSortie = 'La date est requise';
    if (!formData.typeSortie) newErrors.typeSortie = 'Le type est requis';
    if (!formData.statut) newErrors.statut = 'Le statut est requis';
    if (!formData.objectif.trim()) newErrors.objectif = "L'objectif est requis";
    if (!formData.commentaire.trim()) newErrors.commentaire = 'Le commentaire est requis';
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) setErrors({ ...errors, [e.target.name]: '' });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }
    setSaving(true);
    try {
      const payload = {
        idZone: formData.idZone,
        idCampagne: formData.idCampagne,
        idEtablissement: formData.idEtablissement || null,
        dateSortie: formData.dateSortie.length === 16 ? `${formData.dateSortie}:00` : formData.dateSortie,
        typeSortie: formData.typeSortie,
        statut: formData.statut,
        objectif: formData.objectif,
        commentaire: formData.commentaire,
      };
      ('📤 Envoi des données:', payload);

      if (isEdit) {
        await sortieService.update(id, { idSortie: id, ...payload });
        addToast('Sortie modifiée avec succès', 'success');
      } else {
        await sortieService.create(payload);
        addToast('Sortie créée avec succès', 'success');
      }
      setTimeout(() => navigate('/sorties'), 1500);
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
        <div className="loading-container"><Loader size={48} className="spin" /><p>Chargement...</p></div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier la sortie' : 'Nouvelle sortie'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations de la sortie.' : 'Planifiez une nouvelle sortie terrain.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/sorties')}>
          <ArrowLeft size={18} /> Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          <div className="form-group">
            <label>Zone <span className="required">*</span></label>
            <div className="input-icon">
              <MapPin size={18} />
              <select name="idZone" value={formData.idZone} onChange={handleChange} className={errors.idZone ? 'error' : ''} disabled={saving}>
                <option value="">Sélectionner une zone</option>
                {zones.map(z => <option key={z.idZone} value={z.idZone}>{z.libele}</option>)}
              </select>
            </div>
            {errors.idZone && <span className="error-message"><AlertCircle size={12} /> {errors.idZone}</span>}
          </div>

          <div className="form-group">
            <label>Campagne <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <select name="idCampagne" value={formData.idCampagne} onChange={handleChange} className={errors.idCampagne ? 'error' : ''} disabled={saving}>
                <option value="">Sélectionner une campagne</option>
                {campagnes.map(c => <option key={c.idCampagne} value={c.idCampagne}>{c.libele}</option>)}
              </select>
            </div>
            {errors.idCampagne && <span className="error-message"><AlertCircle size={12} /> {errors.idCampagne}</span>}
          </div>

          <div className="form-group">
            <label>Établissement (optionnel)</label>
            <div className="input-icon">
              <Building size={18} />
              <select name="idEtablissement" value={formData.idEtablissement} onChange={handleChange} disabled={saving}>
                <option value="">Aucun</option>
                {etablissements.map(e => <option key={e.idEtablissement} value={e.idEtablissement}>{e.nom}</option>)}
              </select>
            </div>
          </div>

          <div className="form-group">
            <label>Date et heure de sortie <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input type="datetime-local" name="dateSortie" value={formData.dateSortie} onChange={handleChange} className={errors.dateSortie ? 'error' : ''} disabled={saving} />
            </div>
            {errors.dateSortie && <span className="error-message"><AlertCircle size={12} /> {errors.dateSortie}</span>}
          </div>

          <div className="form-group">
            <label>Type de sortie <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <select name="typeSortie" value={formData.typeSortie} onChange={handleChange} className={errors.typeSortie ? 'error' : ''} disabled={saving}>
                {typesSortie.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            {errors.typeSortie && <span className="error-message"><AlertCircle size={12} /> {errors.typeSortie}</span>}
          </div>

          <div className="form-group">
            <label>Statut <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <select name="statut" value={formData.statut} onChange={handleChange} className={errors.statut ? 'error' : ''} disabled={saving}>
                {statutsSortie.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            {errors.statut && <span className="error-message"><AlertCircle size={12} /> {errors.statut}</span>}
          </div>

          <div className="form-group full-width">
            <label>Objectif <span className="required">*</span></label>
            <div className="input-icon">
              <Target size={18} />
              <input type="text" name="objectif" value={formData.objectif} onChange={handleChange} placeholder="Ex: 50 prospects" className={errors.objectif ? 'error' : ''} disabled={saving} />
            </div>
            {errors.objectif && <span className="error-message"><AlertCircle size={12} /> {errors.objectif}</span>}
          </div>

          <div className="form-group full-width">
            <label>Commentaire <span className="required">*</span></label>
            <textarea name="commentaire" rows="4" value={formData.commentaire} onChange={handleChange} placeholder="Informations complémentaires..." className={errors.commentaire ? 'error' : ''} disabled={saving} />
            {errors.commentaire && <span className="error-message"><AlertCircle size={12} /> {errors.commentaire}</span>}
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/sorties')} disabled={saving}>Annuler</button>
          <button type="submit" className="btn-primary" disabled={saving}>
            <Save size={18} />
            {saving ? 'Enregistrement…' : (isEdit ? 'Mettre à jour' : 'Créer la sortie')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default SortiesForm;