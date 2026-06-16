import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, User, Mail, Phone, Shield, Calendar, CheckCircle, XCircle, Clock, Activity } from 'lucide-react';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const UtilisateurDetail = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const { id } = useParams();

  const utilisateur = {
    id: id,
    name: 'Admin ISETAG',
    email: 'admin@isetag.com',
    phone: '691234567',
    role: 'Administrateur',
    status: 'actif',
    lastLogin: '25 Mai 2025 à 14:30',
    createdAt: '01 Janvier 2024',
    avatar: 'AI',
    permissions: [
      'Gestion des utilisateurs',
      'Configuration système',
      'Accès à tous les rapports',
      'Gestion des prospects',
      'Gestion des agents'
    ],
    derniersProspects: [
      { name: 'Marie L.', date: '25 Mai 2025', action: 'Ajout' },
      { name: 'David P.', date: '24 Mai 2025', action: 'Modification' },
      { name: 'Anne S.', date: '23 Mai 2025', action: 'Ajout' }
    ]
  };

  const getStatusBadge = () => {
    return <span className={`badge ${utilisateur.status === 'actif' ? 'badge-success' : 'badge-secondary'}`}>
      {utilisateur.status === 'actif' ? 'Actif' : 'Inactif'}
    </span>;
  };

  const getRoleBadge = () => {
    const classes = {
      'Administrateur': 'badge-danger',
      'Manager': 'badge-warning',
      'Agent': 'badge-info',
      'Viewer': 'badge-secondary'
    };
    return <span className={`badge ${classes[utilisateur.role] || 'badge-secondary'}`}>{utilisateur.role}</span>;
  };

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de l'utilisateur</h1>
          <p className="page-description">Consultez les informations de l'utilisateur.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/utilisateurs')}>
            <ArrowLeft size={18} /> Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/utilisateurs/edit/${id}`)}>
            <Edit size={18} /> Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white', fontSize: '28px' }}>
              {utilisateur.avatar}
            </div>
            <div>
              <h2>{utilisateur.name}</h2>
              {getRoleBadge()}
              {getStatusBadge()}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Mail size={18} /><span>{utilisateur.email}</span></div>
            <div className="info-row"><Phone size={18} /><span>{utilisateur.phone}</span></div>
            <div className="info-row"><Calendar size={18} /><span>Membre depuis: {utilisateur.createdAt}</span></div>
            <div className="info-row"><Clock size={18} /><span>Dernière connexion: {utilisateur.lastLogin}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Permissions</h3>
          <div className="permissions-list" style={{ marginTop: '10px' }}>
            {utilisateur.permissions.map((perm, idx) => (
              <div key={idx} className="info-row" style={{ marginBottom: '8px' }}>
                <CheckCircle size={16} color="#10b981" /> {perm}
              </div>
            ))}
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Dernières activités</h3>
          <div className="table-container" style={{ marginTop: '10px' }}>
            <table className="data-table">
              <thead>
                <tr>
                  <th>Prospect</th><th>Date</th><th>Action</th>
                </tr>
              </thead>
              <tbody>
                {utilisateur.derniersProspects.map((prospect, idx) => (
                  <tr key={idx}>
                    <td><strong>{prospect.name}</strong></td>
                    <td>{prospect.date}</td>
                    <td><span className="badge badge-info">{prospect.action}</span></td>
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

export default UtilisateurDetail;
