import React from 'react';
import { useDashboardStats } from '../hooks/useDashboardStats';
import KPICards from '../components/KPICards/KPICards';
import EvolutionChart from '../components/EvolutionChart/EvolutionChart';
import SourceDonut from '../components/SourceDonut/SourceDonut';
import RecentActivities from '../components/RecentActivities/RecentActivities';
import ProspectsTable from '../components/ProspectsTable/ProspectsTable';
import FiliereBars from '../components/FiliereBars/FiliereBars';

const Dashboard = () => {
  const {
    kpis, evolution, sourceDistribution,
    filiereDistribution, recentActivities, tableRows,
    loading, error, refresh,
  } = useDashboardStats();

  if (loading) return <p>Chargement des statistiques...</p>;

  if (error) {
    return (
      <div>
        <p>Erreur lors du chargement des statistiques : {error.message}</p>
        <button onClick={refresh}>Réessayer</button>
      </div>
    );
  }

  return (
    <>
      <KPICards data={kpis} />
      <div className="mid-row">
        <EvolutionChart data={evolution} />
        <SourceDonut data={sourceDistribution} />
        <RecentActivities data={recentActivities} />
      </div>
      <div className="bot-row">
        <ProspectsTable data={tableRows} />
        <FiliereBars data={filiereDistribution} />
      </div>
    </>
  );
};

export default Dashboard;
