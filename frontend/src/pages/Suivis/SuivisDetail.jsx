// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { ArrowLeft, Edit, Calendar, MessageSquare, User, Clock, Loader, AlertCircle } from 'lucide-react';
// import { suiviService } from '../../services/suiviService';
// import { Suivi } from '../../models/suivi';
// import '../Prospects/Prospects.css';

// //  CORRIGÉ : ce fichier affichait des données 100% inventées (mock),
// // il ne faisait AUCUN appel API. Il charge maintenant le vrai suivi
// // via GET /prospect_api/ISETAG_COM.suivis/{id}/.

// const SuivisDetail = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();

//   const [suivi, setSuivi] = useState(null);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);

//   useEffect(() => {
//     const fetchSuivi = async () => {
//       setLoading(true);
//       setError(null);
//       try {
//         const data = await suiviService.getById(id);
//         ('📥 Suivi chargé:', data);
//         setSuivi(Suivi.fromDjango(data));
//       } catch (err) {
//         console.error(' Erreur de chargement:', err);
//         setError(err.message);
//       } finally {
//         setLoading(false);
//       }
//     };
//     fetchSuivi();
//   }, [id]);

//   if (loading) {
//     return (
//       <div className="page-container">
//         <div className="loading-container">
//           <Loader size={48} className="spin" />
//           <p>Chargement du suivi...</p>
//         </div>
//       </div>
//     );
//   }

//   if (error || !suivi) {
//     return (
//       <div className="page-container">
//         <div className="error-container">
//           <AlertCircle size={48} color="#ef4444" />
//           <h3>Erreur de chargement</h3>
//           <p>{error || 'Suivi introuvable'}</p>
//           <button className="btn-outline" onClick={() => navigate('/suivis')}>Retour à la liste</button>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Détail du suivi</h1>
//           <p className="page-description">Consultez les informations complètes du suivi.</p>
//         </div>
//         <div className="header-buttons">
//           <button className="btn-outline" onClick={() => navigate('/suivis')}>
//             <ArrowLeft size={18} />
//             Retour
//           </button>
//           <button className="btn-primary" onClick={() => navigate(`/suivis/edit/${id}`)}>
//             <Edit size={18} />
//             Modifier
//           </button>
//         </div>
//       </div>

//       <div className="detail-grid">
//         <div className="detail-card">
//           <div className="detail-header">
//             <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
//               <MessageSquare size={20} />
//             </div>
//             <div>
//               <h2>{suivi.libeleSuivi || 'Suivi'}</h2>
//             </div>
//           </div>
//           <div className="detail-info">
//             <div className="info-row"><User size={18} /><span>Prospect: <strong>{suivi.nomProspect || suivi.idProspect}</strong></span></div>
//             <div className="info-row"><Calendar size={18} /><span>Date: {suivi.dateFormatee}</span></div>
//             {suivi.createdAt && (
//               <div className="info-row"><Clock size={18} /><span>Créé le: {new Date(suivi.createdAt).toLocaleDateString('fr-FR')}</span></div>
//             )}
//           </div>
//         </div>

//         <div className="detail-card full-width">
//           <h3>Commentaire</h3>
//           <p className="detail-notes" style={{ background: 'rgba(0,0,0,0.03)', padding: '12px', borderRadius: '10px' }}>
//             {suivi.commentaire || 'Aucun commentaire'}
//           </p>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default SuivisDetail;


import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, MessageSquare, User, Clock, Loader, AlertCircle } from 'lucide-react';
import { suiviService } from '../../services/suiviService';
import { prospectService } from '../../services/prospectService';
import { Suivi } from '../../models/suivi';
import '../Prospects/Prospects.css';

//  CORRIGÉ : ce fichier affichait des données 100% inventées (mock),
// il ne faisait AUCUN appel API. Il charge maintenant le vrai suivi
// via GET /prospect_api/ISETAG_COM.suivis/{id}/.

const SuivisDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const [suivi, setSuivi] = useState(null);
  const [nomProspectSecours, setNomProspectSecours] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchSuivi = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await suiviService.getById(id);
        ('📥 Suivi chargé:', data);
        const suiviObj = Suivi.fromDjango(data);
        setSuivi(suiviObj);

        // Secours si le backend n'a pas renvoyé prospect_details
        if (!suiviObj.nomProspect && suiviObj.idProspect) {
          try {
            const prospect = await prospectService.getById(suiviObj.idProspect);
            setNomProspectSecours(prospect.nomComplet || '');
          } catch {
            // pas grave, on affichera l'ID en dernier recours
          }
        }
      } catch (err) {
        console.error(' Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchSuivi();
  }, [id]);

  if (loading) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement du suivi...</p>
        </div>
      </div>
    );
  }

  if (error || !suivi) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Suivi introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/suivis')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail du suivi</h1>
          <p className="page-description">Consultez les informations complètes du suivi.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/suivis')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/suivis/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <MessageSquare size={20} />
            </div>
            <div>
              <h2>{suivi.libeleSuivi || 'Suivi'}</h2>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><User size={18} /><span>Prospect: <strong>{suivi.nomProspect || nomProspectSecours || suivi.idProspect}</strong></span></div>
            <div className="info-row"><Calendar size={18} /><span>Date: {suivi.dateFormatee}</span></div>
            {suivi.createdAt && (
              <div className="info-row"><Clock size={18} /><span>Créé le: {new Date(suivi.createdAt).toLocaleDateString('fr-FR')}</span></div>
            )}
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Commentaire</h3>
          <p className="detail-notes" style={{ background: 'rgba(0,0,0,0.03)', padding: '12px', borderRadius: '10px' }}>
            {suivi.commentaire || 'Aucun commentaire'}
          </p>
        </div>
      </div>
    </div>
  );
};

export default SuivisDetail;