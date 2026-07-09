// import React, { useState } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { ArrowLeft, Edit, Plus, Trash2, Building, MapPin, Phone, Mail, Users, BookOpen, Eye, Star } from 'lucide-react';
// import Modal from '../../components/common/Modal';
// import { ToastContainer } from '../../components/common/Toast';
// import '../Prospects/Prospects.css';

// const EtablissementDetail = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const [activeTab, setActiveTab] = useState('info');
//   const [toasts, setToasts] = useState([]);
//   const [deleteModal, setDeleteModal] = useState({ isOpen: false, classeId: null, classeName: '' });

//   const addToast = (message, type = 'success') => {
//     const toastId = Date.now();
//     setToasts(prev => [...prev, { id: toastId, message, type }]);
//     setTimeout(() => removeToast(toastId), 3000);
//   };

//   const removeToast = (id) => {
//     setToasts(prev => prev.filter(t => t.id !== id));
//   };

//   const etablissement = {
//     id: id,
//     name: 'Lycée de Biyem-Assi',
//     type: 'Lycée',
//     ville: 'Yaoundé',
//     adresse: 'Biyem-Assi, Yaoundé',
//     telephone: '222 123 456',
//     email: 'contact@lyceebiyemassi.cm',
//     contacts: 3,
//     prospects: 45,
//     agent: 'Jean M.',
//     rating: 4.5
//   };

//   const [classes, setClasses] = useState([
//     { id: 1, name: 'Terminale C', niveau: 'Terminale', effectif: 45, nbProspects: 12, actif: true },
//     { id: 2, name: 'Terminale D', niveau: 'Terminale', effectif: 48, nbProspects: 10, actif: true },
//     { id: 3, name: 'Première C', niveau: 'Première', effectif: 50, nbProspects: 8, actif: true },
//     { id: 4, name: 'Première D', niveau: 'Première', effectif: 47, nbProspects: 7, actif: false },
//   ]);

//   const handleDeleteClasse = () => {
//     addToast(`Classe "${deleteModal.classeName}" supprimée avec succès`, 'success');
//     setClasses(classes.filter(c => c.id !== deleteModal.classeId));
//     setDeleteModal({ isOpen: false, classeId: null, classeName: '' });
//   };

//   const getRatingStars = (rating) => {
//     const stars = [];
//     for (let i = 0; i < Math.floor(rating); i++) stars.push(<Star key={i} size={14} fill="#f5c842" color="#f5c842" />);
//     return stars;
//   };

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />
      
//       <Modal
//         isOpen={deleteModal.isOpen}
//         onClose={() => setDeleteModal({ isOpen: false, classeId: null, classeName: '' })}
//         onConfirm={handleDeleteClasse}
//         title="Confirmer la suppression"
//         message={`Êtes-vous sûr de vouloir supprimer la classe "${deleteModal.classeName}" ?`}
//         confirmText="Supprimer"
//         type="warning"
//       />

//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Détail de l'établissement</h1>
//           <p className="page-description">Consultez les informations de l'établissement et ses classes.</p>
//         </div>
//         <div className="header-buttons">
//           <button className="btn-outline" onClick={() => navigate('/etablissements')}>
//             <ArrowLeft size={18} />
//             Retour
//           </button>
//           <button className="btn-primary" onClick={() => navigate(`/etablissements/edit/${id}`)}>
//             <Edit size={18} />
//             Modifier
//           </button>
//         </div>
//       </div>

//       <div className="detail-tabs">
//         <button className={`tab-btn ${activeTab === 'info' ? 'active' : ''}`} onClick={() => setActiveTab('info')}>
//           <Building size={16} /> Informations
//         </button>
//         <button className={`tab-btn ${activeTab === 'classes' ? 'active' : ''}`} onClick={() => setActiveTab('classes')}>
//           <BookOpen size={16} /> Classes ({classes.length})
//         </button>
//         <button className={`tab-btn ${activeTab === 'prospects' ? 'active' : ''}`} onClick={() => setActiveTab('prospects')}>
//           <Users size={16} /> Prospects
//         </button>
//       </div>

//       {activeTab === 'info' && (
//         <div className="detail-grid">
//           <div className="detail-card">
//             <div className="detail-header">
//               <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
//                 <Building size={24} />
//               </div>
//               <div>
//                 <h2>{etablissement.name}</h2>
//                 <span className="type-badge">{etablissement.type}</span>
//               </div>
//             </div>
//             <div className="detail-info">
//               <div className="info-row"><MapPin size={18} /><span>{etablissement.adresse}</span></div>
//               <div className="info-row"><MapPin size={18} /><span>{etablissement.ville}</span></div>
//               <div className="info-row"><Phone size={18} /><span>{etablissement.telephone}</span></div>
//               <div className="info-row"><Mail size={18} /><span>{etablissement.email}</span></div>
//               <div className="info-row"><Users size={18} /><span>Contacts: {etablissement.contacts}</span></div>
//               <div className="info-row"><Users size={18} /><span>Prospects: {etablissement.prospects}</span></div>
//               <div className="info-row"><Users size={18} /><span>Agent: {etablissement.agent}</span></div>
//               <div className="info-row"><Star size={18} /><span>Note: {getRatingStars(etablissement.rating)} ({etablissement.rating})</span></div>
//             </div>
//           </div>
//         </div>
//       )}

//       {activeTab === 'classes' && (
//         <div className="detail-card full-width">
//           <div className="table-header" style={{ justifyContent: 'space-between', marginBottom: '16px' }}>
//             <h3>Classes de l'établissement</h3>
//             <button className="btn-primary" style={{ padding: '6px 12px' }} onClick={() => navigate(`/classes/new?etablissement=${id}`)}>
//               <Plus size={16} /> Ajouter une classe
//             </button>
//           </div>
//           <div className="table-container">
//             <table className="data-table">
//               <thead>
//                 <tr>
//                   <th>Nom</th>
//                   <th>Niveau</th>
//                   <th>Effectif</th>
//                   <th>Prospects</th>
//                   <th>Statut</th>
//                   <th>Actions</th>
//                 </tr>
//               </thead>
//               <tbody>
//                 {classes.map((classe) => (
//                   <tr key={classe.id}>
//                     <td><strong>{classe.name}</strong></td>
//                     <td>{classe.niveau}</td>
//                     <td className="text-center">{classe.effectif}</td>
//                     <td className="text-center">{classe.nbProspects}</td>
//                     <td><span className={`badge ${classe.actif ? 'badge-success' : 'badge-secondary'}`}>{classe.actif ? 'Actif' : 'Inactif'}</span></td>
//                     <td>
//                       <div className="action-buttons">
//                         <button className="action-btn edit" onClick={() => navigate(`/classes/edit/${classe.id}`)}><Edit size={16} /></button>
//                         <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, classeId: classe.id, classeName: classe.name })}><Trash2 size={16} /></button>
//                       </div>
//                     </td>
//                   </tr>
//                 ))}
//               </tbody>
//             </table>
//           </div>
//         </div>
//       )}

//       {activeTab === 'prospects' && (
//         <div className="detail-card full-width">
//           <h3>Prospects de cet établissement</h3>
//           <div className="table-container">
//             <table className="data-table">
//               <thead>
//                 <tr><th>Nom</th><th>Contact</th><th>Filière</th><th>Statut</th><th>Actions</th></tr>
//               </thead>
//               <tbody>
//                 <tr><td>Marie L.</td><td>691234567</td>
//                 <td>Génie Logiciel</td>
//                 <td><span className="badge badge-warning">À relancer</span></td>
//                 <td><button className="action-btn view" onClick={() => navigate('/prospects/1')}><Eye size={16} /></button></td>
//               </tr>
//                 <tr><td>Paul D.</td>
//                 <td>697890123</td>
//                 <td>Génie Civil</td>
//                 <td><span className="badge badge-success">Converti</span></td>
//                 <td><button className="action-btn view" onClick={() => navigate('/prospects/2')}><Eye size={16} /></button></td>
//               </tr>
//               </tbody>
//             </table>
//           </div>
//         </div>
//       )}
//     </div>
//   );
// };

// export default EtablissementDetail;



import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Building, MapPin, Phone, Loader, AlertCircle } from 'lucide-react';
import { etablissementService } from '../../services/etablissementService';
import '../Prospects/Prospects.css';

// ⚠️ CORRIGÉ : cette page affichait des "classes" et des statistiques
// inventées. Aucune route de ce type n'existe côté backend pour un
// établissement (schéma etablissement : nom, adresse, ville, region,
// type, telephone uniquement) — section retirée.

const EtablissementDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [etab, setEtab] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchEtab = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await etablissementService.getById(id);
        console.log('📥 Établissement chargé:', raw);
        setEtab(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error('❌ Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchEtab();
  }, [id]);

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de l'établissement...</p></div></div>;
  }
  if (error || !etab) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Établissement introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/etablissements')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de l'établissement</h1>
          <p className="page-description">Consultez les informations complètes de l'établissement.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/etablissements')}><ArrowLeft size={18} /> Retour</button>
          <button className="btn-primary" onClick={() => navigate(`/etablissements/edit/${id}`)}><Edit size={18} /> Modifier</button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Building size={24} />
            </div>
            <div>
              <h2>{etab.nom}</h2>
              <span className="badge badge-info">{etab.type}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><MapPin size={18} /><span>Adresse: {etab.adresse}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Ville: {etab.ville}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Région: {etab.region}</span></div>
            <div className="info-row"><Phone size={18} /><span>Téléphone: {etab.telephone}</span></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default EtablissementDetail;