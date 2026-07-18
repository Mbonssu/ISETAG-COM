import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, MapPin, Phone, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { etablissementService } from '../../services/etablissementService';
import { useTranslation } from '../../hooks/useTranslation';
import { SkeletonTable } from '../../components/Skeleton/Skeleton';
import '../Prospects/Prospects.css';

//  CORRIGÉ : page 100% mock. Champs alignés sur le schéma réel
// etablissement : idEtablissement, nom, adresse, ville, region, type,
// telephone. (pas de "classes" ni de stats — inexistants côté backend)

const EtablissementsList = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterVille, setFilterVille] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, etabId: null, etabName: '' });
  const [toasts, setToasts] = useState([]);
  const [etablissements, setEtablissements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };
  const removeToast = (id) => setToasts(prev => prev.filter(t => t.id !== id));

  const fetchEtablissements = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await etablissementService.getAll();
      setEtablissements(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      console.error(' Erreur de chargement:', err);
      setError(err.message);
      addToast('Erreur lors du chargement des établissements', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchEtablissements(); }, []);

  const villes = [...new Set(etablissements.map(e => e.ville).filter(Boolean))];

  const filteredEtabs = etablissements.filter(e => {
    const term = searchTerm.toLowerCase();
    const matchesSearch = (e.nom || '').toLowerCase().includes(term) || (e.adresse || '').toLowerCase().includes(term);
    const matchesVille = filterVille === 'all' || e.ville === filterVille;
    return matchesSearch && matchesVille;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredEtabs, 10);

  const handleDelete = async () => {
    try {
      await etablissementService.delete(deleteModal.etabId);
      addToast(`Établissement "${deleteModal.etabName}" supprimé avec succès`, 'success');
      fetchEtablissements();
    } catch (err) {
      addToast('Erreur lors de la suppression', 'error');
    }
    setDeleteModal({ isOpen: false, etabId: null, etabName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucun établissement ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterVille('all'); }}>Effacer les filtres</button>
    </div>
  );

  if (loading) {
    return <div className="page-container"><SkeletonTable rows={6} columns={7} /></div>;
  }
  if (error) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn-outline" onClick={fetchEtablissements}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, etabId: null, etabName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer l'établissement "${deleteModal.etabName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('gestionEtablissements')}</h1>
          <p className="page-description">{t('descEtablissements')}</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/etablissements/new')}>
          <Plus size={18} /> {t('nouvelEtablissement')}
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par nom ou adresse..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterVille} onChange={(e) => setFilterVille(e.target.value)}>
            <option value="all">Toutes les villes</option>
            {villes.map(v => <option key={v} value={v}>{v}</option>)}
          </select>
        </div>
      </div>

      {filteredEtabs.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead><tr><th>Nom</th><th>Type</th><th>Ville</th><th>Région</th><th>Adresse</th><th>Téléphone</th><th>Actions</th></tr></thead>
              <tbody>
                {paginatedItems.map((etab) => (
                  <tr key={etab.idEtablissement}>
                    <td><strong>{etab.nom}</strong></td>
                    <td><span className="badge badge-info">{etab.type}</span></td>
                    <td>{etab.ville}</td>
                    <td>{etab.region}</td>
                    <td><MapPin size={14} /> {etab.adresse}</td>
                    <td><Phone size={14} /> {etab.telephone}</td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/etablissements/${etab.idEtablissement}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/etablissements/edit/${etab.idEtablissement}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, etabId: etab.idEtablissement, etabName: etab.nom })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
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