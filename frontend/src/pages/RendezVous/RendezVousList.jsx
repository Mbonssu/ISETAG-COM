import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, ChevronLeft, ChevronRight, AlertCircle, Calendar, Clock, MapPin, Phone, Mail, User, CheckCircle, XCircle } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const RendezVousList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, rdvId: null, rdvName: '' });
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

  const rendezvous = [
    { id: 1, prospect: 'Marie L.', dateRv: '25 Mai 2025', heureRv: '10:00', lieuRv: 'Lycée de Biyem-Assi', statutRv: 'Confirmé', agent: 'Jean M.', commentaire: 'Visite de l\'établissement', createdAt: '20 Mai 2025' },
    { id: 2, prospect: 'David P.', dateRv: '26 Mai 2025', heureRv: '14:30', lieuRv: 'Université de Douala', statutRv: 'Planifié', agent: 'David P.', commentaire: 'Entretien d\'orientation', createdAt: '21 Mai 2025' },
    { id: 3, prospect: 'Anne S.', dateRv: '24 Mai 2025', heureRv: '09:00', lieuRv: 'Institut Supérieur', statutRv: 'Effectué', agent: 'Sophie A.', commentaire: 'Inscription confirmée', createdAt: '18 Mai 2025' },
    { id: 4, prospect: 'Junior B.', dateRv: '27 Mai 2025', heureRv: '11:00', lieuRv: 'Lycée Technique', statutRv: 'Annulé', agent: 'Jean M.', commentaire: 'Reporté à une date ultérieure', createdAt: '22 Mai 2025' },
  ];

  const statusRv = ['Planifié', 'Confirmé', 'Effectué', 'Annulé', 'Reporté'];
  
  const getStatusBadge = (status) => {
    const classes = {
      'Planifié': 'badge-info',
      'Confirmé': 'badge-success',
      'Effectué': 'badge-primary',
      'Annulé': 'badge-danger',
      'Reporté': 'badge-warning'
    };
    return <span className={`badge ${classes[status] || 'badge-secondary'}`}>{status}</span>;
  };

  const filteredRendezVous = rendezvous.filter(r => {
    const matchesSearch = r.prospect.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          r.agent.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          r.lieuRv.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === 'all' || r.statutRv === filterStatus;
    return matchesSearch && matchesStatus;
  });

  const totalPages = Math.ceil(filteredRendezVous.length / itemsPerPage);
  const paginatedRendezVous = filteredRendezVous.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => {
    addToast(`Rendez-vous supprimé avec succès`, 'success');
    setDeleteModal({ isOpen: false, rdvId: null, rdvName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucun rendez-vous ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterStatus('all'); }}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, rdvId: null, rdvName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer ce rendez-vous ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Rendez-vous</h1>
          <p className="page-description">Planifiez et suivez les rendez-vous avec les prospects.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/rendezvous/new')}>
          <Plus size={18} />
          Nouveau rendez-vous
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par prospect, agent ou lieu..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
            <option value="all">Tous les statuts</option>
            {statusRv.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>
      </div>

      {filteredRendezVous.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Prospect</th><th>Date/Heure</th><th>Lieu</th><th>Statut</th><th>Agent</th><th>Commentaire</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {paginatedRendezVous.map((rdv) => (
                <tr key={rdv.id}>
                  <td><User size={14} /> {rdv.prospect}</td>
                  <td><Calendar size={14} /> {rdv.dateRv}<br /><Clock size={14} /> {rdv.heureRv}</td>
                  <td><MapPin size={14} /> {rdv.lieuRv}</td>
                  <td>{getStatusBadge(rdv.statutRv)}</td>
                  <td>{rdv.agent}</td>
                  <td><div className="commentaire-cell"><small>{rdv.commentaire}</small></div></td>
                  <td>
                    <div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/rendezvous/${rdv.id}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/rendezvous/edit/${rdv.id}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, rdvId: rdv.id, rdvName: rdv.prospect })}><Trash2 size={16} /></button>
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

export default RendezVousList;
