import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, MapPin, Globe, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { zoneService } from '../../services/zoneService';
import '../Prospects/Prospects.css';

//  CORRIGÉ : cette page était 100% mock (données codées en dur, aucun
// appel API). Le champ "code" n'existe pas côté backend (schéma Zone) :
// remplacé par "libele". "lieuFin" renommé "lieuArrivee" (vrai nom du champ).

const ZonesList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterVille, setFilterVille] = useState('all');
  const [filterRegion, setFilterRegion] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, zoneId: null, zoneName: '' });
  const [toasts, setToasts] = useState([]);
  const [zones, setZones] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const fetchZones = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await zoneService.getAll();
      ('📥 Zones chargées:', data);
      setZones(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      console.error(' Erreur de chargement:', err);
      setError(err.message);
      addToast('Erreur lors du chargement des zones', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchZones();
  }, []);

  // Villes / régions dérivées dynamiquement des zones chargées (plus besoin
  // d'une liste figée en dur qui pourrait ne pas correspondre aux vraies données)
  const villes = [...new Set(zones.map(z => z.ville).filter(Boolean))];
  const regions = [...new Set(zones.map(z => z.region).filter(Boolean))];

  const filteredZones = zones.filter(z => {
    const term = searchTerm.toLowerCase();
    const matchesSearch = (z.libele || '').toLowerCase().includes(term) ||
                          (z.quartier || '').toLowerCase().includes(term) ||
                          (z.description || '').toLowerCase().includes(term);
    const matchesVille = filterVille === 'all' || z.ville === filterVille;
    const matchesRegion = filterRegion === 'all' || z.region === filterRegion;
    return matchesSearch && matchesVille && matchesRegion;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredZones, 10);

  const handleDelete = async () => {
    try {
      await zoneService.delete(deleteModal.zoneId);
      addToast(`Zone "${deleteModal.zoneName}" supprimée avec succès`, 'success');
      fetchZones();
    } catch (err) {
      addToast('Erreur lors de la suppression', 'error');
    }
    setDeleteModal({ isOpen: false, zoneId: null, zoneName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune zone ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterVille('all'); setFilterRegion('all'); }}>Effacer les filtres</button>
    </div>
  );

  if (loading) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement des zones...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn-outline" onClick={fetchZones}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, zoneId: null, zoneName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer la zone "${deleteModal.zoneName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Zones</h1>
          <p className="page-description">Définissez et gérez les zones géographiques d'intervention.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/zones/new')}>
          <Plus size={18} /> Nouvelle zone
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par nom, quartier ou description..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterVille} onChange={(e) => setFilterVille(e.target.value)}>
            <option value="all">Toutes les villes</option>
            {villes.map(v => <option key={v} value={v}>{v}</option>)}
          </select>
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterRegion} onChange={(e) => setFilterRegion(e.target.value)}>
            <option value="all">Toutes les régions</option>
            {regions.map(r => <option key={r} value={r}>{r}</option>)}
          </select>
        </div>
      </div>

      {filteredZones.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Nom</th><th>Quartier</th><th>Ville</th><th>Région</th><th>Lieu départ</th><th>Lieu arrivée</th><th>Description</th><th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((zone) => (
                  <tr key={zone.idZone}>
                    <td><span className="code-badge">{zone.libele}</span></td>
                    <td><MapPin size={14} /> {zone.quartier}</td>
                    <td>{zone.ville}</td>
                    <td>{zone.region} (<Globe size={12} /> {zone.pays})</td>
                    <td>{zone.lieuDepart}</td>
                    <td>{zone.lieuArrivee}</td>
                    <td><div className="commentaire-cell"><small>{zone.description}</small></div></td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/zones/${zone.idZone}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/zones/edit/${zone.idZone}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, zoneId: zone.idZone, zoneName: zone.libele })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={goToPage}
            itemsPerPage={itemsPerPage}
            totalItems={filteredZones.length}
          />
        </>
      )}
    </div>
  );
};

export default ZonesList;