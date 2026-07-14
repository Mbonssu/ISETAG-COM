// import React, { useState, useEffect, useCallback } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { ArrowLeft, Edit, Users, Calendar, Globe, BarChart3, AlertCircle } from 'lucide-react';
// import Loader from '../../components/common/Loader';
// import { sourceService } from '../../services/sourceService';
// import { ficheService } from '../../services/ficheService';
// import '../Prospects/Prospects.css';

// const formatDate = (iso) => {
//   if (!iso) return '—';
//   return new Date(iso).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' });
// };

// const SourceDetail = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();

//   const [source, setSource] = useState(null);
//   const [prospectsCount, setProspectsCount] = useState(0);
//   const [pourcentage, setPourcentage] = useState(0);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);

//   const loadData = useCallback(async () => {
//     try {
//       setLoading(true);
//       setError(null);
//       const [sourceData, fiches] = await Promise.all([
//         sourceService.getById(id),
//         ficheService.getAll(),
//       ]);
//       setSource(sourceData);
//       const nb = fiches.filter((f) => f.idSource === id).length;
//       setProspectsCount(nb);
//       setPourcentage(fiches.length ? Math.round((nb / fiches.length) * 100) : 0);
//     } catch (err) {
//       console.error(err);
//       setError(err.message || "Impossible de charger cette source");
//     } finally {
//       setLoading(false);
//     }
//   }, [id]);

//   useEffect(() => { loadData(); }, [loadData]);

//   if (loading) return <div className="page-container"><Loader fullScreen /></div>;

//   if (error || !source) {
//     return (
//       <div className="page-container">
//         <div className="no-results">
//           <AlertCircle size={48} />
//           <h3>Source introuvable</h3>
//           <p>{error}</p>
//           <button className="btn-outline" onClick={() => navigate('/sources')}>Retour à la liste</button>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Détail de la source</h1>
//           <p className="page-description">Consultez les informations de la source de prospects.</p>
//         </div>
//         <div className="header-buttons">
//           <button className="btn-outline" onClick={() => navigate('/sources')}>
//             <ArrowLeft size={18} /> Retour
//           </button>
//           <button className="btn-primary" onClick={() => navigate(`/sources/edit/${id}`)}>
//             <Edit size={18} /> Modifier
//           </button>
//         </div>
//       </div>

//       <div className="detail-grid">
//         <div className="detail-card">
//           <div className="detail-header">
//             <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
//               <Globe size={24} />
//             </div>
//             <div>
//               <h2>{source.libele}</h2>
//             </div>
//           </div>
//           <div className="detail-info">
//             <div className="info-row"><Users size={18} /><span>Prospects collectés : <strong>{prospectsCount}</strong> ({pourcentage}% du total)</span></div>
//             <div className="info-row"><Calendar size={18} /><span>Créée le : {formatDate(source.createdAt)}</span></div>
//             <div className="info-row"><Calendar size={18} /><span>Dernière modification : {formatDate(source.updatedAt)}</span></div>
//           </div>
//         </div>

//         <div className="detail-card">
//           <h3>Description</h3>
//           <p className="detail-notes">{source.description || 'Aucune description renseignée.'}</p>
//         </div>

//         <div className="detail-card full-width">
//           <h3>Performance</h3>
//           <div className="performance-stats" style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '16px', marginTop: '16px' }}>
//             <div className="perf-item" style={{ textAlign: 'center', padding: '12px', background: 'rgba(0,0,0,0.03)', borderRadius: '10px' }}>
//               <Users size={20} color="#1a5c2a" style={{ marginBottom: '8px' }} />
//               <div style={{ fontSize: '20px', fontWeight: 'bold' }}>{prospectsCount}</div>
//               <div style={{ fontSize: '11px', color: '#666' }}>Prospects collectés</div>
//             </div>
//             <div className="perf-item" style={{ textAlign: 'center', padding: '12px', background: 'rgba(0,0,0,0.03)', borderRadius: '10px' }}>
//               <BarChart3 size={20} color="#1a5c2a" style={{ marginBottom: '8px' }} />
//               <div style={{ fontSize: '20px', fontWeight: 'bold' }}>{pourcentage}%</div>
//               <div style={{ fontSize: '11px', color: '#666' }}>Part de l'ensemble des collectes</div>
//             </div>
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default SourceDetail;

import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Tag, Loader, AlertCircle } from 'lucide-react';
import { sourceService } from '../../services/sourceService';
import '../Prospects/Prospects.css';

const SourceDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [source, setSource] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchSource = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await sourceService.getById(id);
        console.log('📥 Source chargée:', raw);
        setSource(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error('❌ Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchSource();
  }, [id]);

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de la source...</p></div></div>;
  }
  if (error || !source) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Source introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/sources')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la source</h1>
          <p className="page-description">Consultez les informations de la source.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/sources')}><ArrowLeft size={18} /> Retour</button>
          <button className="btn-primary" onClick={() => navigate(`/sources/edit/${id}`)}><Edit size={18} /> Modifier</button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Tag size={24} />
            </div>
            <div>
              <h2>{source.libele}</h2>
              <span className="code-badge">{source.idSource}</span>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Description</h3>
          <p className="detail-notes">{source.description}</p>
        </div>
      </div>
    </div>
  );
};

export default SourceDetail;