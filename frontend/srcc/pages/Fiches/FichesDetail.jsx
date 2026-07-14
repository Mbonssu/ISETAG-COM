import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, User, Star, FileText, TrendingUp } from 'lucide-react';
import '../Prospects/Prospects.css';

const FichesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const fiche = {
    id: id,
    prospect: 'Marie L.',
    source: 'Lycée',
    dateCollecte: '25 Mai 2025',
    scoreInteret: 85,
    commentaire: 'Prospect très intéressé par la formation en Génie Logiciel. A visité le site web et a demandé des informations complémentaires.',
    campagne: 'Campagne Mai 2025',
    agent: 'Jean M.',
    createdAt: '25 Mai 2025',
    recommandations: [
      'À contacter dans les 3 jours',
      'Envoyer documentation complète',
      'Programmer une visite de l\'établissement'
    ]
  };

  const getScoreColor = (score) => {
    if (score >= 80) return '#10b981';
    if (score >= 60) return '#f59e0b';
    return '#ef4444';
  };

  const getScoreLabel = (score) => {
    if (score >= 80) return 'Très intéressé';
    if (score >= 60) return 'Intéressé';
    if (score >= 40) return 'Moyennement intéressé';
    return 'Peu intéressé';
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la fiche</h1>
          <p className="page-description">Consultez les informations complètes de la fiche de collecte.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/fiches')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/fiches/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <FileText size={24} />
            </div>
            <div>
              <h2>Fiche de {fiche.prospect}</h2>
              <span className="badge badge-info">{fiche.source}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><User size={18} /><span>Prospect: <strong>{fiche.prospect}</strong></span></div>
            <div className="info-row"><Calendar size={18} /><span>Date collecte: {fiche.dateCollecte}</span></div>
            <div className="info-row"><TrendingUp size={18} /><span>Campagne: {fiche.campagne}</span></div>
            <div className="info-row"><User size={18} /><span>Agent: {fiche.agent}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Score d'intérêt</h3>
          <div className="score-detail" style={{ textAlign: 'center', padding: '20px' }}>
            <div className="score-circle" style={{ 
              width: '120px', 
              height: '120px', 
              borderRadius: '50%', 
              background: `conic-gradient(${getScoreColor(fiche.scoreInteret)} 0deg ${fiche.scoreInteret * 3.6}deg, #e5e7eb ${fiche.scoreInteret * 3.6}deg 360deg)`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              margin: '0 auto'
            }}>
              <div style={{ 
                width: '100px', 
                height: '100px', 
                borderRadius: '50%', 
                background: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexDirection: 'column'
              }}>
                <Star size={24} color={getScoreColor(fiche.scoreInteret)} fill={getScoreColor(fiche.scoreInteret)} />
                <span style={{ fontSize: '24px', fontWeight: 'bold', color: getScoreColor(fiche.scoreInteret) }}>{fiche.scoreInteret}%</span>
              </div>
            </div>
            <p style={{ textAlign: 'center', marginTop: '10px', fontWeight: 'bold', color: getScoreColor(fiche.scoreInteret) }}>
              {getScoreLabel(fiche.scoreInteret)}
            </p>
          </div>
        </div>

        <div className="detail-card">
          <h3>Commentaire</h3>
          <p className="detail-notes" style={{ background: 'rgba(0,0,0,0.03)', padding: '12px', borderRadius: '10px' }}>
            {fiche.commentaire}
          </p>
        </div>

        <div className="detail-card">
          <h3>Recommandations</h3>
          <ul style={{ margin: 0, paddingLeft: '20px' }}>
            {fiche.recommandations.map((rec, idx) => (
              <li key={idx} style={{ marginBottom: '8px', color: '#4b5563' }}>{rec}</li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default FichesDetail;
