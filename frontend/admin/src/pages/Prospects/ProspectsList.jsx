import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  Plus,
  Search,
  Edit,
  Trash2,
  Eye,
  Filter,
  Download,
  ChevronLeft,
  ChevronRight,
  AlertCircle,
  FileSpreadsheet,
  FileJson,
  FileText,
  FileImage,
} from "lucide-react";
import Modal from "../../components/common/Modal";
import { ToastContainer } from "../../components/common/Toast";
import { useTranslation } from "../../hooks/useTranslation";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import jsPDF from "jspdf";
import html2canvas from "html2canvas";
import "./Prospects.css";

const ProspectsList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState("");
  const [filterSexe, setFilterSexe] = useState("all");
  const [filterType, setFilterType] = useState("all");
  const [currentPage, setCurrentPage] = useState(1);
  const [showExportMenu, setShowExportMenu] = useState(false);
  const [isExporting, setIsExporting] = useState(false);
  const [deleteModal, setDeleteModal] = useState({
    isOpen: false,
    prospectId: null,
    prospectName: "",
  });
  const [toasts, setToasts] = useState([]);
  const itemsPerPage = 5;

  const addToast = (message, type = "success") => {
    const id = Date.now();
    setToasts((prev) => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  };

  // Données mockées selon le nouveau diagramme
  const prospects = [
    {
      id: "P001",
      nomComplet: "Marie Laure",
      telephone: "691234567",
      email: "marie@email.com",
      niveauEtude: "Terminale",
      concerne: "Lycée de Biyem-Assi",
      adresse: "Biyem-Assi, Yaoundé",
      sexe: "F",
      typeProspect: "Etudiant",
      createdAt: "25 Mai 2025",
    },
    {
      id: "P002",
      nomComplet: "David Paul",
      telephone: "692345678",
      email: "david@email.com",
      niveauEtude: "Bac+1",
      concerne: "Université de Douala",
      adresse: "Logbessou, Douala",
      sexe: "M",
      typeProspect: "Etudiant",
      createdAt: "24 Mai 2025",
    },
    {
      id: "P003",
      nomComplet: "Anne Sophie",
      telephone: "693456789",
      email: "anne@email.com",
      niveauEtude: "Bac+2",
      concerne: "Institut Supérieur",
      adresse: "Bonamoussadi, Douala",
      sexe: "F",
      typeProspect: "Parent",
      createdAt: "23 Mai 2025",
    },
  ];

  const niveauxEtude = [
    "Terminale",
    "Bac+1",
    "Bac+2",
    "Bac+3",
    "Master",
    "Doctorat",
  ];
  const typesProspect = ["Etudiant", "Parent", "Professionnel", "Autre"];
  const sexes = ["M", "F"];

  const filteredProspects = prospects.filter((prospect) => {
    const matchesSearch =
      prospect.nomComplet.toLowerCase().includes(searchTerm.toLowerCase()) ||
      prospect.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      prospect.telephone.includes(searchTerm);
    const matchesSexe = filterSexe === "all" || prospect.sexe === filterSexe;
    const matchesType =
      filterType === "all" || prospect.typeProspect === filterType;
    return matchesSearch && matchesSexe && matchesType;
  });

  const totalPages = Math.ceil(filteredProspects.length / itemsPerPage);
  const paginatedProspects = filteredProspects.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage,
  );

  const getSexeLabel = (sexe) => {
    return sexe === "M" ? "Masculin" : "Féminin";
  };

  const handleDelete = () => {
    addToast(
      `${deleteModal.prospectName} ${t("suppressionReussie")}`,
      "success",
    );
    setDeleteModal({ isOpen: false, prospectId: null, prospectName: "" });
  };

  const getExportHeader = (title) => {
    const currentDate = new Date();
    const formattedDate = currentDate.toLocaleDateString("fr-FR");
    const formattedTime = currentDate.toLocaleTimeString("fr-FR");

    return {
      title: title,
      organization: "ISETAG-COM",
      generatedAt: `${formattedDate} à ${formattedTime}`,
      generatedBy: "Administrateur",
      filters: {
        [t("sexe")]: filterSexe !== "all" ? getSexeLabel(filterSexe) : "Tous",
        [t("typeProspect")]: filterType !== "all" ? filterType : "Tous",
        [t("rechercher")]: searchTerm || "Aucune",
      },
      totalRecords: filteredProspects.length,
    };
  };

  const exportToExcel = () => {
    setIsExporting(true);
    try {
      const header = getExportHeader(t("gestionProspects"));

      const headerData = [
        [header.organization],
        [header.title],
        [`Généré le: ${header.generatedAt}`],
        [`Généré par: ${header.generatedBy}`],
        [`${t("sexe")}: ${header.filters[t("sexe")]}`],
        [`${t("typeProspect")}: ${header.filters[t("typeProspect")]}`],
        [`${t("rechercher")}: ${header.filters[t("rechercher")]}`],
        [`Total: ${header.totalRecords} enregistrement(s)`],
        [],
        [
          "ID",
          t("nomComplet"),
          t("telephone"),
          t("email"),
          t("niveauEtude"),
          t("etablissement"),
          t("adresse"),
          t("sexe"),
          t("typeProspect"),
          t("dateCreation"),
        ],
      ];

      const dataRows = filteredProspects.map((p) => [
        p.id,
        p.nomComplet,
        p.telephone,
        p.email,
        p.niveauEtude,
        p.concerne,
        p.adresse,
        p.sexe,
        p.typeProspect,
        p.createdAt,
      ]);

      const wsData = [...headerData, ...dataRows];
      const ws = XLSX.utils.aoa_to_sheet(wsData);
      ws["!cols"] = [
        { wch: 10 },
        { wch: 20 },
        { wch: 15 },
        { wch: 25 },
        { wch: 15 },
        { wch: 25 },
        { wch: 25 },
        { wch: 10 },
        { wch: 15 },
        { wch: 15 },
      ];

      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Prospects");

      const excelBuffer = XLSX.write(wb, { bookType: "xlsx", type: "array" });
      const blob = new Blob([excelBuffer], {
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      });
      saveAs(
        blob,
        `prospects_export_${new Date().toISOString().slice(0, 19).replace(/:/g, "-")}.xlsx`,
      );

      addToast(t("exportReussi"), "success");
    } catch (error) {
      addToast(t("exportErreur"), "error");
    } finally {
      setIsExporting(false);
      setShowExportMenu(false);
    }
  };

  const exportToCSV = () => {
    setIsExporting(true);
    try {
      const header = getExportHeader(t("gestionProspects"));

      const headerRows = [
        `# ${header.organization}`,
        `# ${header.title}`,
        `# Généré le: ${header.generatedAt}`,
        `# Généré par: ${header.generatedBy}`,
        `# ${t("sexe")}: ${header.filters[t("sexe")]}`,
        `# ${t("typeProspect")}: ${header.filters[t("typeProspect")]}`,
        `# ${t("rechercher")}: ${header.filters[t("rechercher")]}`,
        `# Total: ${header.totalRecords} enregistrement(s)`,
        "# ----------------------------------------",
        "ID,Nom complet,Téléphone,Email,Niveau étude,Établissement,Adresse,Sexe,Type prospect,Date création",
      ];

      const dataRows = filteredProspects.map(
        (p) =>
          `"${p.id}","${p.nomComplet}","${p.telephone}","${p.email}","${p.niveauEtude}","${p.concerne}","${p.adresse}","${p.sexe}","${p.typeProspect}","${p.createdAt}"`,
      );

      const csvContent = headerRows.join("\n") + "\n" + dataRows.join("\n");

      const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
      saveAs(
        blob,
        `prospects_export_${new Date().toISOString().slice(0, 19).replace(/:/g, "-")}.csv`,
      );

      addToast(t("exportReussi"), "success");
    } catch (error) {
      addToast(t("exportErreur"), "error");
    } finally {
      setIsExporting(false);
      setShowExportMenu(false);
    }
  };

  const exportToJSON = () => {
    setIsExporting(true);
    try {
      const header = getExportHeader(t("gestionProspects"));

      const exportData = {
        metadata: {
          organization: header.organization,
          title: header.title,
          generatedAt: new Date().toISOString(),
          generatedBy: header.generatedBy,
          filters: header.filters,
          totalRecords: header.totalRecords,
        },
        data: filteredProspects.map((p) => ({
          id: p.id,
          nomComplet: p.nomComplet,
          telephone: p.telephone,
          email: p.email,
          niveauEtude: p.niveauEtude,
          etablissement: p.concerne,
          adresse: p.adresse,
          sexe: p.sexe,
          typeProspect: p.typeProspect,
          createdAt: p.createdAt,
        })),
      };

      const jsonStr = JSON.stringify(exportData, null, 2);
      const blob = new Blob([jsonStr], { type: "application/json" });
      saveAs(
        blob,
        `prospects_export_${new Date().toISOString().slice(0, 19).replace(/:/g, "-")}.json`,
      );

      addToast(t("exportReussi"), "success");
    } catch (error) {
      addToast(t("exportErreur"), "error");
    } finally {
      setIsExporting(false);
      setShowExportMenu(false);
    }
  };

  const exportToPDF = async () => {
    setIsExporting(true);
    addToast(t("chargement"), "info");

    try {
      const header = getExportHeader(t("gestionProspects"));

      const pdfContent = document.createElement("div");
      pdfContent.style.width = "800px";
      pdfContent.style.padding = "20px";
      pdfContent.style.backgroundColor = "white";
      pdfContent.style.fontFamily = "Arial, sans-serif";

      let tableRows = "";
      filteredProspects.forEach((p) => {
        tableRows += `
          <tr style="border-bottom: 1px solid #ddd;">
            <td style="padding: 8px;">${p.id}</td>
            <td style="padding: 8px;">${p.nomComplet}</td>
            <td style="padding: 8px;">${p.telephone}</td>
            <td style="padding: 8px;">${p.email}</td>
            <td style="padding: 8px;">${p.niveauEtude}</td>
            <td style="padding: 8px;">${p.concerne}</td>
            <td style="padding: 8px;">${p.sexe === "M" ? "Masculin" : "Féminin"}</td>
            <td style="padding: 8px;">${p.typeProspect}</td>
            <td style="padding: 8px;">${p.createdAt}</td>
          </tr>
        `;
      });

      pdfContent.innerHTML = `
        <div style="text-align: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 3px solid #f5c842;">
          <h2 style="color: #1a5c2a; margin: 0;">${header.organization}</h2>
          <h1 style="color: #1a5c2a; margin: 5px 0;">${header.title}</h1>
          <p style="color: #666; margin: 5px 0;">Généré le: ${header.generatedAt}</p>
          <p style="color: #666;">Généré par: ${header.generatedBy}</p>
          <p style="color: #666;">${t("sexe")}: ${header.filters[t("sexe")]} | ${t("typeProspect")}: ${header.filters[t("typeProspect")]}</p>
          <p style="color: #666;">Total: ${header.totalRecords} enregistrement(s)</p>
        </div>
        <table style="width: 100%; border-collapse: collapse;">
          <thead>
            <tr style="background: #1a5c2a; color: white;">
              <th style="padding: 10px;">ID</th>
              <th style="padding: 10px;">${t("nomComplet")}</th>
              <th style="padding: 10px;">${t("telephone")}</th>
              <th style="padding: 10px;">${t("email")}</th>
              <th style="padding: 10px;">${t("niveauEtude")}</th>
              <th style="padding: 10px;">${t("etablissement")}</th>
              <th style="padding: 10px;">${t("sexe")}</th>
              <th style="padding: 10px;">${t("typeProspect")}</th>
              <th style="padding: 10px;">${t("dateCreation")}</th>
            </tr>
          </thead>
          <tbody>${tableRows}</tbody>
        </table>
        <div style="text-align: center; margin-top: 20px; padding-top: 10px; border-top: 2px solid #f5c842;">
          <p style="color: #999; font-size: 10px;">${header.organization} - ${t("gestionProspects")}</p>
        </div>
      `;

      document.body.appendChild(pdfContent);

      const canvas = await html2canvas(pdfContent, {
        scale: 2,
        backgroundColor: "#ffffff",
        logging: false,
      });
      const imgData = canvas.toDataURL("image/png");
      const pdf = new jsPDF({
        orientation: "landscape",
        unit: "mm",
        format: "a4",
      });

      const imgWidth = 297;
      const imgHeight = (canvas.height * imgWidth) / canvas.width;

      pdf.addImage(imgData, "PNG", 0, 0, imgWidth, imgHeight);
      pdf.save(
        `prospects_export_${new Date().toISOString().slice(0, 19).replace(/:/g, "-")}.pdf`,
      );

      document.body.removeChild(pdfContent);

      addToast(t("exportReussi"), "success");
    } catch (error) {
      addToast(t("exportErreur"), "error");
    } finally {
      setIsExporting(false);
      setShowExportMenu(false);
    }
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t("aucunResultat")}</h3>
      <p>Aucun prospect ne correspond à votre recherche "{searchTerm}"</p>
      <button
        className="btn-outline"
        onClick={() => {
          setSearchTerm("");
          setFilterSexe("all");
          setFilterType("all");
        }}
      >
        {t("effacerFiltres")}
      </button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />

      <Modal
        isOpen={deleteModal.isOpen}
        onClose={() =>
          setDeleteModal({ isOpen: false, prospectId: null, prospectName: "" })
        }
        onConfirm={handleDelete}
        title={t("confirmer")}
        message={`${t("supprimer")} "${deleteModal.prospectName}" ?`}
        confirmText={t("supprimer")}
        type="warning"
      />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t("gestionProspects")}</h1>
          <p className="page-description">{t("descProspects")}</p>
        </div>
        <div style={{ display: "flex", gap: "12px" }}>
          <div className="export-dropdown">
            <button
              className="btn-outline"
              onClick={() => setShowExportMenu(!showExportMenu)}
              disabled={isExporting}
            >
              <Download size={18} />
              {isExporting ? t("chargement") : t("exporter")}
            </button>
            {showExportMenu && (
              <div className="export-menu">
                <button onClick={exportToExcel}>
                  <FileSpreadsheet size={16} /> Excel (.xlsx)
                </button>
                <button onClick={exportToCSV}>
                  <FileText size={16} /> CSV (.csv)
                </button>
                <button onClick={exportToJSON}>
                  <FileJson size={16} /> JSON (.json)
                </button>
                <button onClick={exportToPDF}>
                  <FileImage size={16} /> PDF
                </button>
              </div>
            )}
          </div>
          <button
            className="btn-primary"
            onClick={() => navigate("/prospects/new")}
          >
            <Plus size={18} />
            {t("ajouter")}
          </button>
        </div>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input
            type="text"
            placeholder={`${t("rechercher")}...`}
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select
            value={filterSexe}
            onChange={(e) => setFilterSexe(e.target.value)}
          >
            <option value="all">Tous les sexes</option>
            <option value="M">Masculin</option>
            <option value="F">Féminin</option>
          </select>
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select
            value={filterType}
            onChange={(e) => setFilterType(e.target.value)}
          >
            <option value="all">Tous les types</option>
            {typesProspect.map((t) => (
              <option key={t} value={t}>
                {t}
              </option>
            ))}
          </select>
        </div>
      </div>

      {filteredProspects.length === 0 ? (
        renderNoResults()
      ) : (
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                {/* <th>ID</th> */}
                <th>{t("nom")}</th>
                <th>{t("tel")}</th>
                <th>{t("email")}</th>
                <th>{t("niveau")}</th>
                <th>{t("établissement")}</th>
                <th>{t("sexe")}</th>
                <th>{t("typeProspect")}</th>
                <th>{t("dateCreation")}</th>
                <th>{t("actions")}</th>
              </tr>
            </thead>
            <tbody>
              {paginatedProspects.map((prospect) => (
                <tr key={prospect.id}>
                  {/* <td>{prospect.id}</td> */}
                  <td>{prospect.nomComplet}</td>
                  <td>{prospect.telephone}</td>
                  <td>{prospect.email}</td>
                  <td>{prospect.niveauEtude}</td>
                  <td>{prospect.concerne}</td>
                  <td>{getSexeLabel(prospect.sexe)}</td>
                  <td>{prospect.typeProspect}</td>
                  <td>{prospect.createdAt}</td>
                  <td>
                    <div className="action-buttons">
                      <button
                        className="action-btn view"
                        onClick={() => navigate(`/prospects/${prospect.id}`)}
                      >
                        <Eye size={16} />
                      </button>
                      <button
                        className="action-btn edit"
                        onClick={() =>
                          navigate(`/prospects/edit/${prospect.id}`)
                        }
                      >
                        <Edit size={16} />
                      </button>
                      <button
                        className="action-btn delete"
                        onClick={() =>
                          setDeleteModal({
                            isOpen: true,
                            prospectId: prospect.id,
                            prospectName: prospect.nomComplet,
                          })
                        }
                      >
                        <Trash2 size={16} />
                      </button>                <th>ID</th>

                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {totalPages > 1 && (
            <div className="pagination">
              <button
                className="pagination-btn"
                onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                disabled={currentPage === 1}
              >
                <ChevronLeft size={16} /> Précédent
              </button>
              <span className="pagination-info">
                Page {currentPage} sur {totalPages}
              </span>
              <button
                className="pagination-btn"
                onClick={() =>
                  setCurrentPage((p) => Math.min(totalPages, p + 1))
                }
                disabled={currentPage === totalPages}
              >
                Suivant <ChevronRight size={16} />
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default ProspectsList;
