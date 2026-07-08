import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, AlertCircle, Calendar, User, Star } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
// 🔧 ROUTE — modifier BASE_URL dans src/services/ficheService.js
import { ficheService } from '../../services/ficheService';
import '../Prospects/Prospects.css';

const FichesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [allFiches, setAllFiches]   = useState([]);
  const [loading, setLoading]       = useState(true);
  const [loadError, setLoadError]   = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, ficheId: null, ficheName: '' });
  const [toasts, setToasts]         = useState([]);

  const addToast = (msg, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message: msg, type }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 3000);
  };

  const fetchFiches = useCallback(async () => {
    setLoading(true); setLoadError(null);
    try {
      const data = await ficheService.getAll();
      setAllFiches(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      setLoadError(err.message);
      addToast('Erreur lors du chargement des fiches', 'error');
    } finally { setLoading(false); }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => { fetchFiches(); }, [fetchFiches]);

  const getProspect = (f) => f.prospect ?? f.prospectNom ?? f.nomProspect ?? '—';
  const getSource   = (f) => f.source ?? f.sourceNom ?? f.nomSource ?? '—';
  const getAgent    = (f) => f.agent ?? f.agentNom ?? '—';
  const getScore    = (f) => f.scoreInteret ?? f.score ?? null;
  const getDate     = (f) => f.dateCollecte ?? f.date ?? '—';
  const getCampagne = (f) => f.campagne ?? f.campagneNom ?? f.nomCampagne ?? '—';

  const getScoreColor = (score) => score >= 80 ? '#10b981' : score >= 60 ? '#f59e0b' : '#ef4444';
  const getScoreLabel = (score) => score >= 80 ? 'Très intéressé' : score >= 60 ? 'Intéressé' : score >= 40 ? 'Moyennement intéressé' : 'Peu intéressé';

  const filteredFiches = allFiches.filter(f => {
    const txt = `${getProspect(f)} ${getSource(f)} ${getAgent(f)}`.toLowerCase();
    return txt.includes(searchTerm.toLowerCase());
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredFiches, 10);

  const handleDelete = async () => {
    const { ficheId, ficheName } = deleteModal;
    if (!ficheId) return;
    setDeleteModal({ isOpen: false, ficheId: null, ficheName: '' });
    try {
      await ficheService.delete(ficheId);
      addToast(`Fiche "${ficheName}" ${t('suppressionReussie')}`, 'success');
      fetchFiches();
    } catch { addToast('Erreur lors de la suppression', 'error'); }
  };

  if (loading)   return <div className="page-container"><p className="text-center">{t('chargement')}</p></div>;
  if (loadError) return <div className="page-container"><p className="text-center text-danger">Erreur : {loadError}</p><button className="btn-outline" onClick={fetchFiches}>Réessayer</button></div>;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={id => setToasts(p => p.filter(t => t.id !== id))} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, ficheId: null, ficheName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer cette fiche ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">Gestion des Fiches</h1><p className="page-description">Consultez les fiches de collecte d'informations des prospects.</p></div>
        <button className="btn-primary" onClick={() => navigate('/fiches/new')}><Plus size={18} /> Nouvelle fiche</button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher par prospect, source ou agent..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} /></div>
      </div>

      {filteredFiches.length === 0 ? (
        <div className="no-results"><AlertCircle size={48} /><h3>{t('aucunResultat')}</h3><button className="btn-outline" onClick={() => setSearchTerm('')}>{t('effacerFiltres')}</button></div>
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Prospect</th><th>Source</th><th>Date collecte</th><th>Score d'intérêt</th><th>Commentaire</th><th>Campagne</th><th>Agent</th><th>{t('actions')}</th></tr></thead>
              <tbody>
                {paginatedItems.map(f => {
                  const score = getScore(f);
                  return (
                    <tr key={f.id ?? f.idFiche}>
                      <td><User size={14} /> {getProspect(f)}</td>
                      <td>{getSource(f)}</td>
                      <td><Calendar size={14} /> {getDate(f)}</td>
                      <td>
                        {score != null
                          ? <div className="score-cell"><div className="score-value" style={{ color: getScoreColor(score) }}><Star size={14} /> {score}%</div><small>{getScoreLabel(score)}</small></div>
                          : '—'}
                      </td>
                      <td><div className="commentaire-cell"><small>{f.commentaire ?? '—'}</small></div></td>
                      <td>{getCampagne(f)}</td>
                      <td>{getAgent(f)}</td>
                      <td><div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/fiches/${f.id ?? f.idFiche}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/fiches/edit/${f.id ?? f.idFiche}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, ficheId: f.id ?? f.idFiche, ficheName: getProspect(f) })}><Trash2 size={16} /></button>
                      </div></td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredFiches.length} />
        </>
      )}
    </div>
  );
};
export default FichesList;
