// import React, { useState, useEffect } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { Plus, Search, Edit, Trash2, Eye, AlertCircle, Calendar, Loader } from 'lucide-react';
// import Modal from '../../components/common/Modal';
// import { ToastContainer } from '../../components/common/Toast';
// import Pagination from '../../components/Pagination/Pagination';
// import { usePagination } from '../../hooks/usePagination';
// import { suiviService } from '../../services/suiviService';
// import { Suivi } from '../../models/suivi';
// import '../Prospects/Prospects.css';

// // ⚠️ CORRIGÉ : plus de filtre par type (n'existe pas côté backend),
// // plus de colonne Agent / Prochaine action (idem).

// const SuivisList = () => {
//   const navigate = useNavigate();
//   const [searchTerm, setSearchTerm] = useState('');
//   const [deleteModal, setDeleteModal] = useState({ isOpen: false, suiviId: null, suiviName: '' });
//   const [toasts, setToasts] = useState([]);
//   const [suivis, setSuivis] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const itemsPerPage = 5;

//   const addToast = (message, type = 'success') => {
//     const id = Date.now();
//     setToasts(prev => [...prev, { id, message, type }]);
//     setTimeout(() => removeToast(id), 3000);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   const fetchSuivis = async () => {
//     setLoading(true);
//     setError(null);
//     try {
//       const data = await suiviService.getAll();
//       console.log('📥 Suivis chargés:', data);
//       const suivisData = Suivi.fromDjango(data);
//       setSuivis(suivisData);
//     } catch (err) {
//       console.error('❌ Erreur de chargement:', err);
//       setError(err.message);
//       addToast('Erreur lors du chargement des suivis', 'error');
//     } finally {
//       setLoading(false);
//     }
//   };

//   useEffect(() => {
//     fetchSuivis();
//   }, []);

//   const filteredSuivis = suivis.filter(s => {
//     const haystack = `${s.nomProspect} ${s.idProspect} ${s.libeleSuivi} ${s.commentaire}`.toLowerCase();
//     return haystack.includes(searchTerm.toLowerCase());
//   });

//   const { currentPage: page, totalPages, paginatedItems, goToPage, itemsPerPage: perPage } = usePagination(filteredSuivis, itemsPerPage);

//   const handleDelete = async () => {
//     try {
//       await suiviService.delete(deleteModal.suiviId);
//       addToast('Suivi supprimé avec succès', 'success');
//       fetchSuivis();
//     } catch (err) {
//       addToast('Erreur lors de la suppression', 'error');
//     }
//     setDeleteModal({ isOpen: false, suiviId: null, suiviName: '' });
//   };

//   const renderNoResults = () => (
//     <div className="no-results">
//       <AlertCircle size={48} />
//       <h3>Aucun résultat trouvé</h3>
//       <p>Aucun suivi ne correspond à votre recherche "{searchTerm}"</p>
//       <button className="btn-outline" onClick={() => setSearchTerm('')}>Effacer la recherche</button>
//     </div>
//   );

//   if (loading) {
//     return (
//       <div className="page-container">
//         <div className="loading-container">
//           <Loader size={48} className="spin" />
//           <p>Chargement des suivis...</p>
//         </div>
//       </div>
//     );
//   }

//   if (error) {
//     return (
//       <div className="page-container">
//         <div className="error-container">
//           <AlertCircle size={48} color="#ef4444" />
//           <h3>Erreur de chargement</h3>
//           <p>{error}</p>
//           <button className="btn-outline" onClick={() => fetchSuivis()}>Réessayer</button>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />

//       <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, suiviId: null, suiviName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message="Êtes-vous sûr de vouloir supprimer ce suivi ?" confirmText="Supprimer" type="warning" />

//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Gestion des Suivis</h1>
//           <p className="page-description">Suivez l'historique des interactions avec les prospects.</p>
//         </div>
//         <button className="btn-primary" onClick={() => navigate('/suivis/new')}>
//           <Plus size={18} />
//           Nouveau suivi
//         </button>
//       </div>

//       <div className="filters-bar">
//         <div className="search-box">
//           <Search size={18} />
//           <input
//             type="text"
//             placeholder="Rechercher par prospect, libellé ou commentaire..."
//             value={searchTerm}
//             onChange={(e) => setSearchTerm(e.target.value)}
//           />
//         </div>
//       </div>

//       {filteredSuivis.length === 0 ? renderNoResults() : (
//         <>
//           <div className="table-container">
//             <table className="data-table">
//               <thead>
//                 <tr>
//                   <th>Prospect</th>
//                   <th>Libellé</th>
//                   <th>Date</th>
//                   <th>Commentaire</th>
//                   <th>Actions</th>
//                 </tr>
//               </thead>
//               <tbody>
//                 {paginatedItems.map((suivi) => (
//                   <tr key={suivi.id}>
//                     <td><strong>{suivi.nomProspect || suivi.idProspect}</strong></td>
//                     <td>{suivi.libeleSuivi}</td>
//                     <td><Calendar size={14} /> {suivi.dateFormatee}</td>
//                     <td><div className="commentaire-cell"><small>{suivi.commentaire || '-'}</small></div></td>
//                     <td>
//                       <div className="action-buttons">
//                         <button className="action-btn view" onClick={() => navigate(`/suivis/${suivi.id}`)}><Eye size={16} /></button>
//                         <button className="action-btn edit" onClick={() => navigate(`/suivis/edit/${suivi.id}`)}><Edit size={16} /></button>
//                         <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, suiviId: suivi.id, suiviName: suivi.libeleSuivi })}><Trash2 size={16} /></button>
//                       </div>
//                     </td>
//                   </tr>
//                 ))}
//               </tbody>
//             </table>
//           </div>
//           <Pagination
//             currentPage={page}
//             totalPages={totalPages}
//             onPageChange={goToPage}
//             itemsPerPage={perPage}
//             totalItems={filteredSuivis.length}
//           />
//         </>
//       )}
//     </div>
//   );
// };

// export default SuivisList;


import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, AlertCircle, Calendar, Loader } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { suiviService } from '../../services/suiviService';
import { prospectService } from '../../services/prospectService';
import { Suivi } from '../../models/suivi';
import '../Prospects/Prospects.css';

// ⚠️ CORRIGÉ : plus de filtre par type (n'existe pas côté backend),
// plus de colonne Agent / Prochaine action (idem).

const SuivisList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, suiviId: null, suiviName: '' });
  const [toasts, setToasts] = useState([]);
  const [suivis, setSuivis] = useState([]);
  const [prospectsById, setProspectsById] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const itemsPerPage = 5;

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  // Résolution du nom du prospect : le backend renvoie normalement
  // prospect_details avec chaque suivi (voir models/suivi.js), mais on
  // charge quand même la liste des prospects en secours, au cas où
  // ce champ imbriqué ne serait pas toujours présent.
  const fetchProspectsMap = async () => {
    try {
      const data = await prospectService.getAll();
      const list = Array.isArray(data) ? data : (data?.results ?? []);
      const map = {};
      list.forEach(p => {
        const pid = p.idProspect || p.id;
        if (pid) map[pid] = p.nomComplet || p.email || p.telephone || pid;
      });
      setProspectsById(map);
    } catch (err) {
      console.warn('⚠️ Impossible de charger les prospects pour résoudre les noms:', err);
    }
  };

  const getNomProspect = (suivi) => suivi.nomProspect || prospectsById[suivi.idProspect] || suivi.idProspect;

  const fetchSuivis = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await suiviService.getAll();
      console.log('📥 Suivis chargés:', data);
      const suivisData = Suivi.fromDjango(data);
      setSuivis(suivisData);
    } catch (err) {
      console.error('❌ Erreur de chargement:', err);
      setError(err.message);
      addToast('Erreur lors du chargement des suivis', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSuivis();
    fetchProspectsMap();
  }, []);

  const filteredSuivis = suivis.filter(s => {
    const haystack = `${getNomProspect(s)} ${s.libeleSuivi} ${s.commentaire}`.toLowerCase();
    return haystack.includes(searchTerm.toLowerCase());
  });

  const { currentPage: page, totalPages, paginatedItems, goToPage, itemsPerPage: perPage } = usePagination(filteredSuivis, itemsPerPage);

  const handleDelete = async () => {
    try {
      await suiviService.delete(deleteModal.suiviId);
      addToast('Suivi supprimé avec succès', 'success');
      fetchSuivis();
    } catch (err) {
      addToast('Erreur lors de la suppression', 'error');
    }
    setDeleteModal({ isOpen: false, suiviId: null, suiviName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucun suivi ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>Effacer la recherche</button>
    </div>
  );

  if (loading) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement des suivis...</p>
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
          <button className="btn-outline" onClick={() => fetchSuivis()}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, suiviId: null, suiviName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message="Êtes-vous sûr de vouloir supprimer ce suivi ?" confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Suivis</h1>
          <p className="page-description">Suivez l'historique des interactions avec les prospects.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/suivis/new')}>
          <Plus size={18} />
          Nouveau suivi
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input
            type="text"
            placeholder="Rechercher par prospect, libellé ou commentaire..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      {filteredSuivis.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Prospect</th>
                  <th>Libellé</th>
                  <th>Date du suivi</th>
                  <th>Commentaire</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((suivi) => (
                  <tr key={suivi.id}>
                    <td><strong>{getNomProspect(suivi)}</strong></td>
                    <td>{suivi.libeleSuivi}</td>
                    <td><Calendar size={14} /> {suivi.dateFormatee}</td>
                    <td><div className="commentaire-cell"><small>{suivi.commentaire || '-'}</small></div></td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/suivis/${suivi.id}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/suivis/edit/${suivi.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, suiviId: suivi.id, suiviName: suivi.libeleSuivi })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination
            currentPage={page}
            totalPages={totalPages}
            onPageChange={goToPage}
            itemsPerPage={perPage}
            totalItems={filteredSuivis.length}
          />
        </>
      )}
    </div>
  );
};

export default SuivisList;