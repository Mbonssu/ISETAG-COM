import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Filter, ChevronLeft, ChevronRight, User, Shield, Calendar, CheckCircle, XCircle, Mail, Phone, Users, AlertCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import ExportButton from '../../components/ExportButton/ExportButton';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';
import './Utilisateurs.css';

const UtilisateursList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterRole, setFilterRole] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, userId: null, userName: '' });
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

  const utilisateurs = [
    { id: 1, name: 'Admin ISETAG', email: 'admin@isetag.com', phone: '691234567', role: 'Administrateur', status: 'actif', lastLogin: '25 Mai 2025', createdAt: '01 Jan 2024', avatar: 'AI' },
    { id: 2, name: 'Jean M.', email: 'jean@isetag.com', phone: '691234567', role: 'Agent', status: 'actif', lastLogin: '24 Mai 2025', createdAt: '15 Jan 2024', avatar: 'JM' },
    { id: 3, name: 'David P.', email: 'david@isetag.com', phone: '692345678', role: 'Agent', status: 'actif', lastLogin: '23 Mai 2025', createdAt: '20 Fév 2024', avatar: 'DP' },
    { id: 4, name: 'Sophie A.', email: 'sophie@isetag.com', phone: '693456789', role: 'Manager', status: 'actif', lastLogin: '25 Mai 2025', createdAt: '10 Mar 2024', avatar: 'SA' },
    { id: 5, name: 'Marie L.', email: 'marie@isetag.com', phone: '694567890', role: 'Agent', status: 'inactif', lastLogin: '10 Mai 2025', createdAt: '05 Avr 2024', avatar: 'ML' },
  ];

  const roles = ['Administrateur', 'Manager', 'Agent', 'Viewer'];
  
  const getRoleBadge = (role) => {
    const classes = { 'Administrateur': 'badge-danger', 'Manager': 'badge-warning', 'Agent': 'badge-info', 'Viewer': 'badge-secondary' };
    return <span className={`badge ${classes[role] || 'badge-secondary'}`}>{role}</span>;
  };

  const getRoleIcon = (role) => {
    switch(role) {
      case 'Administrateur': return <Shield size={14} />;
      default: return <User size={14} />;
    }
  };

  const filteredUtilisateurs = utilisateurs.filter(u => {
    const matchesSearch = u.name.toLowerCase().includes(searchTerm.toLowerCase()) || u.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRole = filterRole === 'all' || u.role === filterRole;
    const matchesStatus = filterStatus === 'all' || u.status === filterStatus;
    return matchesSearch && matchesRole && matchesStatus;
  });

  const totalPages = Math.ceil(filteredUtilisateurs.length / itemsPerPage);
  const paginatedUtilisateurs = filteredUtilisateurs.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => { addToast(`${t('utilisateur')} "${deleteModal.userName}" ${t('suppressionReussie')}`, 'success'); setDeleteModal({ isOpen: false, userId: null, userName: '' }); };

  const getExportData = () => {
    return filteredUtilisateurs.map(u => ({
      [t('nom')]: u.name,
      [t('email')]: u.email,
      [t('telephone')]: u.phone,
      [t('role')]: u.role,
      [t('derniereConnexion')]: u.lastLogin,
      [t('dateCreation')]: u.createdAt,
      [t('statut')]: u.status === 'actif' ? t('actif') : t('inactif')
    }));
  };

  const getExportColumns = () => [
    { key: t('nom'), label: t('nom') },
    { key: t('email'), label: t('email') },
    { key: t('telephone'), label: t('telephone') },
    { key: t('role'), label: t('role') },
    { key: t('derniereConnexion'), label: t('derniereConnexion') },
    { key: t('dateCreation'), label: t('dateCreation') },
    { key: t('statut'), label: t('statut') }
  ];

  const getFilters = () => ({
    [t('role')]: filterRole !== 'all' ? filterRole : 'Tous',
    [t('statut')]: filterStatus !== 'all' ? filterStatus : 'Tous',
    [t('rechercher')]: searchTerm || 'Aucune'
  });

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun utilisateur ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterRole('all'); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, userId: null, userName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`${t('supprimer')} l'utilisateur "${deleteModal.userName}" ?`} confirmText={t('supprimer')} type="warning" />
      <div className="page-header-actions">
        <div><h1 className="page-title-h1">{t('gestionUtilisateurs')}</h1><p className="page-description">{t('descUtilisateurs')}</p></div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <ExportButton data={getExportData()} filename="utilisateurs_export" title={t('gestionUtilisateurs')} filters={getFilters()} columns={getExportColumns()} />
          <button className="btn-primary" onClick={() => navigate('/utilisateurs/new')}><Plus size={18} />{t('ajouter')}</button>
        </div>
      </div>
      <div className="filters-bar">
        <div className="search-box"><Search size={18} /><input type="text" placeholder={`${t('rechercher')}...`} value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} /></div>
        <div className="filter-group"><Filter size={18} /><select value={filterRole} onChange={(e) => setFilterRole(e.target.value)}><option value="all">Tous les rôles</option>{roles.map(r => <option key={r} value={r}>{r}</option>)}</select></div>
        <div className="filter-group"><Filter size={18} /><select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}><option value="all">Tous les statuts</option><option value="actif">{t('actif')}</option><option value="inactif">{t('inactif')}</option></select></div>
      </div>
      {filteredUtilisateurs.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead><tr><th>{t('utilisateur')}</th><th>{t('contact')}</th><th>{t('role')}</th><th>{t('derniereConnexion')}</th><th>{t('dateCreation')}</th><th>{t('statut')}</th><th>{t('actions')}</th></tr></thead>
            <tbody>
              {paginatedUtilisateurs.map((user) => (
                <tr key={user.id}>
                  <td><div className="user-cell"><div className="user-avatar">{user.avatar}</div><strong>{user.name}</strong></div></td>
                  <td><div><Mail size={12} /> {user.email}</div><small><Phone size={10} /> {user.phone}</small></td>
                  <td><div className="role-badge">{getRoleIcon(user.role)}{getRoleBadge(user.role)}</div></td>
                  <td>{user.lastLogin}</td>
                  <td>{user.createdAt}</td>
                  <td><span className={`badge ${user.status === 'actif' ? 'badge-success' : 'badge-secondary'}`}>{user.status === 'actif' ? t('actif') : t('inactif')}</span></td>
                  <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/utilisateurs/edit/${user.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, userId: user.id, userName: user.name })}><Trash2 size={16} /></button></div></td>
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

export default UtilisateursList;
