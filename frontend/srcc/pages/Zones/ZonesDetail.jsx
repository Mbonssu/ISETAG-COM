import React from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, MapPin, Building, Globe, Calendar, Users, Target, TrendingUp, User, Mail, Eye } from 'lucide-react';
import '../Prospects/Prospects.css';

const ZonesDetail = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const zone = {
    id: id,
    code: 'Z001',
    quartier: 'Biyem-Assi',
    ville: 'Yaoundé',
    region: 'Centre',
    pays: 'Cameroun',
    lieuDepart: 'Carrefour Biyem-Assi',
    lieuFin: 'Lycée de Biyem-Assi',
    description: 'Zone couvrant le quartier Biyem-Assi et ses environs',
    createdAt: '01 Jan 2024',
    statistiques: {
      agents: 2,
      prospects: 245,
      sorties: 12,
      tauxReussite: 78
    },
    agents: [
      { id: 1, nom: 'Jean M.', email: 'jean@isetag.com', performance: 'Excellent' },
      { id: 2, nom: 'Sophie A.', email: 'sophie@isetag.com', performance: 'Très bien' }
    ]
  };

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
              <h2>{zone.quartier}</h2>
              <span className="code-badge">{zone.code}</span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Building size={18} /><span>Ville: {zone.ville}</span></div>
            <div className="info-row"><Globe size={18} /><span>Région: {zone.region}</span></div>
            <div className="info-row"><Globe size={18} /><span>Pays: {zone.pays}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Lieu départ: {zone.lieuDepart}</span></div>
            <div className="info-row"><MapPin size={18} /><span>Lieu fin: {zone.lieuFin}</span></div>
            <div className="info-row"><Calendar size={18} /><span>Créée le: {zone.createdAt}</span></div>
          </div>
        </div>

        <div className="detail-card">
          <h3>Description</h3>
          <p className="detail-notes">{zone.description}</p>
        </div>

        <div className="detail-card">
          <h3>Statistiques</h3>
          <div className="performance-stats">
            <div className="perf-item">
              <Users size={20} />
              <div>
                <div className="perf-value">{zone.statistiques.agents}</div>
                <div className="perf-label">Agents affectés</div>
              </div>
            </div>
            <div className="perf-item">
              <Target size={20} />
              <div>
                <div className="perf-value">{zone.statistiques.prospects}</div>
                <div className="perf-label">Prospects</div>
              </div>
            </div>
            <div className="perf-item">
              <Calendar size={20} />
              <div>
                <div className="perf-value">{zone.statistiques.sorties}</div>
                <div className="perf-label">Sorties effectuées</div>
              </div>
            </div>
            <div className="perf-item">
              <TrendingUp size={20} />
              <div>
                <div className="perf-value">{zone.statistiques.tauxReussite}%</div>
                <div className="perf-label">Taux de réussite</div>
              </div>
            </div>
          </div>
        </div>

        <div className="detail-card full-width">
          <h3>Agents affectés à cette zone</h3>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Agent</th>
                  <th>Email</th>
                  <th>Performance</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {zone.agents.map((agent) => (
                  <tr key={agent.id}>
                    <td><User size={14} /> {agent.nom}</td>
                    <td><Mail size={12} /> {agent.email}</td>
                    <td><span className="badge badge-success">{agent.performance}</span></td>
                    <td><button className="action-btn view" onClick={() => navigate(`/agents/${agent.id}`)}><Eye size={16} /></button></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ZonesDetail;
