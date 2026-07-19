import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import {
  ArrowLeft, FileText, User, Calendar, Star, Tag, MapPin, Loader, AlertCircle,
  Mail, Phone, GraduationCap, Users, Building, Compass, Clock, UserCog, Eye,
} from 'lucide-react';
import { ficheService } from '../../services/ficheService';
import '../Prospects/Prospects.css';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import { getErrorMessage } from '../../utils/errorMessages';

// ⚠️ LECTURE SEULE : cette fiche a été créée par un agent sur le terrain
// via l'app mobile. Pas de bouton "Modifier" ici — l'admin web ne fait
// que consulter les fiches déjà remontées.
//
// ⚠️ CORRIGÉ (v2) : GET /campagne_api/ISETAG_COM.fiches-sortie/{id}/
// renvoie DÉJÀ toute la structure imbriquée : participation_detail
// (avec utilisateur_detail + sortie_detail -> campagne/zone/etablissement),
// source_detail, et surtout "prospects" — un TABLEAU (une fiche peut
// concerner plusieurs prospects, ce n'est plus un prospect_detail/idProspect
// unique comme avant). On lit tout directement depuis cette réponse, sans
// second appel API.

const formatDate = (v) => (v ? new Date(v).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' }) : null);
const formatDateTime = (v) => (v ? new Date(v).toLocaleString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric', hour: '2-digit', minute: '2-digit' }) : null);
const formatHeure = (v) => {
  if (!v) return null;
  // heureArrivee/heureDepart arrivent au format "HH:MM:SS.mmmZ" (pas une date complète)
  const match = String(v).match(/^(\d{2}):(\d{2})/);
  return match ? `${match[1]}:${match[2]}` : String(v);
};

const FichesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const { t } = useTranslation();
  const [fiche, setFiche] = useState(null);
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

  useEffect(() => {
    const fetchFiche = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await ficheService.getById(id);
        console.log('📥 Fiche chargée:', raw);
        setFiche(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error('❌ Erreur de chargement:', err);
        setError(getErrorMessage(err, t));
        addToast(getErrorMessage(err, t), 'error');
      } finally {
        setLoading(false);
      }
    };
    fetchFiche();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  if (loading) {
    return (
      <div className="page-container">
        <ToastContainer toasts={toasts} removeToast={removeToast} />
        <div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de la fiche...</p></div>
      </div>
    );
  }
  if (error || !fiche) {
    return (
      <div className="page-container">
        <ToastContainer toasts={toasts} removeToast={removeToast} />
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Fiche introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/fiches')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  const prospects = Array.isArray(fiche.prospects) ? fiche.prospects : [];
  const source = fiche.source_detail || {};
  const participation = fiche.participation_detail || {};
  const agent = participation.utilisateur_detail || {};
  const sortie = participation.sortie_detail || {};
  const campagne = sortie.campagne_detail || {};
  const zone = sortie.zone_detail || {};
  const etablissement = sortie.etablissement_detail || {};

  const nomAgent = [agent.nom, agent.prenom].filter(Boolean).join(' ') || agent.username || '—';
  const titrePage = prospects.length === 1
    ? (prospects[0].nomComplet || prospects[0].idProspect)
    : `${prospects.length} prospect${prospects.length > 1 ? 's' : ''}`;

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la fiche de collecte</h1>
          <p className="page-description">Fiche remontée depuis le terrain — consultation uniquement.</p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/fiches')}>
          <ArrowLeft size={18} /> Retour
        </button>
      </div>

      <div className="detail-grid">
        {/* --- Fiche : identité + suivi --- */}
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <FileText size={24} />
            </div>
            <div>
              <h2>{titrePage || '—'}</h2>
              <span className="code-badge">{fiche.idFiche}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Users size={18} /><span>Prospects concernés : <strong>{prospects.length}</strong></span></div>
            <div className="info-row"><Tag size={18} /><span>Source : {source.libele || fiche.idSource || '—'}</span></div>
            <div className="info-row"><Calendar size={18} /><span>Date de collecte : {formatDateTime(fiche.dateCollecte) || '—'}</span></div>
            <div className="info-row"><Star size={18} /><span>Score d'intérêt : <strong>{fiche.scoreInteret ?? '—'}</strong></span></div>
          </div>
        </div>

        {/* --- Agent & sortie terrain --- */}
        <div className="detail-card">
          <h3>Collecte terrain</h3>
          <div className="detail-info" style={{ marginTop: 10 }}>
            <div className="info-row"><UserCog size={18} /><span>Agent : <strong>{nomAgent}</strong>{agent.role ? ` (${agent.role})` : ''}</span></div>
            {agent.telephone && <div className="info-row"><Phone size={18} /><span>{agent.telephone}</span></div>}
            {campagne.libele && <div className="info-row"><Compass size={18} /><span>Campagne : {campagne.libele}</span></div>}
            {etablissement.nom && <div className="info-row"><Building size={18} /><span>Établissement : {etablissement.nom}{etablissement.ville ? ` — ${etablissement.ville}` : ''}</span></div>}
            {(zone.libele || zone.ville) && <div className="info-row"><MapPin size={18} /><span>Zone : {zone.libele || zone.ville}{zone.quartier ? ` (${zone.quartier})` : ''}</span></div>}
            {sortie.dateSortie && <div className="info-row"><Calendar size={18} /><span>Date de sortie : {formatDate(sortie.dateSortie)}</span></div>}
            {(participation.heureArrivee || participation.heureDepart) && (
              <div className="info-row">
                <Clock size={18} />
                <span>
                  {participation.heureArrivee ? `Arrivée ${formatHeure(participation.heureArrivee)}` : ''}
                  {participation.heureArrivee && participation.heureDepart ? ' · ' : ''}
                  {participation.heureDepart ? `Départ ${formatHeure(participation.heureDepart)}` : ''}
                </span>
              </div>
            )}
            {participation.statut && <div className="info-row"><Tag size={18} /><span>Statut de participation : {participation.statut}</span></div>}
          </div>
        </div>

        {/* --- Tableau des prospects rattachés à la fiche --- */}
        <div className="detail-card full-width">
          <h3>Prospects rattachés à cette fiche ({prospects.length})</h3>
          {prospects.length === 0 ? (
            <p className="detail-notes">Aucun prospect rattaché à cette fiche.</p>
          ) : (
            <div className="table-container" style={{ marginTop: 12 }}>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>Nom</th>
                    <th>Contact</th>
                    <th>Ville</th>
                    <th>Type</th>
                    <th>Études</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {prospects.map((p) => (
                    <tr key={p.idProspect}>
                      <td><User size={14} /> <strong>{p.nomComplet || p.idProspect}</strong></td>
                      <td>
                        {p.email && <div>{p.email}</div>}
                        {p.telephone && <div>{p.telephone}</div>}
                        {!p.email && !p.telephone && '—'}
                      </td>
                      <td>{p.ville || '—'}</td>
                      <td>{p.typeProspect || '—'}</td>
                      <td>{[p.niveauEtude, p.domaineEtude].filter(Boolean).join(' — ') || '—'}</td>
                      <td>
                        {p.idProspect && (
                          <button className="action-btn view" onClick={() => navigate(`/prospects/${p.idProspect}`)}>
                            <Eye size={16} />
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

        {/* --- Commentaire agent (fiche) + observation (participation) --- */}
        <div className="detail-card full-width">
          <h3>Commentaire de l'agent</h3>
          <p className="detail-notes">{fiche.commentaire || 'Aucun commentaire'}</p>
          {participation.observation && (
            <>
              <h3 style={{ marginTop: 16 }}>Observation de sortie</h3>
              <p className="detail-notes">{participation.observation}</p>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default FichesDetail;