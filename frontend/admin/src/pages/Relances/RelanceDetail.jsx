import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Bell, Calendar, Clock, User, Loader, AlertCircle } from 'lucide-react';
import { relanceService } from '../../services/relanceService';
import { prospectService } from '../../services/prospectService';
import { useTranslation } from '../../hooks/useTranslation';
import { getErrorMessage } from '../../utils/errorMessages';
import '../Prospects/Prospects.css';

//  CORRIGÉ : affichait l'ID brut du prospect en premier, avec le nom
// seulement entre parenthèses en secours. Affiche maintenant le NOM en
// priorité (via prospect_details, renvoyé automatiquement par le
// backend), avec un appel de secours à prospectService si ce champ
// imbriqué est absent — jamais l'ID nu affiché à l'utilisateur sauf
// échec total de résolution.

const RelanceDetail = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const { id } = useParams();
  const [relance, setRelance] = useState(null);
  const [nomProspectSecours, setNomProspectSecours] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'error') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  useEffect(() => {
    if (!id) return;
    relanceService.getById(id)
      .then(async (raw) => {
        const data = Array.isArray(raw) ? raw[0] : raw;
        setRelance(data);

        // Secours si le backend n'a pas renvoyé prospect_details imbriqué
        if (!data?.prospect_details?.nomComplet && data?.idProspect) {
          try {
            const prospect = await prospectService.getById(data.idProspect);
            const p = Array.isArray(prospect) ? prospect[0] : prospect;
            setNomProspectSecours(p?.nomComplet || '');
          } catch {
            // pas grave, on affichera l'ID en tout dernier recours
          }
        }
      })
      .catch((err) => {
        const msg = getErrorMessage(err, t);
        setError(msg);
        addToast(msg, 'error');
      })
      .finally(() => setLoading(false));
  }, [id, t]);

  const getNomProspect = () => relance?.prospect_details?.nomComplet || nomProspectSecours || relance?.idProspect;

  const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' });
  };

  const formatTime = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
  };

  if (loading) {
    return (
      <div className="page-container">
        <div className="text-center py-5">
          <Loader size={48} className="spinner" />
          <p className="mt-3">Chargement de la relance...</p>
        </div>
      </div>
    );
  }

  if (error || !relance) {
    return (
      <div className="page-container">
        <div className="alert alert-danger">
          <AlertCircle size={24} />
          <div>
            <h4>{t('erreurChargement')}</h4>
            <p>{error || 'Relance non trouvée'}</p>
            <button className="btn-primary" onClick={() => navigate('/relances')}>
              {t('retourALaListe')}
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la relance</h1>
          <p className="page-description">
            {relance.sujet}
          </p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/relances')}>
            <ArrowLeft size={18} />
            {t('retour')}
          </button>
          <button className="btn-primary" onClick={() => navigate(`/relances/edit/${id}`)}>
            <Edit size={18} />
            {t('modifier')}
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Bell size={24} />
            </div>
            <div>
              <h2>{relance.sujet}</h2>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row">
              <User size={18} />
              <span>Prospect: <strong>{getNomProspect()}</strong></span>
            </div>
            <div className="info-row">
              <Calendar size={18} />
              <span>Date: {formatDate(relance.dateRelance)}</span>
            </div>
            <div className="info-row">
              <Clock size={18} />
              <span>Heure: {formatTime(relance.dateRelance)}</span>
            </div>
            <div className="info-row">
              <Bell size={18} />
              <span>Description: {relance.description || 'Aucune description'}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RelanceDetail;