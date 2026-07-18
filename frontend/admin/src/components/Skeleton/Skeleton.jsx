import React from 'react';
import './Skeleton.css';

/**
 * Composant de squelette de chargement réutilisable.
 *
 * Usage basique :
 *   <Skeleton width="60%" height={20} />
 *
 * Variantes prêtes à l'emploi :
 *   <SkeletonText lines={3} />
 *   <SkeletonCard />
 *   <SkeletonTable rows={5} columns={6} />
 */
export const Skeleton = ({ width = '100%', height = 16, radius = 6, style = {} }) => (
  <div className="skeleton-shimmer" style={{ width, height, borderRadius: radius, ...style }} />
);

export const SkeletonText = ({ lines = 3 }) => (
  <div className="skeleton-text-block">
    {Array.from({ length: lines }).map((_, i) => (
      <Skeleton key={i} width={i === lines - 1 ? '60%' : '100%'} height={14} />
    ))}
  </div>
);

export const SkeletonCard = () => (
  <div className="skeleton-card">
    <Skeleton width={40} height={40} radius={10} />
    <div style={{ flex: 1 }}>
      <Skeleton width="50%" height={12} style={{ marginBottom: 8 }} />
      <Skeleton width="30%" height={20} />
    </div>
  </div>
);

export const SkeletonTable = ({ rows = 5, columns = 5 }) => (
  <div className="skeleton-table">
    {Array.from({ length: rows }).map((_, r) => (
      <div key={r} className="skeleton-table-row">
        {Array.from({ length: columns }).map((_, c) => (
          <Skeleton key={c} height={14} width={c === 0 ? '80%' : '60%'} />
        ))}
      </div>
    ))}
  </div>
);

/**
 * Silhouette d'un graphique (barres de hauteurs variées), pour les zones
 * qui vont accueillir un vrai graphique Recharts une fois les données
 * chargées — plus fidèle qu'un simple rectangle plein.
 */
export const SkeletonChart = ({ height = 260 }) => {
  const heights = [55, 80, 45, 90, 65, 40, 75, 50, 85, 60, 70, 48];
  return (
    <div className="skeleton-chart" style={{ height }}>
      {heights.map((h, i) => (
        <Skeleton key={i} width="100%" height={`${h}%`} radius={4} style={{ alignSelf: 'flex-end' }} />
      ))}
    </div>
  );
};

export default Skeleton;