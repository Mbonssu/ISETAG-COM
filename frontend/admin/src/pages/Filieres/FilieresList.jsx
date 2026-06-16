import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Trash2, Filter, Download, AlertCircle, GraduationCap, Users, TrendingUp, BookOpen } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import '../Prospects/Prospects.css';

const FilieresList = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, filiereId: null, filiereName: '' });
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const filieres = [
    { id: 1, name: 'Génie Logiciel', code: 'GL', prospects: 399, pourcentage: 32, specialites: ['Développement Web', 'Mobile', 'IA'], actif: true },
    { id: 2, name: 'Génie Civil', code: 'GC', prospects: 249, pourcentage: 20, specialites: ['BTP', 'Architecture', 'Matériaux'], actif: true },
    { id: 3, name: 'Marketing', code: 'MK', prospects: 224, pourcentage: 18, specialites: ['Digital', 'Communication', 'Vente'], actif: true },
    { id: 4, name: 'Réseaux & Télécoms', code: 'RT', prospects: 150, pourcentage: 12, specialites: ['Cybersécurité', 'Cloud', '5G'], actif: true },
    { id: 5, name: 'Architecture', code: 'AR', prospects: 100, pourcentage: 8, specialites: ['Design', 'Urbanisme', '3D'], actif: true },
    { id: 6, name: 'Comptabilité', code: 'CG', prospects: 76, pourcentage: 6, specialites: ['Audit', 'Fiscalité', 'Gestion'], actif: false },
    { id: 7, name: 'Ressources Humaines', code: 'RH', prospects: 50, pourcentage: 4, specialites: ['Recrutement', 'Paie', 'Formation'], actif: true },
    { id: 8, name: 'Logistique', code: 'LG', prospects: 45, pourcentage: 3.6, specialites: ['Transport', 'Supply Chain'], actif: true },
  ];

  const filteredFilieres = filieres.filter(f => f.name.toLowerCase().includes(searchTerm.toLowerCase()) || f.code.toLowerCase().includes(searchTerm.toLowerCase()));
  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(filteredFilieres, 10);

  const handleDelete = () => {
    addToast(`Filière "${deleteModal.filiereName}" supprimée avec succès`, 'success');
    setDeleteModal({ isOpen: false, filiereId: null, filiereName: '' });
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucune filière ne correspond à votre recherche "{searchTerm}"</p>
      <button className="btn-outline" onClick={() => setSearchTerm('')}>Effacer les filtres</button>
    </div>
  );

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal isOpen={deleteModal.isOpen} onClose={() => setDeleteModal({ isOpen: false, filiereId: null, filiereName: '' })} onConfirm={handleDelete} title="Confirmer la suppression" message={`Supprimer la filière "${deleteModal.filiereName}" ?`} confirmText="Supprimer" type="warning" />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Filières & Spécialités</h1>
          <p className="page-description">Gérez les filières de formation et leurs spécialités.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/filieres/new')}>
          <Plus size={18} /> Nouvelle filière
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input type="text" placeholder="Rechercher une filière..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        </div>
      </div>

      {filteredFilieres.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr><th>Code</th><th>Filière</th><th>Spécialités</th><th>Prospects</th><th>Part</th><th>Statut</th><th>Actions</th></tr>
              </thead>
              <tbody>
                {paginatedItems.map((filiere) => (
                  <tr key={filiere.id}>
                    <td><span className="code-badge">{filiere.code}</span></td>
                    <td><strong>{filiere.name}</strong></td>
                    <td><div className="specialites-list">{filiere.specialites.slice(0, 2).map((s, i) => <span key={i} className="specialite-tag">{s}</span>)}{filiere.specialites.length > 2 && <span className="specialite-tag more">+{filiere.specialites.length - 2}</span>}</div></td>
                    <td className="text-center">{filiere.prospects}</td>
                    <td className="text-center"><div className="progress-bar-small"><div className="progress-fill-small" style={{ width: `${filiere.pourcentage}%` }}></div><span>{filiere.pourcentage}%</span></div></td>
                    <td><span className={`badge ${filiere.actif ? 'badge-success' : 'badge-secondary'}`}>{filiere.actif ? 'Actif' : 'Inactif'}</span></td>
                    <td><div className="action-buttons"><button className="action-btn edit" onClick={() => navigate(`/filieres/edit/${filiere.id}`)}><Edit size={16} /></button><button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, filiereId: filiere.id, filiereName: filiere.name })}><Trash2 size={16} /></button></div></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <Pagination 
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={goToPage}
            itemsPerPage={itemsPerPage}
            totalItems={filteredFilieres.length}
          />
        </>
      )}
    </div>
  );
};

export default FilieresList;
