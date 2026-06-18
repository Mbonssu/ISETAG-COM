import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Save, ArrowLeft, AlertCircle, Calendar, MessageSquare, User, Clock, Loader } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { suiviService } from '../../services/suiviService';
import { prospectService } from '../../services/prospectService';
import { userService } from '../../services/userService';
import '../Prospects/Prospects.css';

const SuivisForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;
  const [loading, setLoading] = useState(false);
  const [loadingData, setLoadingData] = useState(true);
  const [toasts, setToasts] = useState([]);
  const [errors, setErrors] = useState({});
  const [prospects, setProspects] = useState([]);
  const [agents, setAgents] = useState([]);

  const addToast = (message, type = 'success') => {
    const toastId = Date.now();
    setToasts(prev => [...prev, { id: toastId, message, type }]);
    setTimeout(() => removeToast(toastId), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const [formData, setFormData] = useState({
    idProspect: '',
    dateSuivi: '',
    typeSuivi: 'Appel',
    commentaire: '',
    prochainAction: '',
    idAgent: '',
    statut: 'En attente'
  });

  const typesSuivi = ['Appel', 'Email', 'Visite', 'SMS', 'Autre'];
  const statuts = ['En attente', 'Effectué', 'Annulé', 'Reporté'];

  // Charger les prospects et les agents depuis l'API
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoadingData(true);
        
        // Charger les prospects
        const prospectsData = await prospectService.getAll();
        console.log('📥 Prospects chargés:', prospectsData);
        // S'assurer que c'est un tableau
        const prospectsList = Array.isArray(prospectsData) ? prospectsData : [];
        setProspects(prospectsList);

        // Charger tous les utilisateurs
        const usersData = await userService.getAll();
        console.log('📥 Utilisateurs chargés:', usersData);
        
        // Filtrer les utilisateurs avec le rôle AGENT_COMMERCIAL
        const usersList = Array.isArray(usersData) ? usersData : [];
        const agentsList = usersList.filter(u => u.role === 'AGENT_COMMERCIAL' || u.role === 'Agent');
        console.log('📥 Agents filtrés:', agentsList);
        setAgents(agentsList);

        // Si c'est une édition, charger les données du suivi
        if (isEdit && id) {
          const suiviData = await suiviService.getById(id);
          console.log('📥 Suivi à modifier:', suiviData);
          setFormData({
            idProspect: suiviData.idProspect || '',
            dateSuivi: suiviData.dateSuivi || '',
            typeSuivi: suiviData.typeSuivi || 'Appel',
            commentaire: suiviData.commentaire || '',
            prochainAction: suiviData.prochainAction || '',
            idAgent: suiviData.idAgent || '',
            statut: suiviData.statut || 'En attente'
          });
        }
      } catch (error) {
        console.error('❌ Erreur de chargement:', error);
        addToast('Erreur lors du chargement des données', 'error');
      } finally {
        setLoadingData(false);
      }
    };

    fetchData();
  }, [id, isEdit]);

  const validateForm = () => {
    const newErrors = {};
    if (!formData.idProspect) newErrors.idProspect = 'Veuillez sélectionner un prospect';
    if (!formData.dateSuivi) newErrors.dateSuivi = 'La date est requise';
    if (!formData.typeSuivi) newErrors.typeSuivi = 'Le type de suivi est requis';
    if (!formData.idAgent) newErrors.idAgent = 'Veuillez sélectionner un agent';
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    if (errors[e.target.name]) {
      setErrors({ ...errors, [e.target.name]: '' });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) {
      addToast('Veuillez corriger les erreurs dans le formulaire', 'error');
      return;
    }

    setLoading(true);
    try {
      const data = {
        idProspect: formData.idProspect,
        dateSuivi: formData.dateSuivi,
        typeSuivi: formData.typeSuivi,
        commentaire: formData.commentaire || '',
        prochainAction: formData.prochainAction || '',
        idAgent: formData.idAgent,
        statut: formData.statut || 'En attente'
      };

      console.log('📤 Envoi des données:', data);

      if (isEdit) {
        await suiviService.update(id, data);
        addToast('Suivi modifié avec succès', 'success');
      } else {
        await suiviService.create(data);
        addToast('Suivi créé avec succès', 'success');
      }

      setTimeout(() => navigate('/suivis'), 1500);
    } catch (error) {
      console.error('❌ Erreur:', error);
      addToast(error.message || 'Erreur lors de l\'enregistrement', 'error');
    } finally {
      setLoading(false);
    }
  };

  // Fonction pour obtenir le nom complet d'un prospect
  const getProspectName = (prospect) => {
    if (!prospect) return 'Prospect inconnu';
    const nom = prospect.nom || '';
    const prenom = prospect.prenom || '';
    return `${nom} ${prenom}`.trim() || prospect.email || prospect.telephone || 'Prospect inconnu';
  };

  // Fonction pour obtenir le nom complet d'un agent
  const getAgentName = (agent) => {
    if (!agent) return 'Agent inconnu';
    const nom = agent.nom || '';
    const prenom = agent.prenom || '';
    return `${nom} ${prenom}`.trim() || agent.email || agent.username || 'Agent inconnu';
  };

  if (loadingData) {
    return (
      <div className="page-container">
        <div className="loading-container">
          <Loader size={48} className="spin" />
          <p>Chargement...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{isEdit ? 'Modifier le suivi' : 'Nouveau suivi'}</h1>
          <p className="page-description">
            {isEdit ? 'Modifiez les informations du suivi.' : 'Ajoutez un nouveau suivi pour un prospect.'}
          </p>
        </div>
        <button className="btn-outline" onClick={() => navigate('/suivis')}>
          <ArrowLeft size={18} />
          Retour à la liste
        </button>
      </div>

      <form onSubmit={handleSubmit} className="form-container">
        <div className="form-grid">
          {/* Prospect */}
          <div className="form-group">
            <label>Prospect <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select 
                name="idProspect" 
                value={formData.idProspect} 
                onChange={handleChange} 
                className={errors.idProspect ? 'error' : ''}
              >
                <option value="">Sélectionner un prospect</option>
                {prospects.map(p => {
                  const id = p.idProspect || p.id;
                  const name = getProspectName(p);
                  return (
                    <option key={id} value={id}>
                      {name}
                    </option>
                  );
                })}
              </select>
            </div>
            {errors.idProspect && <span className="error-message"><AlertCircle size={12} /> {errors.idProspect}</span>}
          </div>

          {/* Date de suivi */}
          <div className="form-group">
            <label>Date de suivi <span className="required">*</span></label>
            <div className="input-icon">
              <Calendar size={18} />
              <input 
                type="date" 
                name="dateSuivi" 
                value={formData.dateSuivi} 
                onChange={handleChange} 
                className={errors.dateSuivi ? 'error' : ''} 
              />
            </div>
            {errors.dateSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.dateSuivi}</span>}
          </div>

          {/* Type de suivi */}
          <div className="form-group">
            <label>Type de suivi <span className="required">*</span></label>
            <div className="input-icon">
              <MessageSquare size={18} />
              <select 
                name="typeSuivi" 
                value={formData.typeSuivi} 
                onChange={handleChange} 
                className={errors.typeSuivi ? 'error' : ''}
              >
                {typesSuivi.map(t => <option key={t} value={t}>{t}</option>)}
              </select>
            </div>
            {errors.typeSuivi && <span className="error-message"><AlertCircle size={12} /> {errors.typeSuivi}</span>}
          </div>

          {/* Agent responsable */}
          <div className="form-group">
            <label>Agent responsable <span className="required">*</span></label>
            <div className="input-icon">
              <User size={18} />
              <select 
                name="idAgent" 
                value={formData.idAgent} 
                onChange={handleChange} 
                className={errors.idAgent ? 'error' : ''}
              >
                <option value="">Sélectionner un agent</option>
                {agents.map(a => {
                  const id = a.idUtilisateur || a.id;
                  const name = getAgentName(a);
                  return (
                    <option key={id} value={id}>
                      {name}
                    </option>
                  );
                })}
              </select>
            </div>
            {errors.idAgent && <span className="error-message"><AlertCircle size={12} /> {errors.idAgent}</span>}
          </div>

          {/* Statut */}
          <div className="form-group">
            <label>Statut</label>
            <div className="input-icon">
              <Clock size={18} />
              <select 
                name="statut" 
                value={formData.statut} 
                onChange={handleChange}
              >
                {statuts.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
          </div>

          {/* Commentaire */}
          <div className="form-group full-width">
            <label>Commentaire</label>
            <textarea 
              name="commentaire" 
              rows="3" 
              value={formData.commentaire} 
              onChange={handleChange} 
              placeholder="Détails du suivi..." 
            />
          </div>

          {/* Prochaine action */}
          <div className="form-group full-width">
            <label>Prochaine action</label>
            <div className="input-icon">
              <Clock size={18} />
              <input 
                type="text" 
                name="prochainAction" 
                value={formData.prochainAction} 
                onChange={handleChange} 
                placeholder="Ex: Rappeler dans 3 jours" 
              />
            </div>
          </div>
        </div>

        <div className="form-actions">
          <button type="button" className="btn-outline" onClick={() => navigate('/suivis')}>
            Annuler
          </button>
          <button type="submit" className="btn-primary" disabled={loading}>
            <Save size={18} />
            {loading ? 'Enregistrement...' : (isEdit ? 'Mettre à jour' : 'Créer le suivi')}
          </button>
        </div>
      </form>
    </div>
  );
};

export default SuivisForm;
