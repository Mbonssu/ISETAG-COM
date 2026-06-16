import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import '../Prospects/Prospects.css';

const SourcesList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, sourceId: null, sourceName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const sources = [
    { id: 1, name: 'Terrain', prospects: 562, pourcentage: 45, couleur: '#FF6B6B', actif: true, evolution: '+12%' },
    { id: 2, name: 'Lycée', prospects: 374, pourcentage: 30, couleur: '#4ECDC4', actif: true, evolution: '+8%' },
    { id: 3, name: 'Passage institut', prospects: 187, pourcentage: 15, couleur: '#FFE66D', actif: true, evolution: '+5%' },
    { id: 4, name: 'Réseaux sociaux', prospects: 75, pourcentage: 6, couleur: '#A78BFA', actif: true, evolution: '+25%' },
    { id: 5, name: 'Référence', prospects: 50, pourcentage: 4, couleur: '#F9A26C', actif: true, evolution: '+3%' },
    { id: 6, name: 'Site web', prospects: 32, pourcentage: 2.6, couleur: '#845EC2', actif: false, evolution: '+15%' },
    { id: 7, name: 'Salon', prospects: 28, pourcentage: 2.3, couleur: '#00C9A7', actif: true, evolution: '+10%' },
  ];

  const filteredSources = sources.filter(s => s.name.toLowerCase().includes(searchTerm.toLowerCase()));
  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSources, 10);

  const handleDelete = () => {
    addToast(`Source "${deleteModal.sourceName}" supprimée avec succès`, 'success');
    setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune source ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>Effacer les filtres</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer la source "${deleteModal.sourceName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Sources des prospects</h1>
          <p className="page-description">Gérez les différentes sources d'acquisition de prospects.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/sources/new')}>
          <Plus size={18} /> Nouvelle source
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher une source..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
      </div>

      {filteredSources.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Source</th><th>Prospects</th><th>Part</th><th>Évolution</th><th>Statut</th><th>Actions</th></tr>
              </thead>
              <tbody>
                {paginatedItems.map((source) => (
                  <tr key={source.id}>
                    <td><div className="source-cell"><div className="source-color" style={{ backgroundColor: source.couleur }}></div><strong>{source.name}</strong></div></td>
                    <td className="text-center">{source.prospects}</td>
                    <td className="text-center"><div className="progress-bar-small"><div className="progress-fill-small" style={{ width: `${source.pourcentage}%` }}></div><span>{source.pourcentage}%</span></div></td>
                    <td><span className={`evolution-badge ${source.evolution.includes('+') ? 'positive' : 'negative'}`}>{source.evolution}</span></td>
                    <td><span className={`badge ${source.actif ? 'badge-success' : 'badge-secondary'}`}>{source.actif ? 'Actif' : 'Inactif'}</span></td>
                    <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/sources/edit/${source.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sourceId: source.id, sourceName: source.name })}><Trash2 size={16} /></button></div></td>
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
            totalItems={filteredSources.length}
          />
        </>
      )}
    </div>
  );
};

export default SourcesList;
