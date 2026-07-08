import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Calendar, MapPin, Target, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { sortieService } from '../../services/sortieService';
import '../Prospects/Prospects.css';

// ⚠️ CORRIGÉ : plus de colonne "Agent" (n'existe pas côté backend, géré
// via Participation séparément). Zone affichée via zone_detail (renvoyé
// automatiquement par le backend), plus de champ zone en texte libre.

const typesSortie = ['Prospection', 'Suivi', 'Formation', 'Réunion', 'Autre'];
const statutsSortie = ['Planifiée', 'En cours', 'Effectuée', 'Annulée', 'Reportée'];

const SortiesList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, sortieId: null, sortieName: '' });
  const [toasts, setToasts] = useState([]);
  const [sorties, setSorties] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  const fetchSorties = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await sortieService.getAll();
      console.log('📥 Sorties chargées:', data);
      setSorties(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      console.error('❌ Erreur de chargement:', err);
      setError(err.message);
      addToast('Erreur lors du chargement des sorties', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchSorties(); }, []);

  const getZoneNom = (s) => s.zone_detail?.libele || s.idZone || '-';

  const getStatusBadge = (status) => {
    const classes = {
      'Planifiée': 'badge-info', 'En cours': 'badge-warning', 'Effectuée': 'badge-success',
      'Annulée': 'badge-danger', 'Reportée': 'badge-secondary'
    };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const filteredSorties = sorties.filter(s => {
    const term = searchTerm.toLowerCase();
    const matchesSearch = (s.typeSortie || '').toLowerCase().includes(term) ||
                          (s.objectif || '').toLowerCase().includes(term) ||
                          getZoneNom(s).toLowerCase().includes(term);
    const matchesType = filterType === 'all' || s.typeSortie === filterType;
    const matchesStatus = filterStatus === 'all' || s.statut === filterStatus;
    return matchesSearch && matchesType && matchesStatus;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSorties, 10);

  const handleDelete = async () => {
    try {
      await sortieService.delete(deleteModal.sortieId);
      addToast('Sortie supprimée avec succès', 'success');
      fetchSorties();
    } catch (err) {
      addToast('Erreur lors de la suppression', 'error');
    }
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

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement des sorties...</p></div></div>;
  }
  if (error) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn-outline" onClick={fetchSorties}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sortieId: null, sortieName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message="Êtes-vous sûr de vouloir supprimer cette sortie ?" confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Sorties</h1>
          <p className="page-description">Planifiez et suivez les sorties terrain.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/sorties/new')}>
          <Plus size={18} /> Nouvelle sortie
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par type, objectif ou zone..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
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
                <tr><th>Type</th><th>Date</th><th>Statut</th><th>Objectif</th><th>Zone</th><th>Actions</th></tr>
              </thead>
              <tbody>
                {paginatedItems.map((sortie) => (
                  <tr key={sortie.idSortie}>
                    <td><span className="badge badge-info">{sortie.typeSortie}</span></td>
                    <td><Calendar size={14} /> {sortie.dateSortie ? new Date(sortie.dateSortie).toLocaleString('fr-FR') : '-'}</td>
                    <td>{getStatusBadge(sortie.statut)}</td>
                    <td><Target size={14} /> {sortie.objectif}</td>
                    <td><MapPin size={14} /> {getZoneNom(sortie)}</td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/sorties/${sortie.idSortie}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/sorties/edit/${sortie.idSortie}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sortieId: sortie.idSortie, sortieName: sortie.typeSortie })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredSorties.length} />
        </>
      )}
    </div>
  );
};

export default SortiesList;