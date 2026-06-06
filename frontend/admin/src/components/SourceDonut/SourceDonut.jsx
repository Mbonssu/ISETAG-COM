import React, { useEffect, useRef } from 'react';
import './SourceDonut.css';

const sourceData = [
  { name: 'Terrain', percentage: 45, value: 562, color: '#2d7a3a' },
  { name: 'Lycée', percentage: 30, value: 374, color: '#f5c842' },
  { name: 'Passage institut', percentage: 15, value: 187, color: '#b0bec5' },
  { name: 'Réseaux sociaux', percentage: 6, value: 75, color: '#78909c' },
  { name: 'Référence', percentage: 4, value: 50, color: '#dde3e7' },
];

const SourceDonut = () => {
  const canvasRef = useRef(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    const cx = 75, cy = 75, R = 62, r = 42;

    canvas.width = 150;
    canvas.height = 150;

    let startAngle = -Math.PI / 2;

    sourceData.forEach(slice => {
      const endAngle = startAngle + (slice.percentage / 100) * Math.PI * 2;
      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.arc(cx, cy, R, startAngle, endAngle);
      ctx.closePath();
      ctx.fillStyle = slice.color;
      ctx.fill();
      startAngle = endAngle;
    });

    // Glass hole
    const grad = ctx.createRadialGradient(cx, cy, r - 8, cx, cy, r);
    grad.addColorStop(0, 'rgba(255,255,255,0.95)');
    grad.addColorStop(1, 'rgba(240,252,244,0.85)');
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI * 2);
    ctx.fillStyle = grad;
    ctx.fill();
  }, []);

  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Prospects par source</div>
      </div>
      <div className="donut-wrap">
        <canvas ref={canvasRef} width="150" height="150"></canvas>
        <div className="donut-legend">
          {sourceData.map((item, idx) => (
            <div key={idx} className="donut-item">
              <div className="donut-dot" style={{ background: item.color }}></div>
              <span className="donut-label">{item.name}</span>
              <span className="donut-pct">{item.percentage}% ({item.value})</span>
            </div>
          ))}
        </div>
        <div className="donut-total">Total : <strong>1 248</strong></div>
      </div>
    </div>
  );
};

export default SourceDonut;