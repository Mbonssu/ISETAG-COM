import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Plus, Trash2, Calendar, Users, Target, TrendingUp, MapPin, User } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const CampagneDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [activeTab, setActiveTab] = useState('info');
  const [toasts, setToasts] = useState([]);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, participationId: null, participationName: '' });

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const campagne = {
    id: id,
    name: 'Campagne Mai 2025',
    type: 'Email',
    status: 'En cours',
    dateDebut: '01 Mai 2025',
    dateFin: '31 Mai 2025',
    objectif: '500 prospects',
    prospects: 245,
    taux: 32,
    agent: 'Jean M.'
  };

  const [participations, setParticipations] = useState([
    { id: 1, agent: 'Jean M.', zone: 'Yaoundé Centre', dateAssignation: '01 Mai 2025', heureArrivee: '08:00', heureDepart: '16:00', statut: 'Effectué', observation: 'Très bonne participation' },
    { id: 2, agent: 'David P.', zone: 'Douala Nord', dateAssignation: '02 Mai 2025', heureArrivee: '09:00', heureDepart: '17:00', statut: 'Effectué', observation: 'Objectif atteint' },
    { id: 3, agent: 'Sophie A.', zone: 'Yaoundé Sud', dateAssignation: '03 Mai 2025', heureArrivee: '08:30', heureDepart: '15:30', statut: 'En cours', observation: 'En progression' },
  ]);

  const handleDeleteParticipation = () => {
    addToast(`Participation supprimée avec succès`, 'success');
    setParticipations(participations.filter(p => p.id !== deleteModal.participationId));
    setDeleteModal({ isOpen: false, participationId: null, participationName: '' });
  };

  const getStatusBadge = (status) => {
    const classes = { 'Effectué': 'badge-success', 'En cours': 'badge-warning', 'Planifié': 'badge-info', 'Annulé': 'badge-danger' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ isOpen: false, participationId: null, participationName: '' })}
        onConfirm={handleDeleteParticipation}
        title="Confirmer la suppression"
        message="Êtes-vous sûr de vouloir supprimer cette participation ?"
        confirmText="Supprimer"
        type="warning"
      />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la campagne</h1>
          <p className="page-description">Consultez les informations de la campagne et les participations.</p>
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

      <div className="detail-tabs">
        <button className={`tab-btn ${activeTab === 'info' ? 'active' : ''}`} onClick={() => setActiveTab('info')}>
          <Calendar size={16} /> Informations
        </button>
        <button className={`tab-btn ${activeTab === 'participations' ? 'active' : ''}`} onClick={() => setActiveTab('participations')}>
          <Users size={16} /> Participations ({participations.length})
        </button>
        <button className={`tab-btn ${activeTab === 'stats' ? 'active' : ''}`} onClick={() => setActiveTab('stats')}>
          <TrendingUp size={16} /> Statistiques
        </button>
      </div>

      {activeTab === 'info' && (
        <div className="detail-grid">
          <div className="detail-card">
            <div className="detail-header">
              <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
                <Calendar size={24} />
              </div>
              <div>
                <h2>{campagne.name}</h2>
                <span className="type-badge">{campagne.type}</span>
              </div>
            </div>
            <div className="detail-info">
              <div className="info-row"><Calendar size={18} /><span>Du {campagne.dateDebut} au {campagne.dateFin}</span></div>
              <div className="info-row"><Target size={18} /><span>Objectif: {campagne.objectif}</span></div>
              <div className="info-row"><Users size={18} /><span>Prospects touchés: {campagne.prospects}</span></div>
              <div className="info-row"><TrendingUp size={18} /><span>Taux: {campagne.taux}%</span></div>
              <div className="info-row"><User size={18} /><span>Responsable: {campagne.agent}</span></div>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'participations' && (
        <div className="detail-card full-width">
          <div className="table-header" style={{ justifyContent: 'space-between', marginBottom: '16px' }}>
            <h3>Participations des agents</h3>
            <button className="btn-primary" style={{ padding: '6px 12px' }} onClick={() => navigate(`/participations/new?campagne=${id}`)}>
              <Plus size={16} /> Ajouter une participation
            </button>
          </div>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Agent</th>
                  <th>Zone</th>
                  <th>Date</th>
                  <th>Heure arrivée</th>
                  <th>Heure départ</th>
                  <th>Statut</th>
                  <th>Observation</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {participations.map((part) => (
                  <tr key={part.id}>
                    <td><User size={14} /> {part.agent}</td>
                    <td><MapPin size={14} /> {part.zone}</td>
                    <td>{part.dateAssignation}</td>
                    <td>{part.heureArrivee}</td>
                    <td>{part.heureDepart}</td>
                    <td>{getStatusBadge(part.statut)}</td>
                    <td><div className="commentaire-cell"><small>{part.observation}</small></div></td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn edit" onClick={() => navigate(`/participations/edit/${part.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, participationId: part.id, participationName: `${part.agent} - ${part.zone}` })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {activeTab === 'stats' && (
        <div className="detail-grid">
          <div className="detail-card">
            <h3>Performance de la campagne</h3>
            <div className="performance-stats">
              <div className="perf-item"><Users size={20} /><div><div className="perf-value">{campagne.prospects}</div><div className="perf-label">Prospects touchés</div></div></div>
              <div className="perf-item"><Target size={20} /><div><div className="perf-value">{Math.round(campagne.prospects / 500 * 100)}%</div><div className="perf-label">Objectif atteint</div></div></div>
              <div className="perf-item"><TrendingUp size={20} /><div><div className="perf-value">{campagne.taux}%</div><div className="perf-label">Taux conversion</div></div></div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default CampagneDetail;
