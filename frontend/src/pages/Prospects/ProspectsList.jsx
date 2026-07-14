import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, AlertCircle, FileSpreadsheet, FileJson, FileText, FileImage } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
import { prospectService } from '../../services/prospectService';
import { Prospect } from '../../models/prospect';
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
  const [allProspects, setAllProspects] = useState([]);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState(null);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  // Le backend (ProspectView.get) renvoie un TABLEAU JSON direct,
  // pas un objet enveloppé { data: { items: [...] } }.
  const fetchProspects = useCallback(async () => {
    setLoading(true);
    setLoadError(null);
    try {
      const data = await prospectService.getAll();
      const list = Array.isArray(data) ? data.map(item => Prospect.fromDjango(item)) : [];
      setAllProspects(list);
    } catch (error) {
      setLoadError(error.message);
      addToast('Erreur lors du chargement des prospects', 'error');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchProspects();
  }, [fetchProspects]);

  const filteredProspects = allProspects.filter(prospect => {
    const matchesSearch = prospect.nomComplet.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          prospect.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          prospect.telephone.includes(searchTerm);
    const matchesSexe = filterSexe === 'all' || prospect.sexe === filterSexe;
    const matchesType = filterType === 'all' || prospect.typeProspect === filterType;
    return matchesSearch && matchesSexe && matchesType;
  });

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredProspects, 10);

  const getSexeLabel = (sexe) => sexe === 'M' ? 'Masculin' : 'Féminin';

  const handleDelete = async () => {
    // On capture l'id/nom localement avant de fermer la modale, pour
    // éviter qu'un double-clic relance handleDelete avec un id déjà
    // remis à null (même bug que celui corrigé sur Utilisateurs).
    const { prospectId, prospectName } = deleteModal;
    if (!prospectId) return;
    setDeleteModal({ isOpen: false, prospectId: null, prospectName: '' });

    try {
      await prospectService.delete(prospectId);
      addToast(`${prospectName} ${t('suppressionReussie')}`, 'success');
      fetchProspects();
    } catch (error) {
      addToast('Erreur lors de la suppression', 'error');
    }
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

      {loading ? (
        <p className="page-loading">Chargement des prospects…</p>
      ) : loadError ? (
        <p className="form-error">{loadError}</p>
      ) : filteredProspects.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>{t('Nom etudiant')}</th><th>{t('telephone')}</th><th>{t('email')}</th><th>{t('niveauEtude')}</th><th>Domaine/Série</th><th>{t('sexe')}</th><th>{t('typeProspect')}</th><th>{t('dateCreation')}</th><th>{t('actions')}</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((prospect) => (
                  <tr key={prospect.id}>
                    {/* <td>{prospect.id}</td> */}
                    <td>{prospect.nomComplet}</td>
                    <td>{prospect.telephone}</td>
                    <td>{prospect.email}</td>
                    <td>{prospect.niveauEtude}</td>
                    <td>{prospect.domaineEtude || '-'}</td>
                    <td>{getSexeLabel(prospect.sexe)}</td>
                    <td>{prospect.typeProspect}</td>
                    <td>{prospect.createdAt ? new Date(prospect.createdAt).toLocaleDateString('fr-FR') : '-'}</td>
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