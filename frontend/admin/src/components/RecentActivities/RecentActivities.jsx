import React from 'react';
import ActivityItem from './ActivityItem';
import './RecentActivities.css';

const activities = [
  { icon: '👤', iconType: 'person', title: 'Marie L. a ajouté 8 prospects', subtitle: 'Lycée de Biyem-Assi', time: '10:30' },
  { icon: '🕐', iconType: 'clock', title: 'Relance programmée', subtitle: 'Jean M. · 25 Mai 2025', time: '09:15' },
  { icon: '🏫', iconType: 'build', title: 'Nouvel établissement ajouté', subtitle: 'Lycée Technique d\'Efoulan', time: 'Hier' },
  { icon: '👤', iconType: 'person', title: 'David P. a ajouté 12 prospects', subtitle: 'Zone Mvog-Ada', time: 'Hier' },
];

const RecentActivities = () => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Activités récentes</div>
      </div>
      <div className="activity-list">
        {activities.map((activity, idx) => (
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