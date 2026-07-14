import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, ChevronLeft, ChevronRight, AlertCircle, User, Mail, Phone, Shield, Calendar, CheckCircle, XCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const SuperviseursList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, superviseurId: null, superviseurName: '' });
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

  const superviseurs = [
    { id: 1, nom: 'Paul N.', prenom: 'Jean', email: 'paul@isetag.com', telephone: '691234567', matricule: 'SUP001', role: 'Superviseur', actif: true, dateEmbauche: '01 Jan 2024', avatar: 'PN' },
    { id: 2, nom: 'Mballa', prenom: 'Claire', email: 'claire@isetag.com', telephone: '692345678', matricule: 'SUP002', role: 'Superviseur', actif: true, dateEmbauche: '15 Fév 2024', avatar: 'CM' },
    { id: 3, nom: 'Nguema', prenom: 'Pierre', email: 'pierre@isetag.com', telephone: '693456789', matricule: 'SUP003', role: 'Superviseur', actif: false, dateEmbauche: '10 Mar 2024', avatar: 'NP' },
  ];

  const filteredSuperviseurs = superviseurs.filter(s => {
    const matchesSearch = s.nom.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          s.prenom.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          s.email.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === 'all' || (filterStatus === 'actif' ? s.actif : !s.actif);
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filteredSuperviseurs.length / itemsPerPage);
  const paginatedSuperviseurs = filteredSuperviseurs.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => {
    addToast(`Superviseur "${deleteModal.superviseurName}" supprimé avec succès`, 'success');
    setDeleteModal({ isOpen: false, superviseurId: null, superviseurName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun superviseur ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, superviseurId: null, superviseurName: '' })} onConfirm={handleDelete} title={t('confirmer')} message={`Êtes-vous sûr de vouloir supprimer le superviseur "${deleteModal.superviseurName}" ?`} confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Superviseurs</h1>
          <p className="page-description">Gérez les superviseurs qui encadrent les agents commerciaux.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/superviseurs/new')}>
          <Plus size={18} />
          Nouveau superviseur
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par nom, prénom ou email..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
            <option value="all">Tous les statuts</option>
            <option value="actif">Actif</option>
            <option value="inactif">Inactif</option>
          </select>
        </div>
      </div>

      {filteredSuperviseurs.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Superviseur</th><th>Contact</th><th>Matricule</th><th>Date embauche</th><th>Statut</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {paginatedSuperviseurs.map((superviseur) => (
                <tr key={superviseur.id}>
                  <td>
                    <div className="user-cell">
                      <div className="user-avatar">{superviseur.avatar}</div>
                      <div><strong>{superviseur.nom} {superviseur.prenom}</strong></div>
                    </div>
                  </td>
                  <td>
                    <div><Mail size={12} /> {superviseur.email}</div>
                    <small><Phone size={10} /> {superviseur.telephone}</small>
                  </td>
                  <td><span className="badge badge-info">{superviseur.matricule}</span></td>
                  <td><Calendar size={14} /> {superviseur.dateEmbauche}</td>
                  <td><span className={`badge ${superviseur.actif ? 'badge-success' : 'badge-secondary'}`}>{superviseur.actif ? 'Actif' : 'Inactif'}</span></td>
                  <td>
                    <div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/superviseurs/${superviseur.id}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/superviseurs/edit/${superviseur.id}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, superviseurId: superviseur.id, superviseurName: `${superviseur.nom} ${superviseur.prenom}` })}><Trash2 size={16} /></button>
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

export default SuperviseursList;
