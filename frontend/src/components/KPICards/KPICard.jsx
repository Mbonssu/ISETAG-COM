import React from 'react';

const KPICard = ({ icon, label, value, trend, vs, color }) => {
  return (
    <div className="kpi-card">
      <div className={`kpi-icon ${color}`}>{icon}</div>
      <div>
        <div className="kpi-label">{label}</div>
        <div className="kpi-value">{value}</div>
        {trend && (
          <div className="kpi-trend">↗ {trend} <span className="vs">{vs}</span></div>
        )}
      </div>
    </div>
  );
};

export default KPICard;
