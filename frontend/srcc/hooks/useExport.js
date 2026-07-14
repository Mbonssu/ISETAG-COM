import { useState } from 'react';
import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

export const useExport = () => {
  const [isExporting, setIsExporting] = useState(false);

  const getExportHeader = (title, filters = {}, totalRecords = 0) => {
    const currentDate = new Date();
    const formattedDate = currentDate.toLocaleDateString('fr-FR');
    const formattedTime = currentDate.toLocaleTimeString('fr-FR');
    
    return {
      title: title,
      organization: 'ISETAG-COM',
      generatedAt: `${formattedDate} à ${formattedTime}`,
      generatedBy: 'Administrateur',
      filters: filters,
      totalRecords: totalRecords
    };
  };

  const exportToExcel = (data, filename, title, filters) => {
    setIsExporting(true);
    try {
      const header = getExportHeader(title, filters, data.length);
      
      const headerData = [
        [header.organization],
        [header.title],
        [`Généré le: ${header.generatedAt}`],
        [`Généré par: ${header.generatedBy}`],
        ...Object.entries(header.filters).map(([key, value]) => [`${key}: ${value}`]),
        [`Total: ${header.totalRecords} enregistrement(s)`],
        [],
        Object.keys(data[0] || {})
      ];
      
      const dataRows = data.map(item => Object.values(item));
      const wsData = [...headerData, ...dataRows];
      const ws = XLSX.utils.aoa_to_sheet(wsData);
      
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, 'Data');
      
      const excelBuffer = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
      const blob = new Blob([excelBuffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
      saveAs(blob, `${filename}_${new Date().toISOString().slice(0, 19).replace(/:/g, '-')}.xlsx`);
      
      return true;
    } catch (error) {
      console.error('Erreur Excel:', error);
      return false;
    } finally {
      setIsExporting(false);
    }
  };

  const exportToCSV = (data, filename, title, filters) => {
    setIsExporting(true);
    try {
      const header = getExportHeader(title, filters, data.length);
      
      const headerRows = [
        `# ${header.organization}`,
        `# ${header.title}`,
        `# Généré le: ${header.generatedAt}`,
        `# Généré par: ${header.generatedBy}`,
        ...Object.entries(header.filters).map(([key, value]) => `# ${key}: ${value}`),
        `# Total: ${header.totalRecords} enregistrement(s)`,
        '# ----------------------------------------',
        Object.keys(data[0] || {}).join(',')
      ];
      
      const dataRows = data.map(item => Object.values(item).map(v => `"${v}"`).join(','));
      const csvContent = headerRows.join('\n') + '\n' + dataRows.join('\n');
      
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
      saveAs(blob, `${filename}_${new Date().toISOString().slice(0, 19).replace(/:/g, '-')}.csv`);
      
      return true;
    } catch (error) {
      console.error('Erreur CSV:', error);
      return false;
    } finally {
      setIsExporting(false);
    }
  };

  const exportToJSON = (data, filename, title, filters) => {
    setIsExporting(true);
    try {
      const header = getExportHeader(title, filters, data.length);
      
      const exportData = {
        metadata: {
          organization: header.organization,
          title: header.title,
          generatedAt: new Date().toISOString(),
          generatedBy: header.generatedBy,
          filters: header.filters,
          totalRecords: header.totalRecords
        },
        data: data
      };
      
      const jsonStr = JSON.stringify(exportData, null, 2);
      const blob = new Blob([jsonStr], { type: 'application/json' });
      saveAs(blob, `${filename}_${new Date().toISOString().slice(0, 19).replace(/:/g, '-')}.json`);
      
      return true;
    } catch (error) {
      console.error('Erreur JSON:', error);
      return false;
    } finally {
      setIsExporting(false);
    }
  };

  const exportToPDF = async (data, filename, title, filters, columns) => {
    setIsExporting(true);
    try {
      const header = getExportHeader(title, filters, data.length);
      
      const pdfContent = document.createElement('div');
      pdfContent.style.width = '800px';
      pdfContent.style.padding = '20px';
      pdfContent.style.backgroundColor = 'white';
      pdfContent.style.fontFamily = 'Arial, sans-serif';
      
      let tableRows = '';
      data.forEach(item => {
        tableRows += '<tr style="border-bottom: 1px solid #ddd;">';
        columns.forEach(col => {
          tableRows += `<td style="padding: 8px;">${item[col.key] || ''}</tr>`;
        });
        tableRows += '</tr>';
      });
      
      pdfContent.innerHTML = `
        <div style="text-align: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 3px solid #f5c842;">
          <h2 style="color: #1a5c2a; margin: 0;">${header.organization}</h2>
          <h1 style="color: #1a5c2a; margin: 5px 0;">${header.title}</h1>
          <p style="color: #666; margin: 5px 0;">Généré le: ${header.generatedAt}</p>
          <p style="color: #666;">Généré par: ${header.generatedBy}</p>
          <p style="color: #666;">${Object.entries(header.filters).map(([k,v]) => `${k}: ${v}`).join(' | ')}</p>
          <p style="color: #666;">Total: ${header.totalRecords} enregistrement(s)</p>
        </div>
        <table style="width: 100%; border-collapse: collapse;">
          <thead>
            <tr style="background: #1a5c2a; color: white;">
              ${columns.map(col => `<th style="padding: 10px; text-align: left;">${col.label}</th>`).join('')}
            </tr>
          </thead>
          <tbody>${tableRows}</tbody>
        </table>
        <div style="text-align: center; margin-top: 20px; padding-top: 10px; border-top: 2px solid #f5c842;">
          <p style="color: #999; font-size: 10px;">${header.organization} - Système de gestion</p>
        </div>
      `;
      
      document.body.appendChild(pdfContent);
      
      const canvas = await html2canvas(pdfContent, { scale: 2, backgroundColor: '#ffffff', logging: false });
      const imgData = canvas.toDataURL('image/png');
      const pdf = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });
      
      const imgWidth = 210;
      const imgHeight = (canvas.height * imgWidth) / canvas.width;
      
      pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
      pdf.save(`${filename}_${new Date().toISOString().slice(0, 19).replace(/:/g, '-')}.pdf`);
      
      document.body.removeChild(pdfContent);
      return true;
    } catch (error) {
      console.error('Erreur PDF:', error);
      return false;
    } finally {
      setIsExporting(false);
    }
  };

  return { isExporting, exportToExcel, exportToCSV, exportToJSON, exportToPDF };
};
