import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, MapPin, Globe } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/zoneService.js
import { zoneService } from '../../services/zoneService';
import '../Prospects/Prospects.css';

const ZonesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allZones, setAllZones]         = useState([]);
  const [loading, setLoading]           = useState(true);
  const [loadError, setLoadError]       = useState(null);
  const [searchTerm, setSearchTerm]     = useState('');
  const [filterVille, setFilterVille]   = useState('all');
  const [filterRegion, setFilterRegion] = useState('all');
  const [deleteModal, setDeleteModal]   = useState({ isOpen: false, zoneId: null, zoneName: '' });
  const [toasts, setToasts]             = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchZones = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await zoneService.getAll();
      setAllZones(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des zones', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchZones(); }, [fetchZones]);

  // Listes dynamiques calculées depuis l'API
  const villes  = [...new Set(allZones.map(z => z.ville).filter(Boolean))];
  const regions = [...new Set(allZones.map(z => z.region).filter(Boolean))];

  const filteredZones = allZones.filter(z => {
    const txt = `${z.quartier ?? ''} ${z.code ?? ''} ${z.description ?? ''}`.toLowerCase();
    return txt.includes(searchTerm.toLowerCase())
      && (filterVille  === 'all' || z.ville  === filterVille)
      && (filterRegion === 'all' || z.region === filterRegion);
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredZones, 10);

  const handleDelete = async () => {
    const { zoneId, zoneName } = deleteModal;
    if (!zoneId) return;
    setDeleteModal({ isOpen: false, zoneId: null, zoneName: '' });
    try {
      await zoneService.delete(zoneId);
      addToast(`Zone "${zoneName}" ${t('suppressionReussie')}`, 'success');
      fetchZones();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading) return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchZones}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, zoneId: null, zoneName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Supprimer la zone "${deleteModal.zoneName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Gestion des Zones</h1><p className="page-description">Définissez et gérez les zones géographiques d'intervention.</p></div>
        <button className="btn-primary" onClick={() => navigate('/zones/new')}><Plus size={18} /> Nouvelle zone</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par quartier, code ou description..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterVille} onChange={e => setFilterVille(e.target.value)}><option value="all">Toutes les villes</option>{villes.map(v => <option key={v} value={v}>{v}</option>)}</select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterRegion} onChange={e => setFilterRegion(e.target.value)}><option value="all">Toutes les régions</option>{regions.map(r => <option key={r} value={r}>{r}</option>)}</select></div>
      </div>

      {filteredZones.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterVille('all'); setFilterRegion('all'); }}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Code</th><th>Quartier</th><th>{t('ville')}</th><th>Région</th><th>Lieu départ</th><th>Lieu fin</th><th>Description</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(z => (
                  <tr key={z.id ?? z.idZone}>
                    <td><span className="code-badge">{z.code}</span></td>
                    <td><MapPin size={14} /> {z.quartier}</td>
                    <td>{z.ville}</td>
                    <td>{z.region} {z.pays && <><Globe size={12} /> {z.pays}</>}</td>
                    <td>{z.lieuDepart}</td>
                    <td>{z.lieuFin}</td>
                    <td><div className="commentaire-cell"><small>{z.description}</small></div></td>
                    <td><div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/zones/${z.id ?? z.idZone}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/zones/edit/${z.id ?? z.idZone}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, zoneId: z.id ?? z.idZone, zoneName: z.quartier })}><Trash2 size={16} /></button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredZones.length} />
        </>
      )}
    </div>
  );
};
export default ZonesList;
