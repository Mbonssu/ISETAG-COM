import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Calendar, MapPin, User, Target } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/sortieService.js
import { sortieService } from '../../services/sortieService';
import '../Prospects/Prospects.css';

const SortiesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allSorties, setAllSorties]     = useState([]);
  const [loading, setLoading]           = useState(true);
  const [loadError, setLoadError]       = useState(null);
  const [searchTerm, setSearchTerm]     = useState('');
  const [filterType, setFilterType]     = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal]   = useState({ isOpen: false, sortieId: null, sortieName: '' });
  const [toasts, setToasts]             = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchSorties = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await sortieService.getAll();
      setAllSorties(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des sorties', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchSorties(); }, [fetchSorties]);

  const typesSortie   = [...new Set(allSorties.map(s => s.typeSortie ?? s.type).filter(Boolean))];
  const statutsSortie = [...new Set(allSorties.map(s => s.statut ?? s.status).filter(Boolean))];

  const getType   = (s) => s.typeSortie ?? s.type ?? '—';
  const getStatut = (s) => s.statut ?? s.status ?? '';
  const getAgent  = (s) => s.agent ?? s.agentNom ?? '—';
  const getZone   = (s) => s.zone ?? s.zoneNom ?? s.idZone ?? '—';
  const getDate   = (s) => s.dateSortie ?? s.date ?? '—';

  const getStatusBadge = (status) => {
    const classes = { 'Planifiée': 'badge-info', 'En cours': 'badge-warning', 'Effectuée': 'badge-success', 'Annulée': 'badge-danger', 'Reportée': 'badge-secondary' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const filteredSorties = allSorties.filter(s => {
    const txt = `${getType(s)} ${getAgent(s)} ${getZone(s)}`.toLowerCase();
    return txt.includes(searchTerm.toLowerCase())
      && (filterType   === 'all' || getType(s)   === filterType)
      && (filterStatus === 'all' || getStatut(s) === filterStatus);
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSorties, 10);

  const handleDelete = async () => {
    const { sortieId, sortieName } = deleteModal;
    if (!sortieId) return;
    setDeleteModal({ isOpen: false, sortieId: null, sortieName: '' });
    try {
      await sortieService.delete(sortieId);
      addToast(`Sortie "${sortieName}" ${t('suppressionReussie')}`, 'success');
      fetchSorties();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchSorties}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sortieId: null, sortieName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer cette sortie ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Gestion des Sorties</h1><p className="page-description">Planifiez et suivez les sorties terrain des agents.</p></div>
        <button className="btn-primary" onClick={() => navigate('/sorties/new')}><Plus size={18} /> Nouvelle sortie</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par type, agent ou zone..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={e => setFilterType(e.target.value)}><option value="all">{t('tousTypes')}</option>{typesSortie.map(tp => <option key={tp} value={tp}>{tp}</option>)}</select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option>{statutsSortie.map(st => <option key={st} value={st}>{st}</option>)}</select></div>
      </div>

      {filteredSorties.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterStatus('all'); }}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Type</th><th>Date</th><th>{t('statut')}</th><th>Objectif</th><th>Commentaire</th><th>Agent</th><th>Zone</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(s => (
                  <tr key={s.id ?? s.idSortie}>
                    <td><span className="badge badge-info">{getType(s)}</span></td>
                    <td><Calendar size={14} /> {getDate(s)}</td>
                    <td>{getStatusBadge(getStatut(s))}</td>
                    <td><Target size={14} /> {s.objectif ?? '—'}</td>
                    <td><div className="commentaire-cell"><small>{s.commentaire ?? '—'}</small></div></td>
                    <td><User size={14} /> {getAgent(s)}</td>
                    <td><MapPin size={14} /> {getZone(s)}</td>
                    <td><div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/sorties/${s.id ?? s.idSortie}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/sorties/edit/${s.id ?? s.idSortie}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sortieId: s.id ?? s.idSortie, sortieName: getType(s) })}><Trash2 size={16} /></button>
                    </div></td>
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
