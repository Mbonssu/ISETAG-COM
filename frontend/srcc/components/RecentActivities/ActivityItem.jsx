import React from 'react';

const ActivityItem = ({ icon, iconType, title, subtitle, time }) => {
  return (
    <div className="activity-item">
      <div className={`act-icon ${iconType}`}>{icon}</div>
      <div className="act-body">
        <div className="act-title">{title}</div>
        <div className="act-sub">{subtitle}</div>
      </div>
      <div className="act-time">{time}</div>
    </div>
  );
};

export default ActivityItem;
