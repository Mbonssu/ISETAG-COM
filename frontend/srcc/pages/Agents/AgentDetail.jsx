import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Mail, Phone, MapPin, Calendar, Users, Target, Award } from 'lucide-react';
import '../Prospects/Prospects.css';

const AgentDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const agent = {
    id: id,
    name: 'Jean M.',
    email: 'jean@isetag.com',
    phone: '691234567',
    zone: 'Yaoundé Centre',
    status: 'actif',
    joinedDate: '15 Janvier 2024',
    prospects: 45,
    converted: 18,
    taux: 40,
    recentProspects: [
      { name: 'Marie L.', date: '25 Mai 2025', status: 'Contacté' },
      { name: 'Junior B.', date: '24 Mai 2025', status: 'À relancer' },
      { name: 'Paul D.', date: '23 Mai 2025', status: 'Converti' }
    ]
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de l'agent</h1>
          <p className="page-description">Consultez les informations et performances de l'agent.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/agents')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/agents/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              {agent.name.charAt(0)}
            </div>
            <div>
              <h2>{agent.name}</h2>
              <span className={`badge ${agent.status === 'actif' ? 'badge-success' : 'badge-secondary'}`}>
                {agent.status === 'actif' ? 'Actif' : 'Inactif'}
              </span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Mail size={18} /><span>{agent.email}</span></div>
            <div className="info-row"><Phone size={18} /><span>{agent.phone}</span></div>
            <div className="info-row"><MapPin size={18} /><span>{agent.zone}</span></div>
            <div className="info-row"><Calendar size={18} /><span>Arrivé le {agent.joinedDate}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Performances</h3>
          <div className="performance-stats">
            <div className="perf-item">
              <Users size={20} />
              <div>
                <div className="perf-value">{agent.prospects}</div>
                <div className="perf-label">Prospects</div>
              </div>
            </div>
            <div className="perf-item">
              <Target size={20} />
              <div>
                <div className="perf-value">{agent.converted}</div>
                <div className="perf-label">Conversions</div>
              </div>
            </div>
            <div className="perf-item">
              <Award size={20} />
              <div>
                <div className="perf-value">{agent.taux}%</div>
                <div className="perf-label">Taux conversion</div>
              </div>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Derniers prospects ajoutés</h3>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Prospect</th><th>Date</th><th>Statut</th></tr></thead>
              <tbody>
                {agent.recentProspects.map((p, idx) => (
                  <tr key={idx}>
                    <td><strong>{p.name}</strong></td>
                    <td>{p.date}</td>
                    <td><span className={`badge ${p.status === 'Converti' ? 'badge-success' : p.status === 'Contacté' ? 'badge-info' : 'badge-warning'}`}>{p.status}</span></td>
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

export default AgentDetail;
