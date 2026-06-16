import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, AlertCircle, FileSpreadsheet, FileJson, FileText, FileImage } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import './Prospects.css';

const ProspectsList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterSexe, setFilterSexe] = useState('all');
  const [filterType, setFilterType] = useState('all');
  const [showExportMenu, setShowExportMenu] = useState(false);
  const [isExporting, setIsExporting] = useState(false);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, prospectId: null, prospectName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const prospects = [
    { id: 'P001', nomComplet: 'Marie L.', telephone: '691234567', email: 'marie@email.com', niveauEtude: 'Terminale', concerne: 'Lycée de Biyem-Assi', adresse: 'Biyem-Assi, Yaoundé', sexe: 'F', typeProspect: 'Etudiant', createdAt: '25 Mai 2025' },
    { id: 'P002', nomComplet: 'David P.', telephone: '692345678', email: 'david@email.com', niveauEtude: 'Bac+1', concerne: 'Université de Douala', adresse: 'Logbessou, Douala', sexe: 'M', typeProspect: 'Etudiant', createdAt: '24 Mai 2025' },
    { id: 'P003', nomComplet: 'Anne S.', telephone: '693456789', email: 'anne@email.com', niveauEtude: 'Bac+2', concerne: 'Institut Supérieur', adresse: 'Bonamoussadi, Douala', sexe: 'F', typeProspect: 'Parent', createdAt: '23 Mai 2025' },
    { id: 'P004', nomComplet: 'Junior B.', telephone: '694567890', email: 'junior@email.com', niveauEtude: 'Terminale', concerne: 'Lycée Technique', adresse: 'Efouan, Yaoundé', sexe: 'M', typeProspect: 'Etudiant', createdAt: '22 Mai 2025' },
    { id: 'P005', nomComplet: 'Luc M.', telephone: '695678901', email: 'luc@email.com', niveauEtude: 'Bac+3', concerne: 'Université de Douala', adresse: 'Logbessou, Douala', sexe: 'M', typeProspect: 'Etudiant', createdAt: '21 Mai 2025' },
    { id: 'P006', nomComplet: 'Sophie L.', telephone: '696789012', email: 'sophie@email.com', niveauEtude: 'Master', concerne: 'Institut Supérieur', adresse: 'Bonamoussadi, Douala', sexe: 'F', typeProspect: 'Professionnel', createdAt: '20 Mai 2025' },
    { id: 'P007', nomComplet: 'Paul D.', telephone: '697890123', email: 'paul@email.com', niveauEtude: 'Bac+1', concerne: 'Lycée de Biyem-Assi', adresse: 'Biyem-Assi, Yaoundé', sexe: 'M', typeProspect: 'Parent', createdAt: '19 Mai 2025' },
    { id: 'P008', nomComplet: 'Claire N.', telephone: '698901234', email: 'claire@email.com', niveauEtude: 'Terminale', concerne: 'Lycée Technique', adresse: 'Efouan, Yaoundé', sexe: 'F', typeProspect: 'Etudiant', createdAt: '18 Mai 2025' },
    { id: 'P009', nomComplet: 'Michel K.', telephone: '699012345', email: 'michel@email.com', niveauEtude: 'Bac+2', concerne: 'Université de Douala', adresse: 'Logbessou, Douala', sexe: 'M', typeProspect: 'Professionnel', createdAt: '17 Mai 2025' },
    { id: 'P010', nomComplet: 'Isabelle M.', telephone: '690123456', email: 'isabelle@email.com', niveauEtude: 'Doctorat', concerne: 'Institut Supérieur', adresse: 'Bonamoussadi, Douala', sexe: 'F', typeProspect: 'Professionnel', createdAt: '16 Mai 2025' },
  ];

  const filteredProspects = prospects.filter(prospect => {
    const matchesSearch = prospect.nomComplet.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          prospect.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          prospect.telephone.includes(searchTerm);
    const matchesSexe = filterSexe === 'all' || prospect.sexe === filterSexe;
    const matchesType = filterType === 'all' || prospect.typeProspect === filterType;
    return matchesSearch && matchesSexe && matchesType;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredProspects, 10);

  const getSexeLabel = (sexe) => sexe === 'M' ? 'Masculin' : 'Féminin';

  const handleDelete = () => {
    addToast(`${deleteModal.prospectName} ${t('suppressionReussie')}`, 'success');
    setDeleteModal({ isOpen: false, prospectId: null, prospectName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun prospect ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterSexe('all'); setFilterType('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, prospectId: null, prospectName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} "${deleteModal.prospectName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('gestionProspects')}</h1>
          <p className="page-description">{t('descProspects')}</p>
        </div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <div className="export-dropdown">
            <button className="btn-outline" onClick={() => setShowExportMenu(!showExportMenu)} disabled={isExporting}>
              <Download size={18} /> Exporter
            </button>
            {showExportMenu && (
              <div className="export-menu">
                <button><FileSpreadsheet size={16} /> Excel (.xlsx)</button>
                <button><FileText size={16} /> CSV (.csv)</button>
                <button><FileJson size={16} /> JSON (.json)</button>
                <button><FileImage size={16} /> PDF</button>
              </div>
            )}
          </div>
          <button className="btn-primary" onClick={() => navigate('/prospects/new')}>
            <Plus size={18} /> {t('ajouter')}
          </button>
        </div>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterSexe} onChange={(e) => setFilterSexe(e.target.value)}>
            <option value="all">Tous les sexes</option>
            <option value="M">Masculin</option>
            <option value="F">Féminin</option>
          </select>
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterType} onChange={(e) => setFilterType(e.target.value)}>
            <option value="all">Tous les types</option>
            <option value="Etudiant">Étudiant</option>
            <option value="Parent">Parent</option>
            <option value="Professionnel">Professionnel</option>
            <option value="Autre">Autre</option>
          </select>
        </div>
      </div>

      {filteredProspects.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>ID</th><th>{t('nomComplet')}</th><th>{t('telephone')}</th><th>{t('email')}</th><th>{t('niveauEtude')}</th><th>{t('etablissement')}</th><th>{t('sexe')}</th><th>{t('typeProspect')}</th><th>{t('dateCreation')}</th><th>{t('actions')}</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((prospect) => (
                  <tr key={prospect.id}>
                    <td>{prospect.id}</td>
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
                        <button className="action-btn view" onClick={() => navigate(`/prospects/${prospect.id}`)}><Eye size={16} /></button>
                        <button className="action-btn edit" onClick={() => navigate(`/prospects/edit/${prospect.id}`)}><Edit size={16} /></button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, prospectId: prospect.id, prospectName: prospect.nomComplet })}><Trash2 size={16} /></button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination 
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={goToPage}
            itemsPerPage={itemsPerPage}
            totalItems={filteredProspects.length}
          />
        </>
      )}
    </div>
  );
};

export default ProspectsList;
