import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, ChevronLeft, ChevronRight, AlertCircle, Mail, Smartphone, Phone, Calendar, TrendingUp, Users, Target } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const CampagnesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, campagneId: null, campagneName: '' });
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

  const campagnes = [
    { id: 1, name: 'Campagne Mai 2025', type: 'Email', status: 'En cours', prospects: 245, taux: 32, dateDebut: '01 Mai 2025', dateFin: '31 Mai 2025', agent: 'Jean M.' },
    { id: 2, name: 'Campagne Lycées', type: 'SMS', status: 'Terminée', prospects: 189, taux: 45, dateDebut: '15 Avril 2025', dateFin: '30 Avril 2025', agent: 'Sophie A.' },
    { id: 3, name: 'Campagne Réseaux Sociaux', type: 'Email', status: 'Planifiée', prospects: 320, taux: 0, dateDebut: '01 Juin 2025', dateFin: '30 Juin 2025', agent: 'David P.' },
    { id: 4, name: 'Campagne Téléphonique', type: 'Appel', status: 'En cours', prospects: 98, taux: 28, dateDebut: '20 Mai 2025', dateFin: '10 Juin 2025', agent: 'Marie L.' },
    { id: 5, name: 'Campagne Filières', type: 'Email', status: 'Terminée', prospects: 412, taux: 38, dateDebut: '01 Mars 2025', dateFin: '31 Mars 2025', agent: 'Jean M.' },
  ];

  const filteredCampagnes = campagnes.filter(c => {
    const matchesSearch = c.name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || c.type === filterType;
    const matchesStatus = filterStatus === 'all' || c.status === filterStatus;
    return matchesSearch && matchesType && matchesStatus;
  });

  const totalPages = Math.ceil(filteredCampagnes.length / itemsPerPage);
  const paginatedCampagnes = filteredCampagnes.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => {
    addToast(`${t('campagne')} "${deleteModal.campagneName}" ${t('suppressionReussie')}`, 'success');
    setDeleteModal({ isOpen: false, campagneId: null, campagneName: '' });
  };

  const getExportData = () => {
    return filteredCampagnes.map(c => ({
      [t('nom')]: c.name,
      [t('type')]: c.type,
      [t('statut')]: c.status,
      [t('prospects')]: c.prospects,
      [t('taux')]: `${c.taux}%`,
      [t('dateDebut')]: c.dateDebut,
      [t('dateFin')]: c.dateFin,
      [t('agent')]: c.agent
    }));
  };

  const getExportColumns = () => [
    { key: t('nom'), label: t('nom') },
    { key: t('type'), label: t('type') },
    { key: t('statut'), label: t('statut') },
    { key: t('prospects'), label: t('prospects') },
    { key: t('taux'), label: t('taux') },
    { key: t('dateDebut'), label: t('dateDebut') },
    { key: t('dateFin'), label: t('dateFin') },
    { key: t('agent'), label: t('agent') }
  ];

  const getFilters = () => ({
    [t('type')]: filterType !== 'all' ? filterType : 'Tous',
    [t('statut')]: filterStatus !== 'all' ? filterStatus : 'Tous',
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const getStatusBadge = (status) => {
    const classes = { 'En cours': 'badge-warning', 'Terminée': 'badge-success', 'Planifiée': 'badge-info' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Email': return <Mail size={16} />;
      case 'SMS': return <Smartphone size={16} />;
      case 'Appel': return <Phone size={16} />;
      default: return <Mail size={16} />;
    }
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucune campagne ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, campagneId: null, campagneName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} la campagne "${deleteModal.campagneName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div><h1 className="page-title-h1">{t('gestionCampagnes')}</h1><p className="page-description">{t('descCampagnes')}</p></div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton data={getExportData()} filename="campagnes_export" title={t('gestionCampagnes')} filters={getFilters()} columns={getExportColumns()} />
          <button className="btn-primary" onClick={() => navigate('/campagnes/new')}><Plus size={18} />{t('ajouter')}</button>
        </div>
      </div>

      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={(e) => setFilterType(e.target.value)}><option value="all">Tous les types</option><option value="Email">{t('email')}</option><option value="SMS">{t('sms')}</option><option value="Appel">{t('appel')}</option></select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}><option value="all">{t('tousStatuts')}</option><option value="Planifiée">{t('planifie')}</option><option value="En cours">{t('enCours')}</option><option value="Terminée">{t('termine')}</option></select></div>
      </div>

      {filteredCampagnes.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead><tr><th>{t('nom')}</th><th>{t('type')}</th><th>{t('periode')}</th><th>{t('prospects')}</th><th>{t('taux')}</th><th>{t('statut')}</th><th>{t('agent')}</th><th>{t('actions')}</th></tr></thead>
            <tbody>
              {paginatedCampagnes.map((campagne) => (
                <tr key={campagne.id}>
                  <td><strong>{campagne.name}</strong></td>
                  <td><div className="type-badge">{getTypeIcon(campagne.type)}<span>{campagne.type}</span></div></td>
                  <td><div className="date-range"><small>{campagne.dateDebut}</small><small>→</small><small>{campagne.dateFin}</small></div></td>
                  <td className="text-center">{campagne.prospects}</td>
                  <td className="text-center"><div className="progress-bar"><div className="progress-fill" style={{ width: `${campagne.taux}%` }}></div><span>{campagne.taux}%</span></div></td>
                  <td>{getStatusBadge(campagne.status)}</td>
                  <td>{campagne.agent}</td>
                  <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/campagnes/edit/${campagne.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, campagneId: campagne.id, campagneName: campagne.name })}><Trash2 size={16} /></button></div></td>
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

export default CampagnesList;
