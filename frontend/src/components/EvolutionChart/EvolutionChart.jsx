import React, { useEffect, useRef, useState } from 'react';
import './EvolutionChart.css';

// `data` vient de useDashboardStats() -> computeEvolution() (statsService.js)
// Forme attendue : { labels: string[], total: number[], relance: number[] }
const EvolutionChart = ({ data }) => {
  const canvasRef = useRef(null);
  const [tooltip, setTooltip] = useState({ visible: false, x: 0, y: 0, date: '', total: 0, relance: 0 });

  const labels = data?.labels?.length ? data.labels : [];
  const total = data?.total?.length ? data.total : [];
  const relance = data?.relance?.length ? data.relance : [];
  const hasData = labels.length > 0;

  useEffect(() => {
    if (!hasData) return undefined;

    const canvas = canvasRef.current;
    const wrapper = canvas.parentElement;

    // Échelle Y dynamique : arrondie au 100 supérieur au-dessus du max réel,
    // avec un plancher pour éviter un graphe illisible si les valeurs sont
    // toutes petites.
    const rawMax = Math.max(1, ...total, ...relance);
    const maxV = Math.max(100, Math.ceil(rawMax / 100) * 100 * 1.15);
    const steps = 5;
    const gridValues = Array.from({ length: steps + 1 }, (_, i) => Math.round((maxV / steps) * i));

    const draw = () => {
      canvas.width = wrapper.clientWidth;
      canvas.height = wrapper.clientHeight;
      const ctx = canvas.getContext('2d');
      const W = canvas.width, H = canvas.height;
      const padL = 40, padR = 16, padT = 10, padB = 30;
      const cW = W - padL - padR, cH = H - padT - padB;
      const xP = (i) => padL + (labels.length > 1 ? (i / (labels.length - 1)) * cW : cW / 2);
      const yP = (v) => padT + cH - (v / maxV) * cH;

      ctx.clearRect(0, 0, W, H);

      // Grid lines
      ctx.strokeStyle = 'rgba(200,230,210,0.5)';
      ctx.lineWidth = 1;
      ctx.fillStyle = '#9ca3af';
      ctx.font = '11px DM Sans, sans-serif';
      ctx.textAlign = 'right';
      gridValues.forEach((v) => {
        const y = yP(v);
        ctx.beginPath();
        ctx.moveTo(padL, y);
        ctx.lineTo(W - padR, y);
        ctx.stroke();
        ctx.fillText(v === 0 ? '0' : v >= 1000 ? (v / 1000).toFixed(1) + 'K' : String(v), padL - 4, y + 4);
      });

      // X-axis labels
      ctx.textAlign = 'center';
      labels.forEach((l, i) => ctx.fillText(l, xP(i), H - 6));

      const drawLine = (values, color, fillColor) => {
        if (values.length === 0) return;
        ctx.beginPath();
        ctx.moveTo(xP(0), yP(values[0]));
        for (let i = 1; i < values.length; i++) {
          const x0 = xP(i - 1), y0 = yP(values[i - 1]), x1 = xP(i), y1 = yP(values[i]);
          const cpx = (x0 + x1) / 2;
          ctx.bezierCurveTo(cpx, y0, cpx, y1, x1, y1);
        }
        ctx.strokeStyle = color;
        ctx.lineWidth = 2.5;
        ctx.stroke();
        ctx.lineTo(xP(values.length - 1), yP(0));
        ctx.lineTo(xP(0), yP(0));
        ctx.closePath();
        ctx.fillStyle = fillColor;
        ctx.fill();

        values.forEach((v, i) => {
          ctx.beginPath();
          ctx.arc(xP(i), yP(v), 4, 0, Math.PI * 2);
          ctx.fillStyle = color;
          ctx.fill();
          ctx.strokeStyle = 'rgba(255,255,255,0.8)';
          ctx.lineWidth = 2;
          ctx.stroke();
        });
      };

      drawLine(total, '#2d7a3a', 'rgba(45,122,58,0.10)');
      drawLine(relance, '#f5c842', 'rgba(245,200,66,0.12)');

      if (total.length) {
        const lastIdx = total.length - 1;
        ctx.beginPath();
        ctx.arc(xP(lastIdx), yP(total[lastIdx]), 6, 0, Math.PI * 2);
        ctx.fillStyle = '#2d7a3a';
        ctx.fill();
        ctx.strokeStyle = 'rgba(255,255,255,0.9)';
        ctx.lineWidth = 2.5;
        ctx.stroke();
      }
    };

    draw();

    const handleMouseMove = (e) => {
      const rect = canvas.getBoundingClientRect();
      const mouseX = e.clientX - rect.left;
      const width = rect.width;
      const padL = 40, padR = 16;
      const cW = width - padL - padR;

      for (let i = 0; i < labels.length; i++) {
        const xPos = padL + (labels.length > 1 ? (i / (labels.length - 1)) * cW : cW / 2);
        if (Math.abs(mouseX - xPos) < 30) {
          setTooltip({
            visible: true,
            x: e.clientX - rect.left + 15,
            y: e.clientY - rect.top - 40,
            date: labels[i],
            total: total[i] ?? 0,
            relance: relance[i] ?? 0,
          });
          return;
        }
      }
      setTooltip((t) => ({ ...t, visible: false }));
    };

    const handleMouseLeave = () => setTooltip((t) => ({ ...t, visible: false }));

    canvas.addEventListener('mousemove', handleMouseMove);
    canvas.addEventListener('mouseleave', handleMouseLeave);
    window.addEventListener('resize', draw);

    return () => {
      canvas.removeEventListener('mousemove', handleMouseMove);
      canvas.removeEventListener('mouseleave', handleMouseLeave);
      window.removeEventListener('resize', draw);
    };
  }, [hasData, labels, total, relance]);

  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Évolution des prospects</div>
      </div>
      <div className="chart-legend">
        <div className="legend-item">
          <div className="legend-dot" style={{ background: '#2d7a3a' }}></div>
          Total prospects
        </div>
        <div className="legend-item">
          <div className="legend-dot" style={{ background: '#f5c842' }}></div>
          Relances
        </div>
      </div>
      <div className="chart-wrap" style={{ position: 'relative' }}>
        {hasData ? (
          <canvas ref={canvasRef} style={{ cursor: 'crosshair' }}></canvas>
        ) : (
          <p style={{ padding: '1rem', color: '#9ca3af' }}>Pas encore de données à afficher.</p>
        )}
        {tooltip.visible && (
          <div className="chart-custom-tooltip" style={{ position: 'absolute', left: tooltip.x, top: tooltip.y }}>
            <div className="chart-tooltip-date">{tooltip.date}</div>
            <div className="chart-tooltip-row">
              <div className="chart-tooltip-dot" style={{ background: '#2d7a3a' }}></div>
              <span>Total prospects: <strong>{tooltip.total}</strong></span>
            </div>
            <div className="chart-tooltip-row">
              <div className="chart-tooltip-dot" style={{ background: '#f5c842' }}></div>
              <span>Relances: <strong>{tooltip.relance}</strong></span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default EvolutionChart;
