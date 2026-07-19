// pages/Filieres/FilieresList.jsx
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Plus, Search, Edit, Trash2, AlertCircle, 
  BookOpen, Loader, X, RefreshCw 
} from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { specialiteService } from '../../services/filiereService'; // ← CORRECTION : Bon import
import '../Prospects/Prospects.css';

const FilieresList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ 
    isOpen: false, 
    specialiteId: null, 
    specialiteName: '' 
  });
  const [toasts, setToasts] = useState([]);
  const [specialites, setSpecialites] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const loadSpecialites = async (search = '') => {
    setLoading(true);
    setError(null);
    try {
      ('🔄 Chargement des spécialités...');
      const params = search ? { search: search } : {};
      const data = await specialiteService.getAll(params);
      (' Spécialités chargées:', data);
      setSpecialites(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error(' Erreur chargement spécialités:', err);
      setError(err.message || 'Erreur lors du chargement des spécialités');
      setSpecialites([]);
      addToast(`Erreur: ${err.message || 'Impossible de charger les spécialités'}`, 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadSpecialites();
  }, []);

  const handleSearchChange = (value) => {
    setSearchTerm(value);
    clearTimeout(window.searchTimeout);
    window.searchTimeout = setTimeout(() => {
      loadSpecialites(value);
    }, 500);
  };

  const clearSearch = () => {
    setSearchTerm('');
    loadSpecialites('');
  };

  const handleDelete = async () => {
    if (!deleteModal.specialiteId) return;
    
    try {
      await specialiteService.delete(deleteModal.specialiteId);
      addToast(`Spécialité "${deleteModal.specialiteName}" supprimée avec succès`, 'success');
      loadSpecialites(searchTerm);
      setDeleteModal({ isOpen: false, specialiteId: null, specialiteName: '' });
    } catch (err) {
      console.error(' Erreur suppression:', err);
      addToast(`Erreur: ${err.message || 'Impossible de supprimer'}`, 'error');
    }
  };

  const filteredSpecialites = specialites.filter(s => {
    if (!searchTerm) return true;
    const term = searchTerm.toLowerCase();
    return (s.libeleSpecialite?.toLowerCase().includes(term) || 
            s.idSpecialite?.toLowerCase().includes(term) ||
            s.acronyme?.toLowerCase().includes(term));
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = 
    usePagination(filteredSpecialites, 10);

  if (loading) {
    return (
      <div className="page-container">
        <div className="text-center py-5">
          <Loader size={48} className="spinner" />
          <p className="mt-3">Chargement des spécialités...</p>
        </div>
      </div>
    );
  }

  const renderNoResults = () => (
    <div className="no-results">
      <BookOpen size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>
        {searchTerm 
          ? `Aucune spécialité ne correspond à votre recherche "${searchTerm}"`
          : 'Aucune spécialité n\'a été créée pour le moment'
        }
      </p>
      <div className="d-flex gap-2 justify-content-center">
        {searchTerm && (
          <button className="btn-outline" onClick={clearSearch}>
            Effacer les filtres
          </button>
        )}
        <button 
          className="btn-primary" 
          onClick={() => navigate('/filieres/new')}
        >
          <Plus size={16} /> Créer une spécialité
        </button>
      </div>
    </div>
  );

  if (error) {
    return (
      <div className="page-container">
        <div className="alert alert-danger">
          <AlertCircle size={24} />
          <div>
            <h4>Erreur de chargement</h4>
            <p>{error}</p>
            <button className="btn-primary" onClick={() => loadSpecialites(searchTerm)}>
              Réessayer
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal 
        isOpen={deleteModal.isOpen} 
        onClose={() => setDeleteModal({ isOpen: false, specialiteId: null, specialiteName: '' })} 
        onConfirm={handleDelete} 
        title="Confirmer la suppression" 
        message={`Supprimer la spécialité "${deleteModal.specialiteName}" ?`} 
        confirmText="Supprimer" 
        type="warning" 
      />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Spécialités</h1>
          <p className="page-description">
            Gérez les spécialités de formation.
            <span className="badge ms-2">{specialites.length} spécialités</span>
          </p>
        </div>
        <button 
          className="btn-primary" 
          onClick={() => navigate('/filieres/new')}
        >
          <Plus size={18} /> Nouvelle spécialité
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box" style={{ flex: 1 }}>
          <Search size={18} />
          <input 
            type="text" 
            placeholder="Rechercher par libellé, ID ou acronyme..." 
            value={searchTerm} 
            onChange={(e) => handleSearchChange(e.target.value)}
          />
          {searchTerm && (
            <button className="btn-clear-search" onClick={clearSearch}>
              <X size={16} />
            </button>
          )}
        </div>
        <button 
          className="btn-outline" 
          onClick={() => loadSpecialites(searchTerm)}
          title="Rafraîchir"
        >
          <RefreshCw size={18} />
        </button>
      </div>

      {filteredSpecialites.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Numero</th>
                  <th>Libellé</th>
                  <th>Acronyme</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((specialite, index) => (
                  <tr key={specialite.idSpecialite}>
                    <td>
                      <span className="code-badge">
                        {index + 1}
                      </span>
                    </td>
                    <td>
                      <strong>{specialite.libeleSpecialite}</strong>
                    </td>
                    <td>
                      <span className="acronyme-badge">
                        {specialite.acronyme || '-'}
                      </span>
                    </td>
                    <td>{specialite.description || '-'}</td>
                    <td>
                      <div className="action-buttons">
                        <button 
                          className="action-btn edit" 
                          onClick={() => navigate(`/filieres/edit/${specialite.idSpecialite}`)}
                          title="Modifier"
                        >
                          <Edit size={16} />
                        </button>
                        <button 
                          className="action-btn delete" 
                          onClick={() => setDeleteModal({ 
                            isOpen: true, 
                            specialiteId: specialite.idSpecialite, 
                            specialiteName: specialite.libeleSpecialite
                          })}
                          title="Supprimer"
                        >
                          <Trash2 size={16} />
                        </button>
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
            totalItems={filteredSpecialites.length}
          />
        </>
      )}
    </div>
  );
};

export default FilieresList;