import React from 'react';
import KPICards from '../components/KPICards/KPICards';
import EvolutionChart from '../components/EvolutionChart/EvolutionChart';
import SourceDonut from '../components/SourceDonut/SourceDonut';
import RecentActivities from '../components/RecentActivities/RecentActivities';
import ProspectsTable from '../components/ProspectsTable/ProspectsTable';
import FiliereBars from '../components/FiliereBars/FiliereBars';

const Dashboard = () => {

  return (
    <>
      <KPICards />
      <div className="mid-row">
        <EvolutionChart />
        <SourceDonut />
        <RecentActivities />
      </div>
      <div className="bot-row">
        <ProspectsTable />
        <FiliereBars />
      </div>
    </>
  );
};

export default Dashboard;
