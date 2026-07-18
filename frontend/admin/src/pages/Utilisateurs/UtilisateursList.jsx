import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { Plus, Search, Edit, Eye, Trash2, Filter, Download, AlertCircle, User, Shield, Calendar, CheckCircle, XCircle, Mail, Phone, Users } from 'lucide-react';
import Modal from '../../components/common/Modal';
import { ToastContainer } from '../../components/common/Toast';
import Pagination from '../../components/Pagination/Pagination';
import { usePagination } from '../../hooks/usePagination';
import { useTranslation } from '../../hooks/useTranslation';
import { userService } from '../../services/userService';
import { SkeletonTable } from '../../components/Skeleton/Skeleton';
import { User as UserModel } from '../../models/User';
import '../Prospects/Prospects.css';
import './Utilisateurs.css';

const UtilisateursList = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [filterRole, setFilterRole] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [deleteModal, setDeleteModal] = useState({ isOpen: false, userId: null, userName: '' });
  const [toasts, setToasts] = useState([]);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);
  const [total, setTotal] = useState(0);

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  // Il ne supporte aucun filtre côté serveur (search/role/statut) pour
  // l'instant, donc on récupère tout et on filtre côté client.
  
  const fetchUsers = useCallback(async () => {
    setLoading(true);
    try {
      const data = await userService.getAll();
      const allUsers = Array.isArray(data) ? data.map(item => UserModel.fromDjango(item)) : [];

      const filtered = allUsers.filter((u) => {
        const matchesSearch =
          !searchTerm ||
          u.fullName.toLowerCase().includes(searchTerm.toLowerCase()) ||
          u.email.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesRole = filterRole === 'all' || u.role === filterRole;
        const matchesStatus =
          filterStatus === 'all' ||
          (filterStatus === 'actif' && u.isActive) ||
          (filterStatus === 'inactif' && !u.isActive);
        return matchesSearch && matchesRole && matchesStatus;
      });

      setUsers(filtered);
      setTotal(filtered.length);
    } catch (error) {
      addToast('Erreur lors du chargement des utilisateurs', 'error');
      console.error(error);
    } finally {
      setLoading(false);
    }
  }, [searchTerm, filterRole, filterStatus]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const { currentPage, totalPages, paginatedItems, goToPage, itemsPerPage } = usePagination(users, 10);

  const roles = ['Administrateur', 'Manager', 'Agent', 'Viewer'];
  
  const getRoleBadge = (role) => {
    const classes = { 
      'Administrateur': 'badge-danger', 
      'Manager': 'badge-warning', 
      'Agent': 'badge-info', 
      'Viewer': 'badge-secondary' 
    };
    return <span className={`badge ${classes[role] || 'badge-secondary'}`}>{role}</span>;
  };

  const getRoleIcon = (role) => {
    switch(role) {
      case 'Administrateur': return <Shield size={14} />;
      default: return <User size={14} />;
    }
  };

  const handleDelete = async () => {
    // On capture l'id et le nom localement AVANT de fermer la modale,
    // pour ne jamais dépendre de deleteModal après ce point (qui sera
    // remis à null juste en dessous). Ça évite qu'un second appel,
    // déclenché par un double-clic ou un re-render, parte avec userId=null.
    const { userId, userName } = deleteModal;
    if (!userId) return;

    // Fermer la modale immédiatement empêche aussi un second clic sur
    // "Confirmer" pendant que la requête réseau est encore en cours.
    setDeleteModal({ isOpen: false, userId: null, userName: '' });

    try {
      await userService.delete(userId);
      addToast(`Utilisateur "${userName}" supprimé avec succès`, 'success');
      fetchUsers();
    } catch (error) {
      addToast('Erreur lors de la suppression', 'error');
    }
  };

  const renderNoResults = () => (
    <div className="no-results">
      <AlertCircle size={48} />
      <h3>Aucun résultat trouvé</h3>
      <p>Aucun utilisateur ne correspond à votre recherche</p>
      <button className="btn-outline" onClick={() => { setSearchTerm(''); setFilterRole('all'); setFilterStatus('all'); }}>
        Effacer les filtres
      </button>
    </div>
  );

  if (loading) {
    return (
      <div className="page-container">
        <SkeletonTable rows={6} columns={6} />
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <Modal 
        isOpen={deleteModal.isOpen} 
        onClose={() => setDeleteModal({ isOpen: false, userId: null, userName: '' })} 
        onConfirm={handleDelete} 
        title="Confirmer la suppression" 
        message={`Supprimer l'utilisateur "${deleteModal.userName}" ?`} 
        confirmText="Supprimer" 
        type="warning" 
      />

      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Utilisateurs</h1>
          <p className="page-description">Gérez les accès et les permissions des utilisateurs.</p>
        </div>
        <button className="btn-primary" onClick={() => navigate('/utilisateurs/new')}>
          <Plus size={18} /> Nouvel utilisateur
        </button>
      </div>

      <div className="filters-bar">
        <div className="search-box">
          <Search size={18} />
          <input 
            type="text" 
            placeholder="Rechercher un utilisateur..." 
            value={searchTerm} 
            onChange={(e) => setSearchTerm(e.target.value)} 
          />
        </div>
        <div className="filter-group">
          <Filter size={18} />
          <select value={filterRole} onChange={(e) => setFilterRole(e.target.value)}>
            <option value="all">Tous les rôles</option>
            {roles.map(r => <option key={r} value={r}>{r}</option>)}
          </select>
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

      {users.length === 0 ? renderNoResults() : (
        <>
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Utilisateur</th>
                  <th>Contact</th>
                  <th>Rôle</th>
                  <th>Date création</th>
                  <th>Statut</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedItems.map((user) => (
                  <tr key={user.id}>
                    <td>
                      <div className="user-cell">
                        <div className="user-avatar">
                          {user.photoProfil ? (
                            <img src={user.photoProfil} alt={user.fullName} />
                          ) : (
                            user.initials
                          )}
                        </div>
                        <div>
                          <strong>{user.fullName}</strong>
                          {/* <small>{user.email}</small> */}
                        </div>
                      </div>
                    </td>
                    <td>
                      <div><Mail size={12} /> {user.email}</div>
                      <small><Phone size={10} /> {user.telephone}</small>
                    </td>
                    <td>
                      <div className="role-badge">
                        {getRoleIcon(user.role)}
                        {getRoleBadge(user.role)}
                      </div>
                    </td>
                    <td>{user.dateEmbauche || user.createdAt || '-'}</td>
                    <td>
                      <span className={`badge ${user.isActive ? 'badge-success' : 'badge-secondary'}`}>
                        {user.isActive ? 'Actif' : 'Inactif'}
                      </span>
                    </td>
                    <td>
                      <div className="action-buttons">
                        <button className="action-btn view" onClick={() => navigate(`/utilisateurs/${user.id}`)}>
                          <Eye size={16} />
                        </button>
                        <button className="action-btn edit" onClick={() => navigate(`/utilisateurs/edit/${user.id}`)}>
                          <Edit size={16} />
                        </button>
                        <button className="action-btn delete" onClick={() => setDeleteModal({ isOpen: true, userId: user.id, userName: user.fullName })}>
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
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
            totalItems={users.length}
          />
        </>
      )}
    </div>
  );
};

export default UtilisateursList;