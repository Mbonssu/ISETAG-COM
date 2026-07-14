import React from 'react';

const AdminCard = () => {
  return (
    <div className="admin-card">
      <div className="admin-avatar">A</div>
      <div className="admin-info">
        <div className="admin-name">Admin ISETAG</div>
        <div className="admin-role">Administrateur</div>
      </div>
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.5)" strokeWidth="2">
        <path d="m6 9 6 6 6-6" />
      </svg>
    </div>
  );
};

export default AdminCard;