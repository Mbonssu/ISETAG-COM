import React from 'react';
import TableRow from './TableRow';
import './ProspectsTable.css';

// `data` vient de useDashboardStats() -> computeProspectsTableRows() (statsService.js)
// Forme attendue : [{ initials, name, source, filiere, agent, date, status, statusType }]
const ProspectsTable = ({ data = [] }) => {
  return (
    <div className="card">
      <div className="table-header">
        <div className="card-title">Derniers prospects ajoutés</div>
        <button className="voir-tout-btn">Voir tout</button>
      </div>
      <table>
        <thead>
          <tr>
            <th>Nom du prospect</th><th>Ville</th><th>Filière intéressée</th>
            <th>Niveau d'étude</th><th>Date</th><th>Statut</th>
          </tr>
        </thead>
        <tbody>
          {data.length === 0 && (
            <tr><td colSpan={6} style={{ color: '#9ca3af', textAlign: 'center', padding: '1rem' }}>Aucun prospect pour le moment.</td></tr>
          )}
          {data.map((prospect, idx) => (
            <TableRow key={idx} {...prospect} />
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ProspectsTable;
