import React, { useState } from 'react';
import { Download, FileSpreadsheet, FileJson, FileText, FileImage } from 'lucide-react';
import { useExport } from '../../hooks/useExport';

const ExportButton = ({ data, filename, title, filters, columns }) => {
  const [showMenu, setShowMenu] = useState(false);
  const { isExporting, exportToExcel, exportToCSV, exportToJSON, exportToPDF } = useExport();

  const handleExport = async (format) => {
    let success = false;
    switch(format) {
      case 'excel':
        success = exportToExcel(data, filename, title, filters);
        break;
      case 'csv':
        success = exportToCSV(data, filename, title, filters);
        break;
      case 'json':
        success = exportToJSON(data, filename, title, filters);
        break;
      case 'pdf':
        success = await exportToPDF(data, filename, title, filters, columns);
        break;
      default:
        success = exportToExcel(data, filename, title, filters);
    }
    setShowMenu(false);
  };

  if (!data || data.length === 0) return null;

  return (
    <div className="export-dropdown">
      <button className="btn-outline" onClick={() => setShowMenu(!showMenu)} disabled={isExporting}>
        <Download size={18} />
        {isExporting ? 'Export...' : 'Exporter'}
      </button>
      {showMenu && (
        <div className="export-menu">
          <button onClick={() => handleExport('excel')}><FileSpreadsheet size={16} /> Excel (.xlsx)</button>
          <button onClick={() => handleExport('csv')}><FileText size={16} /> CSV (.csv)</button>
          <button onClick={() => handleExport('json')}><FileJson size={16} /> JSON (.json)</button>
          <button onClick={() => handleExport('pdf')}><FileImage size={16} /> PDF</button>
        </div>
      )}
    </div>
  );
};

export default ExportButton;
