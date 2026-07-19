// import React, { useState, useEffect } from 'react';
// import { useNavigate, useParams } from 'react-router-dom';
// import { ArrowLeft, Edit, Calendar, MapPin, Target, Building, Loader, AlertCircle, Users, Plus, Trash2, User } from 'lucide-react';
// import { sortieService } from '../../services/sortieService';
// import { campagneService } from '../../services/campagneService';
// import { agentService } from '../../services/agentService';
// import { ToastContainer } from '../../components/common/Toast';
// import '../Prospects/Prospects.css';

// // ⚠️ AJOUTÉ : gestion des agents affectés à la sortie, via la ressource
// // Participation (idUtilisateur <-> idSortie). C'est la SEULE façon
// // d'assigner un agent à une sortie côté backend — il n'y a pas de champ
// // "agent" directement sur Sortie.

// const getStatusBadge = (status) => {
//   const classes = {
//     'Planifiée': 'badge-info', 'En cours': 'badge-warning', 'Effectuée': 'badge-success',
//     'Annulée': 'badge-danger', 'Reportée': 'badge-secondary'
//   };
//   return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
// };

// const statutsParticipation = ['Prévu', 'Confirmé', 'Effectué', 'Annulé'];

// const SortiesDetail = () => {
//   const navigate = useNavigate();
//   const { id } = useParams();
//   const [sortie, setSortie] = useState(null);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);

//   const [participations, setParticipations] = useState([]);
//   const [agents, setAgents] = useState([]);
//   const [showAddForm, setShowAddForm] = useState(false);
//   const [saving, setSaving] = useState(false);
//   const [toasts, setToasts] = useState([]);
//   const [newPart, setNewPart] = useState({
//     idUtilisateur: '', dateAssignation: '', heureArrivee: '', heureDepart: '', statut: 'Prévu', observation: '',
//   });

//   const addToast = (message, type = 'success') => {
//     const tid = Date.now();
//     setToasts((prev) => [...prev, { id: tid, message, type }]);
//     setTimeout(() => setToasts((prev) => prev.filter((t) => t.id !== tid)), 3000);
//   };
//   const removeToast = (tid) => setToasts((prev) => prev.filter((t) => t.id !== tid));

//   const fetchParticipations = async () => {
//     try {
//       const raw = await campagneService.getParticipationsBySortie(id);
//       setParticipations(Array.isArray(raw) ? raw : (raw?.results ?? []));
//     } catch (err) {
//       console.warn('⚠️ Impossible de charger les participations:', err);
//       setParticipations([]);
//     }
//   };

//   useEffect(() => {
//     const fetchSortie = async () => {
//       setLoading(true);
//       setError(null);
//       try {
//         const raw = await sortieService.getById(id);
//         setSortie(Array.isArray(raw) ? raw[0] : raw);
//       } catch (err) {
//         setError(err.message);
//       } finally {
//         setLoading(false);
//       }
//     };
//     fetchSortie();
//     fetchParticipations();
//     agentService.getAll().then((raw) => setAgents(Array.isArray(raw) ? raw : (raw?.results ?? []))).catch(() => setAgents([]));
//   }, [id]);

//   const handleAddParticipation = async (e) => {
//     e.preventDefault();
//     if (!newPart.idUtilisateur || !newPart.dateAssignation) {
//       addToast('Sélectionne un agent et une date', 'error');
//       return;
//     }
//     setSaving(true);
//     try {
//       await campagneService.addParticipation({ ...newPart, idSortie: id });
//       addToast('Agent affecté avec succès', 'success');
//       setNewPart({ idUtilisateur: '', dateAssignation: '', heureArrivee: '', heureDepart: '', statut: 'Prévu', observation: '' });
//       setShowAddForm(false);
//       fetchParticipations();
//     } catch (err) {
//       addToast(err.message || "Erreur lors de l'affectation", 'error');
//     } finally {
//       setSaving(false);
//     }
//   };

//   const handleRemoveParticipation = async (idParticipation) => {
//     try {
//       await campagneService.deleteParticipation(idParticipation);
//       addToast('Agent retiré de la sortie', 'success');
//       fetchParticipations();
//     } catch (err) {
//       addToast("Erreur lors du retrait de l'agent", 'error');
//     }
//   };

//   const getNomAgent = (p) => {
//     const u = p.utilisateur_detail;
//     return u ? `${u.prenom || ''} ${u.nom || ''}`.trim() || u.email : p.idUtilisateur;
//   };

//   if (loading) {
//     return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de la sortie...</p></div></div>;
//   }
//   if (error || !sortie) {
//     return (
//       <div className="page-container">
//         <div className="error-container">
//           <AlertCircle size={48} color="#ef4444" />
//           <h3>Erreur de chargement</h3>
//           <p>{error || 'Sortie introuvable'}</p>
//           <button className="btn-outline" onClick={() => navigate('/sorties')}>Retour à la liste</button>
//         </div>
//       </div>
//     );
//   }

//   return (
//     <div className="page-container">
//       <ToastContainer toasts={toasts} removeToast={removeToast} />

//       <div className="page-header-actions">
//         <div>
//           <h1 className="page-title-h1">Détail de la sortie</h1>
//           <p className="page-description">Consultez les informations complètes de la sortie terrain.</p>
//         </div>
//         <div className="header-buttons">
//           <button className="btn-outline" onClick={() => navigate('/sorties')}><ArrowLeft size={18} /> Retour</button>
//           <button className="btn-primary" onClick={() => navigate(`/sorties/edit/${id}`)}><Edit size={18} /> Modifier</button>
//         </div>
//       </div>

//       <div className="detail-grid">
//         <div className="detail-card">
//           <div className="detail-header">
//             <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
//               <Target size={24} />
//             </div>
//             <div>
//               <h2>Sortie {sortie.typeSortie}</h2>
//               {getStatusBadge(sortie.statut)}
//             </div>
//           </div>
//           <div className="detail-info">
//             <div className="info-row"><Calendar size={18} /><span>Date: {sortie.dateSortie ? new Date(sortie.dateSortie).toLocaleString('fr-FR') : '-'}</span></div>
//             <div className="info-row"><MapPin size={18} /><span>Zone: {sortie.zone_detail?.libele || sortie.idZone}</span></div>
//             <div className="info-row"><Target size={18} /><span>Campagne: {sortie.campagne_detail?.libele || sortie.idCampagne}</span></div>
//             {sortie.idEtablissement && (
//               <div className="info-row"><Building size={18} /><span>Établissement: {sortie.etablissement_detail?.nom || sortie.idEtablissement}</span></div>
//             )}
//             <div className="info-row"><Target size={18} /><span>Objectif: {sortie.objectif}</span></div>
//           </div>
//         </div>

//         <div className="detail-card full-width">
//           <h3>Commentaire</h3>
//           <p className="detail-notes">{sortie.commentaire || 'Aucun commentaire'}</p>
//         </div>

//         {/* ============================================================
//             AGENTS AFFECTÉS À CETTE SORTIE (via Participation)
//             ============================================================ */}
//         <div className="detail-card full-width">
//           <div className="table-header" style={{ justifyContent: 'space-between', marginBottom: 16 }}>
//             <h3><Users size={18} style={{ verticalAlign: 'middle', marginRight: 6 }} />Agents affectés ({participations.length})</h3>
//             <button className="btn-primary" style={{ padding: '6px 12px' }} onClick={() => setShowAddForm((v) => !v)}>
//               <Plus size={16} /> Affecter un agent
//             </button>
//           </div>

//           {showAddForm && (
//             <form onSubmit={handleAddParticipation} className="form-container" style={{ marginBottom: 20, background: 'rgba(0,0,0,0.02)', padding: 16, borderRadius: 12 }}>
//               <div className="form-grid">
//                 <div className="form-group">
//                   <label>Agent <span className="required">*</span></label>
//                   <select value={newPart.idUtilisateur} onChange={(e) => setNewPart({ ...newPart, idUtilisateur: e.target.value })} disabled={saving}>
//                     <option value="">Sélectionner un agent</option>
//                     {agents.map((a) => (
//                       <option key={a.idUtilisateur} value={a.idUtilisateur}>{a.prenom} {a.nom}</option>
//                     ))}
//                   </select>
//                 </div>
//                 <div className="form-group">
//                   <label>Date d'assignation <span className="required">*</span></label>
//                   <input type="date" value={newPart.dateAssignation} onChange={(e) => setNewPart({ ...newPart, dateAssignation: e.target.value })} disabled={saving} />
//                 </div>
//                 <div className="form-group">
//                   <label>Heure d'arrivée</label>
//                   <input type="time" value={newPart.heureArrivee} onChange={(e) => setNewPart({ ...newPart, heureArrivee: e.target.value })} disabled={saving} />
//                 </div>
//                 <div className="form-group">
//                   <label>Heure de départ</label>
//                   <input type="time" value={newPart.heureDepart} onChange={(e) => setNewPart({ ...newPart, heureDepart: e.target.value })} disabled={saving} />
//                 </div>
//                 <div className="form-group">
//                   <label>Statut</label>
//                   <select value={newPart.statut} onChange={(e) => setNewPart({ ...newPart, statut: e.target.value })} disabled={saving}>
//                     {statutsParticipation.map((s) => <option key={s} value={s}>{s}</option>)}
//                   </select>
//                 </div>
//                 <div className="form-group full-width">
//                   <label>Observation</label>
//                   <input type="text" value={newPart.observation} onChange={(e) => setNewPart({ ...newPart, observation: e.target.value })} disabled={saving} />
//                 </div>
//               </div>
//               <div className="form-actions">
//                 <button type="button" className="btn-outline" onClick={() => setShowAddForm(false)} disabled={saving}>Annuler</button>
//                 <button type="submit" className="btn-primary" disabled={saving}>{saving ? 'Affectation…' : 'Affecter'}</button>
//               </div>
//             </form>
//           )}

//           {participations.length === 0 ? (
//             <p style={{ textAlign: 'center', color: '#9ca3af', padding: '16px 0' }}>Aucun agent affecté pour le moment</p>
//           ) : (
//             <div className="table-container">
//               <table className="data-table">
//                 <thead>
//                   <tr><th>Agent</th><th>Date</th><th>Arrivée</th><th>Départ</th><th>Statut</th><th>Observation</th><th>Actions</th></tr>
//                 </thead>
//                 <tbody>
//                   {participations.map((p) => (
//                     <tr key={p.idParticipation}>
//                       <td><User size={14} /> {getNomAgent(p)}</td>
//                       <td>{p.dateAssignation}</td>
//                       <td>{p.heureArrivee || '-'}</td>
//                       <td>{p.heureDepart || '-'}</td>
//                       <td><span className="badge badge-info">{p.statut}</span></td>
//                       <td><small>{p.observation || '-'}</small></td>
//                       <td>
//                         <button className="action-btn delete" onClick={() => handleRemoveParticipation(p.idParticipation)}>
//                           <Trash2 size={16} />
//                         </button>
//                       </td>
//                     </tr>
//                   ))}
//                 </tbody>
//               </table>
//             </div>
//           )}
//         </div>
//       </div>
//     </div>
//   );
// };

// export default SortiesDetail;


import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, MapPin, Target, Building, Loader, AlertCircle, Users, Plus, User, Check, X } from 'lucide-react';
import { sortieService } from '../../services/sortieService';
import { campagneService } from '../../services/campagneService';
import { userService } from '../../services/userService';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

// ⚠️ AJOUTÉ : gestion des agents/managers affectés à la sortie, via la
// ressource Participation (idUtilisateur <-> idSortie). C'est la SEULE
// façon d'assigner quelqu'un à une sortie côté backend — il n'y a pas de
// champ "agent" directement sur Sortie.
//
// Sélection MULTIPLE : on récupère tous les utilisateurs une fois, on les
// sépare côté client par rôle (contient "agent" ou "manager", peu importe
// la casse exacte utilisée en base), et on affiche deux groupes de cases
// à cocher. La date/heures/statut/observation saisis s'appliquent à
// TOUTES les personnes cochées, en une seule action.

const getStatusBadge = (status) => {
  const classes = {
    'Planifiée': 'badge-info', 'En cours': 'badge-warning', 'Effectuée': 'badge-success',
    'Annulée': 'badge-danger', 'Reportée': 'badge-secondary'
  };
  return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
};

const statutsParticipation = ['Prévu', 'Confirmé', 'Effectué', 'Annulé'];

const SortiesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [sortie, setSortie] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [participations, setParticipations] = useState([]);
  const [agentsList, setAgentsList] = useState([]);
  const [managersList, setManagersList] = useState([]);
  const [showAddForm, setShowAddForm] = useState(false);
  const [saving, setSaving] = useState(false);
  const [toasts, setToasts] = useState([]);
  const [selectedUsers, setSelectedUsers] = useState([]); // tableau d'idUtilisateur cochés
  const [sharedFields, setSharedFields] = useState({
    dateAssignation: '', heureArrivee: '', heureDepart: '', statut: 'Prévu', observation: '',
  });
  const [editingParticipationId, setEditingParticipationId] = useState(null);
  const [editStatut, setEditStatut] = useState('Prévu');
  const [savingEdit, setSavingEdit] = useState(false);

  const addToast = (message, type = 'success') => {
    const tid = Date.now();
    setToasts((prev) => [...prev, { id: tid, message, type }]);
    setTimeout(() => setToasts((prev) => prev.filter((t) => t.id !== tid)), 3000);
  };
  const removeToast = (tid) => setToasts((prev) => prev.filter((t) => t.id !== tid));

  const fetchParticipations = async () => {
    try {
      const raw = await campagneService.getParticipationsBySortie(id);
      setParticipations(Array.isArray(raw) ? raw : (raw?.results ?? []));
    } catch (err) {
      console.warn('⚠️ Impossible de charger les participations:', err);
      setParticipations([]);
    }
  };

  useEffect(() => {
    const fetchSortie = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await sortieService.getById(id);
        setSortie(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchSortie();
    fetchParticipations();
    userService.getAll()
      .then((raw) => {
        const list = Array.isArray(raw) ? raw : (raw?.results ?? []);
        const norm = (r) => (r || '').toLowerCase();
        setAgentsList(list.filter((u) => norm(u.role).includes('agent')));
        setManagersList(list.filter((u) => norm(u.role).includes('manager')));
      })
      .catch(() => { setAgentsList([]); setManagersList([]); });
  }, [id]);

  const idsDejaAffectes = new Set(participations.map((p) => p.idUtilisateur));

  const toggleUser = (idUtilisateur) => {
    if (idsDejaAffectes.has(idUtilisateur)) return; // déjà affecté à cette sortie, on ignore le clic
    setSelectedUsers((prev) =>
      prev.includes(idUtilisateur) ? prev.filter((x) => x !== idUtilisateur) : [...prev, idUtilisateur]
    );
  };

  const handleAddParticipation = async (e) => {
    e.preventDefault();
    if (selectedUsers.length === 0) {
      addToast('Coche au moins un agent ou un manager', 'error');
      return;
    }
    const doublons = selectedUsers.filter((idUtilisateur) => idsDejaAffectes.has(idUtilisateur));
    if (doublons.length > 0) {
      addToast('Un ou plusieurs agents sélectionnés sont déjà affectés à cette sortie', 'error');
      return;
    }
    if (!sharedFields.dateAssignation) {
      addToast("Choisis une date d'assignation", 'error');
      return;
    }
    setSaving(true);
    try {
      // Une participation par personne cochée, mêmes date/heures/statut/observation pour tous
      await Promise.all(
        selectedUsers.map((idUtilisateur) =>
          campagneService.addParticipation({ idUtilisateur, idSortie: id, ...sharedFields })
        )
      );
      addToast(
        selectedUsers.length > 1
          ? `${selectedUsers.length} personnes affectées avec succès`
          : 'Personne affectée avec succès',
        'success'
      );
      setSelectedUsers([]);
      setSharedFields({ dateAssignation: '', heureArrivee: '', heureDepart: '', statut: 'Prévu', observation: '' });
      setShowAddForm(false);
      fetchParticipations();
    } catch (err) {
      addToast(err.message || "Erreur lors de l'affectation", 'error');
    } finally {
      setSaving(false);
    }
  };

  const startEditStatut = (p) => {
    setEditingParticipationId(p.idParticipation);
    setEditStatut(p.statut || 'Prévu');
  };

  const cancelEditStatut = () => {
    setEditingParticipationId(null);
  };

  const saveEditStatut = async (p) => {
    setSavingEdit(true);
    try {
      await campagneService.updateParticipation(p.idParticipation, {
        idUtilisateur: p.idUtilisateur,
        idSortie: id,
        dateAssignation: p.dateAssignation,
        heureArrivee: p.heureArrivee,
        heureDepart: p.heureDepart,
        statut: editStatut,
        observation: p.observation,
      });
      addToast('Statut mis à jour', 'success');
      setEditingParticipationId(null);
      fetchParticipations();
    } catch (err) {
      addToast(err.message || 'Erreur lors de la mise à jour du statut', 'error');
    } finally {
      setSavingEdit(false);
    }
  };

  const getNomAgent = (p) => {
    const u = p.utilisateur_detail;
    return u ? `${u.prenom || ''} ${u.nom || ''}`.trim() || u.email : p.idUtilisateur;
  };

  if (loading) {
    return <div className="page-container"><div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de la sortie...</p></div></div>;
  }
  if (error || !sortie) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Sortie introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/sorties')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la sortie</h1>
          <p className="page-description">Consultez les informations complètes de la sortie terrain.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/sorties')}><ArrowLeft size={18} /> Retour</button>
          <button className="btn-primary" onClick={() => navigate(`/sorties/edit/${id}`)}><Edit size={18} /> Modifier</button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <Target size={24} />
            </div>
            <div>
              <h2>Sortie {sortie.typeSortie}</h2>
              {getStatusBadge(sortie.statut)}
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Calendar size={18} /><span>Date: {sortie.dateSortie ? new Date(sortie.dateSortie).toLocaleString('fr-FR') : '-'}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Zone: {sortie.zone_detail?.libele || sortie.idZone}</span></div>
            <div className="info-row"><Target size={18} /><span>Campagne: {sortie.campagne_detail?.libele || sortie.idCampagne}</span></div>
            {sortie.idEtablissement && (
              <div className="info-row"><Building size={18} /><span>Établissement: {sortie.etablissement_detail?.nom || sortie.idEtablissement}</span></div>
            )}
            <div className="info-row"><Target size={18} /><span>Objectif: {sortie.objectif}</span></div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Commentaire</h3>
          <p className="detail-notes">{sortie.commentaire || 'Aucun commentaire'}</p>
        </div>

        {/* ============================================================
            AGENTS AFFECTÉS À CETTE SORTIE (via Participation)
            ============================================================ */}
        <div className="detail-card full-width">
          <div className="table-header" style={{ justifyContent: 'space-between', marginBottom: 16 }}>
            <h3><Users size={18} style={{ verticalAlign: 'middle', marginRight: 6 }} />Agents affectés ({participations.length})</h3> <br />
            <button className="btn-primary" style={{ padding: '6px 12px' }} onClick={() => setShowAddForm((v) => !v)}>
              <Plus size={16} /> Affecter un agent
            </button>
          </div>

          {showAddForm && (
            <form onSubmit={handleAddParticipation} className="form-container" style={{ marginBottom: 20, background: 'rgba(0,0,0,0.02)', padding: 16, borderRadius: 12 }}>

              <div className="form-grid" style={{ marginBottom: 12 }}>
                <div className="form-group full-width">
                  <label>Agents <span className="required">*</span></label>
                  {agentsList.length === 0 ? (
                    <p style={{ color: '#9ca3af', fontSize: 13 }}>Aucun agent trouvé</p>
                  ) : (
                    <div className="checkbox-grid">
                      {agentsList.map((u) => {
                        const dejaAffecte = idsDejaAffectes.has(u.idUtilisateur);
                        return (
                          <label key={u.idUtilisateur} className="checkbox-pill" style={dejaAffecte ? { opacity: 0.5, cursor: 'not-allowed' } : undefined}>
                            <input
                              type="checkbox"
                              checked={selectedUsers.includes(u.idUtilisateur)}
                              onChange={() => toggleUser(u.idUtilisateur)}
                              disabled={saving || dejaAffecte}
                            />
                            {u.prenom} {u.nom}{dejaAffecte ? ' (déjà affecté)' : ''}
                          </label>
                        );
                      })}
                    </div>
                  )}
                </div>

                <div className="form-group full-width">
                  <label>Managers / Superviseurs</label>
                  {managersList.length === 0 ? (
                    <p style={{ color: '#9ca3af', fontSize: 13 }}>Aucun manager trouvé</p>
                  ) : (
                    <div className="checkbox-grid">
                      {managersList.map((u) => {
                        const dejaAffecte = idsDejaAffectes.has(u.idUtilisateur);
                        return (
                          <label key={u.idUtilisateur} className="checkbox-pill" style={dejaAffecte ? { opacity: 0.5, cursor: 'not-allowed' } : undefined}>
                            <input
                              type="checkbox"
                              checked={selectedUsers.includes(u.idUtilisateur)}
                              onChange={() => toggleUser(u.idUtilisateur)}
                              disabled={saving || dejaAffecte}
                            />
                            {u.prenom} {u.nom}{dejaAffecte ? ' (déjà affecté)' : ''}
                          </label>
                        );
                      })}
                    </div>
                  )}
                </div>
              </div>

              <div className="form-grid">
                <div className="form-group">
                  <label>Date d'assignation <span className="required">*</span></label>
                  <input type="date" value={sharedFields.dateAssignation} onChange={(e) => setSharedFields({ ...sharedFields, dateAssignation: e.target.value })} disabled={saving} />
                </div>
                <div className="form-group">
                  <label>Heure d'arrivée</label>
                  <input type="time" value={sharedFields.heureArrivee} onChange={(e) => setSharedFields({ ...sharedFields, heureArrivee: e.target.value })} disabled={saving} />
                </div>
                <div className="form-group">
                  <label>Heure de départ</label>
                  <input type="time" value={sharedFields.heureDepart} onChange={(e) => setSharedFields({ ...sharedFields, heureDepart: e.target.value })} disabled={saving} />
                </div>
                <div className="form-group">
                  <label>Statut</label>
                  <select value={sharedFields.statut} onChange={(e) => setSharedFields({ ...sharedFields, statut: e.target.value })} disabled={saving}>
                    {statutsParticipation.map((s) => <option key={s} value={s}>{s}</option>)}
                  </select>
                </div>
                <div className="form-group full-width">
                  <label>Observation</label>
                  <input type="text" value={sharedFields.observation} onChange={(e) => setSharedFields({ ...sharedFields, observation: e.target.value })} disabled={saving} />
                </div>
              </div>

              <div className="form-actions">
                <button type="button" className="btn-outline" onClick={() => { setShowAddForm(false); setSelectedUsers([]); }} disabled={saving}>Annuler</button>
                <button type="submit" className="btn-primary" disabled={saving}>
                  {saving ? 'Affectation…' : `Affecter (${selectedUsers.length} sélectionné${selectedUsers.length > 1 ? 's' : ''})`}
                </button>
              </div>
            </form>
          )}

          {participations.length === 0 ? (
            <p style={{ textAlign: 'center', color: '#9ca3af', padding: '16px 0' }}>Aucun agent affecté pour le moment</p>
          ) : (
            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr><th>Agent</th><th>Date</th><th>Arrivée</th><th>Départ</th><th>Statut</th><th>Observation</th><th>Actions</th></tr>
                </thead>
                <tbody>
                  {participations.map((p) => (
                    <tr key={p.idParticipation}>
                      <td><User size={14} /> {getNomAgent(p)}</td>
                      <td>{p.dateAssignation}</td>
                      <td>{p.heureArrivee || '-'}</td>
                      <td>{p.heureDepart || '-'}</td>
                      <td>
                        {editingParticipationId === p.idParticipation ? (
                          <select value={editStatut} onChange={(e) => setEditStatut(e.target.value)} disabled={savingEdit}>
                            {statutsParticipation.map((s) => <option key={s} value={s}>{s}</option>)}
                          </select>
                        ) : (
                          <span className="badge badge-info">{p.statut}</span>
                        )}
                      </td>
                      <td><small>{p.observation || '-'}</small></td>
                      <td>
                        {editingParticipationId === p.idParticipation ? (
                          <>
                            <button className="action-btn view" onClick={() => saveEditStatut(p)} disabled={savingEdit} title="Valider">
                              <Check size={16} />
                            </button>
                            <button className="action-btn delete" onClick={cancelEditStatut} disabled={savingEdit} title="Annuler">
                              <X size={16} />
                            </button>
                          </>
                        ) : (
                          <button className="action-btn edit" onClick={() => startEditStatut(p)} title="Modifier le statut">
                            <Edit size={16} />
                          </button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default SortiesDetail;