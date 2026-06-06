import React from 'react';
import KPICard from './KPICard';
import './KPICards.css';

const kpiData = [
  { icon: '👥', label: 'Total Prospects', value: '1 248', trend: '+18.5%', vs: 'vs hier', color: 'green' },
  { icon: '📋', label: 'À relancer', value: '256', trend: '+12.3%', vs: 'vs hier', color: 'yellow' },
  { icon: '🏫', label: 'Établissements visités', value: '42', trend: '+8.7%', vs: 'vs hier', color: 'green' },
  { icon: '👤', label: 'Agents actifs', value: '28', trend: '+5.2%', vs: 'vs hier', color: 'yellow' },
];

const KPICards = () => {
  return (
    <div className="kpi-grid">
      {kpiData.map((kpi, index) => (
        <KPICard key={index} {...kpi} />
      ))}
    </div>
  );
};

export default KPICards;