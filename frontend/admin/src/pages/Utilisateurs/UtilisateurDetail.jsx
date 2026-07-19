import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Edit, Mail, Phone, Shield, User as UserIcon, Calendar, Clock, Loader, AlertCircle } from 'lucide-react';
import { useTranslation } from '../../hooks/useTranslation';
import { userService } from '../../services/userService';
import { User } from '../../models/User';
import { ToastContainer } from '../../components/common/Toast';
import { getErrorMessage } from '../../utils/errorMessages';
import '../Prospects/Prospects.css';

//  CORRIGÉ : cette page affichait un utilisateur 100% inventé (mock),
// aucun appel API. Elle charge maintenant le vrai utilisateur via
// GET /user_api/ISETAG_COM.users/{id}/.
//
// Les sections "Permissions" et "Dernières activités" du mock ont été
// retirées : l'API renvoie bien `groups`/`user_permissions`, mais ce sont
// des tableaux d'IDs Django bruts (pas de libellés), et il n'existe aucun
// endpoint pour les résoudre ni pour lister l'activité d'un utilisateur.
// Plutôt que d'inventer ces données, on affiche uniquement les champs
// réels du modèle Utilisateur.

const formatDate = (iso) => {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' });
};

const formatDateTime = (iso) => {
  if (!iso) return 'Jamais connecté';
  return new Date(iso).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric', hour: '2-digit', minute: '2-digit' });
};

const roleBadgeClasses = {
  Administrateur: 'badge-danger',
  ADMINISTRATEUR: 'badge-danger',
  Manager: 'badge-warning',
  MANAGER: 'badge-warning',
  Superviseur: 'badge-warning',
  SUPERVISEUR: 'badge-warning',
  Agent: 'badge-info',
  AGENT_COMMERCIAL: 'badge-info',
  Viewer: 'badge-secondary',
};

const UtilisateurDetail = () => {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const { id } = useParams();

  const [user, setUser] = useState(null);
  const [rawData, setRawData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [toasts, setToasts] = useState([]);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts((prev) => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (toastId) => {
    setToasts((prev) => prev.filter((toast) => toast.id !== toastId));
  };

  useEffect(() => {
    const fetchUser = async () => {
      setLoading(true);
      setError(null);
      try {
        const raw = await userService.getById(id);
        const data = Array.isArray(raw) ? raw[0] : raw;
        setRawData(data);
        setUser(User.fromDjango(data));
      } catch (err) {
        console.error(' Erreur de chargement:', err);
        setError(getErrorMessage(err, t));
        addToast(getErrorMessage(err, t), 'error');
      } finally {
        setLoading(false);
      }
    };
    fetchUser();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  if (loading) {
    return (
      <div className="page-container">
        <ToastContainer toasts={toasts} removeToast={removeToast} />
        <div className="loading-container"><Loader size={48} className="spin" /><p>Chargement de l'utilisateur...</p></div>
      </div>
    );
  }

  if (error || !user) {
    return (
      <div className="page-container">
        <ToastContainer toasts={toasts} removeToast={removeToast} />
        <div className="error-container">
          <AlertCircle size={48} color="#ef4444" />
          <h3>Erreur de chargement</h3>
          <p>{error || 'Utilisateur introuvable'}</p>
          <button className="btn-outline" onClick={() => navigate('/utilisateurs')}>Retour à la liste</button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Détail de l'utilisateur</h1>
          <p className="page-description">Consultez les informations de l'utilisateur.</p>
        </div>
        <div className="header-buttons">
          <button className="btn-outline" onClick={() => navigate('/utilisateurs')}>
            <ArrowLeft size={18} /> Retour
          </button>
          <button className="btn-primary" onClick={() => navigate(`/utilisateurs/edit/${id}`)}>
            <Edit size={18} /> Modifier
          </button>
        </div>
      </div>

      <div className="detail-grid">
        <div className="detail-card">
          <div className="detail-header">
            <div className="detail-avatar" style={{ background: 'linear-gradient(135deg, #1a5c2a, #2d7a3a)', color: 'white', fontSize: '28px' }}>
              {user.initials}
            </div>
            <div>
              <h2>{user.fullName}</h2>
              <span className={`badge ${roleBadgeClasses[user.role] || 'badge-secondary'}`}>
                {user.displayRole}
              </span>{' '}
              <span className={`badge ${user.isActive ? 'badge-success' : 'badge-secondary'}`}>
                {user.isActive ? 'Actif' : 'Inactif'}
              </span>
            </div>
          </div>
          <div className="detail-info">
            <div className="info-row"><Mail size={18} /><span>{user.email || '—'}</span></div>
            <div className="info-row"><Phone size={18} /><span>{user.telephone || '—'}</span></div>
            {user.username && (
              <div className="info-row"><UserIcon size={18} /><span>Identifiant : {user.username}</span></div>
            )}
            {user.is_superuser && (
              <div className="info-row"><Shield size={18} /><span>Super-utilisateur</span></div>
            )}
            <div className="info-row"><Calendar size={18} /><span>Membre depuis : {formatDate(user.dateEmbauche || rawData?.date_joined || user.createdAt)}</span></div>
            <div className="info-row"><Clock size={18} /><span>Dernière connexion : {formatDateTime(rawData?.last_login)}</span></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UtilisateurDetail;