// import React from 'react';
// import KPICard from './KPICard';
// import './KPICards.css';

// // `data` vient de useDashboardStats() -> computeKPIs() (src/services/statsService.js)
// // Chaque élément : { key, icon, label, value, color, trend?, vs? }
// const KPICards = ({ data = [] }) => {
//   return (
//     <div className="kpi-grid">
//       {data.map((kpi) => (
//         <KPICard key={kpi.key} {...kpi} />
//       ))}
//     </div>
//   );
// };

// export default KPICards;


import React from 'react';
import KPICard from './KPICard';
import './KPICards.css';

// ⚠️ CORRIGÉ : les KPI étaient codés en dur. Reçoit maintenant les vraies
// valeurs calculées par useDashboardStats à partir des données réelles.
const KPICards = ({ data = [] }) => {
  return (
    <div className="kpi-grid">
      {data.map((kpi, index) => (
        <KPICard key={index} {...kpi} />
      ))}
    </div>
  );
};

export default KPICards;