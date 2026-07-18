import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Building, MapPin, Phone, Loader, AlertCircle } from 'lucide-react';
import { etablissementService } from '../../services/etablissementService';
import '../Prospects/Prospects.css';

const EtablissementDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [etab, setEtab] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchEtab = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await etablissementService.getById(id);
        setEtab(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error(' Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchEtab();
  }, [id]);

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de l'établissement...</p></div></div>;
  }
  if (error || !etab) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Établissement introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/etablissements')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de l'établissement</h1>
          <p className="page-description">Consultez les informations complètes de l'établissement.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/etablissements')}><ArrowLeft size={18} /> Retour</button>
          <button className="btn-primary" onClick={() => navigate(`/etablissements/edit/${id}`)}><Edit size={18} /> Modifier</button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Building size={24} />
            </div>
            <div>
              <h2>{etab.nom}</h2>
              <span className="badge badge-info">{etab.type}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><MapPin size={18} /><span>Adresse: {etab.adresse}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Ville: {etab.ville}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Région: {etab.region}</span></div>
            <div className="info-row"><Phone size={18} /><span>Téléphone: {etab.telephone}</span></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EtablissementDetail;