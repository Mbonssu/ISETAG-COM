import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Building, MapPin, Star } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/etablissementService.js
import { etablissementService } from '../../services/etablissementService';
import '../Prospects/Prospects.css';

const EtablissementsList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allEtabs, setAllEtabs]         = useState([]);
  const [loading, setLoading]           = useState(true);
  const [loadError, setLoadError]       = useState(null);
  const [searchTerm, setSearchTerm]     = useState('');
  const [filterType, setFilterType]     = useState('all');
  const [filterVille, setFilterVille]   = useState('all');
  const [deleteModal, setDeleteModal]   = useState({ isOpen: false, etablissementId: null, etablissementName: '' });
  const [toasts, setToasts]             = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchEtabs = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await etablissementService.getAll();
      setAllEtabs(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des établissements', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchEtabs(); }, [fetchEtabs]);

  const villes = [...new Set(allEtabs.map(e => e.ville).filter(Boolean))];
  const types  = [...new Set(allEtabs.map(e => e.type ?? e.typeEtablissement).filter(Boolean))];

  const filteredEtabs = allEtabs.filter(e => {
    const txt = `${e.name ?? e.nom ?? ''} ${e.ville ?? ''}`.toLowerCase();
    const type = e.type ?? e.typeEtablissement ?? '';
    return txt.includes(searchTerm.toLowerCase())
      && (filterType  === 'all' || type === filterType)
      && (filterVille === 'all' || e.ville === filterVille);
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredEtabs, 10);

  const handleDelete = async () => {
    const { etablissementId, etablissementName } = deleteModal;
    if (!etablissementId) return;
    setDeleteModal({ isOpen: false, etablissementId: null, etablissementName: '' });
    try {
      await etablissementService.delete(etablissementId);
      addToast(`"${etablissementName}" ${t('suppressionReussie')}`, 'success');
      fetchEtabs();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  const getLabel   = (e) => e.name ?? e.nom ?? '';
  const getRating  = (e) => e.rating ?? e.note ?? null;
  const getRatingStars = (rating) => Array.from({ length: Math.floor(rating) }, (_, i) => <Star key={i} size={14} fill="#f5c842" color="#f5c842" />);

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchEtabs}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, etablissementId: null, etablissementName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Supprimer l'établissement "${deleteModal.etablissementName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Établissements</h1><p className="page-description">Gérez les lycées, universités et instituts partenaires.</p></div>
        <button className="btn-primary" onClick={() => navigate('/etablissements/new')}><Plus size={18} /> Nouvel établissement</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher un établissement..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={e => setFilterType(e.target.value)}><option value="all">{t('tousTypes')}</option>{types.map(tp => <option key={tp} value={tp}>{tp}</option>)}</select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterVille} onChange={e => setFilterVille(e.target.value)}><option value="all">Toutes les villes</option>{villes.map(v => <option key={v} value={v}>{v}</option>)}</select></div>
      </div>

      {filteredEtabs.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterVille('all'); }}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Établissement</th><th>Type</th><th>Adresse</th><th>Contacts</th><th>Prospects</th><th>Agent</th><th>Note</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(e => {
                  const rating = getRating(e);
                  return (
                    <tr key={e.id ?? e.idEtablissement}>
                      <td><div className="etablissement-cell"><Building size={14} /><strong>{getLabel(e)}</strong></div></td>
                      <td><span className="type-badge">{e.type ?? e.typeEtablissement ?? '—'}</span></td>
                      <td><div><MapPin size={12} /> {e.adresse ?? '—'}</div><small>{e.ville}</small></td>
                      <td className="text-center">{e.contacts ?? e.nbContacts ?? '—'}</td>
                      <td className="text-center">{e.prospects ?? e.nbProspects ?? '—'}</td>
                      <td>{e.agent ?? e.agentNom ?? '—'}</td>
                      <td>{rating != null ? <div className="rating-stars">{getRatingStars(rating)} ({rating})</div> : '—'}</td>
                      <td><div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/etablissements/${e.id ?? e.idEtablissement}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/etablissements/edit/${e.id ?? e.idEtablissement}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, etablissementId: e.id ?? e.idEtablissement, etablissementName: getLabel(e) })}><Trash2 size={16} /></button>
                      </div></td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredEtabs.length} />
        </>
      )}
    </div>
  );
};
export default EtablissementsList;
