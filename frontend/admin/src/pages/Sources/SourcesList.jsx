import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Filter, ChevronLeft, ChevronRight, TrendingUp, Users, BarChart3, Globe, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const SourcesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, sourceId: null, sourceName: '' });
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

  const sources = [
    { id: 1, name: 'Terrain', prospects: 562, pourcentage: 45, couleur: '#FF6B6B', actif: true, evolution: '+12%' },
    { id: 2, name: 'Lycée', prospects: 374, pourcentage: 30, couleur: '#4ECDC4', actif: true, evolution: '+8%' },
    { id: 3, name: 'Passage institut', prospects: 187, pourcentage: 15, couleur: '#FFE66D', actif: true, evolution: '+5%' },
    { id: 4, name: 'Réseaux sociaux', prospects: 75, pourcentage: 6, couleur: '#A78BFA', actif: true, evolution: '+25%' },
    { id: 5, name: 'Référence', prospects: 50, pourcentage: 4, couleur: '#F9A26C', actif: true, evolution: '+3%' },
    { id: 6, name: 'Site web', prospects: 32, pourcentage: 2.6, couleur: '#845EC2', actif: false, evolution: '+15%' },
  ];

  const filteredSources = sources.filter(s => s.name.toLowerCase().includes(searchTerm.toLowerCase()));
  const totalPages = Math.ceil(filteredSources.length / itemsPerPage);
  const paginatedSources = filteredSources.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => { addToast(`${t('source')} "${deleteModal.sourceName}" ${t('suppressionReussie')}`, 'success'); setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' }); };

  const getExportData = () => {
    return filteredSources.map(s => ({
      [t('source')]: s.name,
      [t('prospects')]: s.prospects,
      [t('pourcentage')]: `${s.pourcentage}%`,
      [t('evolution')]: s.evolution,
      [t('statut')]: s.actif ? t('actif') : t('inactif')
    }));
  };

  const getExportColumns = () => [
    { key: t('source'), label: t('source') },
    { key: t('prospects'), label: t('prospects') },
    { key: t('pourcentage'), label: t('pourcentage') },
    { key: t('evolution'), label: t('evolution') },
    { key: t('statut'), label: t('statut') }
  ];

  const getFilters = () => ({
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucune source ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, sourceId: null, sourceName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} la source "${deleteModal.sourceName}" ?`} confirmText={t('supprimer')} type="warning" />
      <div className="page-header-actions">
        <div><h1 className="page-title-h1">{t('gestionSources')}</h1><p className="page-description">{t('descSources')}</p></div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton data={getExportData()} filename="sources_export" title={t('gestionSources')} filters={getFilters()} columns={getExportColumns()} />
          <button className="btn-primary" onClick={() => navigate('/sources/new')}><Plus size={18} />{t('ajouter')}</button>
        </div>
      </div>
      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
      </div>
      {filteredSources.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead><tr><th>{t('source')}</th><th>{t('prospects')}</th><th>{t('part')}</th><th>{t('evolution')}</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
            <tbody>
              {paginatedSources.map((source) => (
                <tr key={source.id}>
                  <td><div className="source-cell"><div className="source-color" style={{ backgroundColor: source.couleur }}></div><strong>{source.name}</strong></div></td>
                  <td className="text-center">{source.prospects}</td>
                  <td className="text-center"><div className="progress-bar-small"><div className="progress-fill-small" style={{ width: `${source.pourcentage}%` }}></div><span>{source.pourcentage}%</span></div></td>
                  <td><span className={`evolution-badge ${source.evolution.includes('+') ? 'positive' : 'negative'}`}>{source.evolution}</span></td>
                  <td><span className={`badge ${source.actif ? 'badge-success' : 'badge-secondary'}`}>{source.actif ? t('actif') : t('inactif')}</span></td>
                  <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/sources/edit/${source.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, sourceId: source.id, sourceName: source.name })}><Trash2 size={16} /></button></div></td>
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

export default SourcesList;
