import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, AlertCircle, MapPin, Building, Globe, Calendar } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import '../Prospects/Prospects.css';

const ZonesList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterVille, setFilterVille] = useState('all');
  const [filterRegion, setFilterRegion] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, zoneId: null, zoneName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const zones = [
    { id: 1, code: 'Z001', quartier: 'Biyem-Assi', ville: 'Yaoundé', region: 'Centre', pays: 'Cameroun', lieuDepart: 'Carrefour Biyem-Assi', lieuFin: 'Lycée de Biyem-Assi', description: 'Zone couvrant le quartier Biyem-Assi' },
    { id: 2, code: 'Z002', quartier: 'Mvog-Mbi', ville: 'Yaoundé', region: 'Centre', pays: 'Cameroun', lieuDepart: 'Carrefour Mvog-Mbi', lieuFin: 'Université de Yaoundé I', description: 'Zone universitaire' },
    { id: 3, code: 'Z003', quartier: 'Bonamoussadi', ville: 'Douala', region: 'Littoral', pays: 'Cameroun', lieuDepart: 'Carrefour Bonamoussadi', lieuFin: 'Institut Supérieur', description: 'Zone commerciale et éducative' },
    { id: 4, code: 'Z004', quartier: 'Logbessou', ville: 'Douala', region: 'Littoral', pays: 'Cameroun', lieuDepart: 'Carrefour Logbessou', lieuFin: 'Université de Douala', description: 'Zone périphérique' },
    { id: 5, code: 'Z005', quartier: 'Centre-ville', ville: 'Bafoussam', region: 'Ouest', pays: 'Cameroun', lieuDepart: 'Place Tokam', lieuFin: 'Collège de la Salle', description: 'Zone centrale' },
    { id: 6, code: 'Z006', quartier: 'Quartier administratif', ville: 'Garoua', region: 'Nord', pays: 'Cameroun', lieuDepart: 'Rond-point', lieuFin: 'Lycée Classique', description: 'Zone administrative' },
  ];

  const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua'];
  const regions = ['Centre', 'Littoral', 'Ouest', 'Nord'];

  const filteredZones = zones.filter(z => {
    const matchesSearch = z.quartier.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          z.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          z.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesVille = filterVille === 'all' || z.ville === filterVille;
    const matchesRegion = filterRegion === 'all' || z.region === filterRegion;
    return matchesSearch && matchesVille && matchesRegion;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredZones, 10);

  const handleDelete = () => {
    addToast(`Zone "${deleteModal.zoneName}" supprimée avec succès`, 'success');
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
          <input type="text" placeholder="Rechercher par quartier, code ou description..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
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
                  <th>Code</th><th>Quartier</th><th>Ville</th><th>Région</th><th>Lieu départ</th><th>Lieu fin</th><th>Description</th><th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((zone) => (
                  <tr key={zone.id}>
                    <td><span className="code-badge">{zone.code}</span></td>
                    <td><MapPin size={14} /> {zone.quartier}</td>
                    <td>{zone.ville}</td>
                    <td>{zone.region} (<Globe size={12} /> {zone.pays})</td>
                    <td>{zone.lieuDepart}</td>
                    <td>{zone.lieuFin}</td>
                    <td><div className="commentaire-cell"><small>{zone.description}</small></div></td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/zones/${zone.id}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/zones/edit/${zone.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, zoneId: zone.id, zoneName: zone.quartier })}><Trash2 size={16} /></button>
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
