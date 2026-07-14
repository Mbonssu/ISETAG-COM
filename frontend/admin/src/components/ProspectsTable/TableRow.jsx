// import React from 'react';

// const statusClasses = {
//   relancer: 'badge-relancer',
//   nouveau: 'badge-nouveau',
//   contacte: 'badge-contacte',
// };

// const getInitialsColor = (statusType) => {
//   switch (statusType) {
//     case 'relancer': return { bg: 'rgba(255,236,180,0.7)', color: '#b45309' };
//     case 'nouveau': return { bg: 'rgba(200,240,210,0.7)', color: '#1a5c2a' };
//     case 'contacte': return { bg: 'rgba(190,220,255,0.7)', color: '#0c4a8a' };
//     default: return { bg: 'rgba(200,240,210,0.7)', color: '#1a5c2a' };
//   }
// };

// const TableRow = ({ initials, name, source, filiere, agent, date, status, statusType }) => {
//   const initialsStyle = getInitialsColor(statusType);

//   return (
//     <tr>
//       <td>
//         <span className="prospect-initials" style={{ background: initialsStyle.bg, color: initialsStyle.color }}>
//           {initials}
//         </span>
//         <span className="prospect-name">{name}</span>
//       </td>
//       <td>{source}</td>
//       <td>{filiere}</td>
//       <td>{agent}</td>
//       <td>{date}</td>
//       <td>
//         <span className={`badge ${statusClasses[statusType]}`}>{status}</span>
//       </td>
//     </tr>
//   );
// };

// export default TableRow;


import React from 'react';

// ⚠️ CORRIGÉ : "agent" et "statut" n'existent pas sur le modèle Prospect
// côté backend, retirés. "Filière" remplacé par "domaineEtude" (champ réel).

const getInitials = (nom) => {
  if (!nom) return '?';
  return nom.split(' ').map((p) => p[0]).slice(0, 2).join('').toUpperCase();
};

const typeColors = {
  Etudiant: { bg: 'rgba(200,240,210,0.7)', color: '#1a5c2a' },
  Parent: { bg: 'rgba(190,220,255,0.7)', color: '#0c4a8a' },
  Professionnel: { bg: 'rgba(255,236,180,0.7)', color: '#b45309' },
  Autre: { bg: 'rgba(230,230,230,0.7)', color: '#555' },
};

const TableRow = ({ nomComplet, sourceNom, domaineEtude, typeProspect, ville, createdAt }) => {
  const style = typeColors[typeProspect] || typeColors.Autre;
  const date = createdAt ? new Date(createdAt).toLocaleDateString('fr-FR') : '-';

  return (
    <tr>
      <td>
        <span className="prospect-initials" style={{ background: style.bg, color: style.color }}>
          {getInitials(nomComplet)}
        </span>
        <span className="prospect-name">{nomComplet}</span>
      </td>
      <td>{sourceNom || '-'}</td>
      <td>{domaineEtude || '-'}</td>
      <td>{ville || '-'}</td>
      <td>{date}</td>
      <td><span className="badge" style={{ background: style.bg, color: style.color }}>{typeProspect || 'Non renseigné'}</span></td>
    </tr>
  );
};

export default TableRow;