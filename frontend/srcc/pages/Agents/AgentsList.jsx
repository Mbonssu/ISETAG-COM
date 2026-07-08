import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/agentService.js
import { agentService } from '../../services/agentService';
import '../Prospects/Prospects.css';

const AgentsList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allAgents, setAllAgents]     = useState([]);
  const [loading, setLoading]         = useState(true);
  const [loadError, setLoadError]     = useState(null);
  const [searchTerm, setSearchTerm]   = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, agentId: null, agentName: '' });
  const [toasts, setToasts]           = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchAgents = useCallback(async () => {
    setLoading(true);
    setLoadError(null);
    try {
      const data = await agentService.getAll();
      setAllAgents(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des agents', 'error');
    } finally {
      setLoading(false);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchAgents(); }, [fetchAgents]);

  const filteredAgents = allAgents.filter(a => {
    const name  = `${a.nom ?? ''} ${a.prenom ?? ''} ${a.name ?? ''}`.toLowerCase();
    const email = (a.email ?? '').toLowerCase();
    const phone = a.telephone ?? a.phone ?? '';
    const matchesSearch = name.includes(searchTerm.toLowerCase()) || email.includes(searchTerm.toLowerCase()) || phone.includes(searchTerm);
    const matchesStatus = filterStatus === 'all' || a.statut === filterStatus || a.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredAgents, 10);

  const handleDelete = async () => {
    const { agentId, agentName } = deleteModal;
    if (!agentId) return;
    setDeleteModal({ isOpen: false, agentId: null, agentName: '' });
    try {
      await agentService.delete(agentId);
      addToast(`${agentName} ${t('suppressionReussie')}`, 'success');
      fetchAgents();
    } catch {
      addToast('Erreur lors de la suppression', 'error');
    }
  };

  const getLabel = (a) => a.name ?? `${a.prenom ?? ''} ${a.nom ?? ''}`.trim();
  const getAvatar = (a) => a.avatar ?? getLabel(a).split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase();

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun agent ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  if (loading) return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchAgents}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, agentId: null, agentName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Supprimer l'agent "${deleteModal.agentName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Agents</h1>
          <p className="page-description">Gérez les agents commerciaux et leurs performances.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/agents/new')}><Plus size={18} /> Nouvel agent</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par nom, email ou téléphone..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option><option value="actif">{t('actif')}</option><option value="inactif">{t('inactif')}</option></select></div>
      </div>

      {filteredAgents.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Agent</th><th>{t('contact')}</th><th>{t('zone')}</th><th>Prospects</th><th>{t('conversions')}</th><th>Taux</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(a => (
                  <tr key={a.id ?? a.idAgent}>
                    <td><div className="agent-cell"><div className="agent-avatar">{getAvatar(a)}</div><strong>{getLabel(a)}</strong></div></td>
                    <td><div>{a.email}</div><small>{a.telephone ?? a.phone}</small></td>
                    <td>{a.zone ?? a.idZone}</td>
                    <td className="text-center">{a.prospects ?? '—'}</td>
                    <td className="text-center">{a.converted ?? a.conversions ?? '—'}</td>
                    <td className="text-center"><span className="rate-badge">{a.taux != null ? `${a.taux}%` : '—'}</span></td>
                    <td><span className={`badge ${(a.statut ?? a.status) === 'actif' ? 'badge-success' : 'badge-secondary'}`}>{(a.statut ?? a.status) === 'actif' ? t('actif') : t('inactif')}</span></td>
                    <td><div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/agents/${a.id ?? a.idAgent}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/agents/edit/${a.id ?? a.idAgent}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, agentId: a.id ?? a.idAgent, agentName: getLabel(a) })}><Trash2 size={16} /></button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredAgents.length} />
        </>
      )}
    </div>
  );
};

export default AgentsList;
