// import React from 'react';
// import { useDashboardStats } from '../hooks/useDashboardStats';
// import KPICards from '../components/KPICards/KPICards';
// import EvolutionChart from '../components/EvolutionChart/EvolutionChart';
// import SourceDonut from '../components/SourceDonut/SourceDonut';
// import RecentActivities from '../components/RecentActivities/RecentActivities';
// import ProspectsTable from '../components/ProspectsTable/ProspectsTable';
// import FiliereBars from '../components/FiliereBars/FiliereBars';
// import { SkeletonCard, SkeletonTable } from '../components/Skeleton/Skeleton';

// const DashboardSkeleton = () => (
//   <>
//     <div className="kpi-grid">
//       {Array.from({ length: 4 }).map((_, i) => <SkeletonCard key={i} />)}
//     </div>
//     <div className="mid-row">
//       <div className="card"><SkeletonTable rows={4} columns={3} /></div>
//       <div className="card"><SkeletonTable rows={4} columns={2} /></div>
//       <div className="card"><SkeletonTable rows={5} columns={2} /></div>
//     </div>
//     <div className="bot-row">
//       <div className="card"><SkeletonTable rows={5} columns={6} /></div>
//       <div className="card"><SkeletonTable rows={5} columns={2} /></div>
//     </div>
//   </>
// );

// const Dashboard = () => {
//   const {
//     kpis, evolution, sourceDistribution,
//     recentActivities, prospects, domaineDistribution,
//     loading, error,
//   } = useDashboardStats();

//   if (loading) return <DashboardSkeleton />;
//   if (error) return <p style={{ padding: 24, color: '#ef4444' }}>Erreur : {error.message}</p>;

//   return (
//     <>
//       <KPICards data={kpis} />
//       <div className="mid-row">
//         <EvolutionChart data={evolution} />
//         <SourceDonut data={sourceDistribution} />
//         <RecentActivities data={recentActivities} />
//       </div>
//       <div className="bot-row">
//         <ProspectsTable data={prospects} />
//         <FiliereBars data={domaineDistribution} />
//       </div>
//     </>
//   );
// };

// export default Dashboard;


import React from 'react';
import { useDashboardStats } from '../hooks/useDashboardStats';
import KPICards from '../components/KPICards/KPICards';
import EvolutionChart from '../components/EvolutionChart/EvolutionChart';
import SourceDonut from '../components/SourceDonut/SourceDonut';
import RecentActivities from '../components/RecentActivities/RecentActivities';
import ProspectsTable from '../components/ProspectsTable/ProspectsTable';
import FiliereBars from '../components/FiliereBars/FiliereBars';
import { SkeletonCard, SkeletonTable } from '../components/Skeleton/Skeleton';

const DashboardSkeleton = () => (
  <>
    <div className="kpi-grid">
      {Array.from({ length: 4 }).map((_, i) => <SkeletonCard key={i} />)}
    </div>
    <div className="mid-row">
      <div className="card"><SkeletonTable rows={4} columns={3} /></div>
      <div className="card"><SkeletonTable rows={4} columns={2} /></div>
      <div className="card"><SkeletonTable rows={5} columns={2} /></div>
    </div>
    <div className="bot-row">
      <div className="card"><SkeletonTable rows={5} columns={6} /></div>
      <div className="card"><SkeletonTable rows={5} columns={2} /></div>
    </div>
  </>
);

const Dashboard = () => {
  const {
    kpis, evolution, sourceDistribution,
    recentActivities, prospects, domaineDistribution,
    loading, error,
  } = useDashboardStats();

  if (loading) return <DashboardSkeleton />;
  if (error) return <p style={{ padding: 24, color: '#ef4444' }}>Erreur : {error.message}</p>;

  return (
    <>
      <KPICards data={kpis} />
      <div className="mid-row">
        <EvolutionChart data={evolution} />
        <SourceDonut data={sourceDistribution} />
        <RecentActivities data={recentActivities} />
      </div>
      <div className="bot-row">
        <ProspectsTable data={prospects} />
        <FiliereBars data={domaineDistribution} />
      </div>
    </>
  );
};

export default Dashboard;