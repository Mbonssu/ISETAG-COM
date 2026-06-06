import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Filter, ChevronLeft, ChevronRight, GraduationCap, Users, TrendingUp, BookOpen, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const FilieresList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, filiereId: null, filiereName: '' });
  const [toasts, setToasts] = useState([]);
  const itemsPerPage = 5;

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const filieres = [
    { id: 1, name: 'Génie Logiciel', code: 'GL', prospects: 399, pourcentage: 32, specialites: ['Développement Web', 'Mobile', 'IA'], actif: true },
    { id: 2, name: 'Génie Civil', code: 'GC', prospects: 249, pourcentage: 20, specialites: ['BTP', 'Architecture', 'Matériaux'], actif: true },
    { id: 3, name: 'Marketing', code: 'MK', prospects: 224, pourcentage: 18, specialites: ['Digital', 'Communication', 'Vente'], actif: true },
    { id: 4, name: 'Réseaux & Télécoms', code: 'RT', prospects: 150, pourcentage: 12, specialites: ['Cybersécurité', 'Cloud', '5G'], actif: true },
    { id: 5, name: 'Architecture', code: 'AR', prospects: 100, pourcentage: 8, specialites: ['Design', 'Urbanisme', '3D'], actif: true },
    { id: 6, name: 'Comptabilité', code: 'CG', prospects: 76, pourcentage: 6, specialites: ['Audit', 'Fiscalité', 'Gestion'], actif: false },
  ];

  const filteredFilieres = filieres.filter(f => f.name.toLowerCase().includes(searchTerm.toLowerCase()) || f.code.toLowerCase().includes(searchTerm.toLowerCase()));
  const totalPages = Math.ceil(filteredFilieres.length / itemsPerPage);
  const paginatedFilieres = filteredFilieres.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => { addToast(`${t('filiere')} "${deleteModal.filiereName}" ${t('suppressionReussie')}`, 'success'); setDeleteModal({ isOpen: false, filiereId: null, filiereName: '' }); };

  const getExportData = () => {
    return filteredFilieres.map(f => ({
      [t('code')]: f.code,
      [t('filiere')]: f.name,
      [t('specialites')]: f.specialites.join(', '),
      [t('prospects')]: f.prospects,
      [t('pourcentage')]: `${f.pourcentage}%`,
      [t('statut')]: f.actif ? t('actif') : t('inactif')
    }));
  };

  const getExportColumns = () => [
    { key: t('code'), label: t('code') },
    { key: t('filiere'), label: t('filiere') },
    { key: t('specialites'), label: t('specialites') },
    { key: t('prospects'), label: t('prospects') },
    { key: t('pourcentage'), label: t('pourcentage') },
    { key: t('statut'), label: t('statut') }
  ];

  const getFilters = () => ({
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucune filière ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, filiereId: null, filiereName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} la filière "${deleteModal.filiereName}" ?`} confirmText={t('supprimer')} type="warning" />
      <div className="page-header-actions">
        <div><h1 className="page-title-h1">{t('gestionFilieres')}</h1><p className="page-description">{t('descFilieres')}</p></div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton data={getExportData()} filename="filieres_export" title={t('gestionFilieres')} filters={getFilters()} columns={getExportColumns()} />
          <button className="btn-primary" onClick={() => navigate('/filieres/new')}><Plus size={18} />{t('ajouter')}</button>
        </div>
      </div>
      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
      </div>
      {filteredFilieres.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead><tr><th>{t('code')}</th><th>{t('filiere')}</th><th>{t('specialites')}</th><th>{t('prospects')}</th><th>{t('part')}</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
            <tbody>
              {paginatedFilieres.map((filiere) => (
                <tr key={filiere.id}>
                  <td><span className="code-badge">{filiere.code}</span></td>
                  <td><strong>{filiere.name}</strong></td>
                  <td><div className="specialites-list">{filiere.specialites.slice(0, 2).map((s, i) => <span key={i} className="specialite-tag">{s}</span>)}{filiere.specialites.length > 2 && <span className="specialite-tag more">+{filiere.specialites.length - 2}</span>}</div></td>
                  <td className="text-center">{filiere.prospects}</td>
                  <td className="text-center"><div className="progress-bar-small"><div className="progress-fill-small" style={{ width: `${filiere.pourcentage}%` }}></div><span>{filiere.pourcentage}%</span></div></td>
                  <td><span className={`badge ${filiere.actif ? 'badge-success' : 'badge-secondary'}`}>{filiere.actif ? t('actif') : t('inactif')}</span></td>
                  <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/filieres/edit/${filiere.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, filiereId: filiere.id, filiereName: filiere.name })}><Trash2 size={16} /></button></div></td>
                </tr>
              ))}
            </tbody>
          </table>
          {totalPages > 1 && (<div className="pagination"><button className="pagination-btn" onClick={() => setCurrentPage(p => Math.max(1, p - 1))} disabled={currentPage === 1}><ChevronLeft size={16} /> Précédent</button><span className="pagination-info">Page {currentPage} sur {totalPages}</span><button className="pagination-btn" onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))} disabled={currentPage === totalPages}>Suivant <ChevronRight size={16} /></button></div>)}
        </div>
      )}
    </div>
  );
};

export default FilieresList;
