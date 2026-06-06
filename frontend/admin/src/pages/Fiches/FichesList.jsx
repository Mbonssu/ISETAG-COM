import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Eye, Filter, Download, ChevronLeft, ChevronRight, AlertCircle, FileText, Calendar, User, Star, TrendingUp } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';

const FichesList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, ficheId: null, ficheName: '' });
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

  const fiches = [
    { id: 1, prospect: 'Marie L.', source: 'Lycée', dateCollecte: '25 Mai 2025', scoreInteret: 85, commentaire: 'Très intéressée par la formation', campagne: 'Campagne Mai 2025', agent: 'Jean M.', createdAt: '25 Mai 2025' },
    { id: 2, prospect: 'David P.', source: 'Terrain', dateCollecte: '24 Mai 2025', scoreInteret: 70, commentaire: 'À suivre de près', campagne: 'Campagne Lycées', agent: 'David P.', createdAt: '24 Mai 2025' },
    { id: 3, prospect: 'Anne S.', source: 'Passage institut', dateCollecte: '23 Mai 2025', scoreInteret: 95, commentaire: 'Prospect très chaud', campagne: 'Campagne Réseaux Sociaux', agent: 'Sophie A.', createdAt: '23 Mai 2025' },
  ];

  const getScoreColor = (score) => {
    if (score >= 80) return '#10b981';
    if (score >= 60) return '#f59e0b';
    return '#ef4444';
  };

  const getScoreLabel = (score) => {
    if (score >= 80) return 'Très intéressé';
    if (score >= 60) return 'Intéressé';
    if (score >= 40) return 'Moyennement intéressé';
    return 'Peu intéressé';
  };

  const filteredFiches = fiches.filter(f => {
    const matchesSearch = f.prospect.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          f.source.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          f.agent.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesSearch;
  });

  const totalPages = Math.ceil(filteredFiches.length / itemsPerPage);
  const paginatedFiches = filteredFiches.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  const handleDelete = () => {
    addToast(`Fiche supprimée avec succès`, 'success');
    setDeleteModal({ isOpen: false, ficheId: null, ficheName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>{t('aucunResultat')}</h3>
      <p>Aucune fiche ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>{t('effacerFiltres')}</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, ficheId: null, ficheName: '' })} onConfirm={handleDelete} title={t('confirmer')} message="Êtes-vous sûr de vouloir supprimer cette fiche ?" confirmText={t('supprimer')} type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Gestion des Fiches</h1>
          <p className="page-description">Consultez les fiches de collecte d'informations des prospects.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/fiches/new')}>
          <Plus size={18} />
          Nouvelle fiche
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher par prospect, source ou agent..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
      </div>

      {filteredFiches.length === 0 ? renderNoResults() : (
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Prospect</th><th>Source</th><th>Date collecte</th><th>Score d'intérêt</th><th>Commentaire</th><th>Campagne</th><th>Agent</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {paginatedFiches.map((fiche) => (
                <tr key={fiche.id}>
                  <td><User size={14} /> {fiche.prospect}</td>
                  <td>{fiche.source}</td>
                  <td><Calendar size={14} /> {fiche.dateCollecte}</td>
                  <td>
                    <div className="score-cell">
                      <div className="score-value" style={{ color: getScoreColor(fiche.scoreInteret) }}>
                        <Star size={14} /> {fiche.scoreInteret}%
                      </div>
                      <small>{getScoreLabel(fiche.scoreInteret)}</small>
                    </div>
                  </td>
                  <td><div className="commentaire-cell"><small>{fiche.commentaire}</small></div></td>
                  <td>{fiche.campagne}</td>
                  <td>{fiche.agent}</td>
                  <td>
                    <div className="action-buttons">
                      <button className="action-btn view" onClick={() => navigate(`/fiches/${fiche.id}`)}><Eye size={16} /></button>
                      <button className="action-btn edit" onClick={() => navigate(`/fiches/edit/${fiche.id}`)}><Edit size={16} /></button>
                      <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, ficheId: fiche.id, ficheName: fiche.prospect })}><Trash2 size={16} /></button>
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

export default FichesList;
