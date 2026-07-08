import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Mail, Phone, Calendar } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/userService.js
//   et adapter le filtre role='superviseur' si nécessaire
import { userService } from '../../services/userService';
import '../Prospects/Prospects.css';

const SuperviseursList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allSuperviseurs, setAllSuperviseurs] = useState([]);
  const [loading, setLoading]                 = useState(true);
  const [loadError, setLoadError]             = useState(null);
  const [searchTerm, setSearchTerm]           = useState('');
  const [filterStatus, setFilterStatus]       = useState('all');
  const [deleteModal, setDeleteModal]         = useState({ isOpen: false, superviseurId: null, superviseurName: '' });
  const [toasts, setToasts]                   = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchSuperviseurs = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      // 🔧 Si ton ami expose une route dédiée /superviseur_api/..., remplace
      //    userService.getAll par superviseurService.getAll ici
      const data = await userService.getAll({ role: 'superviseur' });
      const list = Array.isArray(data) ? data : (data?.results ?? []);
      // Garde uniquement les superviseurs si le backend renvoie tout le monde
      setAllSuperviseurs(list.filter(u => !u.role || u.role === 'superviseur' || u.role === 'Superviseur'));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des superviseurs', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchSuperviseurs(); }, [fetchSuperviseurs]);

  const getNom     = (s) => s.nom ?? s.last_name ?? s.lastName ?? '';
  const getPrenom  = (s) => s.prenom ?? s.first_name ?? s.firstName ?? '';
  const getAvatar  = (s) => s.avatar ?? `${getPrenom(s)[0] ?? ''}${getNom(s)[0] ?? ''}`.toUpperCase();
  const isActif    = (s) => s.actif ?? s.is_active ?? s.statut === 'actif' ?? true;
  const getDate    = (s) => s.dateEmbauche ?? s.date_joined ?? s.dateCreation ?? '—';
  const getMatricule = (s) => s.matricule ?? s.username ?? '—';

  const filteredSuperviseurs = allSuperviseurs.filter(s => {
    const txt = `${getNom(s)} ${getPrenom(s)} ${s.email ?? ''}`.toLowerCase();
    const actif = isActif(s);
    return txt.includes(searchTerm.toLowerCase())
      && (filterStatus === 'all' || (filterStatus === 'actif' ? actif : !actif));
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredSuperviseurs, 10);

  const handleDelete = async () => {
    const { superviseurId, superviseurName } = deleteModal;
    if (!superviseurId) return;
    setDeleteModal({ isOpen: false, superviseurId: null, superviseurName: '' });
    try {
      await userService.delete(superviseurId);
      addToast(`"${superviseurName}" ${t('suppressionReussie')}`, 'success');
      fetchSuperviseurs();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchSuperviseurs}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, superviseurId: null, superviseurName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Supprimer "${deleteModal.superviseurName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Gestion des Superviseurs</h1><p className="page-description">Gérez les superviseurs qui encadrent les agents commerciaux.</p></div>
        <button className="btn-primary" onClick={() => navigate('/superviseurs/new')}><Plus size={18} /> Nouveau superviseur</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par nom, prénom ou email..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option><option value="actif">{t('actif')}</option><option value="inactif">{t('inactif')}</option></select></div>
      </div>

      {filteredSuperviseurs.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Superviseur</th><th>{t('contact')}</th><th>Matricule</th><th>Date embauche</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(s => (
                  <tr key={s.id ?? s.idUtilisateur}>
                    <td><div className="user-cell"><div className="user-avatar">{getAvatar(s)}</div><div><strong>{getNom(s)} {getPrenom(s)}</strong></div></div></td>
                    <td><div><Mail size={12} /> {s.email ?? '—'}</div><small><Phone size={10} /> {s.telephone ?? '—'}</small></td>
                    <td><span className="badge badge-info">{getMatricule(s)}</span></td>
                    <td><Calendar size={14} /> {getDate(s)}</td>
                    <td><span className={`badge ${isActif(s) ? 'badge-success' : 'badge-secondary'}`}>{isActif(s) ? t('actif') : t('inactif')}</span></td>
                    <td><div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/superviseurs/${s.id ?? s.idUtilisateur}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/superviseurs/edit/${s.id ?? s.idUtilisateur}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, superviseurId: s.id ?? s.idUtilisateur, superviseurName: `${getNom(s)} ${getPrenom(s)}` })}><Trash2 size={16} /></button>
                    </div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredSuperviseurs.length} />
        </>
      )}
    </div>
  );
};
export default SuperviseursList;
