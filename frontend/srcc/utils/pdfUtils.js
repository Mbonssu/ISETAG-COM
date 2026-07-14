import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

// Fonction pour exporter une page en PDF stylisé
export const exportToStyledPDF = async (elementId, title, subtitle = '') => {
  const element = document.getElementById(elementId);
  if (!element) {
    console.error('Élément non trouvé');
    return;
  }

  // Afficher un indicateur de chargement
  const loadingToast = document.createElement('div');
  loadingToast.className = 'pdf-loading';
  loadingToast.innerHTML = '📄 Génération du PDF en cours...';
  document.body.appendChild(loadingToast);

  try {
    // Capturer l'élément
    const canvas = await html2canvas(element, {
      scale: 2,
      backgroundColor: '#ffffff',
      logging: false,
      useCORS: true
    });
    
    const imgData = canvas.toDataURL('image/png');
    const pdf = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4'
    });
    
    const imgWidth = 210; // A4 width in mm
    const pageHeight = 297; // A4 height in mm
    const imgHeight = (canvas.height * imgWidth) / canvas.width;
    let heightLeft = imgHeight;
    let position = 0;
    
    // Ajouter l'en-tête stylisé
    pdf.setFillColor(26, 92, 42);
    pdf.rect(0, 0, 210, 40, 'F');
    
    pdf.setTextColor(255, 255, 255);
    pdf.setFontSize(22);
    pdf.setFont('helvetica', 'bold');
    pdf.text(title, 20, 20);
    
    pdf.setFontSize(11);
    pdf.setFont('helvetica', 'normal');
    pdf.text(subtitle || `Généré le ${new Date().toLocaleDateString('fr-FR')}`, 20, 32);
    
    // Logo ou icône
    pdf.setFillColor(245, 200, 66);
    pdf.circle(190, 20, 8, 'F');
    pdf.setTextColor(26, 92, 42);
    pdf.setFontSize(14);
    pdf.setFont('helvetica', 'bold');
    pdf.text('IS', 186, 24);
    
    // Ajouter le contenu
    pdf.addImage(imgData, 'PNG', 0, 40, imgWidth, imgHeight);
    heightLeft -= pageHeight - 40;
    
    // Ajouter des pages supplémentaires si nécessaire
    while (heightLeft > 0) {
      position = heightLeft - imgHeight;
      pdf.addPage();
      pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
      heightLeft -= pageHeight;
    }
    
    // Ajouter un pied de page stylisé
    const pageCount = pdf.internal.getNumberOfPages();
    for (let i = 1; i <= pageCount; i++) {
      pdf.setPage(i);
      pdf.setFillColor(245, 200, 66);
      pdf.rect(0, 287, 210, 10, 'F');
      pdf.setTextColor(26, 92, 42);
      pdf.setFontSize(9);
      pdf.text('ISETAG-COM - Tableau de bord', 20, 292);
      pdf.text(`Page ${i} sur ${pageCount}`, 170, 292);
    }
    
    pdf.save(`${title.toLowerCase().replace(/ /g, '_')}.pdf`);
    
    // Retirer l'indicateur de chargement
    loadingToast.remove();
    
    return true;
  } catch (error) {
    console.error('Erreur lors de la génération du PDF:', error);
    loadingToast.remove();
    return false;
  }
};

// Fonction pour exporter un tableau en PDF stylisé
export const exportTableToStyledPDF = async (tableData, columns, title, filename) => {
  // Créer un élément temporaire pour le rendu
  const tempDiv = document.createElement('div');
  tempDiv.style.position = 'absolute';
  tempDiv.style.left = '-9999px';
  tempDiv.style.top = '-9999px';
  tempDiv.style.width = '800px';
  tempDiv.style.backgroundColor = 'white';
  tempDiv.style.padding = '20px';
  tempDiv.style.fontFamily = 'Arial, sans-serif';
  
  // Style du tableau
  tempDiv.innerHTML = `
    <div style="text-align: center; margin-bottom: 20px;">
      <h1 style="color: #1a5c2a; font-size: 24px; margin-bottom: 5px;">${title}</h1>
      <p style="color: #666; font-size: 12px;">Généré le ${new Date().toLocaleDateString('fr-FR')} à ${new Date().toLocaleTimeString('fr-FR')}</p>
    </div>
    <div style="border: 1px solid #ddd; border-radius: 10px; overflow: hidden;">
      <table style="width: 100%; border-collapse: collapse; font-size: 12px;">
        <thead>
          <tr style="background: linear-gradient(135deg, #1a5c2a, #2d7a3a); color: white;">
            ${columns.map(col => `<th style="padding: 12px; text-align: left; border-bottom: 2px solid #f5c842;">${col.label}</th>`).join('')}
          </tr>
        </thead>
        <tbody>
          ${tableData.map(row => `
            <tr style="border-bottom: 1px solid #eee;">
              ${columns.map(col => `<td style="padding: 10px; color: #333;">${row[col.key] || ''}</td>`).join('')}
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
    <div style="text-align: center; margin-top: 20px; padding-top: 10px; border-top: 2px solid #f5c842;">
      <p style="color: #999; font-size: 10px;">ISETAG-COM - Système de gestion des prospects</p>
      <p style="color: #999; font-size: 10px;">Total: ${tableData.length} enregistrement(s)</p>
    </div>
  `;
  
  document.body.appendChild(tempDiv);
  
  try {
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
    console.error('Erreur:', error);
    document.body.removeChild(tempDiv);
    return false;
  }
};
