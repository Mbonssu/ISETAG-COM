import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Users, TrendingUp, Calendar, Globe, CheckCircle, XCircle, BarChart3 } from 'lucide-react';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const SourceDetail = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const { id } = useParams();

  const source = {
    id: id,
    name: 'Terrain',
    description: 'Prospects rencontrés lors des sorties terrain, visites d\'établissements et événements locaux.',
    prospects: 562,
    pourcentage: 45,
    couleur: '#FF6B6B',
    evolution: '+12%',
    actif: true,
    createdAt: '01 Janvier 2024',
    campagnesAssociees: ['Campagne Mai 2025', 'Campagne Lycées', 'Campagne Terrain Q1'],
    performance: {
      tauxConversion: 32,
      coutParProspect: '250 FCFA',
      meilleurMois: 'Mars 2025'
    }
  };

  const getStatusBadge = () => {
    return <span className={`badge ${source.actif ? 'badge-success' : 'badge-secondary'}`}>{source.actif ? 'Actif' : 'Inactif'}</span>;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la source</h1>
          <p className="page-description">Consultez les informations de la source de prospects.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/sources')}>
            <ArrowLeft size={18} /> Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/sources/edit/${id}`)}>
            <Edit size={18} /> Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: source.couleur, color: 'white' }}>
              <Globe size={24} />
            </div>
            <div>
              <h2>{source.name}</h2>
              {getStatusBadge()}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Users size={18} /><span>Prospects: <strong>{source.prospects}</strong> ({source.pourcentage}% du total)</span></div>
            <div className="info-row"><TrendingUp size={18} /><span>Évolution: <strong style={{ color: '#10b981' }}>{source.evolution}</strong></span></div>
            <div className="info-row"><Calendar size={18} /><span>Créée le: {source.createdAt}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Description</h3>
          <p className="detail-notes">{source.description}</p>
        </div>

        <div className="detail-card">
          <h3>Performance</h3>
          <div className="performance-stats" style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '16px', marginTop: '16px' }}>
            <div className="perf-item" style={{ textAlign: 'center', padding: '12px', background: 'rgba(0,0,0,0.03)', borderRadius: '10px' }}>
              <BarChart3 size={20} color="#1a5c2a" style={{ marginBottom: '8px' }} />
              <div style={{ fontSize: '20px', fontWeight: 'bold' }}>{source.performance.tauxConversion}%</div>
              <div style={{ fontSize: '11px', color: '#666' }}>Taux conversion</div>
            </div>
            <div className="perf-item" style={{ textAlign: 'center', padding: '12px', background: 'rgba(0,0,0,0.03)', borderRadius: '10px' }}>
              <TrendingUp size={20} color="#1a5c2a" style={{ marginBottom: '8px' }} />
              <div style={{ fontSize: '20px', fontWeight: 'bold' }}>{source.performance.coutParProspect}</div>
              <div style={{ fontSize: '11px', color: '#666' }}>Coût par prospect</div>
            </div>
            <div className="perf-item" style={{ textAlign: 'center', padding: '12px', background: 'rgba(0,0,0,0.03)', borderRadius: '10px' }}>
              <Calendar size={20} color="#1a5c2a" style={{ marginBottom: '8px' }} />
              <div style={{ fontSize: '20px', fontWeight: 'bold' }}>{source.performance.meilleurMois}</div>
              <div style={{ fontSize: '11px', color: '#666' }}>Meilleur mois</div>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Campagnes associées</h3>
          <div className="campagnes-list" style={{ display: 'flex', flexWrap: 'wrap', gap: '10px', marginTop: '10px' }}>
            {source.campagnesAssociees.map((campagne, idx) => (
              <span key={idx} style={{ padding: '6px 12px', background: 'rgba(26, 92, 42, 0.1)', borderRadius: '20px', fontSize: '13px' }}>
                📊 {campagne}
              </span>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SourceDetail;
