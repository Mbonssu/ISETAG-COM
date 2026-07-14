import React from 'react';
import KPICard from './KPICard';
import './KPICards.css';

// `data` vient de useDashboardStats() -> computeKPIs() (src/services/statsService.js)
// Chaque élément : { key, icon, label, value, color, trend?, vs? }
const KPICards = ({ data = [] }) => {
  return (
    <div className="kpi-grid">
      {data.map((kpi) => (
        <KPICard key={kpi.key} {...kpi} />
      ))}
    </div>
  );
};

export default KPICards;
