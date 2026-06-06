import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, ChevronLeft, ChevronRight, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const AgentsList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, agentId: null, agentName: '' });
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

  const agents = [
    { id: 1, name: 'Jean M.', email: 'jean@isetag.com', phone: '691234567', prospects: 45, converted: 18, status: 'actif', zone: 'Yaoundé Centre', avatar: 'JM', taux: 40 },
    { id: 2, name: 'David P.', email: 'david@isetag.com', phone: '692345678', prospects: 38, converted: 12, status: 'actif', zone: 'Douala Nord', avatar: 'DP', taux: 32 },
    { id: 3, name: 'Sophie A.', email: 'sophie@isetag.com', phone: '693456789', prospects: 52, converted: 24, status: 'actif', zone: 'Yaoundé Sud', avatar: 'SA', taux: 46 },
    { id: 4, name: 'Marie L.', email: 'marie@isetag.com', phone: '694567890', prospects: 29, converted: 8, status: 'inactif', zone: 'Bafoussam', avatar: 'ML', taux: 28 },
    { id: 5, name: 'Paul K.', email: 'paul@isetag.com', phone: '695678901', prospects: 41, converted: 15, status: 'actif', zone: 'Garoua', avatar: 'PK', taux: 37 },
  ];

  const filteredAgents = agents.filter(agent => {
    const matchesSearch = agent.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          agent.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          agent.phone.includes(searchTerm);
    const matchesStatus = filterStatus === 'all' || agent.status === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filteredAgents.length / itemsPerPage);
  const paginatedAgents = filteredAgents.slice(
    (currentPage - 1) * itemsPerPage,
    currentPage * itemsPerPage
  );

  const handleDelete = () => {
    addToast(`${deleteModal.agentName} ${t('suppressionReussie')}`, 'success');
    setDeleteModal({ isOpen: false, agentId: null, agentName: '' });
  };

  const getExportData = () => {
    return filteredAgents.map(agent => ({
      [t('nom')]: agent.name,
      [t('email')]: agent.email,
      [t('telephone')]: agent.phone,
      [t('zone')]: agent.zone,
      [t('prospects')]: agent.prospects,
      [t('conversions')]: agent.converted,
      [t('taux')]: `${agent.taux}%`,
      [t('statut')]: agent.status === 'actif' ? t('actif') : t('inactif')
    }));
  };

  const getExportColumns = () => [
    { key: t('nom'), label: t('nom') },
    { key: t('email'), label: t('email') },
    { key: t('telephone'), label: t('telephone') },
    { key: t('zone'), label: t('zone') },
    { key: t('prospects'), label: t('prospects') },
    { key: t('conversions'), label: t('conversions') },
    { key: t('taux'), label: t('taux') },
    { key: t('statut'), label: t('statut') }
  ];

  const getFilters = () => ({
    [t('statut')]: filterStatus !== 'all' ? (filterStatus === 'actif' ? t('actif') : t('inactif')) : 'Tous',
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun agent ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, agentId: null, agentName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} l'agent "${deleteModal.agentName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('gestionAgents')}</h1>
          <p className="page-description">{t('descAgents')}</p>
        </div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton 
            data={getExportData()} 
            filename="agents_export" 
            title={t('gestionAgents')}
            filters={getFilters()}
            columns={getExportColumns()}
          />
          <button className="btn-primary" onClick={() => navigate('/agents/new')}>
            <Plus size={18} />
            {t('ajouter')}
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
          <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
            <option value="all">{t('tousStatuts') || 'Tous les statuts'}</option>
            <option value="actif">{t('actif')}</option>
            <option value="inactif">{t('inactif')}</option>
          </select>
        </div>
      </div>

      {filteredAgents.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>{t('nom')}</th><th>{t('contact')}</th><th>{t('zone')}</th><th>{t('prospects')}</th><th>{t('conversions')}</th><th>{t('taux')}</th><th>{t('statut')}</th><th>{t('actions')}</th>
              </tr>
            </thead>
            <tbody>
              {paginatedAgents.map((agent) => (
                <tr key={agent.id}>
                  <td><div className="agent-cell"><div className="agent-avatar">{agent.avatar}</div><strong>{agent.name}</strong></div></td>
                  <td><div>{agent.email}</div><small>{agent.phone}</small></td>
                  <td>{agent.zone}</td>
                  <td className="text-center">{agent.prospects}</td>
                  <td className="text-center">{agent.converted}</td>
                  <td className="text-center"><span className="rate-badge">{agent.taux}%</span></td>
                  <td><span className={`badge ${agent.status === 'actif' ? 'badge-success' : 'badge-secondary'}`}>{agent.status === 'actif' ? t('actif') : t('inactif')}</span></td>
                  <td>
                    <div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/agents/${agent.id}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/agents/edit/${agent.id}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, agentId: agent.id, agentName: agent.name })}><Trash2 size={16} /></button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {totalPages > 1 && (
            <div className="pagination">
              <button className="pagination-btn" onClick={() => setCurrentPage(p => Math.max(1, p - 1))} disabled={currentPage === 1}><ChevronLeft size={16} /> Précédent</button>
              <span className="pagination-info">Page {currentPage} sur {totalPages}</span>
              <button className="pagination-btn" onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))} disabled={currentPage === totalPages}>Suivant <ChevronRight size={16} /></button>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default AgentsList;
