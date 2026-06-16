import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, Phone, Mail, MessageSquare, User, Clock, CheckCircle } from 'lucide-react';
import '../Prospects/Prospects.css';

const SuivisDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const suivi = {
    id: id,
    prospect: 'Marie L.',
    dateSuivi: '25 Mai 2025',
    typeSuivi: 'Appel',
    commentaire: 'Premier contact, prospect très intéressé par la formation en Génie Logiciel. A demandé plus d\'informations sur les modalités d\'inscription.',
    prochainAction: 'Rappeler dans 2 jours pour confirmer l\'inscription',
    agent: 'Jean M.',
    createdAt: '25 Mai 2025',
    historique: [
      { date: '25 Mai 2025', action: 'Appel initial', description: 'Prospect intéressé' },
      { date: '20 Mai 2025', action: 'Email envoyé', description: 'Documentation formation' }
    ]
  };

  const getTypeIcon = () => {
    switch(suivi.typeSuivi) {
      case 'Appel': return <Phone size={20} />;
      case 'Email': return <Mail size={20} />;
      case 'Visite': return <User size={20} />;
      default: return <MessageSquare size={20} />;
    }
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail du suivi</h1>
          <p className="page-description">Consultez les informations complètes du suivi.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/suivis')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/suivis/edit/${id}`)}>
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
              <h2>Suivi {suivi.typeSuivi}</h2>
              <span className="badge badge-info">{suivi.typeSuivi}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><User size={18} /><span>Prospect: <strong>{suivi.prospect}</strong></span></div>
            <div className="info-row"><Calendar size={18} /><span>Date: {suivi.dateSuivi}</span></div>
            <div className="info-row"><User size={18} /><span>Agent: {suivi.agent}</span></div>
            <div className="info-row"><Clock size={18} /><span>Créé le: {suivi.createdAt}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Commentaire</h3>
          <p className="detail-notes" style={{ background: 'rgba(0,0,0,0.03)', padding: '12px', borderRadius: '10px' }}>
            {suivi.commentaire}
          </p>
        </div>

        <div className="detail-card">
          <h3>Prochaine action</h3>
          <p className="detail-notes" style={{ background: 'rgba(245,200,66,0.1)', padding: '12px', borderRadius: '10px', border: '1px solid #f5c842' }}>
            <Clock size={16} /> {suivi.prochainAction}
          </p>
        </div>

        <div className="detail-card full-width">
          <h3>Historique des interactions</h3>
          <div className="activities-timeline">
            {suivi.historique.map((item, idx) => (
              <div key={idx} className="activity-timeline-item">
                <div className="timeline-dot"></div>
                <div className="timeline-content">
                  <div className="timeline-header">
                    <strong>{item.action}</strong>
                    <span>{item.date}</span>
                  </div>
                  <p>{item.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SuivisDetail;
