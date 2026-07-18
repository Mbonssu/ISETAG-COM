import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, AlertCircle, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { sourceService } from '../../services/sourceService';
import { SkeletonTable } from '../../components/Skeleton/Skeleton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

//  CORRIGÉ : page 100% mock, aucun appel API. Champs alignés sur le
// schéma réel Source : idSource, libele, description.

const SourcesList = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, sourceId: null, sourceName: '' });
  const [toasts, setToasts] = useState([]);
  const [sources, setSources] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  const fetchSources = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await sourceService.getAll();
      setSources(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      console.error(' Erreur de chargement:', err);
      setError(err.message);
      addToast('Erreur lors du chargement des sources', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchSources(); }, []);

  const filteredSources = sources.filter(s =>
    (s.libele || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
    (s.description || '').toLowerCase().includes(searchTerm.toLowerCase())
  );

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSources, 10);

  const handleDelete = async () => {
    try {
      await sourceService.delete(deleteModal.sourceId);
      addToast(`Source "${deleteModal.sourceName}" supprimée avec succès`, 'success');
      fetchSources();
    } catch (err) {
      addToast('Erreur lors de la suppression', 'error');
    }
    setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune source ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>Effacer la recherche</button>
    </div>
  );

  if (loading) {
    return <div className="page-container"><SkeletonTable rows={6} columns={3} /></div>;
  }
  if (error) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn-outline" onClick={fetchSources}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer la source "${deleteModal.sourceName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('gestionSources')}</h1>
          <p className="page-description">{t('descSources')}</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/sources/new')}>
          <Plus size={18} /> {t('nouvelleSource')}
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par nom ou description..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
      </div>

      {filteredSources.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Nom</th><th>Description</th><th>Actions</th></tr></thead>
              <tbody>
                {paginatedItems.map((source) => (
                  <tr key={source.idSource}>
                    <td><strong>{source.libele}</strong></td>
                    <td><div className="commentaire-cell"><small>{source.description}</small></div></td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/sources/${source.idSource}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/sources/edit/${source.idSource}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sourceId: source.idSource, sourceName: source.libele })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredSources.length} />
        </>
      )}
    </div>
  );
};

export default SourcesList;