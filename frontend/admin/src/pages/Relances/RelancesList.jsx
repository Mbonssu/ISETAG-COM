import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, ChevronLeft, ChevronRight, Bell, Clock, CheckCircle, AlertCircle, Phone, Mail, MessageSquare } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const RelancesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, relanceId: null, relanceName: '' });
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

  const relances = [
    { id: 1, prospect: 'Marie L.', type: 'Email', date: '25 Mai 2025', heure: '10:00', status: 'En attente', agent: 'Jean M.', priorite: 'Haute', message: 'Relance pour inscription formation' },
    { id: 2, prospect: 'Junior B.', type: 'Appel', date: '25 Mai 2025', heure: '14:30', status: 'Programmée', agent: 'Jean M.', priorite: 'Moyenne', message: 'Confirmation inscription' },
    { id: 3, prospect: 'Paul D.', type: 'SMS', date: '24 Mai 2025', heure: '09:00', status: 'Effectuée', agent: 'David P.', priorite: 'Basse', message: 'Rappel de rendez-vous' },
    { id: 4, prospect: 'Anne S.', type: 'Email', date: '26 Mai 2025', heure: '11:00', status: 'En attente', agent: 'Sophie A.', priorite: 'Haute', message: 'Documentation supplémentaire' },
    { id: 5, prospect: 'Luc M.', type: 'Appel', date: '23 Mai 2025', heure: '16:00', status: 'Effectuée', agent: 'David P.', priorite: 'Moyenne', message: 'Suite à la visite' },
  ];

  const getTypeIcon = (type) => {
    switch(type) {
      case 'Email': return <Mail size={16} />;
      case 'Appel': return <Phone size={16} />;
      case 'SMS': return <MessageSquare size={16} />;
      default: return <Bell size={16} />;
    }
  };

  const getStatusBadge = (status) => {
    const classes = { 'En attente': 'badge-warning', 'Programmée': 'badge-info', 'Effectuée': 'badge-success' };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const getPrioriteIcon = (priorite) => {
    switch(priorite) {
      case 'Haute': return <AlertCircle size={14} color="#ef4444" />;
      case 'Moyenne': return <Clock size={14} color="#f59e0b" />;
      case 'Basse': return <CheckCircle size={14} color="#10b981" />;
      default: return <Bell size={14} />;
    }
  };

  const filteredRelances = relances.filter(r => {
    const matchesSearch = r.prospect.toLowerCase().includes(searchTerm.toLowerCase()) || r.agent.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || r.type === filterType;
    const matchesStatus = filterStatus === 'all' || r.status === filterStatus;
    return matchesSearch && matchesType && matchesStatus;
  });

  const totalPages = Math.ceil(filteredRelances.length / itemsPerPage);
  const paginatedRelances = filteredRelances.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => { addToast(`${t('relance')} ${t('suppressionReussie')}`, 'success'); setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' }); };

  const getExportData = () => {
    return filteredRelances.map(r => ({
      [t('prospect')]: r.prospect,
      [t('type')]: r.type,
      [t('message')]: r.message,
      [t('date')]: r.date,
      [t('heure')]: r.heure,
      [t('priorite')]: r.priorite,
      [t('statut')]: r.status,
      [t('agent')]: r.agent
    }));
  };

  const getExportColumns = () => [
    { key: t('prospect'), label: t('prospect') },
    { key: t('type'), label: t('type') },
    { key: t('message'), label: t('message') },
    { key: t('date'), label: t('date') },
    { key: t('heure'), label: t('heure') },
    { key: t('priorite'), label: t('priorite') },
    { key: t('statut'), label: t('statut') },
    { key: t('agent'), label: t('agent') }
  ];

  const getFilters = () => ({
    [t('type')]: filterType !== 'all' ? filterType : 'Tous',
    [t('statut')]: filterStatus !== 'all' ? filterStatus : 'Tous',
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucune relance ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, relanceId: null, relanceName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} cette relance ?`} confirmText={t('supprimer')} type="warning" />
      <div className="page-header-actions">
        <div><h1 className="page-title-h1">{t('gestionRelances')}</h1><p className="page-description">{t('descRelances')}</p></div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton data={getExportData()} filename="relances_export" title={t('gestionRelances')} filters={getFilters()} columns={getExportColumns()} />
          <button className="btn-primary" onClick={() => navigate('/relances/new')}><Plus size={18} />{t('ajouter')}</button>
        </div>
      </div>
      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterType} onChange={(e) => setFilterType(e.target.value)}><option value="all">Tous les types</option><option value="Email">{t('email')}</option><option value="Appel">{t('appel')}</option><option value="SMS">{t('sms')}</option></select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}><option value="all">Tous les statuts</option><option value="En attente">{t('enAttente')}</option><option value="Programmée">{t('programmee')}</option><option value="Effectuée">{t('effectuee')}</option></select></div>
      </div>
      {filteredRelances.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead><tr><th>{t('prospect')}</th><th>{t('type')}</th><th>{t('message')}</th><th>{t('date')}/{t('heure')}</th><th>{t('priorite')}</th><th>{t('statut')}</th><th>{t('agent')}</th><th>{t('actions')}</th></tr></thead>
            <tbody>
              {paginatedRelances.map((relance) => (
                <tr key={relance.id}>
                  <td><strong>{relance.prospect}</strong></td>
                  <td><div className="type-badge">{getTypeIcon(relance.type)}<span>{relance.type}</span></div></td>
                  <td><div className="relance-message"><small>{relance.message}</small></div></td>
                  <td><div className="date-time"><div>{relance.date}</div><small>{relance.heure}</small></div></td>
                  <td><div className="priority-badge">{getPrioriteIcon(relance.priorite)}<span className={`priority-${relance.priorite.toLowerCase()}`}>{relance.priorite}</span></div></td>
                  <td>{getStatusBadge(relance.status)}</td>
                  <td>{relance.agent}</td>
                  <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/relances/edit/${relance.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, relanceId: relance.id, relanceName: relance.prospect })}><Trash2 size={16} /></button></div></td>
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

export default RelancesList;
