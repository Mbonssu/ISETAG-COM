import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Bell, Calendar, Clock, User, Loader, AlertCircle } from 'lucide-react';
import { relanceService } from '../../services/relanceService';
import '../Prospects/Prospects.css';

const RelanceDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [relance, setRelance] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'error') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  useEffect(() => {
    if (id) {
      relanceService.getById(id)
        .then((data) => {
          console.log('📥 Relance:', data);
          setRelance(data);
        })
        .catch((err) => {
          console.error('❌ Erreur:', err);
          setError(err.message);
          addToast(`Erreur: ${err.message}`, 'error');
        })
        .finally(() => setLoading(false));
    }
  }, [id]);

  const formatDate = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    });
  };

  const formatTime = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleTimeString('fr-FR', {
      hour: '2-digit',
      minute: '2-digit'
    });
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
            <h4>Erreur</h4>
            <p>{error || 'Relance non trouvée'}</p>
            <button className="btn-primary" onClick={() => navigate('/relances')}>
              Retour à la liste
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
            <span className="ms-2 badge" style={{ backgroundColor: '#e9ecef', color: '#495057' }}>
              ID: {relance.idRelance}
            </span>
          </p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/relances')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/relances/edit/${id}`)}>
            <Edit size={18} />
            Modifier
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
              <span className="code-badge">{relance.idRelance}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row">
              <User size={18} />
              <span>Prospect: {relance.idProspect}
                {relance.prospect_details && relance.prospect_details.nomComplet && (
                  <span className="ms-2">({relance.prospect_details.nomComplet})</span>
                )}
              </span>
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