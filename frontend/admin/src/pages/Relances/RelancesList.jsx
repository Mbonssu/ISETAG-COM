import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, 
  Bell, Calendar, Clock, User, Mail, Phone, MessageSquare, 
  RefreshCw, Loader, X 
} from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { relanceService } from '../../services/relanceService';
import { useTranslation } from '../../hooks/useTranslation';
import { SkeletonTable } from '../../components/Skeleton/Skeleton';
import { matchesDateRange as matchesDateRangeFilter } from './relancesFilterUtils';
import '../Prospects/Prospects.css';

const RelancesList = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [nomProspectSecours, setNomProspectSecours] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, relanceId: null, relanceName: '' });
  const [toasts, setToasts] = useState([]);
  const [relances, setRelances] = useState([]);
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

  const loadRelances = async (search = '') => {
    setLoading(true);
    setError(null);
    try {
      const params = search ? { search: search } : {};
      const data = await relanceService.getAll(params);
      setRelances(Array.isArray(data) ? data : []);
    } catch (err) {
      setError(err.message || 'Erreur lors du chargement des relances');
      setRelances([]);
      addToast(`Erreur: ${err.message || 'Impossible de charger les relances'}`, 'error');
    } finally {
      setLoading(false);
    }
  };

  const getNomProspect = (relance ) => relance?.prospect_details?.nomComplet || nomProspectSecours || relance?.idProspect;


  useEffect(() => {
    loadRelances();
  }, []);

  const handleSearchChange = (value) => {
    setSearchTerm(value);
    clearTimeout(window.searchTimeout);
    window.searchTimeout = setTimeout(() => {
      loadRelances(value);
    }, 500);
  };

  const clearSearch = () => {
    setSearchTerm('');
    loadRelances('');
  };

  const clearFilters = () => {
    setSearchTerm('');
    setStartDate('');
    setEndDate('');
    loadRelances('');
  };

  const handleDelete = async () => {
    if (!deleteModal.relanceId) return;
    try {
      await relanceService.delete(deleteModal.relanceId);
      addToast(`Relance supprimée avec succès`, 'success');
      loadRelances(searchTerm);
      setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' });
    } catch (err) {
      addToast(`Erreur: ${err.message || 'Impossible de supprimer'}`, 'error');
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    });
  };

  const formatTime = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleTimeString('fr-FR', {
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  // Fonction pour récupérer le nom du prospect
  const getProspectName = (relance) => {
    if (relance.prospect_details && relance.prospect_details.nomComplet) {
      return relance.prospect_details.nomComplet;
    }
    return relance.idProspect || 'Prospect inconnu';
  };

  const hasActiveFilters = Boolean(searchTerm || startDate || endDate);

  const filteredRelances = relances.filter((r) => {
    const term = searchTerm.toLowerCase();
    const prospectName = getProspectName(r).toLowerCase();
    const matchesSearch = !searchTerm || (
      r.sujet?.toLowerCase().includes(term) ||
      prospectName.includes(term) ||
      String(r.idRelance ?? '').toLowerCase().includes(term)
    );
    const matchesDate = matchesDateRangeFilter(r.dateRelance, startDate, endDate);

    return matchesSearch && matchesDate;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredRelances, 10);

  if (loading) {
    return (
      <div className="page-container">
        <SkeletonTable rows={6} columns={5} />
      </div>
    );
  }

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>
        {hasActiveFilters
          ? 'Aucune relance ne correspond aux filtres appliqués.'
          : 'Aucune relance n\'a été créée pour le moment'
        }
      </p>
      <div className="d-flex gap-2 justify-content-center">
        {hasActiveFilters && (
          <button className="btn-outline" onClick={clearFilters}>Effacer les filtres</button>
        )}
        <button className="btn-primary" onClick={() => navigate('/relances/new')}>
          <Plus size={16} /> Nouvelle relance
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
            <button className="btn-primary" onClick={() => loadRelances(searchTerm)}>Réessayer</button>
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
        onClose={() => setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' })} 
        onConfirm={handleDelete} 
        title="Confirmer la suppression" 
        message={`Supprimer cette relance ?`} 
        confirmText="Supprimer" 
        type="warning" 
      />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('gestionRelances')}</h1>
          <p className="page-description">
            {t('descRelances')}
            <span className="badge ms-2">{relances.length} relances</span>
          </p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/relances/new')}>
          <Plus size={18} /> {t('nouvelleRelance')}
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box" style={{ flex: 1 }}>
          <Search size={18} />
          <input 
            type="text" 
            placeholder="Rechercher par sujet, prospect..." 
            value={searchTerm} 
            onChange={(e) => handleSearchChange(e.target.value)}
          />
          {searchTerm && (
            <button className="btn-clear-search" onClick={clearSearch}>
              <X size={16} />
            </button>
          )}
        </div>
        <div className="filter-group">
          <label htmlFor="relance-start-date">Du</label>
          <input
            id="relance-start-date"
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
          />
        </div>
        <div className="filter-group">
          <label htmlFor="relance-end-date">Au</label>
          <input
            id="relance-end-date"
            type="date"
            value={endDate}
            min={startDate || undefined}
            onChange={(e) => setEndDate(e.target.value)}
          />
        </div>
        {hasActiveFilters && (
          <button className="btn-outline" onClick={clearFilters}>
            Effacer les filtres
          </button>
        )}
        <button 
          className="btn-outline" 
          onClick={() => loadRelances(searchTerm)}
          title="Rafraîchir"
        >
          <RefreshCw size={18} />
        </button>
      </div>

      {filteredRelances.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Prospect</th>
                  <th>Sujet</th>
                  <th>Date</th>
                  <th>Heure</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((relance) => (
                  <tr key={relance.idRelance}>
                    <td>
                      <strong>{getNomProspect(relance)}</strong></td>
                    <td>
                      <strong>{relance.sujet}</strong>
                    </td>
                    <td>{formatDate(relance.dateRelance)}</td>
                    <td>{formatTime(relance.dateRelance)}</td>
                    <td>
                      <div className="action-buttons">
                        {/* Bouton Voir */}
                        <button 
                          className="action-btn view" 
                          onClick={() => navigate(`/relances/${relance.idRelance}`)}
                          title="Voir le détail"
                        >
                          <Eye size={16} />
                        </button>
                        {/* Bouton Modifier - utilise l'ID pour le PUT */}
                        <button 
                          className="action-btn edit" 
                          onClick={() => navigate(`/relances/edit/${relance.idRelance}`)}
                          title="Modifier"
                        >
                          <Edit size={16} />
                        </button>
                        {/* Bouton Supprimer - utilise l'ID pour le DELETE */}
                        <button 
                          className="action-btn delete" 
                          onClick={() => setDeleteModal({ 
                            isOpen: true, 
                            relanceId: relance.idRelance, 
                            relanceName: relance.sujet 
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
            totalItems={filteredRelances.length}
          />
        </>
      )}
    </div>
  );
};

export default RelancesList;