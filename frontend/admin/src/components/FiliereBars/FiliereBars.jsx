import React, { useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import FiliereRow from './FiliereRow';
import './FiliereBars.css';

//  CORRIGÉ : liste 100% codée en dur, sans lien avec les vraies données.
// "Filière" au sens strict (relation via interetSpecialite) n'a pas de
// route groupée côté backend, ce qui rendrait ce calcul très coûteux
// (un appel par prospect). On utilise donc "domaineEtude", un champ RÉEL
// et directement disponible sur le modèle Prospect, ce qui donne une vraie
// répartition sans appels supplémentaires.

const FiliereBars = ({ data = [] }) => {
  const barsRef = useRef([]);
  const navigate = useNavigate();
  const total = data.reduce((sum, d) => sum + d.value, 0);

  useEffect(() => {
    barsRef.current.forEach((bar, i) => {
      if (bar) {
        const width = bar.dataset.w;
        setTimeout(() => { bar.style.width = width; }, 400 + i * 90);
      }
    });
  }, [data]);

  return (
    <div className="card">
      <div className="table-header">
        <div className="card-title">Prospects par domaine d'étude</div>
        <span className="see-all" onClick={() => navigate('/prospects')} style={{ cursor: 'pointer' }}>Voir tout</span>
      </div>
      {data.length === 0 ? (
        <p style={{ textAlign: 'center', color: '#9ca3af', padding: '20px 0' }}>Aucune donnée pour le moment</p>
      ) : (
        <>
          <div className="filiere-list">
            {data.map((item, idx) => (
              <FiliereRow key={idx} {...item} barRef={(el) => (barsRef.current[idx] = el)} />
            ))}
          </div>
          <div className="filiere-total">Total : <strong>{total}</strong></div>
        </>
      )}
    </div>
  );
};

export default FiliereBars;