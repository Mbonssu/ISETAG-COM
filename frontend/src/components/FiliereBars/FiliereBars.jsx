import React, { useEffect, useRef } from 'react';
import FiliereRow from './FiliereRow';
import './FiliereBars.css';

// `data` vient de useDashboardStats() -> computeFiliereDistribution() (statsService.js)
// Forme attendue : [{ name, value, percentage }]
const FiliereBars = ({ data = [] }) => {
  const barsRef = useRef([]);
  const total = data.reduce((sum, f) => sum + f.value, 0);

  useEffect(() => {
    barsRef.current.forEach((bar, i) => {
      if (bar) {
        const width = bar.dataset.w;
        setTimeout(() => {
          bar.style.width = width;
        }, 400 + i * 90);
      }
    });
  }, [data]);

  return (
    <div className="card">
      <div className="table-header">
        <div className="card-title">Prospects par filière</div>
        <span className="see-all">Voir tout</span>
      </div>
      <div className="filiere-list">
        {data.length === 0 && <p style={{ color: '#9ca3af' }}>Aucune donnée</p>}
        {data.map((filiere, idx) => (
          <FiliereRow key={filiere.name} {...filiere} barRef={(el) => (barsRef.current[idx] = el)} />
        ))}
      </div>
      <div className="filiere-total">Total : <strong>{total}</strong></div>
    </div>
  );
};

export default FiliereBars;
