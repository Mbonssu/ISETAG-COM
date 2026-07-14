import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Filter, AlertCircle, Bell, Clock, CheckCircle, AlertCircle as AlertIcon, Phone, Mail, MessageSquare } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/relanceService.js
import { relanceService } from '../../services/relanceService';
import '../Prospects/Prospects.css';

const RelancesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allRelances, setAllRelances]   = useState([]);
  const [loading, setLoading]           = useState(true);
  const [loadError, setLoadError]       = useState(null);
  const [searchTerm, setSearchTerm]     = useState('');
  const [filterType, setFilterType]     = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal]   = useState({ isOpen: false, relanceId: null, relanceName: '' });
  const [toasts, setToasts]             = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchRelances = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await relanceService.getAll();
      setAllRelances(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des relances', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchRelances(); }, [fetchRelances]);

  const getTypeIcon = (type) => {
    switch (type) {
      case 'Email': return <Mail size={16} />;
      case 'Appel': return <Phone size={16} />;
      case 'SMS':   return <MessageSquare size={16} />;
      default:      return <Bell size={16} />;
    }
  };

  const getStatusBadge = (status) => {
    const classes = { 'En attente': 'badge-warning', 'Programmée': 'badge-info', 'Effectuée': 'badge-success' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const getPrioriteIcon = (p) => {
    switch (p) {
      case 'Haute':   return <AlertIcon size={14} color="#ef4444" />;
      case 'Moyenne': return <Clock size={14} color="#f59e0b" />;
      case 'Basse':   return <CheckCircle size={14} color="#10b981" />;
      default:        return <Bell size={14} />;
    }
  };

  const getProspectLabel = (r) => r.prospect ?? r.prospectNom ?? r.nomProspect ?? '—';
  const getAgentLabel    = (r) => r.agent ?? r.agentNom ?? r.nomAgent ?? '—';
  const getType          = (r) => r.type ?? r.typeRelance ?? '';
  const getStatus        = (r) => r.status ?? r.statut ?? r.statutRelance ?? '';
  const getPriorite      = (r) => r.priorite ?? r.prioriteRelance ?? '';

  const filteredRelances = allRelances.filter(r => {
    const txt = `${getProspectLabel(r)} ${getAgentLabel(r)}`.toLowerCase();
    return txt.includes(searchTerm.toLowerCase())
      && (filterType   === 'all' || getType(r)   === filterType)
      && (filterStatus === 'all' || getStatus(r) === filterStatus);
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredRelances, 10);

  const handleDelete = async () => {
    const { relanceId, relanceName } = deleteModal;
    if (!relanceId) return;
    setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' });
    try {
      await relanceService.delete(relanceId);
      addToast(`Relance "${relanceName}" ${t('suppressionReussie')}`, 'success');
      fetchRelances();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchRelances}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer cette relance ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Gestion des Relances</h1><p className="page-description">Planifiez et suivez les relances auprès des prospects.</p></div>
        <button className="btn-primary" onClick={() => navigate('/relances/new')}><Plus size={18} /> Nouvelle relance</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par prospect ou agent..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={e => setFilterType(e.target.value)}><option value="all">{t('tousTypes')}</option><option value="Email">Email</option><option value="Appel">Appel</option><option value="SMS">SMS</option></select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option><option value="En attente">En attente</option><option value="Programmée">Programmée</option><option value="Effectuée">Effectuée</option></select></div>
      </div>

      {filteredRelances.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterStatus('all'); }}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Prospect</th><th>Type</th><th>Message</th><th>Date/Heure</th><th>Priorité</th><th>{t('statut')}</th><th>Agent</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(r => (
                  <tr key={r.id ?? r.idRelance}>
                    <td><strong>{getProspectLabel(r)}</strong></td>
                    <td><div className="type-badge">{getTypeIcon(getType(r))}<span>{getType(r)}</span></div></td>
                    <td><div className="relance-message"><small>{r.message ?? r.messageRelance ?? '—'}</small></div></td>
                    <td><div className="date-time"><div>{r.date ?? r.dateRelance ?? '—'}</div><small>{r.heure ?? r.heureRelance ?? ''}</small></div></td>
                    <td><div className="priority-badge">{getPrioriteIcon(getPriorite(r))}<span className={`priority-${(getPriorite(r) ?? '').toLowerCase()}`}>{getPriorite(r) ?? '—'}</span></div></td>
                    <td>{getStatusBadge(getStatus(r))}</td>
                    <td>{getAgentLabel(r)}</td>
                    <td><div className="action-buttons">
                      <button className="action-btn edit" onClick={() => navigate(`/relances/edit/${r.id ?? r.idRelance}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, relanceId: r.id ?? r.idRelance, relanceName: getProspectLabel(r) })}><Trash2 size={16} /></button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredRelances.length} />
        </>
      )}
    </div>
  );
};
export default RelancesList;
