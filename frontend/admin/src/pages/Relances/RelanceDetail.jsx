import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Bell, Calendar, Clock, Flag, User, Mail, Phone, MessageSquare, CheckCircle } from 'lucide-react';
import '../Prospects/Prospects.css';

const RelanceDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const relance = {
    id: id,
    prospect: 'Marie L.',
    type: 'Email',
    date: '25 Mai 2025',
    heure: '10:00',
    priorite: 'Haute',
    status: 'En attente',
    agent: 'Jean M.',
    message: 'Bonjour Marie, nous vous remercions pour votre intérêt. Souhaitez-vous plus d\'informations sur nos formations ?',
    historique: [
      { date: '25 Mai 2025', action: 'Relance créée', agent: 'Jean M.' },
      { date: '24 Mai 2025', action: 'Premier contact', agent: 'Jean M.' }
    ]
  };

  const getTypeIcon = () => {
    switch(relance.type) {
      case 'Email': return <Mail size={20} />;
      case 'Appel': return <Phone size={20} />;
      default: return <MessageSquare size={20} />;
    }
  };

  const getPrioriteColor = () => {
    switch(relance.priorite) {
      case 'Haute': return '#ef4444';
      case 'Moyenne': return '#f59e0b';
      case 'Basse': return '#10b981';
      default: return '#6b7280';
    }
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la relance</h1>
          <p className="page-description">Consultez les informations de la relance.</p>
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
              {getTypeIcon()}
            </div>
            <div>
              <h2>Relance {relance.type}</h2>
              <span className={`badge ${relance.status === 'En attente' ? 'badge-warning' : relance.status === 'Programmée' ? 'badge-info' : 'badge-success'}`}>
                {relance.status}
              </span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Bell size={18} /><span>Prospect: {relance.prospect}</span></div>
            <div className="info-row"><Calendar size={18} /><span>Date: {relance.date}</span></div>
            <div className="info-row"><Clock size={18} /><span>Heure: {relance.heure}</span></div>
            <div className="info-row"><Flag size={18} /><span style={{ color: getPrioriteColor() }}>Priorité: {relance.priorite}</span></div>
            <div className="info-row"><User size={18} /><span>Agent: {relance.agent}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Message</h3>
          <p className="detail-notes" style={{ background: 'rgba(0,0,0,0.03)', padding: '12px', borderRadius: '10px' }}>
            {relance.message}
          </p>
        </div>

        <div className="detail-card full-width">
          <h3>Historique</h3>
          <div className="activities-timeline">
            {relance.historique.map((item, idx) => (
              <div key={idx} className="activity-timeline-item">
                <div className="timeline-dot"></div>
                <div className="timeline-content">
                  <div className="timeline-header">
                    <strong>{item.action}</strong>
                    <span>{item.date}</span>
                  </div>
                  <div className="timeline-agent">Agent: {item.agent}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default RelanceDetail;
