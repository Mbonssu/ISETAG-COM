import React from 'react';

const statusClasses = {
  relancer: 'badge-relancer',
  nouveau: 'badge-nouveau',
  contacte: 'badge-contacte',
};

const getInitialsColor = (statusType) => {
  switch (statusType) {
    case 'relancer': return { bg: 'rgba(255,236,180,0.7)', color: '#b45309' };
    case 'nouveau': return { bg: 'rgba(200,240,210,0.7)', color: '#1a5c2a' };
    case 'contacte': return { bg: 'rgba(190,220,255,0.7)', color: '#0c4a8a' };
    default: return { bg: 'rgba(200,240,210,0.7)', color: '#1a5c2a' };
  }
};

const TableRow = ({ initials, name, source, filiere, agent, date, status, statusType }) => {
  const initialsStyle = getInitialsColor(statusType);

  return (
    <tr>
      <td>
        <span className="prospect-initials" style={{ background: initialsStyle.bg, color: initialsStyle.color }}>
          {initials}
        </span>
        <span className="prospect-name">{name}</span>
      </td>
      <td>{source}</td>
      <td>{filiere}</td>
      <td>{agent}</td>
      <td>{date}</td>
      <td>
        <span className={`badge ${statusClasses[statusType]}`}>{status}</span>
      </td>
    </tr>
  );
};

export default TableRow;
