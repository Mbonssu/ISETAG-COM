import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Filter, ChevronLeft, ChevronRight, User, Building, Calendar, Clock, CheckCircle, XCircle, MapPin, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const AffectationsList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [filterZone, setFilterZone] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, affectationId: null, affectationName: '' });
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

  const affectations = [
    { id: 1, agent: 'Jean M.', agentAvatar: 'JM', etablissement: 'Lycée de Biyem-Assi', zone: 'Yaoundé Centre', prospects: 12, status: 'En cours', dateDebut: '01 Mai 2025', dateFin: '31 Mai 2025', progression: 65 },
    { id: 2, agent: 'David P.', agentAvatar: 'DP', etablissement: 'Lycée Technique d\'Efouan', zone: 'Yaoundé Sud', prospects: 8, status: 'Terminé', dateDebut: '15 Avril 2025', dateFin: '30 Avril 2025', progression: 100 },
    { id: 3, agent: 'Sophie A.', agentAvatar: 'SA', etablissement: 'Université de Douala', zone: 'Douala Nord', prospects: 15, status: 'En cours', dateDebut: '10 Mai 2025', dateFin: '10 Juin 2025', progression: 45 },
    { id: 4, agent: 'Marie L.', agentAvatar: 'ML', etablissement: 'Institut Supérieur de l\'Information', zone: 'Douala Sud', prospects: 5, status: 'Planifié', dateDebut: '01 Juin 2025', dateFin: '30 Juin 2025', progression: 0 },
    { id: 5, agent: 'Jean M.', agentAvatar: 'JM', etablissement: 'Collège de la Salle', zone: 'Bafoussam', prospects: 6, status: 'En cours', dateDebut: '20 Mai 2025', dateFin: '20 Juin 2025', progression: 30 },
  ];

  const zones = ['Yaoundé Centre', 'Yaoundé Sud', 'Douala Nord', 'Douala Sud', 'Bafoussam', 'Garoua'];

  const filteredAffectations = affectations.filter(a => {
    const matchesSearch = a.agent.toLowerCase().includes(searchTerm.toLowerCase()) || a.etablissement.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === 'all' || a.status === filterStatus;
    const matchesZone = filterZone === 'all' || a.zone === filterZone;
    return matchesSearch && matchesStatus && matchesZone;
  });

  const totalPages = Math.ceil(filteredAffectations.length / itemsPerPage);
  const paginatedAffectations = filteredAffectations.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => { addToast(`${t('affectation')} ${t('suppressionReussie')}`, 'success'); setDeleteModal({ isOpen: false, affectationId: null, affectationName: '' }); };

  const getExportData = () => {
    return filteredAffectations.map(a => ({
      [t('agent')]: a.agent,
      [t('etablissement')]: a.etablissement,
      [t('zone')]: a.zone,
      [t('prospects')]: a.prospects,
      [t('dateDebut')]: a.dateDebut,
      [t('dateFin')]: a.dateFin,
      [t('progression')]: `${a.progression}%`,
      [t('statut')]: a.status
    }));
  };

  const getExportColumns = () => [
    { key: t('agent'), label: t('agent') },
    { key: t('etablissement'), label: t('etablissement') },
    { key: t('zone'), label: t('zone') },
    { key: t('prospects'), label: t('prospects') },
    { key: t('dateDebut'), label: t('dateDebut') },
    { key: t('dateFin'), label: t('dateFin') },
    { key: t('progression'), label: t('progression') },
    { key: t('statut'), label: t('statut') }
  ];

  const getFilters = () => ({
    [t('statut')]: filterStatus !== 'all' ? filterStatus : 'Tous',
    [t('zone')]: filterZone !== 'all' ? filterZone : 'Toutes',
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const getStatusBadge = (status) => {
    const classes = { 'En cours': 'badge-warning', 'Terminé': 'badge-success', 'Planifié': 'badge-info' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const getStatusIcon = (status) => {
    switch(status) {
      case 'En cours': return <Clock size={14} />;
      case 'Terminé': return <CheckCircle size={14} />;
      case 'Planifié': return <Calendar size={14} />;
      default: return <XCircle size={14} />;
    }
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucune affectation ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); setFilterZone('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, affectationId: null, affectationName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} cette affectation ?`} confirmText={t('supprimer')} type="warning" />
      <div className="page-header-actions">
        <div><h1 className="page-title-h1">{t('gestionAffectations')}</h1><p className="page-description">{t('descAffectations')}</p></div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton data={getExportData()} filename="affectations_export" title={t('gestionAffectations')} filters={getFilters()} columns={getExportColumns()} />
          <button className="btn-primary" onClick={() => navigate('/affectations/new')}><Plus size={18} />{t('ajouter')}</button>
        </div>
      </div>
      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option><option value="Planifié">{t('planifie')}</option><option value="En cours">{t('enCours')}</option><option value="Terminé">{t('termine')}</option></select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterZone} onChange={(e) => setFilterZone(e.target.value)}><option value="all">Toutes les zones</option>{zones.map(z => <option key={z} value={z}>{z}</option>)}</select></div>
      </div>
      {filteredAffectations.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead><tr><th>{t('agent')}</th><th>{t('etablissement')}</th><th>{t('zone')}</th><th>{t('prospects')}</th><th>{t('periode')}</th><th>{t('progression')}</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
            <tbody>
              {paginatedAffectations.map((affectation) => (
                <tr key={affectation.id}>
                  <td><div className="agent-cell"><div className="agent-avatar">{affectation.agentAvatar}</div><strong>{affectation.agent}</strong></div></td>
                  <td><Building size={14} /> {affectation.etablissement}</td>
                  <td><MapPin size={14} /> {affectation.zone}</td>
                  <td className="text-center">{affectation.prospects}</td>
                  <td><div className="period-cell"><div>{affectation.dateDebut}</div><small>→ {affectation.dateFin}</small></div></td>
                  <td><div className="progress-bar"><div className="progress-fill" style={{ width: `${affectation.progression}%` }}></div><span>{affectation.progression}%</span></div></td>
                  <td><div className="status-badge">{getStatusIcon(affectation.status)}{getStatusBadge(affectation.status)}</div></td>
                  <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/affectations/edit/${affectation.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, affectationId: affectation.id, affectationName: `${affectation.agent} - ${affectation.etablissement}` })}><Trash2 size={16} /></button></div></td>
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

export default AffectationsList;
