import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Plus, Trash2, GraduationCap, BookOpen, Users, TrendingUp, Eye } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const FiliereDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [activeTab, setActiveTab] = useState('info');
  const [toasts, setToasts] = useState([]);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, specialiteId: null, specialiteName: '' });

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  // Données mockées de la filière
  const filiere = {
    id: id,
    name: 'Génie Logiciel',
    code: 'GL',
    description: 'Formation en développement logiciel et technologies web',
    prospects: 399,
    pourcentage: 32,
    actif: true,
    createdAt: '01 Jan 2024'
  };

  // Données mockées des spécialités
  const [specialites, setSpecialites] = useState([
    { id: 1, name: 'Développement Web', description: 'Frontend, Backend, Fullstack', nbProspects: 150, actif: true },
    { id: 2, name: 'Mobile', description: 'iOS, Android, React Native', nbProspects: 120, actif: true },
    { id: 3, name: 'Intelligence Artificielle', description: 'Machine Learning, Deep Learning', nbProspects: 80, actif: true },
    { id: 4, name: 'DevOps', description: 'CI/CD, Cloud, Docker', nbProspects: 49, actif: false },
  ]);

  const handleDeleteSpecialite = () => {
    addToast(`Spécialité "${deleteModal.specialiteName}" supprimée avec succès`, 'success');
    setSpecialites(specialites.filter(s => s.id !== deleteModal.specialiteId));
    setDeleteModal({ isOpen: false, specialiteId: null, specialiteName: '' });
  };

  const getStatusBadge = (actif) => {
    return <span className={`badge ${actif ? 'badge-success' : 'badge-secondary'}`}>{actif ? 'Actif' : 'Inactif'}</span>;
  };

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal
        isOpen={deleteModal.isOpen}
        onClose={() => setDeleteModal({ isOpen: false, specialiteId: null, specialiteName: '' })}
        onConfirm={handleDeleteSpecialite}
        title="Confirmer la suppression"
        message={`Êtes-vous sûr de vouloir supprimer la spécialité "${deleteModal.specialiteName}" ?`}
        confirmText="Supprimer"
        type="warning"
      />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la filière</h1>
          <p className="page-description">Consultez les informations de la filière et ses spécialités.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/filieres')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/filieres/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      {/* Onglets */}
      <div className="detail-tabs">
        <button className={`tab-btn ${activeTab === 'info' ? 'active' : ''}`} onClick={() => setActiveTab('info')}>
          <GraduationCap size={16} /> Informations
        </button>
        <button className={`tab-btn ${activeTab === 'specialites' ? 'active' : ''}`} onClick={() => setActiveTab('specialites')}>
          <BookOpen size={16} /> Spécialités ({specialites.length})
        </button>
        <button className={`tab-btn ${activeTab === 'stats' ? 'active' : ''}`} onClick={() => setActiveTab('stats')}>
          <TrendingUp size={16} /> Statistiques
        </button>
      </div>

      {/* Onglet Informations */}
      {activeTab === 'info' && (
        <div className="detail-grid">
          <div className="detail-card">
            <div className="detail-header">
              <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
                <GraduationCap size={24} />
              </div>
              <div>
                <h2>{filiere.name}</h2>
                <span className="code-badge">{filiere.code}</span>
              </div>
            </div>
            <div className="detail-info">
              <div className="info-row"><GraduationCap size={18} /><span>Description: {filiere.description}</span></div>
              <div className="info-row"><Users size={18} /><span>Prospects: {filiere.prospects}</span></div>
              <div className="info-row"><TrendingUp size={18} /><span>Part: {filiere.pourcentage}%</span></div>
              <div className="info-row"><GraduationCap size={18} /><span>Statut: {getStatusBadge(filiere.actif)}</span></div>
            </div>
          </div>
        </div>
      )}

      {/* Onglet Spécialités */}
      {activeTab === 'specialites' && (
        <div className="detail-card full-width">
          <div className="table-header" style={{ justifyContent: 'space-between', marginBottom: '16px' }}>
            <h3>Spécialités de la filière</h3>
            <button className="btn-primary" style={{ padding: '6px 12px' }} onClick={() => navigate(`/specialites/new?filiere=${id}`)}>
              <Plus size={16} /> Ajouter une spécialité
            </button>
          </div>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Nom</th>
                  <th>Description</th>
                  <th>Prospects</th>
                  <th>Statut</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {specialites.map((spec) => (
                  <tr key={spec.id}>
                    <td><strong>{spec.name}</strong></td>
                    <td>{spec.description}</td>
                    <td className="text-center">{spec.nbProspects}</td>
                    <td>{getStatusBadge(spec.actif)}</td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn edit" onClick={() => navigate(`/specialites/edit/${spec.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, specialiteId: spec.id, specialiteName: spec.name })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Onglet Statistiques */}
      {activeTab === 'stats' && (
        <div className="detail-grid">
          <div className="detail-card">
            <h3>Répartition des spécialités</h3>
            <div className="specialites-stats">
              {specialites.filter(s => s.actif).map((spec) => (
                <div key={spec.id} className="stat-bar-item">
                  <div className="stat-bar-label">{spec.name}</div>
                  <div className="stat-bar-bg">
                    <div className="stat-bar-fill" style={{ width: `${(spec.nbProspects / filiere.prospects) * 100}%` }}></div>
                  </div>
                  <div className="stat-bar-value">{spec.nbProspects} prospects</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default FiliereDetail;
