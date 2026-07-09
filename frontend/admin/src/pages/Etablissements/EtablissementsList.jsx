// import React, { useState } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { Plus, Search, Edit, Trash2, Eye, Filter, Download, AlertCircle, Building, MapPin, Users, Star } from 'lucide-react';
// import Modal from '../../components/common/Modal';
// import { ToastContainer } from '../../components/common/Toast';
// import Pagination from '../../components/Pagination/Pagination';
// import { usePagination } from '../../hooks/usePagination';
// import '../Prospects/Prospects.css';

// const EtablissementsList = () => {
//   const navigate = useNavigate();
//   const [searchTerm, setSearchTerm] = useState('');
//   const [filterType, setFilterType] = useState('all');
//   const [filterVille, setFilterVille] = useState('all');
//   const [deleteModal, setDeleteModal] = useState({ isOpen: false, etablissementId: null, etablissementName: '' });
//   const [toasts, setToasts] = useState([]);

//   const addToast = (message, type = 'success') => {
//     const id = Date.now();
//     setToasts(prev => [...prev, { id, message, type }]);
//     setTimeout(() => removeToast(id), 3000);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   const etablissements = [
//     { id: 1, name: 'Lycée de Biyem-Assi', type: 'Lycée', ville: 'Yaoundé', adresse: 'Biyem-Assi, Yaoundé', contacts: 3, prospects: 45, agent: 'Jean M.', rating: 4.5 },
//     { id: 2, name: 'Lycée Technique d\'Efouan', type: 'Lycée Technique', ville: 'Yaoundé', adresse: 'Efouan, Yaoundé', contacts: 2, prospects: 32, agent: 'Sophie A.', rating: 4.2 },
//     { id: 3, name: 'Université de Douala', type: 'Université', ville: 'Douala', adresse: 'Logbessou, Douala', contacts: 5, prospects: 89, agent: 'David P.', rating: 4.8 },
//     { id: 4, name: 'Institut Supérieur de l\'Information', type: 'Institut', ville: 'Douala', adresse: 'Bonamoussadi, Douala', contacts: 2, prospects: 28, agent: 'Marie L.', rating: 4.0 },
//     { id: 5, name: 'Collège de la Salle', type: 'Collège', ville: 'Bafoussam', adresse: 'Centre-ville, Bafoussam', contacts: 1, prospects: 15, agent: 'Jean M.', rating: 3.8 },
//     { id: 6, name: 'Lycée Classique de Garoua', type: 'Lycée', ville: 'Garoua', adresse: 'Quartier administratif', contacts: 2, prospects: 23, agent: 'Paul K.', rating: 4.1 },
//     { id: 7, name: 'Université de Ngaoundéré', type: 'Université', ville: 'Ngaoundéré', adresse: 'Centre universitaire', contacts: 4, prospects: 56, agent: 'Sophie A.', rating: 4.3 },
//   ];

//   const villes = ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Ngaoundéré'];
//   const types = ['Lycée', 'Lycée Technique', 'Université', 'Institut', 'Collège'];

//   const filteredEtablissements = etablissements.filter(e => {
//     const matchesSearch = e.name.toLowerCase().includes(searchTerm.toLowerCase()) || e.ville.toLowerCase().includes(searchTerm.toLowerCase());
//     const matchesType = filterType === 'all' || e.type === filterType;
//     const matchesVille = filterVille === 'all' || e.ville === filterVille;
//     return matchesSearch && matchesType && matchesVille;
//   });

//   const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredEtablissements, 10);

//   const handleDelete = () => {
//     addToast(`Établissement "${deleteModal.etablissementName}" supprimé avec succès`, 'success');
//     setDeleteModal({ isOpen: false, etablissementId: null, etablissementName: '' });
//   };

//   const getRatingStars = (rating) => {
//     const stars = [];
//     for (let i = 0; i < Math.floor(rating); i++) stars.push(<Star key={i} size={14} fill="#f5c842" color="#f5c842" />);
//     return stars;
//   };

//   const renderNoResults = () => (
//     <div className="no-results">
//       <AlertCircle size={48} />
//       <h3>Aucun résultat trouvé</h3>
//       <p>Aucun établissement ne correspond à votre recherche "{searchTerm}"</p>
//       <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterVille('all'); }}>Effacer les filtres</button>
//     </div>
//   );

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />
      
//       <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, etablissementId: null, etablissementName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer l'établissement "${deleteModal.etablissementName}" ?`} confirmText="Supprimer" type="warning" />

//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Établissements</h1>
//           <p className="page-description">Gérez les lycées, universités et instituts partenaires.</p>
//         </div>
//         <button className="btn-primary" onClick={() => navigate('/etablissements/new')}>
//           <Plus size={18} /> Nouvel établissement
//         </button>
//       </div>

//       <div className="filters-bar">
//         <div className="search-box"><Search size={18} /><input type="text" placeholder="Rechercher un établissement..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
//         <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={(e) => setFilterType(e.target.value)}><option value="all">Tous les types</option>{types.map(t => <option key={t} value={t}>{t}</option>)}</select></div>
//         <div className="filter-group"><Filter size={18} /><select value={filterVille} onChange={(e) => setFilterVille(e.target.value)}><option value="all">Toutes les villes</option>{villes.map(v => <option key={v} value={v}>{v}</option>)}</select></div>
//       </div>

//       {filteredEtablissements.length === 0 ? renderNoResults() : (
//         <>
//           <div className="table-container">
//             <table className="data-table">
//               <thead>
//                 <tr><th>Établissement</th><th>Type</th><th>Adresse</th><th>Contacts</th><th>Prospects</th><th>Agent</th><th>Note</th><th>Actions</th></tr>
//               </thead>
//               <tbody>
//                 {paginatedItems.map((etab) => (
//                   <tr key={etab.id}>
//                     <td><div className="etablissement-cell"><Building size={14} /><strong>{etab.name}</strong></div></td>
//                     <td><span className="type-badge">{etab.type}</span></td>
//                     <td><div><MapPin size={12} /> {etab.adresse}</div><small>{etab.ville}</small></td>
//                     <td className="text-center">{etab.contacts}</td>
//                     <td className="text-center">{etab.prospects}</td>
//                     <td>{etab.agent}</td>
//                     <td><div className="rating-stars">{getRatingStars(etab.rating)} ({etab.rating})</div></td>
//                     <td><div className="action-buttons"><button className="action-btn view" onClick={() => navigate(`/etablissements/${etab.id}`)}><Eye size={16} /></button><button className="action-btn edit" onClick={() => navigate(`/etablissements/edit/${etab.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, etablissementId: etab.id, etablissementName: etab.name })}><Trash2 size={16} /></button></div></td>
//                   </tr>
//                 ))}
//               </tbody>
//             </table>
//           </div>
//           <Pagination 
//             currentPage={currentPage}
//             totalPages={totalPages}
//             onPageChange={goToPage}
//             itemsPerPage={itemsPerPage}
//             totalItems={filteredEtablissements.length}
//           />
//         </>
//       )}
//     </div>
//   );
// };

// export default EtablissementsList;


import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, AlertCircle, MapPin, Phone, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { etablissementService } from '../../services/etablissementService';
import '../Prospects/Prospects.css';

// ⚠️ CORRIGÉ : page 100% mock. Champs alignés sur le schéma réel
// etablissement : idEtablissement, nom, adresse, ville, region, type,
// telephone. (pas de "classes" ni de stats — inexistants côté backend)

const EtablissementsList = () => {
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
      console.log('📥 Établissements chargés:', data);
      setEtablissements(Array.isArray(data) ? data : (data?.results ?? []));
    } catch (err) {
      console.error('❌ Erreur de chargement:', err);
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
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement des établissements...</p></div></div>;
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
          <h1 className="page-title-h1">Gestion des Établissements</h1>
          <p className="page-description">Gérez les établissements scolaires partenaires.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/etablissements/new')}>
          <Plus size={18} /> Nouvel établissement
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