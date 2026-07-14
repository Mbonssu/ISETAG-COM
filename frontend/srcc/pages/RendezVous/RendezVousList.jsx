import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Calendar, Clock, MapPin, User } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/rendezvousService.js
import { rendezvousService } from '../../services/rendezvousService';
import '../Prospects/Prospects.css';

const RendezVousList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allRdv, setAllRdv]             = useState([]);
  const [loading, setLoading]           = useState(true);
  const [loadError, setLoadError]       = useState(null);
  const [searchTerm, setSearchTerm]     = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal]   = useState({ isOpen: false, rdvId: null, rdvName: '' });
  const [toasts, setToasts]             = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchRdv = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await rendezvousService.getAll();
      setAllRdv(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des rendez-vous', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchRdv(); }, [fetchRdv]);

  const getProspect = (r) => r.prospect ?? r.prospectNom ?? r.nomProspect ?? '—';
  const getAgent    = (r) => r.agent ?? r.agentNom ?? '—';
  const getLieu     = (r) => r.lieuRv ?? r.lieu ?? '—';
  const getStatut   = (r) => r.statutRv ?? r.statut ?? r.status ?? '';
  const getDate     = (r) => r.dateRv ?? r.date ?? '—';
  const getHeure    = (r) => r.heureRv ?? r.heure ?? '';

  const statusOptions = ['Planifié', 'Confirmé', 'Effectué', 'Annulé', 'Reporté'];
  const getStatusBadge = (status) => {
    const classes = { 'Planifié': 'badge-info', 'Confirmé': 'badge-success', 'Effectué': 'badge-primary', 'Annulé': 'badge-danger', 'Reporté': 'badge-warning' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const filteredRdv = allRdv.filter(r => {
    const txt = `${getProspect(r)} ${getAgent(r)} ${getLieu(r)}`.toLowerCase();
    return txt.includes(searchTerm.toLowerCase()) && (filterStatus === 'all' || getStatut(r) === filterStatus);
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredRdv, 10);

  const handleDelete = async () => {
    const { rdvId, rdvName } = deleteModal;
    if (!rdvId) return;
    setDeleteModal({ isOpen: false, rdvId: null, rdvName: '' });
    try {
      await rendezvousService.delete(rdvId);
      addToast(`RDV "${rdvName}" ${t('suppressionReussie')}`, 'success');
      fetchRdv();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchRdv}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, rdvId: null, rdvName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer ce rendez-vous ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Gestion des Rendez-vous</h1><p className="page-description">Planifiez et suivez les rendez-vous avec les prospects.</p></div>
        <button className="btn-primary" onClick={() => navigate('/rendezvous/new')}><Plus size={18} /> Nouveau rendez-vous</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par prospect, agent ou lieu..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option>{statusOptions.map(s => <option key={s} value={s}>{s}</option>)}</select></div>
      </div>

      {filteredRdv.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Prospect</th><th>Date/Heure</th><th>Lieu</th><th>{t('statut')}</th><th>Agent</th><th>Commentaire</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(r => (
                  <tr key={r.id ?? r.idRdv}>
                    <td><User size={14} /> {getProspect(r)}</td>
                    <td><Calendar size={14} /> {getDate(r)}<br /><Clock size={14} /> {getHeure(r)}</td>
                    <td><MapPin size={14} /> {getLieu(r)}</td>
                    <td>{getStatusBadge(getStatut(r))}</td>
                    <td>{getAgent(r)}</td>
                    <td><div className="commentaire-cell"><small>{r.commentaire ?? '—'}</small></div></td>
                    <td><div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/rendezvous/${r.id ?? r.idRdv}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/rendezvous/edit/${r.id ?? r.idRdv}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, rdvId: r.id ?? r.idRdv, rdvName: getProspect(r) })}><Trash2 size={16} /></button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredRdv.length} />
        </>
      )}
    </div>
  );
};
export default RendezVousList;
