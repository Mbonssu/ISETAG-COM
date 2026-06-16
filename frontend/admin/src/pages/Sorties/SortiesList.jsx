import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Calendar, MapPin, User, Target } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import '../Prospects/Prospects.css';

const SortiesList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, sortieId: null, sortieName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const sorties = [
    { id: 1, typeSortie: 'Prospection', dateSortie: '25 Mai 2025', statut: 'Planifiée', objectif: '50 prospects', commentaire: 'Visite des lycées de Yaoundé', agent: 'Jean M.', zone: 'Yaoundé Centre' },
    { id: 2, typeSortie: 'Suivi', dateSortie: '24 Mai 2025', statut: 'Effectuée', objectif: '30 prospects', commentaire: 'Relance des prospects intéressés', agent: 'David P.', zone: 'Douala Nord' },
    { id: 3, typeSortie: 'Formation', dateSortie: '26 Mai 2025', statut: 'Annulée', objectif: 'Former les agents', commentaire: 'Reportée', agent: 'Sophie A.', zone: 'Yaoundé Sud' },
    { id: 4, typeSortie: 'Prospection', dateSortie: '27 Mai 2025', statut: 'En cours', objectif: '80 prospects', commentaire: 'Campagne intensive', agent: 'Jean M.', zone: 'Bafoussam' },
  ];

  const typesSortie = ['Prospection', 'Suivi', 'Formation', 'Réunion', 'Autre'];
  const statutsSortie = ['Planifiée', 'En cours', 'Effectuée', 'Annulée', 'Reportée'];

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

  const filteredSorties = sorties.filter(s => {
    const matchesSearch = s.typeSortie.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          s.agent.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          s.zone.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || s.typeSortie === filterType;
    const matchesStatus = filterStatus === 'all' || s.statut === filterStatus;
    return matchesSearch && matchesType && matchesStatus;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSorties, 10);

  const handleDelete = () => {
    addToast(`Sortie supprimée avec succès`, 'success');
    setDeleteModal({ isOpen: false, sortieId: null, sortieName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune sortie ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterStatus('all'); }}>Effacer les filtres</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sortieId: null, sortieName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message="Êtes-vous sûr de vouloir supprimer cette sortie ?" confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Sorties</h1>
          <p className="page-description">Planifiez et suivez les sorties terrain des agents.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/sorties/new')}>
          <Plus size={18} /> Nouvelle sortie
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par type, agent ou zone..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterType} onChange={(e) => setFilterType(e.target.value)}>
            <option value="all">Tous les types</option>
            {typesSortie.map(t => <option key={t} value={t}>{t}</option>)}
          </select>
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
            <option value="all">Tous les statuts</option>
            {statutsSortie.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>
      </div>

      {filteredSorties.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Type</th><th>Date</th><th>Statut</th><th>Objectif</th><th>Commentaire</th><th>Agent</th><th>Zone</th><th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((sortie) => (
                  <tr key={sortie.id}>
                    <td><span className="badge badge-info">{sortie.typeSortie}</span></td>
                    <td><Calendar size={14} /> {sortie.dateSortie}</td>
                    <td>{getStatusBadge(sortie.statut)}</td>
                    <td><Target size={14} /> {sortie.objectif}</td>
                    <td><div className="commentaire-cell"><small>{sortie.commentaire}</small></div></td>
                    <td><User size={14} /> {sortie.agent}</td>
                    <td><MapPin size={14} /> {sortie.zone}</td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/sorties/${sortie.id}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/sorties/edit/${sortie.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sortieId: sortie.id, sortieName: sortie.typeSortie })}><Trash2 size={16} /></button>
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
            totalItems={filteredSorties.length}
          />
        </>
      )}
    </div>
  );
};

export default SortiesList;
