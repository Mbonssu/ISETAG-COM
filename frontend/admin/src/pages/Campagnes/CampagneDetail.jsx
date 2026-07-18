import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, Target, Loader, AlertCircle } from 'lucide-react';
import { campagneService } from '../../services/campagneService';
import '../Prospects/Prospects.css';

const CampagneDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [campagne, setCampagne] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchCampagne = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await campagneService.getById(id);
        setCampagne(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error(' Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchCampagne();
  }, [id]);

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de la campagne...</p></div></div>;
  }
  if (error || !campagne) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Campagne introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/campagnes')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la campagne</h1>
          <p className="page-description">Consultez les informations de la campagne.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/campagnes')}><ArrowLeft size={18} /> Retour</button>
          <button className="btn-primary" onClick={() => navigate(`/campagnes/edit/${id}`)}><Edit size={18} /> Modifier</button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Calendar size={24} />
            </div>
            <div>
              <h2>{campagne.libele}</h2>
              <span className="type-badge">{campagne.type}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Calendar size={18} /><span>Du {new Date(campagne.dateDebut).toLocaleString('fr-FR')} au {new Date(campagne.dateFin).toLocaleString('fr-FR')}</span></div>
            <div className="info-row"><Target size={18} /><span>Objectif: {campagne.objectif}</span></div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Description</h3>
          <p className="detail-notes">{campagne.description}</p>
        </div>
      </div>
    </div>
  );
};

export default CampagneDetail;