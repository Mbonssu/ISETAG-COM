import React, { useState } from 'react';
import { Download, BarChart3, PieChart, TrendingUp, Users, Calendar, FileText, Printer, Filter, ChevronDown } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';
import './Rapports.css';
import { useTranslation } from '../../hooks/useTranslation';

const RapportsDashboard = () => {
  const { t } = useTranslation();
  const [toasts, setToasts] = useState([]);
  const [periode, setPeriode] = useState('mois');
  const [typeRapport, setTypeRapport] = useState('global');

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const handleExport = (format) => {
    addToast(`Export en cours (${format})...`, 'info');
    setTimeout(() => {
      addToast(`Rapport exporté avec succès en ${format}`, 'success');
    }, 1500);
  };

  const handlePrint = () => {
    addToast('Préparation de l\'impression...', 'info');
    setTimeout(() => {
      addToast('Document envoyé à l\'imprimante', 'success');
    }, 1000);
  };

  // Données statistiques
  const stats = {
    totalProspects: 1248,
    evolution: '+18.5%',
    tauxConversion: 32,
    agentsActifs: 28,
    prospectsParAgent: 44.6,
    satisfaction: 4.2
  };

  const prospectsParSource = [
    { name: 'Terrain', value: 562, color: '#FF6B6B' },
    { name: 'Lycée', value: 374, color: '#4ECDC4' },
    { name: 'Passage institut', value: 187, color: '#FFE66D' },
    { name: 'Réseaux sociaux', value: 75, color: '#A78BFA' },
    { name: 'Référence', value: 50, color: '#F9A26C' }
  ];

  const performanceAgents = [
    { name: 'Sophie A.', prospects: 52, convertis: 24, taux: 46 },
    { name: 'Jean M.', prospects: 45, convertis: 18, taux: 40 },
    { name: 'Paul K.', prospects: 41, convertis: 15, taux: 37 },
    { name: 'David P.', prospects: 38, convertis: 12, taux: 32 },
    { name: 'Marie L.', prospects: 29, convertis: 8, taux: 28 }
  ];

  const evolutionMensuelle = [
    { mois: 'Jan', prospects: 890, relances: 120 },
    { mois: 'Fév', prospects: 930, relances: 140 },
    { mois: 'Mar', prospects: 1020, relances: 135 },
    { mois: 'Avr', prospects: 1090, relances: 148 },
    { mois: 'Mai', prospects: 1248, relances: 162 }
  ];

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Rapports & Statistiques</h1>
          <p className="page-description">Analysez les performances et générez des rapports détaillés.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={handlePrint}>
            <Printer size={18} />
            Imprimer
          </button>
          <button className="btn-primary" onClick={() => handleExport('PDF')}>
            <Download size={18} />
            Exporter PDF
          </button>
        </div>
      </div>

      {/* Filtres */}
      <div className="rapports-filters">
        <div className="filter-group">
          <Calendar size={18} />
          <select value={periode} onChange={(e) => setPeriode(e.target.value)}>
            <option value="semaine">Cette semaine</option>
            <option value="mois">Ce mois</option>
            <option value="trimestre">Ce trimestre</option>
            <option value="annee">Cette année</option>
          </select>
          <ChevronDown size={14} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={typeRapport} onChange={(e) => setTypeRapport(e.target.value)}>
            <option value="global">Rapport global</option>
            <option value="agents">Performance agents</option>
            <option value="sources">Analyse des sources</option>
            <option value="filieres">Par filière</option>
          </select>
          <ChevronDown size={14} />
        </div>
      </div>

      {/* KPI Cards */}
      <div className="rapports-kpi">
        <div className="kpi-card-large">
          <div className="kpi-icon-large">
            <Users size={28} />
          </div>
          <div className="kpi-content">
            <div className="kpi-value-large">{stats.totalProspects}</div>
            <div className="kpi-label-large">Total prospects</div>
            <div className="kpi-trend positive">{stats.evolution}</div>
          </div>
        </div>
        <div className="kpi-card-large">
          <div className="kpi-icon-large">
            <TrendingUp size={28} />
          </div>
          <div className="kpi-content">
            <div className="kpi-value-large">{stats.tauxConversion}%</div>
            <div className="kpi-label-large">Taux de conversion</div>
            <div className="kpi-trend positive">+5.2%</div>
          </div>
        </div>
        <div className="kpi-card-large">
          <div className="kpi-icon-large">
            <Users size={28} />
          </div>
          <div className="kpi-content">
            <div className="kpi-value-large">{stats.agentsActifs}</div>
            <div className="kpi-label-large">Agents actifs</div>
            <div className="kpi-trend positive">+2</div>
          </div>
        </div>
        <div className="kpi-card-large">
          <div className="kpi-icon-large">
            <BarChart3 size={28} />
          </div>
          <div className="kpi-content">
            <div className="kpi-value-large">{stats.prospectsParAgent}</div>
            <div className="kpi-label-large">Prospects/agent</div>
            <div className="kpi-trend positive">+8.3%</div>
          </div>
        </div>
      </div>

      {/* Graphiques */}
      <div className="rapports-grid">
        {/* Évolution */}
        <div className="rapport-card">
          <div className="card-header">
            <h3>Évolution des prospects</h3>
            <FileText size={18} />
          </div>
          <div className="evolution-chart">
            {evolutionMensuelle.map((item, idx) => (
              <div key={idx} className="chart-bar-container">
                <div className="chart-label">{item.mois}</div>
                <div className="chart-bars">
                  <div className="bar-wrapper">
                    <div className="bar-label">Prospects</div>
                    <div className="bar-total" style={{ width: `${(item.prospects / 1500) * 100}%` }}>
                      <span>{item.prospects}</span>
                    </div>
                  </div>
                  <div className="bar-wrapper">
                    <div className="bar-label">Relances</div>
                    <div className="bar-relance" style={{ width: `${(item.relances / 200) * 100}%` }}>
                      <span>{item.relances}</span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Performance Agents */}
        <div className="rapport-card">
          <div className="card-header">
            <h3>Performance des agents</h3>
            <TrendingUp size={18} />
          </div>
          <div className="agents-performance">
            {performanceAgents.map((agent, idx) => (
              <div key={idx} className="agent-perf-row">
                <div className="agent-perf-info">
                  <span className="agent-name">{agent.name}</span>
                  <div className="agent-stats">
                    <span>{agent.prospects} prospects</span>
                    <span>{agent.convertis} convertis</span>
                  </div>
                </div>
                <div className="agent-perf-bar">
                  <div className="perf-fill" style={{ width: `${agent.taux}%` }}>
                    <span>{agent.taux}%</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Sources */}
        <div className="rapport-card">
          <div className="card-header">
            <h3>Prospects par source</h3>
            <PieChart size={18} />
          </div>
          <div className="sources-list">
            {prospectsParSource.map((source, idx) => (
              <div key={idx} className="source-row">
                <div className="source-info">
                  <div className="source-color" style={{ backgroundColor: source.color }}></div>
                  <span className="source-name">{source.name}</span>
                </div>
                <div className="source-value">
                  <div className="source-bar" style={{ width: `${(source.value / 1248) * 100}%`, backgroundColor: source.color }}></div>
                  <span>{source.value} ({Math.round((source.value / 1248) * 100)}%)</span>
                </div>
              </div>
            ))}
          </div>
          <div className="source-total">
            Total : <strong>1 248</strong> prospects
          </div>
        </div>

        {/* Taux de conversion par filière */}
        <div className="rapport-card">
          <div className="card-header">
            <h3>Taux de conversion par filière</h3>
            <BarChart3 size={18} />
          </div>
          <div className="filieres-conversion">
            <div className="filiere-conversion-row">
              <span>Génie Logiciel</span>
              <div className="conversion-bar">
                <div className="conversion-fill" style={{ width: '38%' }}>38%</div>
              </div>
            </div>
            <div className="filiere-conversion-row">
              <span>Marketing</span>
              <div className="conversion-bar">
                <div className="conversion-fill" style={{ width: '35%' }}>35%</div>
              </div>
            </div>
            <div className="filiere-conversion-row">
              <span>Génie Civil</span>
              <div className="conversion-bar">
                <div className="conversion-fill" style={{ width: '28%' }}>28%</div>
              </div>
            </div>
            <div className="filiere-conversion-row">
              <span>Réseaux & Télécoms</span>
              <div className="conversion-bar">
                <div className="conversion-fill" style={{ width: '32%' }}>32%</div>
              </div>
            </div>
            <div className="filiere-conversion-row">
              <span>Architecture</span>
              <div className="conversion-bar">
                <div className="conversion-fill" style={{ width: '25%' }}>25%</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Export Section */}
      <div className="export-section">
        <h3>Exporter les rapports</h3>
        <div className="export-buttons">
          <button className="export-btn" onClick={() => handleExport('Excel')}>
            📊 Excel
          </button>
          <button className="export-btn" onClick={() => handleExport('PDF')}>
            📄 PDF
          </button>
          <button className="export-btn" onClick={() => handleExport('CSV')}>
            📈 CSV
          </button>
          <button className="export-btn" onClick={() => handleExport('JSON')}>
            🔧 JSON
          </button>
        </div>
      </div>
    </div>
  );
};

export default RapportsDashboard;
