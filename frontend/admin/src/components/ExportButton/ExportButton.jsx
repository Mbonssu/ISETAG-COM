// import React, { useState, useRef, useEffect } from 'react';
// import { Download, FileSpreadsheet, FileText, FileJson, Loader } from 'lucide-react';
// import { useExport } from '../../hooks/useExport';
// import './ExportButton.css';

// /**
//  * Bouton d'export réutilisable (Excel / PDF / CSV), à placer dans
//  * n'importe quelle page de liste.
//  *
//  * Usage :
//  *   <ExportButton
//  *     data={filteredProspects}
//  *     filename="prospects"
//  *     title="Liste des prospects"
//  *     columns={[
//  *       { key: 'nomComplet', label: 'Nom complet' },
//  *       { key: 'telephone', label: 'Téléphone' },
//  *       { key: 'email', label: 'Email' },
//  *     ]}
//  *     filters={{ Recherche: searchTerm || 'Aucune' }}
//  *   />
//  *
//  * - `data` : le tableau d'objets à exporter (idéalement déjà filtré)
//  * - `columns` : définit l'ordre et les libellés des colonnes pour le PDF ;
//  *   pour Excel/CSV, seules les clés listées dans `columns` sont exportées
//  *   (évite d'exporter des champs internes/techniques par erreur)
//  */
// const ExportButton = ({ data = [], filename = 'export', title = 'Export', columns = [], filters = {} }) => {
//   const { isExporting, exportToExcel, exportToCSV, exportToPDF } = useExport();
//   const [open, setOpen] = useState(false);
//   const ref = useRef(null);

//   useEffect(() => {
//     const onClickOutside = (e) => {
//       if (ref.current && !ref.current.contains(e.target)) setOpen(false);
//     };
//     document.addEventListener('mousedown', onClickOutside);
//     return () => document.removeEventListener('mousedown', onClickOutside);
//   }, []);

//   // Ne garde que les colonnes définies, avec leurs libellés, pour Excel/CSV
//   const shapeData = () => {
//     if (!columns.length) return data;
//     return data.map((item) => {
//       const row = {};
//       columns.forEach((col) => { row[col.label] = item[col.key] ?? ''; });
//       return row;
//     });
//   };

//   const handleExport = async (type) => {
//     setOpen(false);
//     if (data.length === 0) return;
//     const shaped = shapeData();
//     if (type === 'excel') await exportToExcel(shaped, filename, title, filters);
//     if (type === 'csv') await exportToCSV(shaped, filename, title, filters);
//     if (type === 'pdf') await exportToPDF(data, filename, title, filters, columns);
//   };

//   return (
//     <div className="export-btn-wrap" ref={ref}>
//       <button className="btn-outline" onClick={() => setOpen((v) => !v)} disabled={isExporting || data.length === 0}>
//         {isExporting ? <Loader size={16} className="spin" /> : <Download size={16} />}
//         {isExporting ? 'Export en cours…' : 'Exporter'}
//       </button>
//       {open && (
//         <div className="export-dropdown">
//           <button onClick={() => handleExport('excel')}><FileSpreadsheet size={15} /> Excel (.xlsx)</button>
//           <button onClick={() => handleExport('pdf')}><FileText size={15} /> PDF</button>
//           <button onClick={() => handleExport('csv')}><FileJson size={15} /> CSV</button>
//         </div>
//       )}
//     </div>
//   );
// };

// export default ExportButton;

import React, { useState, useRef, useEffect } from 'react';
import { Download, FileSpreadsheet, FileText, FileJson, Loader } from 'lucide-react';
import { useExport } from '../../hooks/useExport';
import './ExportButton.css';

/**
 * Bouton d'export réutilisable (Excel / PDF / CSV), à placer dans
 * n'importe quelle page de liste.
 *
 * Usage :
 *   <ExportButton
 *     data={filteredProspects}
 *     filename="prospects"
 *     title="Liste des prospects"
 *     columns={[
 *       { key: 'nomComplet', label: 'Nom complet' },
 *       { key: 'telephone', label: 'Téléphone' },
 *       { key: 'email', label: 'Email' },
 *     ]}
 *     filters={{ Recherche: searchTerm || 'Aucune' }}
 *   />
 *
 * - `data` : le tableau d'objets à exporter (idéalement déjà filtré)
 * - `columns` : définit l'ordre et les libellés des colonnes pour le PDF ;
 *   pour Excel/CSV, seules les clés listées dans `columns` sont exportées
 *   (évite d'exporter des champs internes/techniques par erreur)
 */
const ExportButton = ({ data = [], filename = 'export', title = 'Export', columns = [], filters = {} }) => {
  const { isExporting, exportToExcel, exportToCSV, exportToPDF } = useExport();
  const [open, setOpen] = useState(false);
  const ref = useRef(null);

  useEffect(() => {
    const onClickOutside = (e) => {
      if (ref.current && !ref.current.contains(e.target)) setOpen(false);
    };
    document.addEventListener('mousedown', onClickOutside);
    return () => document.removeEventListener('mousedown', onClickOutside);
  }, []);

  // Ne garde que les colonnes définies, avec leurs libellés, pour Excel/CSV
  const shapeData = () => {
    if (!columns.length) return data;
    return data.map((item) => {
      const row = {};
      columns.forEach((col) => { row[col.label] = item[col.key] ?? ''; });
      return row;
    });
  };

  const handleExport = async (type) => {
    setOpen(false);
    if (data.length === 0) return;
    const shaped = shapeData();
    if (type === 'excel') await exportToExcel(shaped, filename, title, filters);
    if (type === 'csv') await exportToCSV(shaped, filename, title, filters);
    if (type === 'pdf') await exportToPDF(data, filename, title, filters, columns);
  };

  return (
    <div className="exportbtn-wrap" ref={ref}>
      <button className="btn-outline" onClick={() => setOpen((v) => !v)} disabled={isExporting || data.length === 0}>
        {isExporting ? <Loader size={16} className="spin" /> : <Download size={16} />}
        {isExporting ? 'Export en cours…' : 'Exporter'}
      </button>
      {open && (
        <div className="exportbtn-menu">
          <button onClick={() => handleExport('excel')}><FileSpreadsheet size={15} /> Excel (.xlsx)</button>
          <button onClick={() => handleExport('pdf')}><FileText size={15} /> PDF</button>
          <button onClick={() => handleExport('csv')}><FileJson size={15} /> CSV</button>
        </div>
      )}
    </div>
  );
};

export default ExportButton;