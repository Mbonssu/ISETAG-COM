import React, { useEffect, useRef } from 'react';
import './SourceDonut.css';

// `data` vient de useDashboardStats() -> computeSourceDistribution() (statsService.js)
// Forme attendue : [{ name, value, percentage, color }]
const SourceDonut = ({ data = [] }) => {
  const canvasRef = useRef(null);
  const total = data.reduce((sum, s) => sum + s.value, 0);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const cx = 75, cy = 75, R = 62, r = 42;

    canvas.width = 150;
    canvas.height = 150;
    ctx.clearRect(0, 0, 150, 150);

    if (data.length === 0) {
      ctx.beginPath();
      ctx.arc(cx, cy, R, 0, Math.PI * 2);
      ctx.fillStyle = '#eef2f0';
      ctx.fill();
    } else {
      let startAngle = -Math.PI / 2;
      data.forEach((slice) => {
        const endAngle = startAngle + (slice.percentage / 100) * Math.PI * 2;
        ctx.beginPath();
        ctx.moveTo(cx, cy);
        ctx.arc(cx, cy, R, startAngle, endAngle);
        ctx.closePath();
        ctx.fillStyle = slice.color;
        ctx.fill();
        startAngle = endAngle;
      });
    }

    const grad = ctx.createRadialGradient(cx, cy, r - 8, cx, cy, r);
    grad.addColorStop(0, 'rgba(255,255,255,0.95)');
    grad.addColorStop(1, 'rgba(240,252,244,0.85)');
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI * 2);
    ctx.fillStyle = grad;
    ctx.fill();
  }, [data]);

  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Prospects par source</div>
      </div>
      <div className="donut-wrap">
        <canvas ref={canvasRef} width="150" height="150"></canvas>
        <div className="donut-legend">
          {data.length === 0 && <p style={{ color: '#9ca3af', margin: 0 }}>Aucune donnée</p>}
          {data.map((item) => (
            <div key={item.name} className="donut-item">
              <div className="donut-dot" style={{ background: item.color }}></div>
              <span className="donut-label">{item.name}</span>
              <span className="donut-pct">{item.percentage}% ({item.value})</span>
            </div>
          ))}
        </div>
        <div className="donut-total">Total : <strong>{total}</strong></div>
      </div>
    </div>
  );
};

export default SourceDonut;
