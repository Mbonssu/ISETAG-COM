import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Building, MapPin, Phone, Mail, User, Users, Star, Calendar } from 'lucide-react';
import '../Prospects/Prospects.css';

const EtablissementDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const etablissement = {
    id: id,
    name: 'Lycée de Biyem-Assi',
    type: 'Lycée',
    ville: 'Yaoundé',
    adresse: 'Biyem-Assi, Yaoundé',
    telephone: '222 123 456',
    email: 'contact@lyceebiyemassi.cm',
    contactNom: 'M. Jean Ndongo',
    contactPoste: 'Proviseur',
    prospects: 45,
    agent: 'Jean M.',
    rating: 4.5,
    notes: 'Établissement très actif, bonne relation avec l\'équipe pédagogique.',
    recentProspects: [
      { name: 'Marie L.', date: '25 Mai 2025', status: 'Contacté' },
      { name: 'Paul D.', date: '20 Mai 2025', status: 'Converti' }
    ]
  };

  const getRatingStars = (rating) => {
    const stars = [];
    const fullStars = Math.floor(rating);
    for (let i = 0; i < fullStars; i++) {
      stars.push(<Star key={i} size={16} fill="#f5c842" color="#f5c842" />);
    }
    return stars;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de l'établissement</h1>
          <p className="page-description">Consultez les informations de l'établissement.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/etablissements')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/etablissements/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Building size={24} />
            </div>
            <div>
              <h2>{etablissement.name}</h2>
              <span className="type-badge">{etablissement.type}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><MapPin size={18} /><span>{etablissement.adresse}</span></div>
            <div className="info-row"><MapPin size={18} /><span>{etablissement.ville}</span></div>
            <div className="info-row"><Phone size={18} /><span>{etablissement.telephone}</span></div>
            <div className="info-row"><Mail size={18} /><span>{etablissement.email}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Contact principal</h3>
          <div className="detail-info">
            <div className="info-row"><User size={18} /><span>{etablissement.contactNom}</span></div>
            <div className="info-row"><User size={18} /><span>{etablissement.contactPoste}</span></div>
          </div>
          <div className="divider"></div>
          <div className="detail-info">
            <div className="info-row"><Users size={18} /><span>Prospects: {etablissement.prospects}</span></div>
            <div className="info-row"><User size={18} /><span>Agent: {etablissement.agent}</span></div>
            <div className="info-row"><Star size={18} /><span>Note: {getRatingStars(etablissement.rating)} ({etablissement.rating})</span></div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Notes</h3>
          <p className="detail-notes">{etablissement.notes}</p>
        </div>

        <div className="detail-card full-width">
          <h3>Derniers prospects de cet établissement</h3>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Prospect</th><th>Date</th><th>Statut</th></tr>
              </thead>
              <tbody>
                {etablissement.recentProspects.map((p, idx) => (
                  <tr key={idx}>
                    <td><strong>{p.name}</strong></td>
                    <td>{p.date}</td>
                    <td><span className={`badge ${p.status === 'Converti' ? 'badge-success' : 'badge-info'}`}>{p.status}</span></td>
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

export default EtablissementDetail;
