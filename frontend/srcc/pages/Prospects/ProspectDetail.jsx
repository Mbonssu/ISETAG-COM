import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Mail, Phone, Calendar, MapPin, GraduationCap, Users } from 'lucide-react';
import { prospectService } from '../../services/prospectService';
import { Prospect } from '../../models/prospect';
import './Prospects.css';

const ProspectDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const [prospect, setProspect] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    prospectService.getById(id)
      .then((data) => setProspect(Prospect.fromDjango(data)))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, [id]);

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
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar">{prospect.initials}</div>
            <div>
              <h2>{prospect.nomComplet}</h2>
              <span className="badge badge-info">{prospect.typeProspect}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row">
              <Mail size={18} />
              <span>{prospect.email}</span>
            </div>
            <div className="info-row">
              <Phone size={18} />
              <span>{prospect.telephone}</span>
            </div>
            <div className="info-row">
              <Calendar size={18} />
              <span>Ajouté le {prospect.createdAt ? new Date(prospect.createdAt).toLocaleDateString('fr-FR') : '-'}</span>
            </div>
            <div className="info-row">
              <MapPin size={18} />
              <span>{prospect.adresse}{prospect.ville ? `, ${prospect.ville}` : ''}{prospect.pays ? ` (${prospect.pays})` : ''}</span>
            </div>
            <div className="info-row">
              <GraduationCap size={18} />
              <span>{prospect.niveauEtude} — {prospect.domaineEtude || 'Domaine non renseigné'}</span>
            </div>
            <div className="info-row">
              <Users size={18} />
              <span>{prospect.sexeLabel}</span>
            </div>
          </div>
        </div>

        {(prospect.nomParent || prospect.numeroParent) && (
          <div className="detail-card">
            <h3>Contact parent</h3>
            <div className="detail-info">
              <div className="info-row">
                <Users size={18} />
                <span>{prospect.nomParent || 'Nom non renseigné'}</span>
              </div>
              <div className="info-row">
                <Phone size={18} />
                <span>{prospect.numeroParent || 'Téléphone non renseigné'}</span>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default ProspectDetail;