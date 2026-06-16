import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, AlertCircle, Bell, Clock, CheckCircle, AlertCircle as AlertIcon, Phone, Mail, MessageSquare } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import '../Prospects/Prospects.css';

const RelancesList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, relanceId: null, relanceName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const relances = [
    { id: 1, prospect: 'Marie L.', type: 'Email', date: '25 Mai 2025', heure: '10:00', status: 'En attente', agent: 'Jean M.', priorite: 'Haute', message: 'Relance pour inscription formation' },
    { id: 2, prospect: 'Junior B.', type: 'Appel', date: '25 Mai 2025', heure: '14:30', status: 'Programmée', agent: 'Jean M.', priorite: 'Moyenne', message: 'Confirmation inscription' },
    { id: 3, prospect: 'Paul D.', type: 'SMS', date: '24 Mai 2025', heure: '09:00', status: 'Effectuée', agent: 'David P.', priorite: 'Basse', message: 'Rappel de rendez-vous' },
    { id: 4, prospect: 'Anne S.', type: 'Email', date: '26 Mai 2025', heure: '11:00', status: 'En attente', agent: 'Sophie A.', priorite: 'Haute', message: 'Documentation supplémentaire' },
    { id: 5, prospect: 'Luc M.', type: 'Appel', date: '23 Mai 2025', heure: '16:00', status: 'Effectuée', agent: 'David P.', priorite: 'Moyenne', message: 'Suite à la visite' },
    { id: 6, prospect: 'Sophie L.', type: 'SMS', date: '27 Mai 2025', heure: '09:30', status: 'Programmée', agent: 'Sophie A.', priorite: 'Haute', message: 'Proposition commerciale' },
    { id: 7, prospect: 'Claire N.', type: 'Email', date: '28 Mai 2025', heure: '14:00', status: 'En attente', agent: 'Jean M.', priorite: 'Moyenne', message: 'Suivi inscription' },
    { id: 8, prospect: 'Michel D.', type: 'Appel', date: '29 Mai 2025', heure: '11:30', status: 'Programmée', agent: 'David P.', priorite: 'Basse', message: 'Confirmation rendez-vous' },
  ];

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Email': return <Mail size={16} />;
      case 'Appel': return <Phone size={16} />;
      case 'SMS': return <MessageSquare size={16} />;
      default: return <Bell size={16} />;
    }
  };

  const getStatusBadge = (status) => {
    const classes = { 'En attente': 'badge-warning', 'Programmée': 'badge-info', 'Effectuée': 'badge-success' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const getPrioriteIcon = (priorite) => {
    switch(priorite) {
      case 'Haute': return <AlertIcon size={14} color="#ef4444" />;
      case 'Moyenne': return <Clock size={14} color="#f59e0b" />;
      case 'Basse': return <CheckCircle size={14} color="#10b981" />;
      default: return <Bell size={14} />;
    }
  };

  const filteredRelances = relances.filter(r => {
    const matchesSearch = r.prospect.toLowerCase().includes(searchTerm.toLowerCase()) || r.agent.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || r.type === filterType;
    const matchesStatus = filterStatus === 'all' || r.status === filterStatus;
    return matchesSearch && matchesType && matchesStatus;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredRelances, 10);

  const handleDelete = () => {
    addToast(`Relance supprimée avec succès`, 'success');
    setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune relance ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterStatus('all'); }}>Effacer les filtres</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message="Êtes-vous sûr de vouloir supprimer cette relance ?" confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Relances</h1>
          <p className="page-description">Planifiez et suivez les relances auprès des prospects.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/relances/new')}>
          <Plus size={18} /> Nouvelle relance
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par prospect ou agent..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={(e) => setFilterType(e.target.value)}><option value="all">Tous les types</option><option value="Email">Email</option><option value="Appel">Appel</option><option value="SMS">SMS</option></select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}><option value="all">Tous les statuts</option><option value="En attente">En attente</option><option value="Programmée">Programmée</option><option value="Effectuée">Effectuée</option></select></div>
      </div>

      {filteredRelances.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Prospect</th><th>Type</th><th>Message</th><th>Date/Heure</th><th>Priorité</th><th>Statut</th><th>Agent</th><th>Actions</th></tr>
              </thead>
              <tbody>
                {paginatedItems.map((relance) => (
                  <tr key={relance.id}>
                    <td><strong>{relance.prospect}</strong></td>
                    <td><div className="type-badge">{getTypeIcon(relance.type)}<span>{relance.type}</span></div></td>
                    <td><div className="relance-message"><small>{relance.message}</small></div></td>
                    <td><div className="date-time"><div>{relance.date}</div><small>{relance.heure}</small></div></td>
                    <td><div className="priority-badge">{getPrioriteIcon(relance.priorite)}<span className={`priority-${relance.priorite.toLowerCase()}`}>{relance.priorite}</span></div></td>
                    <td>{getStatusBadge(relance.status)}</td>
                    <td>{relance.agent}</td>
                    <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/relances/edit/${relance.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, relanceId: relance.id, relanceName: relance.prospect })}><Trash2 size={16} /></button></div></td>
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
            totalItems={filteredRelances.length}
          />
        </>
      )}
    </div>
  );
};

export default RelancesList;
