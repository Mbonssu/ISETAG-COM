// import React, { useEffect, useRef } from 'react';
// import './SourceDonut.css';

// // `data` vient de useDashboardStats() -> computeSourceDistribution() (statsService.js)
// // Forme attendue : [{ name, value, percentage, color }]
// const SourceDonut = ({ data = [] }) => {
//   const canvasRef = useRef(null);
//   const total = data.reduce((sum, s) => sum + s.value, 0);

//   useEffect(() => {
//     const canvas = canvasRef.current;
//     if (!canvas) return;
//     const ctx = canvas.getContext('2d');
//     const cx = 75, cy = 75, R = 62, r = 42;

//     canvas.width = 150;
//     canvas.height = 150;
//     ctx.clearRect(0, 0, 150, 150);

//     if (data.length === 0) {
//       ctx.beginPath();
//       ctx.arc(cx, cy, R, 0, Math.PI * 2);
//       ctx.fillStyle = '#eef2f0';
//       ctx.fill();
//     } else {
//       let startAngle = -Math.PI / 2;
//       data.forEach((slice) => {
//         const endAngle = startAngle + (slice.percentage / 100) * Math.PI * 2;
//         ctx.beginPath();
//         ctx.moveTo(cx, cy);
//         ctx.arc(cx, cy, R, startAngle, endAngle);
//         ctx.closePath();
//         ctx.fillStyle = slice.color;
//         ctx.fill();
//         startAngle = endAngle;
//       });
//     }

//     const grad = ctx.createRadialGradient(cx, cy, r - 8, cx, cy, r);
//     grad.addColorStop(0, 'rgba(255,255,255,0.95)');
//     grad.addColorStop(1, 'rgba(240,252,244,0.85)');
//     ctx.beginPath();
//     ctx.arc(cx, cy, r, 0, Math.PI * 2);
//     ctx.fillStyle = grad;
//     ctx.fill();
//   }, [data]);

//   return (
//     <div className="card">
//       <div className="card-header">
//         <div className="card-title">Prospects par source</div>
//       </div>
//       <div className="donut-wrap">
//         <canvas ref={canvasRef} width="150" height="150"></canvas>
//         <div className="donut-legend">
//           {data.length === 0 && <p style={{ color: '#9ca3af', margin: 0 }}>Aucune donnée</p>}
//           {data.map((item) => (
//             <div key={item.name} className="donut-item">
//               <div className="donut-dot" style={{ background: item.color }}></div>
//               <span className="donut-label">{item.name}</span>
//               <span className="donut-pct">{item.percentage}% ({item.value})</span>
//             </div>
//           ))}
//         </div>
//         <div className="donut-total">Total : <strong>{total}</strong></div>
//       </div>
//     </div>
//   );
// };

// export default SourceDonut;


import React from 'react';
import { PieChart, Pie, Cell, Tooltip, ResponsiveContainer } from 'recharts';
import './SourceDonut.css';

//  CORRIGÉ : remplacé le canvas fait main avec des sources 100% inventées
// par un vrai donut Recharts branché sur les vraies fiches de collecte
// (source_detail.libele, calculé dans useDashboardStats).

const SourceDonut = ({ data = [] }) => {
  const total = data.reduce((sum, d) => sum + d.value, 0);

  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Prospects par source</div>
      </div>
      <div className="donut-wrap">
        {data.length === 0 ? (
          <p style={{ textAlign: 'center', color: '#9ca3af', width: '100%' }}>Aucune fiche de collecte pour le moment</p>
        ) : (
          <>
            <div style={{ width: 150, height: 150 }}>
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={data} dataKey="value" nameKey="name" innerRadius={42} outerRadius={62} paddingAngle={1}>
                    {data.map((entry, i) => <Cell key={i} fill={entry.color} />)}
                  </Pie>
                  <Tooltip formatter={(value, name) => [`${value} prospect(s)`, name]} />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div className="donut-legend">
              {data.map((item, idx) => (
                <div key={idx} className="donut-item">
                  <div className="donut-dot" style={{ background: item.color }}></div>
                  <span className="donut-label">{item.name}</span>
                  <span className="donut-pct">{item.percentage}% ({item.value})</span>
                </div>
              ))}
            </div>
            <div className="donut-total">Total : <strong>{total}</strong></div>
          </>
        )}
      </div>
    </div>
  );
};

export default SourceDonut;