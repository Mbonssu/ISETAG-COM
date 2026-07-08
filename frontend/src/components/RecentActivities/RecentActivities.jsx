import React from 'react';
import ActivityItem from './ActivityItem';
import './RecentActivities.css';

// `data` vient de useDashboardStats() -> computeRecentActivities() (statsService.js)
// Forme attendue : [{ icon, iconType, title, subtitle, time }]
const RecentActivities = ({ data = [] }) => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Activités récentes</div>
      </div>
      <div className="activity-list">
        {data.length === 0 && <p style={{ color: '#9ca3af', padding: '0.5rem 0' }}>Aucune activité récente.</p>}
        {data.map((activity, idx) => (
          <ActivityItem key={idx} {...activity} />
        ))}
      </div>
      <div className="act-more">
        <span className="see-all">Voir tout</span>
      </div>
    </div>
  );
};

export default RecentActivities;
