import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, Mail, Smartphone, Phone, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { campagneService } from '../../services/campagneService';
import { useTranslation } from '../../hooks/useTranslation';
import { SkeletonTable } from '../../components/Skeleton/Skeleton';
import '../Prospects/Prospects.css';

//  CORRIGÉ : plus de colonnes "Statut"/"Agent"/"Prospects"/"Taux" —
// aucun de ces champs n'existe côté backend (schéma CampagneProspection).

const CampagnesList = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, campagneId: null, campagneName: '' });
  const [toasts, setToasts] = useState([]);
  const [campagnes, setCampagnes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  const fetchCampagnes = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await campagneService.getAll();
      setCampagnes(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      console.error(' Erreur de chargement:', err);
      setError(err.message);
      addToast('Erreur lors du chargement des campagnes', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchCampagnes(); }, []);

  const getTypeIcon = (type) => {
    switch (type) {
      case 'Email': return <Mail size={16} />;
      case 'SMS': return <Smartphone size={16} />;
      case 'Appel': return <Phone size={16} />;
      default: return <Mail size={16} />;
    }
  };

  const formatDate = (d) => (d ? new Date(d).toLocaleDateString('fr-FR') : '-');

  const filteredCampagnes = campagnes.filter(c => {
    const matchesSearch = (c.libele || '').toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || c.type === filterType;
    return matchesSearch && matchesType;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredCampagnes, 10);

  const handleDelete = async () => {
    try {
      await campagneService.delete(deleteModal.campagneId);
      addToast(`Campagne "${deleteModal.campagneName}" supprimée avec succès`, 'success');
      fetchCampagnes();
    } catch (err) {
      addToast('Erreur lors de la suppression', 'error');
    }
    setDeleteModal({ isOpen: false, campagneId: null, campagneName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune campagne ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); }}>Effacer les filtres</button>
    </div>
  );

  if (loading) {
    return <div className="page-container"><SkeletonTable rows={6} columns={5} /></div>;
  }
  if (error) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn-outline" onClick={fetchCampagnes}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, campagneId: null, campagneName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer la campagne "${deleteModal.campagneName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('gestionCampagnes')}</h1>
          <p className="page-description">{t('descCampagnes')}</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/campagnes/new')}>
          <Plus size={18} /> {t('nouvelleCampagne')}
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher une campagne..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterType} onChange={(e) => setFilterType(e.target.value)}>
            <option value="all">Tous les types</option>
            <option value="Email">Email</option>
            <option value="SMS">SMS</option>
            <option value="Appel">Appel</option>
          </select>
        </div>
      </div>

      {filteredCampagnes.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Nom</th><th>Type</th><th>Période</th><th>Objectif</th><th>Actions</th></tr>
              </thead>
              <tbody>
                {paginatedItems.map((campagne) => (
                  <tr key={campagne.idCampagne}>
                    <td><strong>{campagne.libele}</strong></td>
                    <td><div className="type-badge">{getTypeIcon(campagne.type)}<span>{campagne.type}</span></div></td>
                    <td><div className="date-range"><small>{formatDate(campagne.dateDebut)}</small><small>→</small><small>{formatDate(campagne.dateFin)}</small></div></td>
                    <td>{campagne.objectif}</td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/campagnes/${campagne.idCampagne}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/campagnes/edit/${campagne.idCampagne}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, campagneId: campagne.idCampagne, campagneName: campagne.libele })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredCampagnes.length} />
        </>
      )}
    </div>
  );
};

export default CampagnesList;