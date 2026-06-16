import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';

import '../Prospects/Prospects.css';

const AgentsList = () => {
  const navigate = useNavigate();
  
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, agentId: null, agentName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const agents = [
    { id: 1, name: 'Jean M.', email: 'jean@isetag.com', phone: '691234567', prospects: 45, converted: 18, status: 'actif', zone: 'Yaoundé Centre', avatar: 'JM', taux: 40 },
    { id: 2, name: 'David P.', email: 'david@isetag.com', phone: '692345678', prospects: 38, converted: 12, status: 'actif', zone: 'Douala Nord', avatar: 'DP', taux: 32 },
    { id: 3, name: 'Sophie A.', email: 'sophie@isetag.com', phone: '693456789', prospects: 52, converted: 24, status: 'actif', zone: 'Yaoundé Sud', avatar: 'SA', taux: 46 },
    { id: 4, name: 'Marie L.', email: 'marie@isetag.com', phone: '694567890', prospects: 29, converted: 8, status: 'inactif', zone: 'Bafoussam', avatar: 'ML', taux: 28 },
    { id: 5, name: 'Paul K.', email: 'paul@isetag.com', phone: '695678901', prospects: 41, converted: 15, status: 'actif', zone: 'Garoua', avatar: 'PK', taux: 37 },
    { id: 6, name: 'Claire N.', email: 'claire@isetag.com', phone: '696789012', prospects: 35, converted: 14, status: 'actif', zone: 'Yaoundé Centre', avatar: 'CN', taux: 40 },
    { id: 7, name: 'Michel D.', email: 'michel@isetag.com', phone: '697890123', prospects: 28, converted: 10, status: 'inactif', zone: 'Douala Sud', avatar: 'MD', taux: 36 },
    { id: 8, name: 'Isabelle K.', email: 'isabelle@isetag.com', phone: '698901234', prospects: 44, converted: 19, status: 'actif', zone: 'Yaoundé Sud', avatar: 'IK', taux: 43 },
  ];

  const filteredAgents = agents.filter(agent => {
    const matchesSearch = agent.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          agent.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          agent.phone.includes(searchTerm);
    const matchesStatus = filterStatus === 'all' || agent.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredAgents, 10);

  const handleDelete = () => {
    addToast(`${deleteModal.agentName} supprimé avec succès`, 'success');
    setDeleteModal({ isOpen: false, agentId: null, agentName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucun agent ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>Effacer les filtres</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, agentId: null, agentName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer l'agent "${deleteModal.agentName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Agents</h1>
          <p className="page-description">Gérez les agents commerciaux et leurs performances.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/agents/new')}>
          <Plus size={18} /> Nouvel agent
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par nom, email ou téléphone..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
            <option value="all">Tous les statuts</option>
            <option value="actif">Actif</option>
            <option value="inactif">Inactif</option>
          </select>
        </div>
      </div>

      {filteredAgents.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Agent</th><th>Contact</th><th>Zone</th><th>Prospects</th><th>Conversions</th><th>Taux</th><th>Statut</th><th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((agent) => (
                  <tr key={agent.id}>
                    <td><div className="agent-cell"><div className="agent-avatar">{agent.avatar}</div><strong>{agent.name}</strong></div></td>
                    <td><div>{agent.email}</div><small>{agent.phone}</small></td>
                    <td>{agent.zone}</td>
                    <td className="text-center">{agent.prospects}</td>
                    <td className="text-center">{agent.converted}</td>
                    <td className="text-center"><span className="rate-badge">{agent.taux}%</span></td>
                    <td><span className={`badge ${agent.status === 'actif' ? 'badge-success' : 'badge-secondary'}`}>{agent.status === 'actif' ? 'Actif' : 'Inactif'}</span></td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/agents/${agent.id}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/agents/edit/${agent.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, agentId: agent.id, agentName: agent.name })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination 
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={goToPage}
            itemsPerPage={itemsPerPage}
            totalItems={filteredAgents.length}
          />
        </>
      )}
    </div>
  );
};

export default AgentsList;
