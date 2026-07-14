import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, MapPin, Building, Globe, Loader, AlertCircle } from 'lucide-react';
import { zoneService } from '../../services/zoneService';
import '../Prospects/Prospects.css';

// ⚠️ CORRIGÉ : cette page était 100% mock (aucun appel API), et affichait
// des statistiques + une liste d'agents entièrement inventées. Il n'existe
// AUCUNE route dans le YAML pour des stats ou des agents liés à une zone
// (le modèle Zone n'a même pas de champ les référençant) — cette section
// a donc été retirée plutôt que de garder un affichage trompeur.

const ZonesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [zone, setZone] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchZone = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await zoneService.getById(id);
        console.log('📥 Zone chargée:', data);
        // ⚠️ Le backend renvoie parfois un tableau [{...}] au lieu d'un
        // objet direct pour getById (bug backend). On gère les deux cas.
        const zoneData = Array.isArray(data) ? data[0] : data;
        setZone(zoneData);
      } catch (err) {
        console.error('❌ Erreur de chargement:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    fetchZone();
  }, [id]);

  if (loading) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement de la zone...</p>
        </div>
      </div>
    );
  }

  if (error || !zone) {
    return (
      <div className="page-container">
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Zone introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/zones')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de la zone</h1>
          <p className="page-description">Consultez les informations complètes de la zone géographique.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/zones')}>
            <ArrowLeft size={18} />
            Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/zones/edit/${id}`)}>
            <Edit size={18} />
            Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white' }}>
              <MapPin size={24} />
            </div>
            <div>
              <h2>{zone.libele}</h2>
              <span className="code-badge">{zone.idZone}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Building size={18} /><span>Quartier: {zone.quartier}</span></div>
            <div className="info-row"><Building size={18} /><span>Ville: {zone.ville}</span></div>
            <div className="info-row"><Globe size={18} /><span>Région: {zone.region}</span></div>
            <div className="info-row"><Globe size={18} /><span>Pays: {zone.pays}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Lieu départ: {zone.lieuDepart}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Lieu d'arrivée: {zone.lieuArrivee}</span></div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Description</h3>
          <p className="detail-notes">{zone.description}</p>
        </div>
      </div>
    </div>
  );
};

export default ZonesDetail;