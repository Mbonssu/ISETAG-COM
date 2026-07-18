// import React, { useState, useEffect } from 'react';
// import { useNavigate } from 'react-router-dom';
// import { Search, Eye, AlertCircle, Calendar, User, Loader } from 'lucide-react';
// import Pagination from '../../components/Pagination/Pagination';
// import { usePagination } from '../../hooks/usePagination';
// import { ficheService } from '../../services/ficheService';
// import { SkeletonTable } from '../../components/Skeleton/Skeleton';
// import EmptyState from '../../components/EmptyState/EmptyState';
// import ExportButton from '../../components/ExportButton/ExportButton';
// import { useUrlState } from '../../hooks/useUrlState';
// import '../Prospects/Prospects.css';
// import { ToastContainer } from '../../components/common/Toast';
// import { useTranslation } from '../../hooks/useTranslation';
// import { getErrorMessage } from '../../utils/errorMessages';

// // ⚠️ IMPORTANT : les fiches de collecte sont créées par les agents sur le
// // terrain via l'application MOBILE, pas depuis cet espace admin web. Cette
// // page est donc en LECTURE SEULE : pas de création ni de modification ici,
// // uniquement consultation + export des fiches déjà remontées du terrain.

// const getScoreColor = (score) => {
//   if (score >= 80) return '#10b981';
//   if (score >= 60) return '#f59e0b';
//   return '#ef4444';
// };

// const FichesList = () => {
//   const navigate = useNavigate();
//   const { t } = useTranslation();
//   const [searchTerm, setSearchTerm] = useUrlState('q', '');
//   const [fiches, setFiches] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [toasts, setToasts] = useState([]);

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts((prev) => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (toastId) => {
//     setToasts((prev) => prev.filter((toast) => toast.id !== toastId));
//   };

//   const fetchFiches = async () => {
//     setLoading(true);
//     setError(null);
//     try {
//       const raw = await ficheService.getAll();
//       console.log('📥 Fiches chargées:', raw);
//       setFiches(Array.isArray(raw) ? raw : (raw?.results ?? []));
//     } catch (err) {
//       console.error('❌ Erreur de chargement:', err);
//       setError(getErrorMessage(err, t));
//       addToast(getErrorMessage(err, t), 'error');
//     } finally {
//       setLoading(false);
//     }
//   };

//   useEffect(() => { fetchFiches(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

//   const getNomProspect = (f) => String(f.prospect_detail?.nomComplet || f.idProspect || '-');
//   const getNomSource = (f) => String(f.source_detail?.libele || f.idSource || '-');

//   const filteredFiches = fiches.filter((f) => {
//     const term = searchTerm.toLowerCase();
//     return getNomProspect(f).toLowerCase().includes(term) ||
//            getNomSource(f).toLowerCase().includes(term) ||
//            (f.commentaire || '').toLowerCase().includes(term);
//   });

//   const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredFiches, 10);

//   // ExportButton lit directement item[col.key] : on enrichit donc chaque
//   // fiche avec des champs plats avant de les passer à l'export.
//   const fichesPourExport = filteredFiches.map((f) => ({
//     ...f,
//     _nomProspect: getNomProspect(f),
//     _nomSource: getNomSource(f),
//   }));

//   if (loading) {
//     return (
//       <div className="page-container">
//         <ToastContainer toasts={toasts} removeToast={removeToast} />
//         <SkeletonTable rows={6} columns={5} />
//       </div>
//     );
//   }
//   if (error) {
//     return (
//       <div className="page-container">
//         <ToastContainer toasts={toasts} removeToast={removeToast} />
//         <div className="error-container">
//           <AlertCircle size={48} color="#ef4444" />
//           <h3>Erreur de chargement</h3>
//           <p>{error}</p>
//           <button className="btn-outline" onClick={fetchFiches}>Réessayer</button>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Fiches de collecte</h1>
//           <p className="page-description">
//             Fiches remontées par les agents depuis le terrain (application mobile). Consultation uniquement.
//           </p>
//         </div>
//         <ExportButton
//           data={fichesPourExport}
//           filename="fiches_collecte"
//           title="Fiches de collecte"
//           columns={[
//             { key: '_nomProspect', label: 'Prospect' },
//             { key: '_nomSource', label: 'Source' },
//             { key: 'dateCollecte', label: 'Date de collecte' },
//             { key: 'scoreInteret', label: "Score d'intérêt" },
//             { key: 'commentaire', label: 'Commentaire' },
//           ]}
//         />
//       </div>

//       <div className="filters-bar">
//         <div className="search-box">
//           <Search size={18} />
//           <input
//             type="text"
//             placeholder="Rechercher par prospect, source ou commentaire..."
//             value={searchTerm}
//             onChange={(e) => setSearchTerm(e.target.value)}
//           />
//         </div>
//       </div>

//       {filteredFiches.length === 0 ? (
//         fiches.length === 0 ? (
//           <EmptyState
//             variant="empty"
//             title="Aucune fiche remontée pour le moment"
//             message="Les fiches apparaîtront ici dès que les agents en créeront depuis l'application mobile sur le terrain."
//           />
//         ) : (
//           <EmptyState variant="search" searchTerm={searchTerm} onClearFilters={() => setSearchTerm('')} />
//         )
//       ) : (
//         <>
//           <div className="table-container">
//             <table className="data-table">
//               <thead>
//                 <tr><th>Prospect</th><th>Source</th><th>Date de collecte</th><th>Score d'intérêt</th><th>Actions</th></tr>
//               </thead>
//               <tbody>
//                 {paginatedItems.map((fiche) => (
//                   <tr key={fiche.idFiche}>
//                     <td><User size={14} /> <strong>{getNomProspect(fiche)}</strong></td>
//                     <td>{getNomSource(fiche)}</td>
//                     <td><Calendar size={14} /> {fiche.dateCollecte ? new Date(fiche.dateCollecte).toLocaleDateString('fr-FR') : '-'}</td>
//                     <td>
//                       <span style={{ color: getScoreColor(fiche.scoreInteret), fontWeight: 600 }}>
//                         {fiche.scoreInteret ?? '-'}
//                       </span>
//                     </td>
//                     <td>
//                       <button className="action-btn view" onClick={() => navigate(`/fiches/${fiche.idFiche}`)}>
//                         <Eye size={16} />
//                       </button>
//                     </td>
//                   </tr>
//                 ))}
//               </tbody>
//             </table>
//           </div>
//           <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={goToPage} itemsPerPage={itemsPerPage} totalItems={filteredFiches.length} />
//         </>
//       )}
//     </div>
//   );
// };

// export default FichesList;


import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, Eye, AlertCircle, Calendar, User, Loader } from 'lucide-react';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { ficheService } from '../../services/ficheService';
import { SkeletonTable } from '../../components/Skeleton/Skeleton';
import EmptyState from '../../components/EmptyState/EmptyState';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useUrlState } from '../../hooks/useUrlState';
import '../Prospects/Prospects.css';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import { getErrorMessage } from '../../utils/errorMessages';

// ⚠️ IMPORTANT : les fiches de collecte sont créées par les agents sur le
// terrain via l'application MOBILE, pas depuis cet espace admin web. Cette
// page est donc en LECTURE SEULE : pas de création ni de modification ici,
// uniquement consultation + export des fiches déjà remontées du terrain.

const getScoreColor = (score) => {
  if (score >= 80) return '#10b981';
  if (score >= 60) return '#f59e0b';
  return '#ef4444';
};

const FichesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useUrlState('q', '');
  const [fiches, setFiches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts((prev) => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (toastId) => {
    setToasts((prev) => prev.filter((toast) => toast.id !== toastId));
  };

  const fetchFiches = async () => {
    setLoading(true);
    setError(null);
    try {
      const raw = await ficheService.getAll();
      console.log('📥 Fiches chargées:', raw);
      setFiches(Array.isArray(raw) ? raw : (raw?.results ?? []));
    } catch (err) {
      console.error('❌ Erreur de chargement:', err);
      setError(getErrorMessage(err, t));
      addToast(getErrorMessage(err, t), 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchFiches(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // ⚠️ CORRIGÉ : le backend renvoie maintenant "prospects" (tableau —
  // une fiche peut concerner plusieurs prospects), et non plus un seul
  // "prospect_detail"/"idProspect".
  const getProspects = (f) => (Array.isArray(f.prospects) ? f.prospects : []);
  const getNomsProspects = (f) => getProspects(f).map((p) => p.nomComplet || p.idProspect).filter(Boolean);
  const getNomProspectAffiche = (f) => {
    const noms = getNomsProspects(f);
    if (noms.length === 0) return '—';
    if (noms.length === 1) return noms[0];
    return `${noms[0]} +${noms.length - 1}`;
  };
  const getNomSource = (f) => String(f.source_detail?.libele || f.idSource || '-');

  const filteredFiches = fiches.filter((f) => {
    const term = searchTerm.toLowerCase();
    return getNomsProspects(f).join(' ').toLowerCase().includes(term) ||
           getNomSource(f).toLowerCase().includes(term) ||
           (f.commentaire || '').toLowerCase().includes(term);
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredFiches, 10);

  // ExportButton lit directement item[col.key] : on enrichit donc chaque
  // fiche avec des champs plats avant de les passer à l'export.
  const fichesPourExport = filteredFiches.map((f) => ({
    ...f,
    _nomProspect: getNomsProspects(f).join('; ') || '—',
    _nomSource: getNomSource(f),
  }));

  if (loading) {
    return (
      <div className="page-container">
        <ToastContainer toasts={toasts} removeToast={removeToast} />
        <SkeletonTable rows={6} columns={5} />
      </div>
    );
  }
  if (error) {
    return (
      <div className="page-container">
        <ToastContainer toasts={toasts} removeToast={removeToast} />
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn-outline" onClick={fetchFiches}>Réessayer</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Fiches de collecte</h1>
          <p className="page-description">
            Fiches remontées par les agents depuis le terrain (application mobile). Consultation uniquement.
          </p>
        </div>
        <ExportButton
          data={fichesPourExport}
          filename="fiches_collecte"
          title="Fiches de collecte"
          columns={[
            { key: '_nomProspect', label: 'Prospect' },
            { key: '_nomSource', label: 'Source' },
            { key: 'dateCollecte', label: 'Date de collecte' },
            { key: 'scoreInteret', label: "Score d'intérêt" },
            { key: 'commentaire', label: 'Commentaire' },
          ]}
        />
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input
            type="text"
            placeholder="Rechercher par prospect, source ou commentaire..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      {filteredFiches.length === 0 ? (
        fiches.length === 0 ? (
          <EmptyState
            variant="empty"
            title="Aucune fiche remontée pour le moment"
            message="Les fiches apparaîtront ici dès que les agents en créeront depuis l'application mobile sur le terrain."
          />
        ) : (
          <EmptyState variant="search" searchTerm={searchTerm} onClearFilters={() => setSearchTerm('')} />
        )
      ) : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Prospect</th><th>Source</th><th>Date de collecte</th><th>Score d'intérêt</th><th>Actions</th></tr>
              </thead>
              <tbody>
                {paginatedItems.map((fiche) => (
                  <tr key={fiche.idFiche}>
                    <td><User size={14} /> <strong>{getNomProspectAffiche(fiche)}</strong></td>
                    <td>{getNomSource(fiche)}</td>
                    <td><Calendar size={14} /> {fiche.dateCollecte ? new Date(fiche.dateCollecte).toLocaleDateString('fr-FR') : '-'}</td>
                    <td>
                      <span style={{ color: getScoreColor(fiche.scoreInteret), fontWeight: 600 }}>
                        {fiche.scoreInteret ?? '-'}
                      </span>
                    </td>
                    <td>
                      <button className="action-btn view" onClick={() => navigate(`/fiches/${fiche.idFiche}`)}>
                        <Eye size={16} />
                      </button>
                    </td>
                  </tr>
                ))}
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