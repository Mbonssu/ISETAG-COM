import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Mail, Smartphone, Phone, Calendar, Users, Target, TrendingUp, Clock } from 'lucide-react';
import '../Prospects/Prospects.css';

const CampagneDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const campagne = {
    id: id,
    name: 'Campagne Mai 2025',
    type: 'Email',
    status: 'En cours',
    dateDebut: '01 Mai 2025',
    dateFin: '31 Mai 2025',
    agent: 'Jean M.',
    objectif: 500,
    prospects: 245,
    taux: 32,
    description: 'Campagne de sensibilisation sur les formations disponibles. Cible : lycéens et étudiants.',
    recentActions: [
      { date: '25 Mai 2025', action: 'Envoi email', prospects: 120, taux: 28 },
      { date: '20 Mai 2025', action: 'Envoi email', prospects: 125, taux: 35 },
      { date: '15 Mai 2025', action: 'Préparation', prospects: 0, taux: 0 }
    ]
  };

  const getTypeIcon = () => {
    switch(campagne.type) {
      case 'Email': return <Mail size={20} />;
      case 'SMS': return <Smartphone size={20} />;
      case 'Appel': return <Phone size={20} />;
      default: return <Mail size={20} />;
    }
  };

  const getStatusBadge = () => {
    const classes = {
      'En cours': 'badge-warning',
      'Terminée': 'badge-success',
      'Planifiée': 'badge-info'
    };
    return <span className={`badge ${classes[campagne.status] || 'badge-secondary'}`}>{campagne.status}</span>;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la campagne</h1>
          <p className="page-description">Consultez les informations et performances de la campagne.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/campagnes')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/campagnes/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              {getTypeIcon()}
            </div>
            <div>
              <h2>{campagne.name}</h2>
              {getStatusBadge()}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Calendar size={18} /><span>Du {campagne.dateDebut} au {campagne.dateFin}</span></div>
            <div className="info-row"><Users size={18} /><span>Responsable: {campagne.agent}</span></div>
            <div className="info-row"><Target size={18} /><span>Objectif: {campagne.objectif} prospects</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Performances</h3>
          <div className="performance-stats">
            <div className="perf-item">
              <Users size={20} />
              <div>
                <div className="perf-value">{campagne.prospects}</div>
                <div className="perf-label">Prospects touchés</div>
              </div>
            </div>
            <div className="perf-item">
              <TrendingUp size={20} />
              <div>
                <div className="perf-value">{campagne.taux}%</div>
                <div className="perf-label">Taux conversion</div>
              </div>
            </div>
            <div className="perf-item">
              <Clock size={20} />
              <div>
                <div className="perf-value">{Math.round(campagne.prospects / campagne.objectif * 100)}%</div>
                <div className="perf-label">Progression</div>
              </div>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Description</h3>
          <p className="detail-notes">{campagne.description}</p>
        </div>

        <div className="detail-card full-width">
          <h3>Historique des actions</h3>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Date</th><th>Action</th><th>Prospects touchés</th><th>Taux</th></tr>
              </thead>
              <tbody>
                {campagne.recentActions.map((action, idx) => (
                  <tr key={idx}>
                    <td>{action.date}</td>
                    <td>{action.action}</td>
                    <td>{action.prospects}</td>
                    <td><span className="rate-badge">{action.taux}%</span></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CampagneDetail;
