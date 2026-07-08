import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Calendar, MapPin, Target, Clock, Building, Loader, AlertCircle } from 'lucide-react';
import { sortieService } from '../../services/sortieService';
import '../Prospects/Prospects.css';

// ⚠️ CORRIGÉ : cette page était 100% mock (participants/résultats/
// historique inventés — aucune route de ce type n'existe dans le YAML).
// Connectée au vrai backend ; affiche zone_detail/campagne_detail/
// etablissement_detail (renvoyés automatiquement par le backend en
// lecture seule) plutôt que des IDs bruts.

const getStatusBadge = (status) => {
  const classes = {
    'Planifiée': 'badge-info', 'En cours': 'badge-warning', 'Effectuée': 'badge-success',
    'Annulée': 'badge-danger', 'Reportée': 'badge-secondary'
  };
  return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
};

const SortiesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [sortie, setSortie] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchSortie = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await sortieService.getById(id);
        console.log('📥 Sortie chargée:', raw);
        // ⚠️ Comme pour Zone, le backend peut renvoyer un tableau [{...}]
        // au lieu d'un objet direct sur certains endpoints "détail".
        setSortie(Array.isArray(raw) ? raw[0] : raw);
      } catch (err) {
        console.error('❌ Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchSortie();
  }, [id]);

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
      </div>
    </div>
  );
};

export default SortiesDetail;