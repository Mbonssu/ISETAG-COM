// // import React, { useState, useEffect } from 'react';
// // import { useNavigate, useParams } from 'react-router-dom';
// // import { ArrowLeft, Edit, Mail, Phone, Calendar, MapPin, GraduationCap, Users, BookOpen } from 'lucide-react';
// // import { prospectService } from '../../services/prospectService';
// // import { interetService } from '../../services/interetService';
// // import { specialiteService } from '../../services/filiereService';
// // import StarRating from '../../components/StarRating';
// // import { Prospect } from '../../models/prospect';
// // import './Prospects.css';

// // const ProspectDetail = () => {
// //   const navigate = useNavigate();
// //   const { id } = useParams();

// //   const [prospect, setProspect] = useState(null);
// //   const [loading, setLoading] = useState(true);
// //   const [error, setError] = useState(null);
// //   const [interets, setInterets] = useState([]);

// //   useEffect(() => {
// //     const loadData = async () => {
// //       setLoading(true);
// //       try {
// //         // Charger le prospect
// //         const data = await prospectService.getById(id);
// //         setProspect(Prospect.fromDjango(data));

// //         // Charger les niveaux d'intérêt
// //         try {
// //           const interetsData = await interetService.getByProspect(id);
// //           if (Array.isArray(interetsData) && interetsData.length > 0) {
// //             const interetsWithDetails = await Promise.all(
// //               interetsData.map(async (interet) => {
// //                 try {
// //                   const specialite = await specialiteService.getById(interet.idSpecialite);
// //                   return {
// //                     ...interet,
// //                     libeleSpecialite: specialite.libeleSpecialite || specialite.libele || 'Spécialité inconnue',
// //                     acronyme: specialite.acronyme || '',
// //                   };
// //                 } catch (err) {
// //                   return {
// //                     ...interet,
// //                     libeleSpecialite: 'Spécialité non trouvée',
// //                     acronyme: '',
// //                   };
// //                 }
// //               })
// //             );
// //             setInterets(interetsWithDetails);
// //           }
// //         } catch (err) {
// //           console.warn('⚠️ Aucun niveau d\'intérêt trouvé:', err);
// //           setInterets([]);
// //         }
// //       } catch (err) {
// //         console.error('❌ Erreur:', err);
// //         setError(err.message);
// //       } finally {
// //         setLoading(false);
// //       }
// //     };

// //     loadData();
// //   }, [id]);

// //   // ============================================================
// //   // FONCTIONS UTILITAIRES
// //   // ============================================================

// //   const displayInfo = (value, fallback = 'Informations non renseignées') => {
// //     if (!value || value === '' || value === null || value === undefined) {
// //       return fallback;
// //     }
// //     return value;
// //   };

// //   const formatPhoneNumber = (phone) => {
// //     if (!phone) return 'Téléphone non renseigné';
// //     const clean = phone.replace(/\D/g, '');
// //     if (clean.length !== 9 || !clean.startsWith('6')) {
// //       return phone;
// //     }
// //     return clean.replace(/(\d{1})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
// //   };

// //   const InfoRow = ({ icon: Icon, label, value, fallback = 'Informations non renseignées' }) => {
// //     const displayValue = displayInfo(value, fallback);
// //     const isMissing = displayValue === fallback;
    
// //     return (
// //       <div className="info-row">
// //         <Icon size={18} className={isMissing ? 'text-muted' : ''} />
// //         <span className={isMissing ? 'text-muted missing-info' : ''}>
// //           {displayValue}
// //         </span>
// //       </div>
// //     );
// //   };

// //   if (loading) return <p className="page-loading">Chargement…</p>;
// //   if (error) return <p className="form-error">{error}</p>;
// //   if (!prospect) return <p className="form-error">Prospect introuvable.</p>;

// //   return (
// //     <div className="page-container">
// //       <div className="page-header-actions">
// //         <div>
// //           <h1 className="page-title-h1">Détail du prospect</h1>
// //           <p className="page-description">Consultez toutes les informations concernant ce prospect.</p>
// //         </div>
// //         <div className="header-buttons">
// //           <button className="btn-outline" onClick={() => navigate('/prospects')}>
// //             <ArrowLeft size={18} />
// //             Retour
// //           </button>
// //           <button className="btn-primary" onClick={() => navigate(`/prospects/edit/${id}`)}>
// //             <Edit size={18} />
// //             Modifier
// //           </button>
// //         </div>
// //       </div>

// //       <div className="detail-grid">
// //         {/* ============================================================
// //             CARTE PRINCIPALE - INFORMATIONS DU PROSPECT
// //             ============================================================ */}
// //         <div className="detail-card">
// //           <div className="detail-header">
// //             <div className="detail-avatar">{prospect.initials}</div>
// //             <div>
// //               <h2>{displayInfo(prospect.nomComplet, 'Nom non renseigné')}</h2>
// //               <span className="badge badge-info">
// //                 {displayInfo(prospect.typeProspect, 'Type non renseigné')}
// //               </span>
// //             </div>
// //           </div>
// //           <div className="detail-info">
// //             {/* Email */}
// //             <div className="info-row">
// //               <Mail size={18} className={!prospect.email ? 'text-muted' : ''} />
// //               <span className={!prospect.email ? 'text-muted missing-info' : ''}>
// //                 {prospect.email || 'Email non renseigné'}
// //               </span>
// //             </div>

// //             {/* Téléphone */}
// //             <div className="info-row">
// //               <Phone size={18} className={!prospect.telephone ? 'text-muted' : ''} />
// //               <span className={!prospect.telephone ? 'text-muted missing-info' : ''}>
// //                 {formatPhoneNumber(prospect.telephone)}
// //               </span>
// //             </div>

// //             {/* Date d'ajout */}
// //             <div className="info-row">
// //               <Calendar size={18} />
// //               <span>
// //                 Ajouté le {prospect.createdAt ? new Date(prospect.createdAt).toLocaleDateString('fr-FR') : 'Date non renseignée'}
// //               </span>
// //             </div>

// //             {/* Adresse complète */}
// //             <div className="info-row">
// //               <MapPin size={18} className={!prospect.adresse && !prospect.ville && !prospect.pays ? 'text-muted' : ''} />
// //               <span className={!prospect.adresse && !prospect.ville && !prospect.pays ? 'text-muted missing-info' : ''}>
// //                 {prospect.adresse || prospect.ville || prospect.pays ? 
// //                   `${prospect.adresse || ''}${prospect.ville ? `, ${prospect.ville}` : ''}${prospect.pays ? ` (${prospect.pays})` : ''}` 
// //                   : 'Adresse non renseignée'}
// //               </span>
// //             </div>

// //             {/* Niveau d'étude et domaine */}
// //             <div className="info-row">
// //               <GraduationCap size={18} className={!prospect.niveauEtude && !prospect.domaineEtude ? 'text-muted' : ''} />
// //               <span className={!prospect.niveauEtude && !prospect.domaineEtude ? 'text-muted missing-info' : ''}>
// //                 {prospect.niveauEtude || 'Niveau non renseigné'}
// //                 {prospect.domaineEtude && ` — ${prospect.domaineEtude}`}
// //                 {!prospect.domaineEtude && prospect.niveauEtude && ' — Domaine non renseigné'}
// //               </span>
// //             </div>

// //             {/* Sexe */}
// //             <div className="info-row">
// //               <Users size={18} className={!prospect.sexe ? 'text-muted' : ''} />
// //               <span className={!prospect.sexe ? 'text-muted missing-info' : ''}>
// //                 {prospect.sexeLabel || 'Sexe non renseigné'}
// //               </span>
// //             </div>
// //           </div>
// //         </div>

// //         {/* ============================================================
// //             CARTE SPÉCIALITÉS ET NIVEAUX D'INTÉRÊT
// //             ============================================================ */}
// //         <div className="detail-card">
// //           <h3>Spécialités et niveaux d'intérêt</h3> <br />
// //           <div className="detail-info">
// //             {interets.length > 0 ? (
// //               interets.map((interet, index) => (
// //                 <div key={index} className="interet-detail-item">
// //                   <div className="interet-detail-info">
// //                     <span className="interet-detail-name">
// //                       <BookOpen size={16} style={{ marginRight: '8px' }} />
// //                       {interet.libeleSpecialite || 'Spécialité inconnue'}
// //                       {interet.acronyme && (
// //                         <span className="acronyme-badge" style={{ marginLeft: '8px' }}>
// //                           {interet.acronyme}
// //                         </span>
// //                       )}
// //                     </span>
// //                     <div className="interet-detail-rating">
// //                       <span className="rating-label">Intérêt:</span>
// //                       <StarRating 
// //                         value={parseInt(interet.niveauInteret) || 0} 
// //                         readonly={true} 
// //                         size={20}
// //                       />
// //                     </div>
// //                   </div>
// //                 </div>
// //               ))
// //             ) : (
// //               <div className="info-row">
// //                 <span className="text-muted missing-info" style={{ fontSize: '14px' }}>
// //                   Aucune spécialité renseignée
// //                 </span>
// //               </div>
// //             )}
// //           </div>
// //         </div>

// //         {/* ============================================================
// //             CARTE PARENT - INFORMATIONS DU PARENT
// //             ============================================================ */}
// //         <div className="detail-card">
// //           <h3>Contact parent</h3> <br />
// //           <div className="detail-info">
// //             {/* Nom du parent */}
// //             <div className="info-row">
// //               <Users size={18} className={!prospect.nomParent ? 'text-muted' : ''} />
// //               <span className={!prospect.nomParent ? 'text-muted missing-info' : ''}>
// //                 {prospect.nomParent || 'Nom du parent non renseigné'}
// //               </span>
// //             </div> 

// //             {/* Téléphone du parent */}
// //             <div className="info-row">
// //               <Phone size={18} className={!prospect.numeroParent ? 'text-muted' : ''} />
// //               <span className={!prospect.numeroParent ? 'text-muted missing-info' : ''}>
// //                 {prospect.numeroParent ? formatPhoneNumber(prospect.numeroParent) : 'Téléphone du parent non renseigné'}
// //               </span>
// //             </div>

// //             {/* Si aucun info parent */}
// //             {!prospect.nomParent && !prospect.numeroParent && (
// //               <div className="info-row">
// //                 <span className="text-muted missing-info" style={{ fontStyle: 'italic', fontSize: '14px' }}>
// //                   Aucune information sur le parent renseignée
// //                 </span>
// //               </div>
// //             )}
// //           </div>
// //         </div>
// //       </div>
// //     </div>
// //   );
// // };

// // export default ProspectDetail;

// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { ArrowLeft, Edit, Mail, Phone, Calendar, MapPin, GraduationCap, Users, BookOpen } from 'lucide-react';
// import { prospectService } from '../../services/prospectService';
// import { interetService } from '../../services/interetService';
// import { specialiteService } from '../../services/filiereService';
// import StarRating from '../../components/StarRating';
// import { Prospect } from '../../models/prospect';
// import './Prospects.css';

// const ProspectDetail = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();

//   const [prospect, setProspect] = useState(null);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [interets, setInterets] = useState([]);

//   useEffect(() => {
//     const loadData = async () => {
//       setLoading(true);
//       try {
//         // Charger le prospect
//         const data = await prospectService.getById(id);
//         setProspect(Prospect.fromDjango(data));

//         // Charger les niveaux d'intérêt
//         try {
//           const interetsData = await interetService.getByProspect(id);
//           console.log('🔍 DEBUG - forme brute de la réponse getByProspect:', interetsData);
//           if (Array.isArray(interetsData) && interetsData.length > 0) {
//             const interetsWithDetails = await Promise.all(
//               interetsData.map(async (interet) => {
//                 try {
//                   const specialite = await specialiteService.getById(interet.idSpecialite);
//                   return {
//                     ...interet,
//                     libeleSpecialite: specialite.libeleSpecialite || specialite.libele || 'Spécialité inconnue',
//                     acronyme: specialite.acronyme || '',
//                   };
//                 } catch (err) {
//                   return {
//                     ...interet,
//                     libeleSpecialite: 'Spécialité non trouvée',
//                     acronyme: '',
//                   };
//                 }
//               })
//             );
//             setInterets(interetsWithDetails);
//           }
//         } catch (err) {
//           console.warn('⚠️ Aucun niveau d\'intérêt trouvé:', err);
//           setInterets([]);
//         }
//       } catch (err) {
//         console.error('❌ Erreur:', err);
//         setError(err.message);
//       } finally {
//         setLoading(false);
//       }
//     };

//     loadData();
//   }, [id]);

//   // ============================================================
//   // FONCTIONS UTILITAIRES
//   // ============================================================

//   const displayInfo = (value, fallback = 'Informations non renseignées') => {
//     if (!value || value === '' || value === null || value === undefined) {
//       return fallback;
//     }
//     return value;
//   };

//   const formatPhoneNumber = (phone) => {
//     if (!phone) return 'Téléphone non renseigné';
//     const clean = phone.replace(/\D/g, '');
//     if (clean.length !== 9 || !clean.startsWith('6')) {
//       return phone;
//     }
//     return clean.replace(/(\d{1})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
//   };

//   const InfoRow = ({ icon: Icon, label, value, fallback = 'Informations non renseignées' }) => {
//     const displayValue = displayInfo(value, fallback);
//     const isMissing = displayValue === fallback;
    
//     return (
//       <div className="info-row">
//         <Icon size={18} className={isMissing ? 'text-muted' : ''} />
//         <span className={isMissing ? 'text-muted missing-info' : ''}>
//           {displayValue}
//         </span>
//       </div>
//     );
//   };

//   if (loading) return <p className="page-loading">Chargement…</p>;
//   if (error) return <p className="form-error">{error}</p>;
//   if (!prospect) return <p className="form-error">Prospect introuvable.</p>;

//   return (
//     <div className="page-container">
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Détail du prospect</h1>
//           <p className="page-description">Consultez toutes les informations concernant ce prospect.</p>
//         </div>
//         <div className="header-buttons">
//           <button className="btn-outline" onClick={() => navigate('/prospects')}>
//             <ArrowLeft size={18} />
//             Retour
//           </button>
//           <button className="btn-primary" onClick={() => navigate(`/prospects/edit/${id}`)}>
//             <Edit size={18} />
//             Modifier
//           </button>
//         </div>
//       </div>

//       <div className="detail-grid">
//         {/* ============================================================
//             CARTE PRINCIPALE - INFORMATIONS DU PROSPECT
//             ============================================================ */}
//         <div className="detail-card">
//           <div className="detail-header">
//             <div className="detail-avatar">{prospect.initials}</div>
//             <div>
//               <h2>{displayInfo(prospect.nomComplet, 'Nom non renseigné')}</h2>
//               <span className="badge badge-info">
//                 {displayInfo(prospect.typeProspect, 'Type non renseigné')}
//               </span>
//             </div>
//           </div>
//           <div className="detail-info">
//             {/* Email */}
//             <div className="info-row">
//               <Mail size={18} className={!prospect.email ? 'text-muted' : ''} />
//               <span className={!prospect.email ? 'text-muted missing-info' : ''}>
//                 {prospect.email || 'Email non renseigné'}
//               </span>
//             </div>

//             {/* Téléphone */}
//             <div className="info-row">
//               <Phone size={18} className={!prospect.telephone ? 'text-muted' : ''} />
//               <span className={!prospect.telephone ? 'text-muted missing-info' : ''}>
//                 {formatPhoneNumber(prospect.telephone)}
//               </span>
//             </div>

//             {/* Date d'ajout */}
//             <div className="info-row">
//               <Calendar size={18} />
//               <span>
//                 Ajouté le {prospect.createdAt ? new Date(prospect.createdAt).toLocaleDateString('fr-FR') : 'Date non renseignée'}
//               </span>
//             </div>

//             {/* Adresse complète */}
//             <div className="info-row">
//               <MapPin size={18} className={!prospect.adresse && !prospect.ville && !prospect.pays ? 'text-muted' : ''} />
//               <span className={!prospect.adresse && !prospect.ville && !prospect.pays ? 'text-muted missing-info' : ''}>
//                 {prospect.adresse || prospect.ville || prospect.pays ? 
//                   `${prospect.adresse || ''}${prospect.ville ? `, ${prospect.ville}` : ''}${prospect.pays ? ` (${prospect.pays})` : ''}` 
//                   : 'Adresse non renseignée'}
//               </span>
//             </div>

//             {/* Niveau d'étude et domaine */}
//             <div className="info-row">
//               <GraduationCap size={18} className={!prospect.niveauEtude && !prospect.domaineEtude ? 'text-muted' : ''} />
//               <span className={!prospect.niveauEtude && !prospect.domaineEtude ? 'text-muted missing-info' : ''}>
//                 {prospect.niveauEtude || 'Niveau non renseigné'}
//                 {prospect.domaineEtude && ` — ${prospect.domaineEtude}`}
//                 {!prospect.domaineEtude && prospect.niveauEtude && ' — Domaine non renseigné'}
//               </span>
//             </div>

//             {/* Sexe */}
//             <div className="info-row">
//               <Users size={18} className={!prospect.sexe ? 'text-muted' : ''} />
//               <span className={!prospect.sexe ? 'text-muted missing-info' : ''}>
//                 {prospect.sexeLabel || 'Sexe non renseigné'}
//               </span>
//             </div>
//           </div>
//         </div>

//         {/* ============================================================
//             CARTE SPÉCIALITÉS ET NIVEAUX D'INTÉRÊT
//             ============================================================ */}
//         <div className="detail-card">
//           <h3>Spécialités et niveaux d'intérêt</h3> <br />
//           <div className="detail-info">
//             {interets.length > 0 ? (
//               interets.map((interet, index) => (
//                 <div key={index} className="interet-detail-item">
//                   <div className="interet-detail-info">
//                     <span className="interet-detail-name">
//                       <BookOpen size={16} style={{ marginRight: '8px' }} />
//                       {interet.libeleSpecialite || 'Spécialité inconnue'}
//                       {interet.acronyme && (
//                         <span className="acronyme-badge" style={{ marginLeft: '8px' }}>
//                           {interet.acronyme}
//                         </span>
//                       )}
//                     </span>
//                     <div className="interet-detail-rating">
//                       <span className="rating-label">Intérêt:</span>
//                       <StarRating 
//                         value={parseInt(interet.niveauInteret) || 0} 
//                         readonly={true} 
//                         size={20}
//                       />
//                     </div>
//                   </div>
//                 </div>
//               ))
//             ) : (
//               <div className="info-row">
//                 <span className="text-muted missing-info" style={{ fontSize: '14px' }}>
//                   Aucune spécialité renseignée
//                 </span>
//               </div>
//             )}
//           </div>
//         </div>

//         {/* ============================================================
//             CARTE PARENT - INFORMATIONS DU PARENT
//             ============================================================ */}
//         <div className="detail-card">
//           <h3>Contact parent</h3> <br />
//           <div className="detail-info">
//             {/* Nom du parent */}
//             <div className="info-row">
//               <Users size={18} className={!prospect.nomParent ? 'text-muted' : ''} />
//               <span className={!prospect.nomParent ? 'text-muted missing-info' : ''}>
//                 {prospect.nomParent || 'Nom du parent non renseigné'}
//               </span>
//             </div> 

//             {/* Téléphone du parent */}
//             <div className="info-row">
//               <Phone size={18} className={!prospect.numeroParent ? 'text-muted' : ''} />
//               <span className={!prospect.numeroParent ? 'text-muted missing-info' : ''}>
//                 {prospect.numeroParent ? formatPhoneNumber(prospect.numeroParent) : 'Téléphone du parent non renseigné'}
//               </span>
//             </div>

//             {/* Si aucun info parent */}
//             {!prospect.nomParent && !prospect.numeroParent && (
//               <div className="info-row">
//                 <span className="text-muted missing-info" style={{ fontStyle: 'italic', fontSize: '14px' }}>
//                   Aucune information sur le parent renseignée
//                 </span>
//               </div>
//             )}
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default ProspectDetail;

import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Mail, Phone, Calendar, MapPin, GraduationCap, Users, BookOpen } from 'lucide-react';
import { prospectService } from '../../services/prospectService';
import { interetService } from '../../services/interetService';
import { specialiteService } from '../../services/filiereService';
import StarRating from '../../components/StarRating';
import { Prospect } from '../../models/prospect';
import './Prospects.css';

// Mapping identique à celui de ProspectForm.jsx : niveauInteret est un texte
// ("Faible" | "Moyen" | "Élevé" | "Très élevé"), pas un nombre. parseInt()
// dessus renvoie NaN, ce qui faisait afficher 0 étoile à chaque fois.
const NIVEAU_TO_STARS = { 'Faible': 1, 'Moyen': 2, 'Élevé': 3, 'Très élevé': 4, 'Excellent': 5 };

const ProspectDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const [prospect, setProspect] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [interets, setInterets] = useState([]);

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        // Charger le prospect
        const data = await prospectService.getById(id);
        setProspect(Prospect.fromDjango(data));

        // Charger les niveaux d'intérêt
        try {
          const interetsData = await interetService.getByProspect(id);
          if (Array.isArray(interetsData) && interetsData.length > 0) {
            const interetsWithDetails = await Promise.all(
              interetsData.map(async (interet) => {
                try {
                  const specialite = await specialiteService.getById(interet.idSpecialite);
                  return {
                    ...interet,
                    libeleSpecialite: specialite.libeleSpecialite || specialite.libele || 'Spécialité inconnue',
                    acronyme: specialite.acronyme || '',
                  };
                } catch (err) {
                  return {
                    ...interet,
                    libeleSpecialite: 'Spécialité non trouvée',
                    acronyme: '',
                  };
                }
              })
            );
            setInterets(interetsWithDetails);
          }
        } catch (err) {
          console.warn('⚠️ Aucun niveau d\'intérêt trouvé:', err);
          setInterets([]);
        }
      } catch (err) {
        console.error('❌ Erreur:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, [id]);

  // ============================================================
  // FONCTIONS UTILITAIRES
  // ============================================================

  const displayInfo = (value, fallback = 'Informations non renseignées') => {
    if (!value || value === '' || value === null || value === undefined) {
      return fallback;
    }
    return value;
  };

  const formatPhoneNumber = (phone) => {
    if (!phone) return 'Téléphone non renseigné';
    const clean = phone.replace(/\D/g, '');
    if (clean.length !== 9 || !clean.startsWith('6')) {
      return phone;
    }
    return clean.replace(/(\d{1})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
  };

  const InfoRow = ({ icon: Icon, label, value, fallback = 'Informations non renseignées' }) => {
    const displayValue = displayInfo(value, fallback);
    const isMissing = displayValue === fallback;
    
    return (
      <div className="info-row">
        <Icon size={18} className={isMissing ? 'text-muted' : ''} />
        <span className={isMissing ? 'text-muted missing-info' : ''}>
          {displayValue}
        </span>
      </div>
    );
  };

  if (loading) return <p className="page-loading">Chargement…</p>;
  if (error) return <p className="form-error">{error}</p>;
  if (!prospect) return <p className="form-error">Prospect introuvable.</p>;

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail du prospect</h1>
          <p className="page-description">Consultez toutes les informations concernant ce prospect.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/prospects')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/prospects/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        {/* ============================================================
            CARTE PRINCIPALE - INFORMATIONS DU PROSPECT
            ============================================================ */}
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar">{prospect.initials}</div>
            <div>
              <h2>{displayInfo(prospect.nomComplet, 'Nom non renseigné')}</h2>
              <span className="badge badge-info">
                {displayInfo(prospect.typeProspect, 'Type non renseigné')}
              </span>
            </div>
          </div>
          <div className="detail-info">
            {/* Email */}
            <div className="info-row">
              <Mail size={18} className={!prospect.email ? 'text-muted' : ''} />
              <span className={!prospect.email ? 'text-muted missing-info' : ''}>
                {prospect.email || 'Email non renseigné'}
              </span>
            </div>

            {/* Téléphone */}
            <div className="info-row">
              <Phone size={18} className={!prospect.telephone ? 'text-muted' : ''} />
              <span className={!prospect.telephone ? 'text-muted missing-info' : ''}>
                {formatPhoneNumber(prospect.telephone)}
              </span>
            </div>

            {/* Date d'ajout */}
            <div className="info-row">
              <Calendar size={18} />
              <span>
                Ajouté le {prospect.createdAt ? new Date(prospect.createdAt).toLocaleDateString('fr-FR') : 'Date non renseignée'}
              </span>
            </div>

            {/* Adresse complète */}
            <div className="info-row">
              <MapPin size={18} className={!prospect.adresse && !prospect.ville && !prospect.pays ? 'text-muted' : ''} />
              <span className={!prospect.adresse && !prospect.ville && !prospect.pays ? 'text-muted missing-info' : ''}>
                {prospect.adresse || prospect.ville || prospect.pays ? 
                  `${prospect.adresse || ''}${prospect.ville ? `, ${prospect.ville}` : ''}${prospect.pays ? ` (${prospect.pays})` : ''}` 
                  : 'Adresse non renseignée'}
              </span>
            </div>

            {/* Niveau d'étude et domaine */}
            <div className="info-row">
              <GraduationCap size={18} className={!prospect.niveauEtude && !prospect.domaineEtude ? 'text-muted' : ''} />
              <span className={!prospect.niveauEtude && !prospect.domaineEtude ? 'text-muted missing-info' : ''}>
                {prospect.niveauEtude || 'Niveau non renseigné'}
                {prospect.domaineEtude && ` — ${prospect.domaineEtude}`}
                {!prospect.domaineEtude && prospect.niveauEtude && ' — Domaine non renseigné'}
              </span>
            </div>

            {/* Sexe */}
            <div className="info-row">
              <Users size={18} className={!prospect.sexe ? 'text-muted' : ''} />
              <span className={!prospect.sexe ? 'text-muted missing-info' : ''}>
                {prospect.sexeLabel || 'Sexe non renseigné'}
              </span>
            </div>
          </div>
        </div>

        {/* ============================================================
            CARTE SPÉCIALITÉS ET NIVEAUX D'INTÉRÊT
            ============================================================ */}
        <div className="detail-card">
          <h3>Spécialités et niveaux d'intérêt</h3> <br />
          <div className="detail-info">
            {interets.length > 0 ? (
              interets.map((interet, index) => (
                <div key={index} className="interet-detail-item">
                  <div className="interet-detail-info">
                    <span className="interet-detail-name">
                      <BookOpen size={16} style={{ marginRight: '8px' }} />
                      {interet.libeleSpecialite || 'Spécialité inconnue'}
                      {interet.acronyme && (
                        <span className="acronyme-badge" style={{ marginLeft: '8px' }}>
                          {interet.acronyme}
                        </span>
                      )}
                    </span>
                    <div className="interet-detail-rating">
                      <span className="rating-label">Intérêt:</span>
                      <StarRating
                        value={NIVEAU_TO_STARS[interet.niveauInteret] ?? 0}
                        readonly={true}
                        size={20}
                      />
                    </div>
                  </div>
                </div>
              ))
            ) : (
              <div className="info-row">
                <span className="text-muted missing-info" style={{ fontSize: '14px' }}>
                  Aucune spécialité renseignée
                </span>
              </div>
            )}
          </div>
        </div>

        {/* ============================================================
            CARTE PARENT - INFORMATIONS DU PARENT
            ============================================================ */}
        <div className="detail-card">
          <h3>Contact parent</h3> <br />
          <div className="detail-info">
            {/* Nom du parent */}
            <div className="info-row">
              <Users size={18} className={!prospect.nomParent ? 'text-muted' : ''} />
              <span className={!prospect.nomParent ? 'text-muted missing-info' : ''}>
                {prospect.nomParent || 'Nom du parent non renseigné'}
              </span>
            </div> 

            {/* Téléphone du parent */}
            <div className="info-row">
              <Phone size={18} className={!prospect.numeroParent ? 'text-muted' : ''} />
              <span className={!prospect.numeroParent ? 'text-muted missing-info' : ''}>
                {prospect.numeroParent ? formatPhoneNumber(prospect.numeroParent) : 'Téléphone du parent non renseigné'}
              </span>
            </div>

            {/* Si aucun info parent */}
            {!prospect.nomParent && !prospect.numeroParent && (
              <div className="info-row">
                <span className="text-muted missing-info" style={{ fontStyle: 'italic', fontSize: '14px' }}>
                  Aucune information sur le parent renseignée
                </span>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProspectDetail;