import React, { useEffect, useRef, useState } from 'react';
import './EvolutionChart.css';

const EvolutionChart = () => {
  const canvasRef = useRef(null);
  const [tooltip, setTooltip] = useState({ visible: false, x: 0, y: 0, date: '', total: 0, relance: 0 });
  const labels = ['19 Mai', '20 Mai', '21 Mai', '22 Mai', '23 Mai', '24 Mai', '25 Mai'];
  const total = [540, 680, 820, 960, 1050, 1140, 1248];
  const relance = [220, 295, 270, 300, 290, 285, 256];

  useEffect(() => {
    const canvas = canvasRef.current;
    const wrapper = canvas.parentElement;
    
    const draw = () => {
      canvas.width = wrapper.clientWidth;
      canvas.height = wrapper.clientHeight;
      const ctx = canvas.getContext('2d');
      const W = canvas.width, H = canvas.height;
      const padL = 40, padR = 16, padT = 10, padB = 30;
      const cW = W - padL - padR, cH = H - padT - padB;
      const maxV = 1500;
      const xP = (i) => padL + (i / (labels.length - 1)) * cW;
      const yP = (v) => padT + cH - (v / maxV) * cH;

      // Clear canvas
      ctx.clearRect(0, 0, W, H);
      
      // Grid lines
      ctx.strokeStyle = 'rgba(200,230,210,0.5)';
      ctx.lineWidth = 1;
      ctx.fillStyle = '#9ca3af';
      ctx.font = '11px DM Sans, sans-serif';
      ctx.textAlign = 'right';
      [0, 300, 600, 900, 1200, 1500].forEach(v => {
        const y = yP(v);
        ctx.beginPath();
        ctx.moveTo(padL, y);
        ctx.lineTo(W - padR, y);
        ctx.stroke();
        ctx.fillText(v === 0 ? '0' : v >= 1000 ? (v / 1000).toFixed(1) + 'K' : v, padL - 4, y + 4);
      });
      
      // X-axis labels
      ctx.textAlign = 'center';
      labels.forEach((l, i) => ctx.fillText(l, xP(i), H - 6));

      const drawLine = (data, color, fillColor) => {
        ctx.beginPath();
        ctx.moveTo(xP(0), yP(data[0]));
        for (let i = 1; i < data.length; i++) {
          const x0 = xP(i - 1), y0 = yP(data[i - 1]), x1 = xP(i), y1 = yP(data[i]);
          const cpx = (x0 + x1) / 2;
          ctx.bezierCurveTo(cpx, y0, cpx, y1, x1, y1);
        }
        ctx.strokeStyle = color;
        ctx.lineWidth = 2.5;
        ctx.stroke();
        ctx.lineTo(xP(data.length - 1), yP(0));
        ctx.lineTo(xP(0), yP(0));
        ctx.closePath();
        ctx.fillStyle = fillColor;
        ctx.fill();
        
        // Draw points
        data.forEach((v, i) => {
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
      
      // Highlight last point
      ctx.beginPath();
      ctx.arc(xP(6), yP(total[6]), 6, 0, Math.PI * 2);
      ctx.fillStyle = '#2d7a3a';
      ctx.fill();
      ctx.strokeStyle = 'rgba(255,255,255,0.9)';
      ctx.lineWidth = 2.5;
      ctx.stroke();
    };
    
    draw();
    
    // Mouse move handler for tooltip
    const handleMouseMove = (e) => {
      const rect = canvas.getBoundingClientRect();
      const mouseX = e.clientX - rect.left;
      const width = rect.width;
      const padL = 40, padR = 16;
      const cW = width - padL - padR;
      
      // Find closest data point
      for (let i = 0; i < labels.length; i++) {
        const xPos = padL + (i / (labels.length - 1)) * cW;
        if (Math.abs(mouseX - xPos) < 30) {
          setTooltip({
            visible: true,
            x: e.clientX - rect.left + 15,
            y: e.clientY - rect.top - 40,
            date: labels[i],
            total: total[i],
            relance: relance[i]
          });
          return;
        }
      }
      setTooltip({ ...tooltip, visible: false });
    };
    
    const handleMouseLeave = () => {
      setTooltip({ ...tooltip, visible: false });
    };
    
    canvas.addEventListener('mousemove', handleMouseMove);
    canvas.addEventListener('mouseleave', handleMouseLeave);
    window.addEventListener('resize', draw);
    
    return () => {
      canvas.removeEventListener('mousemove', handleMouseMove);
      canvas.removeEventListener('mouseleave', handleMouseLeave);
      window.removeEventListener('resize', draw);
    };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <div className="card">
      <div className="card-header">
        <div className="card-title">Évolution des prospects</div>
        <select className="period-select">
          <option>7 derniers jours</option>
          <option>30 derniers jours</option>
          <option>3 derniers mois</option>
        </select>
      </div>
      <div className="chart-legend">
        <div className="legend-item">
          <div className="legend-dot" style={{ background: '#2d7a3a' }}></div>
          Total prospects
        </div>
        <div className="legend-item">
          <div className="legend-dot" style={{ background: '#f5c842' }}></div>
          À relancer
        </div>
      </div>
      <div className="chart-wrap" style={{ position: 'relative' }}>
        <canvas ref={canvasRef} style={{ cursor: 'crosshair' }}></canvas>
        {tooltip.visible && (
          <div className="chart-custom-tooltip" style={{ position: 'absolute', left: tooltip.x, top: tooltip.y }}>
            <div className="chart-tooltip-date">{tooltip.date}</div>
            <div className="chart-tooltip-row">
              <div className="chart-tooltip-dot" style={{ background: '#2d7a3a' }}></div>
              <span>Total prospects: <strong>{tooltip.total}</strong></span>
            </div>
            <div className="chart-tooltip-row">
              <div className="chart-tooltip-dot" style={{ background: '#f5c842' }}></div>
              <span>À relancer: <strong>{tooltip.relance}</strong></span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default EvolutionChart;
