// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { 
//   ArrowLeft, Edit, Plus, Trash2, GraduationCap, 
//   BookOpen, Users, TrendingUp, Eye, Loader 
// } from 'lucide-react';
// import Modal from '../../components/common/Modal';
// import { ToastContainer } from '../../components/common/Toast';
// import { filiereService } from '../../services/filiereService'; // Import du service
// import '../Prospects/Prospects.css';

// const FiliereDetail = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const [activeTab, setActiveTab] = useState('info');
//   const [toasts, setToasts] = useState([]);
//   const [deleteModal, setDeleteModal] = useState({ 
//     isOpen: false, 
//     specialiteId: null, 
//     specialiteName: '' 
//   });
  
//   // États pour les données
//   const [filiere, setFiliere] = useState(null);
//   const [specialites, setSpecialites] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [loadingSpecialites, setLoadingSpecialites] = useState(false);
//   const [error, setError] = useState(null);

//   // ============================================================
//   // 1. GESTION DES TOASTS
//   // ============================================================

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   // ============================================================
//   // 2. CHARGEMENT DES DONNÉES
//   // ============================================================

//   const loadFiliereData = async () => {
//     if (!id) return;
    
//     setLoading(true);
//     setError(null);
    
//     try {
//       ('🔄 Chargement de la filière:', id);
      
//       // Charger les informations de la filière
//       const data = await filiereService.getById(id);
//       (' Filière chargée:', data);
//       setFiliere(data);
      
//       // Charger les spécialités si disponibles
//       if (data.specialites && Array.isArray(data.specialites)) {
//         setSpecialites(data.specialites);
//       } else {
//         // Si les spécialités ne sont pas incluses, les charger séparément
//         await loadSpecialites(id);
//       }
      
//     } catch (err) {
//       console.error(' Erreur chargement filière:', err);
//       setError(err.message || 'Erreur lors du chargement de la filière');
//       addToast(`Erreur: ${err.message || 'Impossible de charger la filière'}`, 'error');
//     } finally {
//       setLoading(false);
//     }
//   };

//   const loadSpecialites = async (filiereId) => {
//     setLoadingSpecialites(true);
//     try {
//       ('🔄 Chargement des spécialités pour:', filiereId);
//       const data = await filiereService.getSpecialites(filiereId);
//       (' Spécialités chargées:', data);
//       setSpecialites(Array.isArray(data) ? data : []);
//     } catch (err) {
//       console.error(' Erreur chargement spécialités:', err);
//       // Ne pas afficher d'erreur bloquante, juste un toast
//       addToast('Erreur lors du chargement des spécialités', 'warning');
//     } finally {
//       setLoadingSpecialites(false);
//     }
//   };

//   // Chargement initial
//   useEffect(() => {
//     loadFiliereData();
//   }, [id]);

//   // ============================================================
//   // 3. SUPPRESSION D'UNE SPÉCIALITÉ
//   // ============================================================

//   const handleDeleteSpecialite = async () => {
//     if (!deleteModal.specialiteId || !id) return;
    
//     try {
//       ('🗑️ Suppression spécialité:', deleteModal.specialiteId);
      
//       // Appel API pour supprimer la spécialité
//       // Note: Adaptez selon votre API
//       // await specialiteService.delete(deleteModal.specialiteId);
      
//       // Mise à jour de la liste locale
//       setSpecialites(specialites.filter(s => s.id !== deleteModal.specialiteId));
      
//       addToast(`Spécialité "${deleteModal.specialiteName}" supprimée avec succès`, 'success');
      
//       // Recharger les données pour mettre à jour les statistiques
//       await loadFiliereData();
      
//     } catch (err) {
//       console.error(' Erreur suppression spécialité:', err);
//       addToast(`Erreur: ${err.message || 'Impossible de supprimer la spécialité'}`, 'error');
//     } finally {
//       setDeleteModal({ isOpen: false, specialiteId: null, specialiteName: '' });
//     }
//   };

//   // ============================================================
//   // 4. ACTIONS SUR LA FILIÈRE
//   // ============================================================

//   const handleEditFiliere = () => {
//     navigate(`/filieres/edit/${id}`);
//   };

//   const handleAddSpecialite = () => {
//     navigate(`/specialites/new?filiere=${id}`);
//   };

//   const handleEditSpecialite = (specialiteId) => {
//     navigate(`/specialites/edit/${specialiteId}?filiere=${id}`);
//   };

//   // ============================================================
//   // 5. RENDER - COMPOSANTS UTILITAIRES
//   // ============================================================

//   const getStatusBadge = (actif) => {
//     return (
//       <span className={`badge ${actif ? 'badge-success' : 'badge-secondary'}`}>
//         {actif ? 'Actif' : 'Inactif'}
//       </span>
//     );
//   };

//   const formatDate = (dateString) => {
//     if (!dateString) return '-';
//     const date = new Date(dateString);
//     return date.toLocaleDateString('fr-FR', {
//       day: '2-digit',
//       month: 'short',
//       year: 'numeric'
//     });
//   };

//   // ============================================================
//   // 6. RENDER - ÉTAT DE CHARGEMENT
//   // ============================================================

//   if (loading) {
//     return (
//       <div className="page-container">
//         <div className="text-center py-5">
//           <Loader size={48} className="spinner" />
//           <p className="mt-3">Chargement de la filière...</p>
//         </div>
//       </div>
//     );
//   }

//   // ============================================================
//   // 7. RENDER - ERREUR
//   // ============================================================

//   if (error || !filiere) {
//     return (
//       <div className="page-container">
//         <div className="alert alert-danger">
//           <AlertCircle size={24} />
//           <div>
//             <h4>Erreur de chargement</h4>
//             <p>{error || 'Filière non trouvée'}</p>
//             <div className="d-flex gap-2 mt-2">
//               <button className="btn-primary" onClick={() => navigate('/filieres')}>
//                 <ArrowLeft size={16} /> Retour à la liste
//               </button>
//               <button className="btn-outline" onClick={loadFiliereData}>
//                 Réessayer
//               </button>
//             </div>
//           </div>
//         </div>
//       </div>
//     );
//   }

//   // ============================================================
//   // 8. RENDER - PAGE PRINCIPALE
//   // ============================================================

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />
      
//       {/* Modal de confirmation de suppression */}
//       <Modal
//         isOpen={deleteModal.isOpen}
//         onClose={() => setDeleteModal({ isOpen: false, specialiteId: null, specialiteName: '' })}
//         onConfirm={handleDeleteSpecialite}
//         title="Confirmer la suppression"
//         message={`Êtes-vous sûr de vouloir supprimer la spécialité "${deleteModal.specialiteName}" ?`}
//         confirmText="Supprimer"
//         type="warning"
//       />

//       {/* En-tête */}
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Détail de la filière</h1>
//           <p className="page-description">
//             {filiere.nomFiliere || filiere.name || 'Filière sans nom'}
//             <span className="code-badge ms-2">
//               {filiere.codeFiliere || filiere.code || '-'}
//             </span>
//           </p>
//         </div>
//         <div className="header-buttons">
//           <button className="btn-outline" onClick={() => navigate('/filieres')}>
//             <ArrowLeft size={18} />
//             Retour
//           </button>
//           <button className="btn-primary" onClick={handleEditFiliere}>
//             <Edit size={18} />
//             Modifier
//           </button>
//         </div>
//       </div>

//       {/* Onglets */}
//       <div className="detail-tabs">
//         <button 
//           className={`tab-btn ${activeTab === 'info' ? 'active' : ''}`} 
//           onClick={() => setActiveTab('info')}
//         >
//           <GraduationCap size={16} /> Informations
//         </button>
//         <button 
//           className={`tab-btn ${activeTab === 'specialites' ? 'active' : ''}`} 
//           onClick={() => setActiveTab('specialites')}
//         >
//           <BookOpen size={16} /> Spécialités ({specialites.length})
//           {loadingSpecialites && <Loader size={14} className="ms-1 spinner" />}
//         </button>
//         <button 
//           className={`tab-btn ${activeTab === 'stats' ? 'active' : ''}`} 
//           onClick={() => setActiveTab('stats')}
//         >
//           <TrendingUp size={16} /> Statistiques
//         </button>
//       </div>

//       {/* Onglet Informations */}
//       {activeTab === 'info' && (
//         <div className="detail-grid">
//           <div className="detail-card">
//             <div className="detail-header">
//               <div className="detail-avatar" style={{ 
//                 background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', 
//                 color: 'white' 
//               }}>
//                 <GraduationCap size={24} />
//               </div>
//               <div>
//                 <h2>{filiere.nomFiliere || filiere.name || 'Sans nom'}</h2>
//                 <span className="code-badge">
//                   {filiere.codeFiliere || filiere.code || '-'}
//                 </span>
//               </div>
//             </div>
//             <div className="detail-info">
//               <div className="info-row">
//                 <GraduationCap size={18} />
//                 <span>Description: {filiere.description || 'Aucune description'}</span>
//               </div>
//               <div className="info-row">
//                 <Users size={18} />
//                 <span>Prospects: {filiere.nbProspects || filiere.prospects || 0}</span>
//               </div>
//               <div className="info-row">
//                 <TrendingUp size={18} />
//                 <span>Part: {filiere.pourcentage || 0}%</span>
//               </div>
//               <div className="info-row">
//                 <GraduationCap size={18} />
//                 <span>Statut: {getStatusBadge(filiere.actif !== undefined ? filiere.actif : true)}</span>
//               </div>
//               <div className="info-row">
//                 <Eye size={18} />
//                 <span>Créé le: {formatDate(filiere.createdAt || filiere.created_at || filiere.dateCreation)}</span>
//               </div>
//             </div>
//           </div>
//         </div>
//       )}

//       {/* Onglet Spécialités */}
//       {activeTab === 'specialites' && (
//         <div className="detail-card full-width">
//           <div className="table-header" style={{ 
//             justifyContent: 'space-between', 
//             marginBottom: '16px' 
//           }}>
//             <h3>Spécialités de la filière</h3>
//             <button 
//               className="btn-primary" 
//               style={{ padding: '6px 12px' }} 
//               onClick={handleAddSpecialite}
//             >
//               <Plus size={16} /> Ajouter une spécialité
//             </button>
//           </div>
          
//           {loadingSpecialites ? (
//             <div className="text-center py-3">
//               <Loader size={24} className="spinner" />
//               <p>Chargement des spécialités...</p>
//             </div>
//           ) : specialites.length === 0 ? (
//             <div className="text-center py-4">
//               <BookOpen size={48} className="text-muted" />
//               <p className="mt-2">Aucune spécialité pour cette filière</p>
//               <button className="btn-primary mt-2" onClick={handleAddSpecialite}>
//                 <Plus size={16} /> Ajouter une spécialité
//               </button>
//             </div>
//           ) : (
//             <div className="table-container">
//               <table className="data-table">
//                 <thead>
//                   <tr>
//                     <th>Nom</th>
//                     <th>Description</th>
//                     <th>Prospects</th>
//                     <th>Statut</th>
//                     <th>Actions</th>
//                   </tr>
//                 </thead>
//                 <tbody>
//                   {specialites.map((spec) => (
//                     <tr key={spec.idSpecialite || spec.id}>
//                       <td><strong>{spec.nomSpecialite || spec.name || 'Sans nom'}</strong></td>
//                       <td>{spec.description || '-'}</td>
//                       <td className="text-center">{spec.nbProspects || 0}</td>
//                       <td>{getStatusBadge(spec.actif !== undefined ? spec.actif : true)}</td>
//                       <td>
//                         <div className="action-buttons">
//                           <button 
//                             className="action-btn edit" 
//                             onClick={() => handleEditSpecialite(spec.idSpecialite || spec.id)}
//                           >
//                             <Edit size={16} />
//                           </button>
//                           <button 
//                             className="action-btn delete" 
//                             onClick={() => setDeleteModal({ 
//                               isOpen: true, 
//                               specialiteId: spec.idSpecialite || spec.id, 
//                               specialiteName: spec.nomSpecialite || spec.name || 'Sans nom'
//                             })}
//                           >
//                             <Trash2 size={16} />
//                           </button>
//                         </div>
//                       </td>
//                     </tr>
//                   ))}
//                 </tbody>
//               </table>
//             </div>
//           )}
//         </div>
//       )}

//       {/* Onglet Statistiques */}
//       {activeTab === 'stats' && (
//         <div className="detail-grid">
//           <div className="detail-card">
//             <h3>Répartition des spécialités</h3>
//             {specialites.filter(s => s.actif !== false).length === 0 ? (
//               <p className="text-muted text-center py-3">
//                 Aucune spécialité active pour générer des statistiques
//               </p>
//             ) : (
//               <div className="specialites-stats">
//                 {specialites.filter(s => s.actif !== false).map((spec) => {
//                   const total = filiere.nbProspects || filiere.prospects || 1;
//                   const percentage = total > 0 ? ((spec.nbProspects || 0) / total) * 100 : 0;
                  
//                   return (
//                     <div key={spec.idSpecialite || spec.id} className="stat-bar-item">
//                       <div className="stat-bar-label">
//                         {spec.nomSpecialite || spec.name || 'Sans nom'}
//                       </div>
//                       <div className="stat-bar-bg">
//                         <div 
//                           className="stat-bar-fill" 
//                           style={{ width: `${Math.min(percentage, 100)}%` }}
//                         ></div>
//                       </div>
//                       <div className="stat-bar-value">
//                         {spec.nbProspects || 0} prospects ({percentage.toFixed(1)}%)
//                       </div>
//                     </div>
//                   );
//                 })}
//               </div>
//             )}
            
//             <div className="mt-4 pt-3 border-top">
//               <div className="info-row">
//                 <Users size={18} />
//                 <span>Total prospects: {filiere.nbProspects || filiere.prospects || 0}</span>
//               </div>
//               <div className="info-row">
//                 <BookOpen size={18} />
//                 <span>Nombre de spécialités: {specialites.length}</span>
//               </div>
//               <div className="info-row">
//                 <GraduationCap size={18} />
//                 <span>Spécialités actives: {specialites.filter(s => s.actif !== false).length}</span>
//               </div>
//             </div>
//           </div>
//         </div>
//       )}
//     </div>
//   );
// };

// export default FiliereDetail;