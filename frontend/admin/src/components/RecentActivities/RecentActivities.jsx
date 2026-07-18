// import React from 'react';
// import ActivityItem from './ActivityItem';
// import './RecentActivities.css';

// // `data` vient de useDashboardStats() -> computeRecentActivities() (statsService.js)
// // Forme attendue : [{ icon, iconType, title, subtitle, time }]
// const RecentActivities = ({ data = [] }) => {
//   return (
//     <div className="card">
//       <div className="card-header">
//         <div className="card-title">Activités récentes</div>
//       </div>
//       <div className="activity-list">
//         {data.length === 0 && <p style={{ color: '#9ca3af', padding: '0.5rem 0' }}>Aucune activité récente.</p>}
//         {data.map((activity, idx) => (
//           <ActivityItem key={idx} {...activity} />
//         ))}
//       </div>
//       <div className="act-more">
//         <span className="see-all">Voir tout</span>
//       </div>
//     </div>
//   );
// };

// export default RecentActivities;

import React from 'react';
import ActivityItem from './ActivityItem';
import './RecentActivities.css';

//  CORRIGÉ : activités 100% codées en dur. Reçoit maintenant les vraies
// relances/suivis récents (fusionnés et triés), calculés dans useDashboardStats.

const ICONS = {
  relance: { icon: '🔔', iconType: 'clock' },
  suivi: { icon: '📋', iconType: 'person' },
};

const formatRelativeTime = (isoString) => {
  const diffMs = Date.now() - new Date(isoString).getTime();
  const diffMin = Math.floor(diffMs / 60000);
  if (diffMin < 1) return "à l'instant";
  if (diffMin < 60) return `il y a ${diffMin} min`;
  const diffH = Math.floor(diffMin / 60);
  if (diffH < 24) return `il y a ${diffH}h`;
  const diffJ = Math.floor(diffH / 24);
  if (diffJ === 1) return 'hier';
  return `il y a ${diffJ}j`;
};

const RecentActivities = ({ data = [] }) => {
  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Activités récentes</div>
      </div>
      <div className="activity-list">
        {data.length === 0 ? (
          <p style={{ textAlign: 'center', color: '#9ca3af', padding: '20px 0' }}>Aucune activité récente</p>
        ) : (
          data.map((activity, idx) => (
            <ActivityItem
              key={idx}
              icon={ICONS[activity.type]?.icon || '•'}
              iconType={ICONS[activity.type]?.iconType || 'person'}
              title={activity.title}
              subtitle={activity.subtitle}
              time={formatRelativeTime(activity.date)}
            />
          ))
        )}
      </div>
    </div>
  );
};

export default RecentActivities;