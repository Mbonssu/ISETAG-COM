import React from 'react';

const ExportHeader = ({ 
  title, 
  subtitle = '', 
  logo = null,
  filters = {},
  dateRange = null,
  generatedBy = 'Administrateur'
}) => {
  const currentDate = new Date().toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });
  const currentTime = new Date().toLocaleTimeString('fr-FR');

  const headerStyle = `
    <div style="
      text-align: center;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 3px solid #f5c842;
      position: relative;
    ">
      ${logo ? `<div style="position: absolute; left: 0; top: 0;">${logo}</div>` : ''}
      <h1 style="
        color: #1a5c2a;
        font-size: 24px;
        margin: 0 0 5px 0;
        font-family: 'Syne', 'Arial', sans-serif;
      ">${title}</h1>
      ${subtitle ? `<p style="color: #666; margin: 0 0 10px 0; font-size: 14px;">${subtitle}</p>` : ''}
      <div style="
        display: flex;
        justify-content: center;
        gap: 20px;
        font-size: 11px;
        color: #888;
        margin-top: 10px;
      ">
        <span>📅 Date : ${currentDate}</span>
        <span>⏰ Heure : ${currentTime}</span>
        <span>👤 Généré par : ${generatedBy}</span>
      </div>
      ${Object.keys(filters).length > 0 ? `
        <div style="
          margin-top: 10px;
          padding: 8px;
          background: #f5f5f5;
          border-radius: 5px;
          font-size: 11px;
          color: #555;
        ">
          <strong>Filtres appliqués :</strong>
          ${Object.entries(filters).map(([key, value]) => `<span style="margin-left: 10px;">${key}: ${value}</span>`).join('')}
        </div>
      ` : ''}
      ${dateRange ? `
        <div style="margin-top: 8px; font-size: 11px; color: #888;">
          📊 Période : ${dateRange}
        </div>
      ` : ''}
    </div>
  `;

  return headerStyle;
};

export const getExportHeaderHTML = (options) => {
  const header = ExportHeader(options);
  return header;
};

export const addHeaderToExportData = (data, options) => {
  return {
    header: ExportHeader(options),
    data: data,
    generatedAt: new Date().toISOString()
  };
};

export default ExportHeader;
