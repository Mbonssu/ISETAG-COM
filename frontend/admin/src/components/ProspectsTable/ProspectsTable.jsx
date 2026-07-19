// import React from 'react';
// import TableRow from './TableRow';
// import './ProspectsTable.css';

// // `data` vient de useDashboardStats() -> computeProspectsTableRows() (statsService.js)
// // Forme attendue : [{ initials, name, source, filiere, agent, date, status, statusType }]
// const ProspectsTable = ({ data = [] }) => {
//   return (
//     <div className="card">
//       <div className="table-header">
//         <div className="card-title">Derniers prospects ajoutés</div>
//         <button className="voir-tout-btn">Voir tout</button>
//       </div>
//       <table>
//         <thead>
//           <tr>
//             <th>Nom du prospect</th><th>Ville</th><th>Filière intéressée</th>
//             <th>Niveau d'étude</th><th>Date</th><th>Statut</th>
//           </tr>
//         </thead>
//         <tbody>
//           {data.length === 0 && (
//             <tr><td colSpan={6} style={{ color: '#9ca3af', textAlign: 'center', padding: '1rem' }}>Aucun prospect pour le moment.</td></tr>
//           )}
//           {data.map((prospect, idx) => (
//             <TableRow key={idx} {...prospect} />
//           ))}
//         </tbody>
//       </table>
//     </div>
//   );
// };

// export default ProspectsTable;

import React from 'react';
import { useNavigate } from 'react-router-dom';
import TableRow from './TableRow';
import './ProspectsTable.css';

//  CORRIGÉ : liste 100% codée en dur. Reçoit maintenant les vrais
// prospects (les 5 plus récents), triés par date de création.

const ProspectsTable = ({ data = [] }) => {
  const navigate = useNavigate();
  const derniers = data.slice(0, 5);

  return (
    <div className="card">
      <div className="table-header">
        <div className="card-title">Derniers prospects ajoutés</div>
        <button className="voir-tout-btn" onClick={() => navigate('/prospects')}>Voir tout</button>
      </div>
      {derniers.length === 0 ? (
        <p style={{ textAlign: 'center', color: '#9ca3af', padding: '20px 0' }}>Aucun prospect pour le moment</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Nom du prospect</th><th>Source</th><th>Domaine d'étude</th>
              <th>Ville</th><th>Date</th><th>Type</th>
            </tr>
          </thead>
          <tbody>
            {derniers.map((prospect) => (
              <TableRow key={prospect.idProspect} {...prospect} />
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default ProspectsTable;