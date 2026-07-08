import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/filiereService.js
import { filiereService } from '../../services/filiereService';
import '../Prospects/Prospects.css';

const FilieresList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allFilieres, setAllFilieres] = useState([]);
  const [loading, setLoading]         = useState(true);
  const [loadError, setLoadError]     = useState(null);
  const [searchTerm, setSearchTerm]   = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, filiereId: null, filiereName: '' });
  const [toasts, setToasts]           = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchFilieres = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await filiereService.getAll();
      setAllFilieres(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des filières', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchFilieres(); }, [fetchFilieres]);

  const filteredFilieres = allFilieres.filter(f => {
    const label = `${f.name ?? f.nom ?? ''} ${f.code ?? ''}`.toLowerCase();
    return label.includes(searchTerm.toLowerCase());
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredFilieres, 10);

  const handleDelete = async () => {
    const { filiereId, filiereName } = deleteModal;
    if (!filiereId) return;
    setDeleteModal({ isOpen: false, filiereId: null, filiereName: '' });
    try {
      await filiereService.delete(filiereId);
      addToast(`Filière "${filiereName}" ${t('suppressionReussie')}`, 'success');
      fetchFilieres();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  const getLabel = (f) => f.name ?? f.nom ?? '';
  const getSpecialites = (f) => {
    const s = f.specialites ?? f.specialites_list ?? [];
    return Array.isArray(s) ? s : [];
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchFilieres}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, filiereId: null, filiereName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Supprimer la filière "${deleteModal.filiereName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Filières & Spécialités</h1><p className="page-description">Gérez les filières de formation et leurs spécialités.</p></div>
        <button className="btn-primary" onClick={() => navigate('/filieres/new')}><Plus size={18} /> Nouvelle filière</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher une filière..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
      </div>

      {filteredFilieres.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => setSearchTerm('')}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Code</th><th>Filière</th><th>Spécialités</th><th>Prospects</th><th>Part</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(f => {
                  const specialites = getSpecialites(f);
                  const isActif = f.actif ?? f.statut === 'actif' ?? true;
                  return (
                    <tr key={f.id ?? f.idFiliere}>
                      <td><span className="code-badge">{f.code}</span></td>
                      <td><strong>{getLabel(f)}</strong></td>
                      <td>
                        <div className="specialites-list">
                          {specialites.slice(0, 2).map((s, i) => <span key={i} className="specialite-tag">{s?.nom ?? s?.name ?? s}</span>)}
                          {specialites.length > 2 && <span className="specialite-tag more">+{specialites.length - 2}</span>}
                        </div>
                      </td>
                      <td className="text-center">{f.prospects ?? f.nbProspects ?? '—'}</td>
                      <td className="text-center">
                        {f.pourcentage != null
                          ? <div className="progress-bar-small"><div className="progress-fill-small" style={{ width: `${f.pourcentage}%` }}></div><span>{f.pourcentage}%</span></div>
                          : '—'}
                      </td>
                      <td><span className={`badge ${isActif ? 'badge-success' : 'badge-secondary'}`}>{isActif ? t('actif') : t('inactif')}</span></td>
                      <td><div className="action-buttons">
                        <button className="action-btn edit" onClick={() => navigate(`/filieres/edit/${f.id ?? f.idFiliere}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, filiereId: f.id ?? f.idFiliere, filiereName: getLabel(f) })}><Trash2 size={16} /></button>
                      </div></td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredFilieres.length} />
        </>
      )}
    </div>
  );
};
export default FilieresList;
