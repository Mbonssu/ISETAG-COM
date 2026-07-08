import React from 'react';
import TableRow from './TableRow';
import './ProspectsTable.css';

const prospects = [
  { name: 'Marie L.', source: 'Lycée', filiere: 'Génie Logiciel', agent: 'Jean M.', date: '25 Mai 2025', status: 'À relancer', statusType: 'relancer' },
  { name: 'David P.', source: 'Terrain', filiere: 'Génie Civil', agent: 'David P.', date: '25 Mai 2025', status: 'Nouveau', statusType: 'nouveau' },
  { name: 'Anne S.', source: 'Passage institut', filiere: 'Marketing', agent: 'Sophie A.', date: '25 Mai 2025', status: 'Contacté', statusType: 'contacte' },
  { name: 'Junior B.', source: 'Lycée', filiere: 'Réseaux & Télécoms', agent: 'Jean M.', date: '24 Mai 2025', status: 'À relancer', statusType: 'relancer' },
  { name: 'Luc M.', source: 'Terrain', filiere: 'Architecture', agent: 'David P.', date: '24 Mai 2025', status: 'Nouveau', statusType: 'nouveau' },
];

const ProspectsTable = () => {
  return (
    <div className="card">
      <div className="table-header">
        <div className="card-title">Derniers prospects ajoutés</div>
        <button className="voir-tout-btn">Voir tout</button>
      </div>
      <table>
        <thead>
          <tr>
            <th>Nom du prospect</th><th>Source</th><th>Filière intéressée</th>
            <th>Agent</th><th>Date</th><th>Statut</th>
          </tr>
        </thead>
        <tbody>
          {prospects.map((prospect, idx) => (
            <TableRow key={idx} {...prospect} />
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ProspectsTable;