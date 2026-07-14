import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, Clock, MapPin, User } from 'lucide-react';
import '../Prospects/Prospects.css';

const RendezVousDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const rendezvous = {
    id: id,
    prospect: 'Marie L.',
    dateRv: '25 Mai 2025',
    heureRv: '10:00',
    lieuRv: 'Lycée de Biyem-Assi',
    statutRv: 'Confirmé',
    commentaire: 'Visite de l\'établissement pour présenter les formations. Le prospect a confirmé sa présence.',
    agent: 'Jean M.',
    createdAt: '20 Mai 2025',
    historique: [
      { date: '20 Mai 2025', action: 'Rendez-vous planifié', description: 'Contact initial' },
      { date: '22 Mai 2025', action: 'Confirmation', description: 'Prospect a confirmé' }
    ]
  };

  const getStatusBadge = (status) => {
    const classes = {
      'Planifié': 'badge-info',
      'Confirmé': 'badge-success',
      'Effectué': 'badge-primary',
      'Annulé': 'badge-danger',
      'Reporté': 'badge-warning'
    };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail du rendez-vous</h1>
          <p className="page-description">Consultez les informations complètes du rendez-vous.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/rendezvous')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/rendezvous/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Calendar size={24} />
            </div>
            <div>
              <h2>Rendez-vous avec {rendezvous.prospect}</h2>
              {getStatusBadge(rendezvous.statutRv)}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Calendar size={18} /><span>Date: <strong>{rendezvous.dateRv}</strong></span></div>
            <div className="info-row"><Clock size={18} /><span>Heure: {rendezvous.heureRv}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Lieu: {rendezvous.lieuRv}</span></div>
            <div className="info-row"><User size={18} /><span>Agent: {rendezvous.agent}</span></div>
            <div className="info-row"><Clock size={18} /><span>Créé le: {rendezvous.createdAt}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Commentaire</h3>
          <p className="detail-notes" style={{ background: 'rgba(0,0,0,0.03)', padding: '12px', borderRadius: '10px' }}>
            {rendezvous.commentaire}
          </p>
        </div>

        <div className="detail-card full-width">
          <h3>Historique</h3>
          <div className="activities-timeline">
            {rendezvous.historique.map((item, idx) => (
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

export default RendezVousDetail;
