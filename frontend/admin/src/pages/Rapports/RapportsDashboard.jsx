import React from 'react';
import {
  LineChart, Line, BarChart, Bar, PieChart, Pie, Cell,
  XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer,
} from 'recharts';
import { useReportsStats } from '../../hooks/useReportsStats';
import ExportButton from '../../components/ExportButton/ExportButton';
import { SkeletonChart, SkeletonTable, Skeleton } from '../../components/Skeleton/Skeleton';
import './Rapports.css';

const COLORS = ['#2d7a3a', '#f5c842', '#78909c', '#b0bec5', '#5c9e6a', '#dde3e7', '#8fbc94'];

const Section = ({ title, children, exportButton }) => (
  <div className="rapport-section card">
    <div className="rapport-section-header">
      <h2>{title}</h2>
      {exportButton}
    </div>
    {children}
  </div>
);

//  CORRIGÉ : le squelette de chargement affichait juste 2 cartes
// génériques sans rapport avec la vraie mise en page (4 sections, chacune
// avec un graphique + un tableau). Il reproduit maintenant fidèlement
// cette structure : un titre de section, une silhouette de graphique
// (SkeletonChart) et un tableau (SkeletonTable), répétés 4 fois.
const RapportsSkeleton = () => (
  <div className="page-container rapports-page">
    <div className="page-header-actions">
      <div>
        <h1 className="page-title-h1">Statistiques & Rapports</h1>
        <p className="page-description">Vue d'ensemble de l'activité de prospection.</p>
      </div>
    </div>
    {Array.from({ length: 4 }).map((_, i) => (
      <div className="rapport-section card" key={i}>
        <div className="rapport-section-header">
          <Skeleton width={220} height={18} />
          <Skeleton width={110} height={34} radius={8} />
        </div>
        <SkeletonChart height={240} />
        <div style={{ marginTop: 18 }}>
          <SkeletonTable rows={4} columns={i === 1 || i === 3 ? 5 : 3} />
        </div>
      </div>
    ))}
  </div>
);

const RapportsDashboard = () => {
  const { evolution, performanceAgents, parSource, parSpecialite, loading, error } = useReportsStats();

  if (loading) {
    return <RapportsSkeleton />;
  }
  if (error) {
    return <div className="page-container"><p style={{ color: '#ef4444' }}>Erreur : {error.message}</p></div>;
  }

  return (
    <div className="page-container rapports-page">
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Statistiques & Rapports</h1>
          <p className="page-description">Vue d'ensemble de l'activité de prospection.</p>
        </div>
      </div>

      {/* ============================================================
          1. ÉVOLUTION DES PROSPECTS
          ============================================================ */}
      <Section
        title="Évolution des prospects (6 derniers mois)"
        exportButton={
          <ExportButton
            data={evolution}
            filename="evolution_prospects"
            title="Évolution des prospects"
            columns={[
              { key: 'name', label: 'Mois' },
              { key: 'nouveaux', label: 'Nouveaux prospects' },
              { key: 'cumul', label: 'Total cumulé' },
            ]}
          />
        }
      >
        <div style={{ width: '100%', height: 260 }}>
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={evolution} margin={{ top: 10, right: 16, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(200,230,210,0.5)" />
              <XAxis dataKey="name" tick={{ fontSize: 11 }} />
              <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
              <Tooltip />
              <Legend />
              <Line type="monotone" dataKey="cumul" name="Total cumulé" stroke="#2d7a3a" strokeWidth={2.5} dot={{ r: 4 }} isAnimationActive={false} />
              <Line type="monotone" dataKey="nouveaux" name="Nouveaux ce mois" stroke="#f5c842" strokeWidth={2} dot={{ r: 3 }} isAnimationActive={false} />
            </LineChart>
          </ResponsiveContainer>
        </div>
        <table className="rapport-table">
          <thead><tr><th>Mois</th><th>Nouveaux prospects</th><th>Total cumulé</th></tr></thead>
          <tbody>
            {evolution.map((row, i) => (
              <tr key={i}><td>{row.name}</td><td>{row.nouveaux}</td><td>{row.cumul}</td></tr>
            ))}
          </tbody>
        </table>
      </Section>

      {/* ============================================================
          2. PERFORMANCE DES AGENTS
          ============================================================ */}
      <Section
        title="Performance des agents"
        exportButton={
          <ExportButton
            data={performanceAgents}
            filename="performance_agents"
            title="Performance des agents"
            columns={[
              { key: 'agent', label: 'Agent' },
              { key: 'totalSorties', label: 'Total sorties' },
              { key: 'effectuees', label: 'Effectuées' },
              { key: 'prevues', label: 'Prévues' },
              { key: 'annulees', label: 'Annulées' },
              { key: 'tauxReussite', label: 'Taux de réussite (%)' },
            ]}
          />
        }
      >
        {performanceAgents.length === 0 ? (
          <p className="rapport-empty">Aucune participation enregistrée pour le moment</p>
        ) : (
          <>
            <div style={{ width: '100%', height: 280 }}>
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={performanceAgents} margin={{ top: 10, right: 16, left: 0, bottom: 40 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(200,230,210,0.5)" />
                  <XAxis dataKey="agent" tick={{ fontSize: 11 }} angle={-25} textAnchor="end" interval={0} />
                  <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="effectuees" name="Effectuées" fill="#2d7a3a" radius={[4, 4, 0, 0]} isAnimationActive={false} />
                  <Bar dataKey="prevues" name="Prévues" fill="#f5c842" radius={[4, 4, 0, 0]} isAnimationActive={false} />
                  <Bar dataKey="annulees" name="Annulées" fill="#dc6a6a" radius={[4, 4, 0, 0]} isAnimationActive={false} />
                </BarChart>
              </ResponsiveContainer>
            </div>
            <table className="rapport-table">
              <thead><tr><th>Agent</th><th>Total sorties</th><th>Effectuées</th><th>Prévues</th><th>Annulées</th><th>Taux de réussite</th></tr></thead>
              <tbody>
                {performanceAgents.map((row, i) => (
                  <tr key={i}>
                    <td>{row.agent}</td><td>{row.totalSorties}</td><td>{row.effectuees}</td>
                    <td>{row.prevues}</td><td>{row.annulees}</td><td>{row.tauxReussite}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </Section>

      {/* ============================================================
          3. PROSPECTS PAR SOURCE
          ============================================================ */}
      <Section
        title="Prospects par source"
        exportButton={
          <ExportButton
            data={parSource}
            filename="prospects_par_source"
            title="Prospects par source"
            columns={[
              { key: 'name', label: 'Source' },
              { key: 'value', label: 'Nombre de prospects' },
              { key: 'percentage', label: 'Pourcentage' },
            ]}
          />
        }
      >
        {parSource.length === 0 ? (
          <p className="rapport-empty">Aucune fiche de collecte enregistrée pour le moment</p>
        ) : (
          <>
            <div style={{ width: '100%', height: 260, display: 'flex', justifyContent: 'center' }}>
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={parSource} dataKey="value" nameKey="name" innerRadius={60} outerRadius={95} paddingAngle={1} label={(entry) => `${entry.percentage}%`} isAnimationActive={false}>
                    {parSource.map((entry, i) => <Cell key={i} fill={COLORS[i % COLORS.length]} />)}
                  </Pie>
                  <Tooltip />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <table className="rapport-table">
              <thead><tr><th>Source</th><th>Nombre de prospects</th><th>Pourcentage</th></tr></thead>
              <tbody>
                {parSource.map((row, i) => (
                  <tr key={i}><td>{row.name}</td><td>{row.value}</td><td>{row.percentage}%</td></tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </Section>

      {/* ============================================================
          4. PROSPECTS PAR SPÉCIALITÉ CHOISIE + NIVEAU D'INTÉRÊT
          ============================================================ */}
      <Section
        title="Prospects par spécialité et niveau d'intérêt"
        exportButton={
          <ExportButton
            data={parSpecialite}
            filename="prospects_par_specialite"
            title="Prospects par spécialité et niveau d'intérêt"
            columns={[
              { key: 'specialite', label: 'Spécialité' },
              { key: 'total', label: 'Total' },
              { key: 'Faible', label: 'Faible' },
              { key: 'Moyen', label: 'Moyen' },
              { key: 'Élevé', label: 'Élevé' },
              { key: 'Très élevé', label: 'Très élevé' },
            ]}
          />
        }
      >
        {parSpecialite.length === 0 ? (
          <p className="rapport-empty">Aucun intérêt de spécialité enregistré pour le moment</p>
        ) : (
          <>
            <div style={{ width: '100%', height: 280 }}>
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={parSpecialite} margin={{ top: 10, right: 16, left: 0, bottom: 40 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(200,230,210,0.5)" />
                  <XAxis dataKey="specialite" tick={{ fontSize: 11 }} angle={-25} textAnchor="end" interval={0} />
                  <YAxis tick={{ fontSize: 11 }} allowDecimals={false} />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="Faible" stackId="a" fill="#b0bec5" isAnimationActive={false} />
                  <Bar dataKey="Moyen" stackId="a" fill="#f5c842" isAnimationActive={false} />
                  <Bar dataKey="Élevé" stackId="a" fill="#8fbc94" isAnimationActive={false} />
                  <Bar dataKey="Très élevé" stackId="a" fill="#2d7a3a" radius={[4, 4, 0, 0]} isAnimationActive={false} />
                </BarChart>
              </ResponsiveContainer>
            </div>
            <table className="rapport-table">
              <thead><tr><th>Spécialité</th><th>Total</th><th>Faible</th><th>Moyen</th><th>Élevé</th><th>Très élevé</th></tr></thead>
              <tbody>
                {parSpecialite.map((row, i) => (
                  <tr key={i}>
                    <td>{row.specialite}</td><td>{row.total}</td><td>{row.Faible}</td>
                    <td>{row.Moyen}</td><td>{row['Élevé']}</td><td>{row['Très élevé']}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        )}
      </Section>
    </div>
  );
};

export default RapportsDashboard;