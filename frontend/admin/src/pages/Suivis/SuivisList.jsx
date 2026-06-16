import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, ChevronLeft, ChevronRight, AlertCircle, Calendar, Clock, FileText } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import '../Prospects/Prospects.css';

const SuivisList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, suiviId: null, suiviName: '' });
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

  // Données mockées pour les suivis
  const suivis = [
    { id: 1, prospect: 'Marie L.', dateSuivi: '25 Mai 2025', typeSuivi: 'Appel', commentaire: 'Premier contact, prospect intéressé', prochainAction: 'Rappeler dans 2 jours', agent: 'Jean M.', createdAt: '25 Mai 2025' },
    { id: 2, prospect: 'David P.', dateSuivi: '24 Mai 2025', typeSuivi: 'Email', commentaire: 'Envoi de documentation', prochainAction: 'Relance par téléphone', agent: 'David P.', createdAt: '24 Mai 2025' },
    { id: 3, prospect: 'Anne S.', dateSuivi: '23 Mai 2025', typeSuivi: 'Visite', commentaire: 'Visite de l\'établissement', prochainAction: 'Envoyer proposition', agent: 'Sophie A.', createdAt: '23 Mai 2025' },
  ];

  const typesSuivi = ['Appel', 'Email', 'Visite', 'SMS', 'Autre'];

  const filteredSuivis = suivis.filter(s => {
    const matchesSearch = s.prospect.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          s.agent.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = filterType === 'all' || s.typeSuivi === filterType;
    return matchesSearch && matchesType;
  });

  const totalPages = Math.ceil(filteredSuivis.length / itemsPerPage);
  const paginatedSuivis = filteredSuivis.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => {
    addToast(`Suivi supprimé avec succès`, 'success');
    setDeleteModal({ isOpen: false, suiviId: null, suiviName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun suivi ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterType('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, suiviId: null, suiviName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer ce suivi ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Suivis</h1>
          <p className="page-description">Suivez l'historique des interactions avec les prospects.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/suivis/new')}>
          <Plus size={18} />
          Nouveau suivi
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par prospect ou agent..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterType} onChange={(e) => setFilterType(e.target.value)}>
            <option value="all">Tous les types</option>
            {typesSuivi.map(t => <option key={t} value={t}>{t}</option>)}
          </select>
        </div>
      </div>

      {filteredSuivis.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Prospect</th><th>Date</th><th>Type</th><th>Commentaire</th><th>Prochaine action</th><th>Agent</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {paginatedSuivis.map((suivi) => (
                <tr key={suivi.id}>
                  <td><strong>{suivi.prospect}</strong></td>
                  <td><Calendar size={14} /> {suivi.dateSuivi}</td>
                  <td><span className="badge badge-info">{suivi.typeSuivi}</span></td>
                  <td><div className="commentaire-cell"><small>{suivi.commentaire}</small></div></td>
                  <td><Clock size={14} /> {suivi.prochainAction}</td>
                  <td>{suivi.agent}</td>
                  <td>
                    <div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/suivis/${suivi.id}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/suivis/edit/${suivi.id}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, suiviId: suivi.id, suiviName: suivi.prospect })}><Trash2 size={16} /></button>
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

export default SuivisList;
