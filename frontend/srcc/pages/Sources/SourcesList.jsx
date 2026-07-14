import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/sourceService.js
import { sourceService } from '../../services/sourceService';
import '../Prospects/Prospects.css';

const SourcesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allSources, setAllSources] = useState([]);
  const [loading, setLoading]       = useState(true);
  const [loadError, setLoadError]   = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, sourceId: null, sourceName: '' });
  const [toasts, setToasts]         = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchSources = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await sourceService.getAll();
      setAllSources(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des sources', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchSources(); }, [fetchSources]);

  const filteredSources = allSources.filter(s =>
    (s.name ?? s.nom ?? '').toLowerCase().includes(searchTerm.toLowerCase())
  );

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSources, 10);

  const handleDelete = async () => {
    const { sourceId, sourceName } = deleteModal;
    if (!sourceId) return;
    setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' });
    try {
      await sourceService.delete(sourceId);
      addToast(`Source "${sourceName}" ${t('suppressionReussie')}`, 'success');
      fetchSources();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchSources}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Supprimer la source "${deleteModal.sourceName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Sources des prospects</h1><p className="page-description">Gérez les différentes sources d'acquisition de prospects.</p></div>
        <button className="btn-primary" onClick={() => navigate('/sources/new')}><Plus size={18} /> Nouvelle source</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher une source..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
      </div>

      {filteredSources.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => setSearchTerm('')}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Source</th><th>Prospects</th><th>Part</th><th>Évolution</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(s => {
                  const label    = s.name ?? s.nom ?? '';
                  const isActif  = s.actif ?? s.statut === 'actif' ?? true;
                  const evol     = s.evolution ?? null;
                  return (
                    <tr key={s.id ?? s.idSource}>
                      <td><div className="source-cell"><div className="source-color" style={{ backgroundColor: s.couleur ?? '#6366f1' }}></div><strong>{label}</strong></div></td>
                      <td className="text-center">{s.prospects ?? s.nbProspects ?? '—'}</td>
                      <td className="text-center">
                        {s.pourcentage != null
                          ? <div className="progress-bar-small"><div className="progress-fill-small" style={{ width: `${s.pourcentage}%` }}></div><span>{s.pourcentage}%</span></div>
                          : '—'}
                      </td>
                      <td>{evol ? <span className={`evolution-badge ${String(evol).includes('+') ? 'positive' : 'negative'}`}>{evol}</span> : '—'}</td>
                      <td><span className={`badge ${isActif ? 'badge-success' : 'badge-secondary'}`}>{isActif ? t('actif') : t('inactif')}</span></td>
                      <td><div className="action-buttons">
                        <button className="action-btn edit" onClick={() => navigate(`/sources/edit/${s.id ?? s.idSource}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sourceId: s.id ?? s.idSource, sourceName: label })}><Trash2 size={16} /></button>
                      </div></td>
                    </tr>
                  );
                })}
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
