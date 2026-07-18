import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Tag, Loader, AlertCircle } from 'lucide-react';
import { sourceService } from '../../services/sourceService';
import '../Prospects/Prospects.css';

const SourceDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [source, setSource] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchSource = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await sourceService.getById(id);
        setSource(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error(' Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchSource();
  }, [id]);

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de la source...</p></div></div>;
  }
  if (error || !source) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Source introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/sources')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la source</h1>
          <p className="page-description">Consultez les informations de la source.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/sources')}><ArrowLeft size={18} /> Retour</button>
          <button className="btn-primary" onClick={() => navigate(`/sources/edit/${id}`)}><Edit size={18} /> Modifier</button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Tag size={24} />
            </div>
            <div>
              <h2>{source.libele}</h2>
              <span className="code-badge">{source.idSource}</span>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Description</h3>
          <p className="detail-notes">{source.description}</p>
        </div>
      </div>
    </div>
  );
};

export default SourceDetail;