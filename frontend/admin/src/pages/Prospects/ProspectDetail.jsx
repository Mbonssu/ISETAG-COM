import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Mail, Phone, Calendar, MapPin, User, Briefcase } from 'lucide-react';
import './Prospects.css';

const ProspectDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  // Données mockées
  const prospect = {
    id: id,
    name: 'Marie L.',
    email: 'marie.l@email.com',
    phone: '691234567',
    source: 'Lycée',
    filiere: 'Génie Logiciel',
    agent: 'Jean M.',
    date: '25 Mai 2025',
    status: 'À relancer',
    notes: 'Prospect très intéressé par la formation. À rappeler pour confirmer l\'inscription.',
    etablissement: 'Lycée de Biyem-Assi',
    niveau: 'Terminale C',
    activites: [
      { date: '25 Mai 2025', action: 'Premier contact', agent: 'Jean M.', description: 'Appel initial, prospect intéressé' },
      { date: '26 Mai 2025', action: 'Relance', agent: 'Jean M.', description: 'Email envoyé avec documentation' }
    ]
  };

  const getStatusBadge = (status) => {
    const classes = {
      'À relancer': 'badge-warning',
      'Nouveau': 'badge-success',
      'Contacté': 'badge-info',
      'Qualifié': 'badge-primary',
      'Converti': 'badge-dark'
    };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail du prospect</h1>
          <p className="page-description">Consultez toutes les informations concernant ce prospect.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/prospects')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/prospects/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar">{prospect.name.charAt(0)}</div>
            <div>
              <h2>{prospect.name}</h2>
              {getStatusBadge(prospect.status)}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row">
              <Mail size={18} />
              <span>{prospect.email}</span>
            </div>
            <div className="info-row">
              <Phone size={18} />
              <span>{prospect.phone}</span>
            </div>
            <div className="info-row">
              <Calendar size={18} />
              <span>Ajouté le {prospect.date}</span>
            </div>
            <div className="info-row">
              <MapPin size={18} />
              <span>{prospect.etablissement}</span>
            </div>
            <div className="info-row">
              <User size={18} />
              <span>Agent: {prospect.agent}</span>
            </div>
            <div className="info-row">
              <Briefcase size={18} />
              <span>{prospect.filiere} - {prospect.niveau}</span>
            </div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Notes</h3>
          <p className="detail-notes">{prospect.notes}</p>
        </div>

        <div className="detail-card full-width">
          <h3>Historique des activités</h3>
          <div className="activities-timeline">
            {prospect.activites.map((act, idx) => (
              <div key={idx} className="activity-timeline-item">
                <div className="timeline-dot"></div>
                <div className="timeline-content">
                  <div className="timeline-header">
                    <strong>{act.action}</strong>
                    <span>{act.date}</span>
                  </div>
                  <div className="timeline-agent">Agent: {act.agent}</div>
                  <p>{act.description}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProspectDetail;
