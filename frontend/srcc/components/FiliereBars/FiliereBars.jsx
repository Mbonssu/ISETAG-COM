import React, { useEffect, useRef } from 'react';
import FiliereRow from './FiliereRow';
import './FiliereBars.css';

const filieres = [
  { name: 'Génie Logiciel', percentage: 32, value: 399 },
  { name: 'Génie Civil', percentage: 20, value: 249 },
  { name: 'Marketing', percentage: 18, value: 224 },
  { name: 'Réseaux & Télécoms', percentage: 12, value: 150 },
  { name: 'Architecture', percentage: 8, value: 100 },
  { name: 'Autres', percentage: 10, value: 126 },
];

const FiliereBars = () => {
  const barsRef = useRef([]);

  useEffect(() => {
    barsRef.current.forEach((bar, i) => {
      if (bar) {
        const width = bar.dataset.w;
        setTimeout(() => {
          bar.style.width = width;
        }, 400 + i * 90);
      }
    });
  }, []);

  return (
    <div className="card">
      <div className="table-header">
        <div className="card-title">Prospects par filière</div>
        <span className="see-all">Voir tout</span>
      </div>
      <div className="filiere-list">
        {filieres.map((filiere, idx) => (
          <FiliereRow key={idx} {...filiere} barRef={(el) => barsRef.current[idx] = el} />
        ))}
      </div>
      <div className="filiere-total">Total : <strong>1 248</strong></div>
    </div>
  );
};

export default FiliereBars;