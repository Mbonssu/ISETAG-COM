import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';
import { getExportHeaderHTML } from '../components/ExportHeader/ExportHeader';

// Export vers Excel avec en-tête
export const exportToExcel = (data, filename, sheetName = 'Sheet1', headerOptions = {}) => {
  try {
    console.log('exportToExcel called with:', { filename, dataLength: data.length });
    
    const ws = XLSX.utils.json_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, sheetName);
    
    // Ajouter une feuille d'informations
    const infoSheet = XLSX.utils.aoa_to_sheet([
      ['INFORMATIONS DU DOCUMENT'],
      ['Titre', headerOptions.title || filename],
      ['Date de génération', new Date().toLocaleDateString('fr-FR')],
      ['Heure', new Date().toLocaleTimeString('fr-FR')],
      ['Généré par', headerOptions.generatedBy || 'Administrateur'],
      ['Filtres', Object.entries(headerOptions.filters || {}).map(([k,v]) => `${k}: ${v}`).join(', ') || 'Aucun']
    ]);
    XLSX.utils.book_append_sheet(wb, infoSheet, 'Informations');
    
    const excelBuffer = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
    const blob = new Blob([excelBuffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
    saveAs(blob, `${filename}.xlsx`);
    return true;
  } catch (error) {
    console.error('Erreur export Excel:', error);
    return false;
  }
};

// Export vers CSV avec en-tête
export const exportToCSV = (data, filename, headerOptions = {}) => {
  try {
    console.log('exportToCSV called with:', { filename, dataLength: data.length });
    
    const ws = XLSX.utils.json_to_sheet(data);
    const csvBuffer = XLSX.write(ws, { bookType: 'csv', type: 'array' });
    const decoder = new TextDecoder();
    let csvContent = decoder.decode(csvBuffer);
    
    const headerRows = [
      `# ${headerOptions.title || filename}`,
      `# Généré le: ${new Date().toLocaleDateString('fr-FR')} à ${new Date().toLocaleTimeString('fr-FR')}`,
      `# Par: ${headerOptions.generatedBy || 'Administrateur'}`,
      '# ----------------------------------------',
      ''
    ];
    csvContent = headerRows.join('\n') + csvContent;
    
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    saveAs(blob, `${filename}.csv`);
    return true;
  } catch (error) {
    console.error('Erreur export CSV:', error);
    return false;
  }
};

// Export vers JSON avec en-tête
export const exportToJSON = (data, filename, headerOptions = {}) => {
  try {
    console.log('exportToJSON called with:', { filename, dataLength: data.length });
    
    const exportObject = {
      metadata: {
        title: headerOptions.title || filename,
        generatedAt: new Date().toISOString(),
        generatedBy: headerOptions.generatedBy || 'Administrateur',
        filters: headerOptions.filters || {},
        totalRecords: data.length
      },
      data: data
    };
    const jsonStr = JSON.stringify(exportObject, null, 2);
    const blob = new Blob([jsonStr], { type: 'application/json' });
    saveAs(blob, `${filename}.json`);
    return true;
  } catch (error) {
    console.error('Erreur export JSON:', error);
    return false;
  }
};

// Export vers PDF stylisé avec en-tête
export const exportToStyledPDF = async (data, title, columns, filename, headerOptions = {}) => {
  try {
    console.log('exportToStyledPDF called with:', { title, filename, dataLength: data.length });
    
    // Créer un élément temporaire pour le rendu
    const tempDiv = document.createElement('div');
    tempDiv.style.position = 'absolute';
    tempDiv.style.left = '-9999px';
    tempDiv.style.top = '-9999px';
    tempDiv.style.width = '800px';
    tempDiv.style.backgroundColor = 'white';
    tempDiv.style.padding = '20px';
    tempDiv.style.fontFamily = 'Arial, sans-serif';
    
    // Générer l'en-tête HTML
    const headerHTML = getExportHeaderHTML({
      title: title,
      subtitle: headerOptions.subtitle || '',
      filters: headerOptions.filters || {},
      dateRange: headerOptions.dateRange || null,
      generatedBy: headerOptions.generatedBy || 'Administrateur'
    });
    
    tempDiv.innerHTML = `
      ${headerHTML}
      <div style="border: 1px solid #ddd; border-radius: 10px; overflow: hidden; margin-top: 20px;">
        <table style="width: 100%; border-collapse: collapse; font-size: 12px;">
          <thead>
            <tr style="background: linear-gradient(135deg, #1a5c2a, #2d7a3a); color: white;">
              ${columns.map(col => `<th style="padding: 12px; text-align: left; border-bottom: 2px solid #f5c842;">${col.label}</th>`).join('')}
            </tr>
          </thead>
          <tbody>
            ${data.map(row => `
              <tr style="border-bottom: 1px solid #eee;">
                ${columns.map(col => `<td style="padding: 10px; color: #333;">${row[col.key] || ''}</td>`).join('')}
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
      <div style="text-align: center; margin-top: 20px; padding-top: 10px; border-top: 2px solid #f5c842;">
        <p style="color: #999; font-size: 10px;">ISETAG-COM - Système de gestion des prospects</p>
        <p style="color: #999; font-size: 10px;">Total: ${data.length} enregistrement(s)</p>
      </div>
    `;
    
    document.body.appendChild(tempDiv);
    
    const html2canvasModule = await import('html2canvas');
    const html2canvas = html2canvasModule.default;
    const jsPDFModule = await import('jspdf');
    const jsPDF = jsPDFModule.default;
    
    const canvas = await html2canvas(tempDiv, {
      scale: 2,
      backgroundColor: '#ffffff',
      logging: false
    });
    
    const imgData = canvas.toDataURL('image/png');
    const pdf = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4'
    });
    
    const imgWidth = 210;
    const imgHeight = (canvas.height * imgWidth) / canvas.width;
    
    pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
    pdf.save(`${filename}.pdf`);
    
    document.body.removeChild(tempDiv);
    return true;
  } catch (error) {
    console.error('Erreur export PDF:', error);
    return false;
  }
};

// Export du tableau visible actuel
export const exportCurrentView = (data, filename, format = 'excel', headerOptions = {}) => {
  switch(format) {
    case 'excel':
      return exportToExcel(data, filename, 'Sheet1', headerOptions);
    case 'csv':
      return exportToCSV(data, filename, headerOptions);
    case 'json':
      return exportToJSON(data, filename, headerOptions);
    default:
      return exportToExcel(data, filename, 'Sheet1', headerOptions);
  }
};
