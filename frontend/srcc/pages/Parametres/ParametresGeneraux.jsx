import React, { useState, useEffect } from 'react';
import { Save, Bell, Palette, Database, Globe, Lock, User, Mail, Phone, Shield, Smartphone, Moon, Sun, Volume2, Settings, Clock, Download, Upload, Trash2, RefreshCw, Key, Server, Eye, EyeOff } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import { useLanguage } from '../../context/LanguageContext';
import '../Prospects/Prospects.css';
import './Parametres.css';

const ParametresGeneraux = () => {
  const { language, changeLanguage } = useLanguage();
  const [toasts, setToasts] = useState([]);
  const [activeTab, setActiveTab] = useState('general');
  const [showPassword, setShowPassword] = useState(false);
  
  // État des paramètres
  const [notifications, setNotifications] = useState(() => {
    const saved = localStorage.getItem('notifications_settings');
    return saved ? JSON.parse(saved) : {
      email: true,
      sms: false,
      push: true,
      relances: true,
      campagnes: true,
      rapports: false
    };
  });
  
  const [apparence, setApparence] = useState(() => {
    const saved = localStorage.getItem('apparence_settings');
    return saved ? JSON.parse(saved) : {
      theme: 'clair',
      animations: true,
      compact: false,
      fontSize: 'medium'
    };
  });
  
  const [profil, setProfil] = useState(() => {
    const saved = localStorage.getItem('user_profile');
    return saved ? JSON.parse(saved) : {
      name: 'Admin ISETAG',
      email: 'admin@isetag.com',
      phone: '691234567',
      role: 'Administrateur'
    };
  });
  
  const [securite, setSecurite] = useState(() => {
    const saved = localStorage.getItem('security_settings');
    return saved ? JSON.parse(saved) : {
      deuxFacteurs: false,
      sessionTimeout: 30,
      ipRestriction: false
    };
  });

  const [passwordData, setPasswordData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: ''
  });
  const [passwordErrors, setPasswordErrors] = useState({});

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  // Sauvegarde automatique dans localStorage
  useEffect(() => {
    localStorage.setItem('notifications_settings', JSON.stringify(notifications));
    localStorage.setItem('apparence_settings', JSON.stringify(apparence));
    localStorage.setItem('user_profile', JSON.stringify(profil));
    localStorage.setItem('security_settings', JSON.stringify(securite));
  }, [notifications, apparence, profil, securite]);

  // Appliquer le thème
  useEffect(() => {
    if (apparence.theme === 'sombre') {
      document.body.classList.add('dark-mode');
    } else {
      document.body.classList.remove('dark-mode');
    }
  }, [apparence.theme]);

  const handleSave = () => {
    addToast('Paramètres enregistrés avec succès', 'success');
  };

  const handleExportData = () => {
    const exportData = {
      profil,
      notifications,
      apparence,
      securite,
      exportDate: new Date().toISOString()
    };
    const dataStr = JSON.stringify(exportData, null, 2);
    const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
    const exportFileDefaultName = `isetag_params_${new Date().toISOString().slice(0, 19).replace(/:/g, '-')}.json`;
    const linkElement = document.createElement('a');
    linkElement.setAttribute('href', dataUri);
    linkElement.setAttribute('download', exportFileDefaultName);
    linkElement.click();
    addToast('Données exportées avec succès', 'success');
  };

  const handleImportData = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        try {
          const importedData = JSON.parse(e.target.result);
          if (importedData.profil) setProfil(importedData.profil);
          if (importedData.notifications) setNotifications(importedData.notifications);
          if (importedData.apparence) setApparence(importedData.apparence);
          if (importedData.securite) setSecurite(importedData.securite);
          addToast('Données importées avec succès', 'success');
        } catch (error) {
          addToast('Erreur lors de l\'importation', 'error');
        }
      };
      reader.readAsText(file);
    }
  };

  const handleResetAll = () => {
    if (window.confirm('Êtes-vous sûr de vouloir réinitialiser tous les paramètres ? Cette action est irréversible.')) {
      setNotifications({ email: true, sms: false, push: true, relances: true, campagnes: true, rapports: false });
      setApparence({ theme: 'clair', animations: true, compact: false, fontSize: 'medium' });
      setProfil({ name: 'Admin ISETAG', email: 'admin@isetag.com', phone: '691234567', role: 'Administrateur' });
      setSecurite({ deuxFacteurs: false, sessionTimeout: 30, ipRestriction: false });
      addToast('Paramètres réinitialisés avec succès', 'success');
    }
  };

  const handleClearCache = () => {
    if (window.confirm('Vider le cache peut améliorer les performances. Continuer ?')) {
      localStorage.removeItem('notifications_settings');
      localStorage.removeItem('apparence_settings');
      localStorage.removeItem('user_profile');
      localStorage.removeItem('security_settings');
      addToast('Cache vidé avec succès', 'success');
      setTimeout(() => window.location.reload(), 1500);
    }
  };

  const handleChangePassword = () => {
    const errors = {};
    if (!passwordData.currentPassword) errors.currentPassword = 'Mot de passe actuel requis';
    if (!passwordData.newPassword) errors.newPassword = 'Nouveau mot de passe requis';
    else if (passwordData.newPassword.length < 6) errors.newPassword = 'Minimum 6 caractères';
    if (passwordData.newPassword !== passwordData.confirmPassword) errors.confirmPassword = 'Les mots de passe ne correspondent pas';
    
    if (Object.keys(errors).length === 0) {
      addToast('Mot de passe modifié avec succès', 'success');
      setPasswordData({ currentPassword: '', newPassword: '', confirmPassword: '' });
      setPasswordErrors({});
    } else {
      setPasswordErrors(errors);
    }
  };

  const tabs = [
    { id: 'general', label: 'Général', icon: <Settings size={18} /> },
    { id: 'profil', label: 'Mon profil', icon: <User size={18} /> },
    { id: 'notifications', label: 'Notifications', icon: <Bell size={18} /> },
    { id: 'apparence', label: 'Apparence', icon: <Palette size={18} /> },
    { id: 'securite', label: 'Sécurité', icon: <Lock size={18} /> },
    { id: 'donnees', label: 'Données', icon: <Database size={18} /> }
  ];

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">Paramètres</h1>
          <p className="page-description">Configurez l'application selon vos préférences.</p>
        </div>
        <button className="btn-primary" onClick={handleSave}>
          <Save size={18} />
          Enregistrer
        </button>
      </div>

      <div className="parametres-container">
        <div className="parametres-sidebar">
          {tabs.map(tab => (
            <button
              key={tab.id}
              className={`parametre-tab ${activeTab === tab.id ? 'active' : ''}`}
              onClick={() => setActiveTab(tab.id)}
            >
              {tab.icon}
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        <div className="parametres-content">
          {/* Onglet Général */}
          {activeTab === 'general' && (
            <div className="parametre-section">
              <h2>Paramètres généraux</h2>
              <p className="section-desc">Configurez les options générales de l'application.</p>
              
              <div className="settings-group">
                <div className="setting-item">
                  <div className="setting-info">
                    <Globe size={20} />
                    <div>
                      <div className="setting-label">Langue par défaut</div>
                      <div className="setting-desc">Définir la langue de l'interface</div>
                    </div>
                  </div>
                  <select 
                    className="setting-select" 
                    value={language}
                    onChange={(e) => changeLanguage(e.target.value)}
                  >
                    <option value="fr">Français</option>
                    <option value="en">English</option>
                  </select>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Smartphone size={20} />
                    <div>
                      <div className="setting-label">Fuseau horaire</div>
                      <div className="setting-desc">Définir le fuseau horaire par défaut</div>
                    </div>
                  </div>
                  <select className="setting-select" defaultValue="Africa/Douala">
                    <option value="Africa/Douala">Afrique/Douala (GMT+1)</option>
                    <option value="Africa/Paris">Afrique/Paris (GMT+1)</option>
                    <option value="UTC">UTC</option>
                  </select>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Database size={20} />
                    <div>
                      <div className="setting-label">Format de date</div>
                      <div className="setting-desc">Choisir le format d'affichage des dates</div>
                    </div>
                  </div>
                  <select className="setting-select" defaultValue="DD/MM/YYYY">
                    <option>DD/MM/YYYY</option>
                    <option>MM/DD/YYYY</option>
                    <option>YYYY-MM-DD</option>
                  </select>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Server size={20} />
                    <div>
                      <div className="setting-label">Version de l'application</div>
                      <div className="setting-desc">Version actuelle du système</div>
                    </div>
                  </div>
                  <span className="version-badge">v2.0.0</span>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Mon profil */}
          {activeTab === 'profil' && (
            <div className="parametre-section">
              <h2>Mon profil</h2>
              <p className="section-desc">Modifiez vos informations personnelles.</p>
              
              <div className="profile-form">
                <div className="profile-avatar">
                  <div className="avatar-large">{profil.name.charAt(0)}</div>
                  <button className="btn-outline-small" onClick={() => addToast('Fonctionnalité à venir', 'info')}>
                    Changer la photo
                  </button>
                </div>
                
                <div className="profile-fields">
                  <div className="field-group">
                    <label>Nom complet</label>
                    <div className="input-icon">
                      <User size={18} />
                      <input type="text" value={profil.name} onChange={(e) => setProfil({...profil, name: e.target.value})} />
                    </div>
                  </div>
                  
                  <div className="field-group">
                    <label>Email</label>
                    <div className="input-icon">
                      <Mail size={18} />
                      <input type="email" value={profil.email} onChange={(e) => setProfil({...profil, email: e.target.value})} />
                    </div>
                  </div>
                  
                  <div className="field-group">
                    <label>Téléphone</label>
                    <div className="input-icon">
                      <Phone size={18} />
                      <input type="tel" value={profil.phone} onChange={(e) => setProfil({...profil, phone: e.target.value})} />
                    </div>
                  </div>
                  
                  <div className="field-group">
                    <label>Rôle</label>
                    <div className="input-icon">
                      <Shield size={18} />
                      <input type="text" value={profil.role} disabled />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Notifications */}
          {activeTab === 'notifications' && (
            <div className="parametre-section">
              <h2>Notifications</h2>
              <p className="section-desc">Personnalisez vos préférences de notifications.</p>
              
              <div className="settings-group">
                <div className="setting-toggle">
                  <div className="setting-info">
                    <Bell size={20} />
                    <div>
                      <div className="setting-label">Notifications email</div>
                      <div className="setting-desc">Recevoir des notifications par email</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={notifications.email} onChange={(e) => setNotifications({...notifications, email: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-toggle">
                  <div className="setting-info">
                    <Smartphone size={20} />
                    <div>
                      <div className="setting-label">Notifications SMS</div>
                      <div className="setting-desc">Recevoir des notifications par SMS</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={notifications.sms} onChange={(e) => setNotifications({...notifications, sms: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-toggle">
                  <div className="setting-info">
                    <Bell size={20} />
                    <div>
                      <div className="setting-label">Notifications push</div>
                      <div className="setting-desc">Recevoir des notifications dans le navigateur</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={notifications.push} onChange={(e) => setNotifications({...notifications, push: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-divider"></div>

                <div className="setting-toggle">
                  <div className="setting-info">
                    <Bell size={20} />
                    <div>
                      <div className="setting-label">Alertes relances</div>
                      <div className="setting-desc">Recevoir les alertes pour les relances</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={notifications.relances} onChange={(e) => setNotifications({...notifications, relances: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-toggle">
                  <div className="setting-info">
                    <Bell size={20} />
                    <div>
                      <div className="setting-label">Rapports périodiques</div>
                      <div className="setting-desc">Recevoir les rapports par email</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={notifications.rapports} onChange={(e) => setNotifications({...notifications, rapports: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Apparence */}
          {activeTab === 'apparence' && (
            <div className="parametre-section">
              <h2>Apparence</h2>
              <p className="section-desc">Personnalisez l'apparence de l'application.</p>
              
              <div className="theme-options">
                <div className={`theme-card ${apparence.theme === 'clair' ? 'selected' : ''}`} onClick={() => setApparence({...apparence, theme: 'clair'})}>
                  <Sun size={24} />
                  <span>Clair</span>
                </div>
                <div className={`theme-card ${apparence.theme === 'sombre' ? 'selected' : ''}`} onClick={() => setApparence({...apparence, theme: 'sombre'})}>
                  <Moon size={24} />
                  <span>Sombre</span>
                </div>
              </div>

              <div className="settings-group">
                <div className="setting-toggle">
                  <div className="setting-info">
                    <Palette size={20} />
                    <div>
                      <div className="setting-label">Animations</div>
                      <div className="setting-desc">Activer les animations de l'interface</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={apparence.animations} onChange={(e) => setApparence({...apparence, animations: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-toggle">
                  <div className="setting-info">
                    <Database size={20} />
                    <div>
                      <div className="setting-label">Mode compact</div>
                      <div className="setting-desc">Réduire l'espacement des éléments</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={apparence.compact} onChange={(e) => setApparence({...apparence, compact: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Volume2 size={20} />
                    <div>
                      <div className="setting-label">Taille de police</div>
                      <div className="setting-desc">Ajuster la taille du texte</div>
                    </div>
                  </div>
                  <select className="setting-select" value={apparence.fontSize} onChange={(e) => setApparence({...apparence, fontSize: e.target.value})}>
                    <option value="small">Petite</option>
                    <option value="medium">Moyenne</option>
                    <option value="large">Grande</option>
                  </select>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Sécurité */}
          {activeTab === 'securite' && (
            <div className="parametre-section">
              <h2>Sécurité</h2>
              <p className="section-desc">Configurez les options de sécurité.</p>
              
              <div className="settings-group">
                <div className="setting-toggle">
                  <div className="setting-info">
                    <Lock size={20} />
                    <div>
                      <div className="setting-label">Authentification à deux facteurs</div>
                      <div className="setting-desc">Renforcer la sécurité de votre compte</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={securite.deuxFacteurs} onChange={(e) => setSecurite({...securite, deuxFacteurs: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-toggle">
                  <div className="setting-info">
                    <Shield size={20} />
                    <div>
                      <div className="setting-label">Restriction IP</div>
                      <div className="setting-desc">Limiter l'accès à certaines IP</div>
                    </div>
                  </div>
                  <label className="toggle-switch">
                    <input type="checkbox" checked={securite.ipRestriction} onChange={(e) => setSecurite({...securite, ipRestriction: e.target.checked})} />
                    <span className="toggle-slider"></span>
                  </label>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Clock size={20} />
                    <div>
                      <div className="setting-label">Délai d'inactivité</div>
                      <div className="setting-desc">Déconnexion automatique après (minutes)</div>
                    </div>
                  </div>
                  <select className="setting-select" value={securite.sessionTimeout} onChange={(e) => setSecurite({...securite, sessionTimeout: parseInt(e.target.value)})}>
                    <option value="15">15 minutes</option>
                    <option value="30">30 minutes</option>
                    <option value="60">1 heure</option>
                    <option value="120">2 heures</option>
                  </select>
                </div>

                <div className="password-change-section">
                  <h4>Changer le mot de passe</h4>
                  <div className="password-fields">
                    <div className="field-group">
                      <label>Mot de passe actuel</label>
                      <div className="input-icon">
                        <Key size={18} />
                        <input 
                          type={showPassword ? "text" : "password"} 
                          value={passwordData.currentPassword}
                          onChange={(e) => setPasswordData({...passwordData, currentPassword: e.target.value})}
                          className={passwordErrors.currentPassword ? 'error' : ''}
                        />
                        <button type="button" className="password-toggle" onClick={() => setShowPassword(!showPassword)}>
                          {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                        </button>
                      </div>
                      {passwordErrors.currentPassword && <span className="error-message">{passwordErrors.currentPassword}</span>}
                    </div>
                    <div className="field-group">
                      <label>Nouveau mot de passe</label>
                      <div className="input-icon">
                        <Key size={18} />
                        <input 
                          type={showPassword ? "text" : "password"} 
                          value={passwordData.newPassword}
                          onChange={(e) => setPasswordData({...passwordData, newPassword: e.target.value})}
                          className={passwordErrors.newPassword ? 'error' : ''}
                        />
                      </div>
                      {passwordErrors.newPassword && <span className="error-message">{passwordErrors.newPassword}</span>}
                    </div>
                    <div className="field-group">
                      <label>Confirmer le mot de passe</label>
                      <div className="input-icon">
                        <Key size={18} />
                        <input 
                          type={showPassword ? "text" : "password"} 
                          value={passwordData.confirmPassword}
                          onChange={(e) => setPasswordData({...passwordData, confirmPassword: e.target.value})}
                          className={passwordErrors.confirmPassword ? 'error' : ''}
                        />
                      </div>
                      {passwordErrors.confirmPassword && <span className="error-message">{passwordErrors.confirmPassword}</span>}
                    </div>
                    <button className="btn-outline" onClick={handleChangePassword}>
                      <Key size={16} />
                      Changer le mot de passe
                    </button>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Données */}
          {activeTab === 'donnees' && (
            <div className="parametre-section">
              <h2>Données</h2>
              <p className="section-desc">Gérez vos données et sauvegardes.</p>
              
              <div className="settings-group">
                <div className="data-actions">
                  <button className="btn-outline" onClick={handleExportData}>
                    <Download size={16} />
                    Exporter les données
                  </button>
                  <label className="btn-outline" style={{ cursor: 'pointer' }}>
                    <Upload size={16} />
                    Importer les données
                    <input type="file" accept=".json" style={{ display: 'none' }} onChange={handleImportData} />
                  </label>
                </div>

                <div className="setting-divider"></div>

                <div className="danger-zone">
                  <h4>Zone dangereuse</h4>
                  <p>Ces actions sont irréversibles.</p>
                  <div className="danger-actions">
                    <button className="btn-danger" onClick={handleClearCache}>
                      <Trash2 size={16} />
                      Vider le cache
                    </button>
                    <button className="btn-danger" onClick={handleResetAll}>
                      <RefreshCw size={16} />
                      Réinitialiser les paramètres
                    </button>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ParametresGeneraux;
