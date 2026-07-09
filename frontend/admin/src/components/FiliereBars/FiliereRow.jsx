// import React from 'react';

// const FiliereRow = ({ name, percentage, value, avgNiveauLabel, barRef }) => {
//   return (
//     <div className="filiere-row">
//       <div className="filiere-top">
//         <span className="filiere-name">{name}</span>
//         <span className="filiere-pct">{percentage}% ({value} prospect{value > 1 ? 's' : ''})</span>
//       </div>
//       {avgNiveauLabel && (
//         <div className="filiere-niveau" style={{ fontSize: '0.75rem', color: '#6b7280', marginBottom: '2px' }}>
//           Intérêt moyen : {avgNiveauLabel}
//         </div>
//       )}
//       <div className="filiere-bar-bg">
//         <div 
//           ref={barRef}
//           className="filiere-bar-fill" 
//           data-w={`${percentage}%`}
//           style={{ width: '0%' }}
//         ></div>
//       </div>
//     </div>
//   );
// };

// export default FiliereRow;


import React from 'react';

const FiliereRow = ({ name, percentage, value, barRef }) => {
  return (
    <div className="filiere-row">
      <div className="filiere-top">
        <span className="filiere-name">{name}</span>
        <span className="filiere-pct">{percentage}% ({value})</span>
      </div>
      <div className="filiere-bar-bg">
        <div 
          ref={barRef}
          className="filiere-bar-fill" 
          data-w={`${percentage}%`}
          style={{ width: '0%' }}
        ></div>
      </div>
    </div>
  );
};

export default FiliereRow;