import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, MapPin, User, Target, Clock, CheckCircle, XCircle, FileText, Users, TrendingUp } from 'lucide-react';
import '../Prospects/Prospects.css';

const SortiesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const sortie = {
    id: id,
    typeSortie: 'Prospection',
    dateSortie: '25 Mai 2025',
    statut: 'Effectuée',
    objectif: '50 prospects',
    commentaire: 'Visite des lycées de Yaoundé. Très bonne réception des prospects.',
    agent: 'Jean M.',
    zone: 'Yaoundé Centre',
    createdAt: '20 Mai 2025',
    participants: [
      { id: 1, nom: 'Jean M.', role: 'Agent principal' },
      { id: 2, nom: 'Marie L.', role: 'Agent secondaire' }
    ],
    resultats: {
      prospectsContactes: 52,
      prospectsQualifies: 28,
      rendezvousPris: 12,
      tauxConversion: 54
    },
    historique: [
      { date: '20 Mai 2025', action: 'Sortie planifiée', description: 'Création de la sortie' },
      { date: '25 Mai 2025', action: 'Sortie effectuée', description: 'Sortie réalisée avec succès' }
    ]
  };

  const getStatusBadge = (status) => {
    const classes = {
      'Planifiée': 'badge-info',
      'En cours': 'badge-warning',
      'Effectuée': 'badge-success',
      'Annulée': 'badge-danger',
      'Reportée': 'badge-secondary'
    };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la sortie</h1>
          <p className="page-description">Consultez les informations complètes de la sortie terrain.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/sorties')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/sorties/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Target size={24} />
            </div>
            <div>
              <h2>Sortie {sortie.typeSortie}</h2>
              {getStatusBadge(sortie.statut)}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Calendar size={18} /><span>Date: {sortie.dateSortie}</span></div>
            <div className="info-row"><User size={18} /><span>Agent: {sortie.agent}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Zone: {sortie.zone}</span></div>
            <div className="info-row"><Target size={18} /><span>Objectif: {sortie.objectif}</span></div>
            <div className="info-row"><Clock size={18} /><span>Créée le: {sortie.createdAt}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Commentaire</h3>
          <p className="detail-notes">{sortie.commentaire}</p>
        </div>

        <div className="detail-card">
          <h3>Participants</h3>
          <ul className="participants-list">
            {sortie.participants.map((p, idx) => (
              <li key={idx}><User size={14} /> {p.nom} - {p.role}</li>
            ))}
          </ul>
        </div>

        <div className="detail-card">
          <h3>Résultats</h3>
          <div className="performance-stats">
            <div className="perf-item">
              <Users size={20} />
              <div>
                <div className="perf-value">{sortie.resultats.prospectsContactes}</div>
                <div className="perf-label">Prospects contactés</div>
              </div>
            </div>
            <div className="perf-item">
              <Target size={20} />
              <div>
                <div className="perf-value">{sortie.resultats.prospectsQualifies}</div>
                <div className="perf-label">Prospects qualifiés</div>
              </div>
            </div>
            <div className="perf-item">
              <Calendar size={20} />
              <div>
                <div className="perf-value">{sortie.resultats.rendezvousPris}</div>
                <div className="perf-label">Rendez-vous pris</div>
              </div>
            </div>
            <div className="perf-item">
              <TrendingUp size={20} />
              <div>
                <div className="perf-value">{sortie.resultats.tauxConversion}%</div>
                <div className="perf-label">Taux de conversion</div>
              </div>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Historique</h3>
          <div className="activities-timeline">
            {sortie.historique.map((item, idx) => (
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

export default SortiesDetail;
