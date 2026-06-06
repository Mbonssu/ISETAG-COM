import React, { useState } from 'react';
import { Save, Bell, Palette, Database, Globe, Lock, User, Mail, Phone, Shield, Smartphone, Moon, Sun, Volume2, VolumeX, Settings, Clock, Download, Upload, Trash2, RefreshCw, Key } from 'lucide-react';
import { ToastContainer } from '../../components/common/Toast';
import { useTranslation } from '../../hooks/useTranslation';
import '../Prospects/Prospects.css';
import './Parametres.css';

const ParametresGeneraux = () => {
  const { t } = useTranslation();
  const [toasts, setToasts] = useState([]);
  const [activeTab, setActiveTab] = useState('general');
  
  const [notifications, setNotifications] = useState({
    email: true,
    sms: false,
    push: true,
    relances: true,
    campagnes: true,
    rapports: false
  });
  
  const [apparence, setApparence] = useState({
    theme: 'clair',
    animations: true,
    compact: false,
    fontSize: 'medium'
  });
  
  const [profil, setProfil] = useState({
    name: 'Admin ISETAG',
    email: 'admin@isetag.com',
    phone: '691234567',
    role: 'Administrateur'
  });
  
  const [securite, setSecurite] = useState({
    deuxFacteurs: false,
    sessionTimeout: 30,
    ipRestriction: false
  });

  const addToast = (message, type = 'success') => {
    const id = Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => removeToast(id), 3000);
  };

  const removeToast = (id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  };

  const handleSave = () => {
    addToast(t('parametresSauvegardes') || 'Paramètres enregistrés avec succès', 'success');
  };

  const tabs = [
    { id: 'general', label: t('general') || 'Général', icon: <Settings size={18} /> },
    { id: 'profil', label: t('monProfil') || 'Mon profil', icon: <User size={18} /> },
    { id: 'notifications', label: t('notifications') || 'Notifications', icon: <Bell size={18} /> },
    { id: 'apparence', label: t('apparence') || 'Apparence', icon: <Palette size={18} /> },
    { id: 'securite', label: t('securite') || 'Sécurité', icon: <Lock size={18} /> },
    { id: 'donnees', label: t('donnees') || 'Données', icon: <Database size={18} /> }
  ];

  return (
    <div className="page-container">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      
      <div className="page-header-actions">
        <div>
          <h1 className="page-title-h1">{t('parametres')}</h1>
          <p className="page-description">{t('descParametres')}</p>
        </div>
        <button className="btn-primary" onClick={handleSave}>
          <Save size={18} />
          {t('sauvegarder')}
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
              <h2>{t('parametresGeneraux')}</h2>
              <p className="section-desc">{t('configGenerale')}</p>
              
              <div className="settings-group">
                <div className="setting-item">
                  <div className="setting-info">
                    <Globe size={20} />
                    <div>
                      <div className="setting-label">{t('langueDefaut')}</div>
                      <div className="setting-desc">{t('definirLangue')}</div>
                    </div>
                  </div>
                  <select className="setting-select">
                    <option>Français</option>
                    <option>English</option>
                  </select>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Smartphone size={20} />
                    <div>
                      <div className="setting-label">{t('fuseauHoraire')}</div>
                      <div className="setting-desc">{t('definirFuseau')}</div>
                    </div>
                  </div>
                  <select className="setting-select">
                    <option>Afrique/Douala (GMT+1)</option>
                    <option>Afrique/Paris (GMT+1)</option>
                    <option>UTC</option>
                  </select>
                </div>

                <div className="setting-item">
                  <div className="setting-info">
                    <Database size={20} />
                    <div>
                      <div className="setting-label">{t('formatDate')}</div>
                      <div className="setting-desc">{t('choisirFormatDate')}</div>
                    </div>
                  </div>
                  <select className="setting-select">
                    <option>DD/MM/YYYY</option>
                    <option>MM/DD/YYYY</option>
                    <option>YYYY-MM-DD</option>
                  </select>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Mon profil */}
          {activeTab === 'profil' && (
            <div className="parametre-section">
              <h2>{t('monProfil')}</h2>
              <p className="section-desc">{t('modifierProfil')}</p>
              
              <div className="profile-form">
                <div className="profile-avatar">
                  <div className="avatar-large">A</div>
                  <button className="btn-outline-small">{t('changerPhoto')}</button>
                </div>
                
                <div className="profile-fields">
                  <div className="field-group">
                    <label>{t('nomComplet')}</label>
                    <div className="input-icon">
                      <User size={18} />
                      <input type="text" value={profil.name} onChange={(e) => setProfil({...profil, name: e.target.value})} />
                    </div>
                  </div>
                  
                  <div className="field-group">
                    <label>{t('email')}</label>
                    <div className="input-icon">
                      <Mail size={18} />
                      <input type="email" value={profil.email} onChange={(e) => setProfil({...profil, email: e.target.value})} />
                    </div>
                  </div>
                  
                  <div className="field-group">
                    <label>{t('telephone')}</label>
                    <div className="input-icon">
                      <Phone size={18} />
                      <input type="tel" value={profil.phone} onChange={(e) => setProfil({...profil, phone: e.target.value})} />
                    </div>
                  </div>
                  
                  <div className="field-group">
                    <label>{t('role')}</label>
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
              <h2>{t('notifications')}</h2>
              <p className="section-desc">{t('personnaliserNotifications')}</p>
              
              <div className="settings-group">
                <div className="setting-toggle">
                  <div className="setting-info">
                    <Bell size={20} />
                    <div>
                      <div className="setting-label">{t('notificationsEmail')}</div>
                      <div className="setting-desc">{t('recevoirNotificationsEmail')}</div>
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
                      <div className="setting-label">{t('notificationsSMS')}</div>
                      <div className="setting-desc">{t('recevoirNotificationsSMS')}</div>
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
                      <div className="setting-label">{t('notificationsPush')}</div>
                      <div className="setting-desc">{t('recevoirNotificationsPush')}</div>
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
                      <div className="setting-label">{t('alertesRelances')}</div>
                      <div className="setting-desc">{t('recevoirAlertesRelances')}</div>
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
                      <div className="setting-label">{t('rapportsPeriodiques')}</div>
                      <div className="setting-desc">{t('recevoirRapports')}</div>
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
              <h2>{t('apparence')}</h2>
              <p className="section-desc">{t('personnaliserApparence')}</p>
              
              <div className="theme-options">
                <div className={`theme-card ${apparence.theme === 'clair' ? 'selected' : ''}`} onClick={() => setApparence({...apparence, theme: 'clair'})}>
                  <Sun size={24} />
                  <span>{t('themeClair')}</span>
                </div>
                <div className={`theme-card ${apparence.theme === 'sombre' ? 'selected' : ''}`} onClick={() => setApparence({...apparence, theme: 'sombre'})}>
                  <Moon size={24} />
                  <span>{t('themeSombre')}</span>
                </div>
              </div>

              <div className="settings-group">
                <div className="setting-toggle">
                  <div className="setting-info">
                    <Palette size={20} />
                    <div>
                      <div className="setting-label">{t('animations')}</div>
                      <div className="setting-desc">{t('activerAnimations')}</div>
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
                      <div className="setting-label">{t('modeCompact')}</div>
                      <div className="setting-desc">{t('reduireEspacement')}</div>
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
                      <div className="setting-label">{t('taillePolice')}</div>
                      <div className="setting-desc">{t('ajusterTailleTexte')}</div>
                    </div>
                  </div>
                  <select className="setting-select" value={apparence.fontSize} onChange={(e) => setApparence({...apparence, fontSize: e.target.value})}>
                    <option value="small">{t('petite')}</option>
                    <option value="medium">{t('moyenne')}</option>
                    <option value="large">{t('grande')}</option>
                  </select>
                </div>
              </div>
            </div>
          )}

          {/* Onglet Sécurité */}
          {activeTab === 'securite' && (
            <div className="parametre-section">
              <h2>{t('securite')}</h2>
              <p className="section-desc">{t('configurerSecurite')}</p>
              
              <div className="settings-group">
                <div className="setting-toggle">
                  <div className="setting-info">
                    <Lock size={20} />
                    <div>
                      <div className="setting-label">{t('authentificationDeuxFacteurs')}</div>
                      <div className="setting-desc">{t('renforcerSecurite')}</div>
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
                      <div className="setting-label">{t('restrictionIP')}</div>
                      <div className="setting-desc">{t('limiterAccesIP')}</div>
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
                      <div className="setting-label">{t('delaiInactivite')}</div>
                      <div className="setting-desc">{t('deconnexionAutomatique')}</div>
                    </div>
                  </div>
                  <select className="setting-select" value={securite.sessionTimeout} onChange={(e) => setSecurite({...securite, sessionTimeout: parseInt(e.target.value)})}>
                    <option value="15">15 {t('minutes')}</option>
                    <option value="30">30 {t('minutes')}</option>
                    <option value="60">1 {t('heure')}</option>
                    <option value="120">2 {t('heures')}</option>
                  </select>
                </div>

                <button className="btn-outline" style={{ marginTop: '16px' }}>
                  <Key size={16} />
                  {t('changerMotDePasse')}
                </button>
              </div>
            </div>
          )}

          {/* Onglet Données */}
          {activeTab === 'donnees' && (
            <div className="parametre-section">
              <h2>{t('donnees')}</h2>
              <p className="section-desc">{t('gererDonnees')}</p>
              
              <div className="settings-group">
                <div className="data-actions">
                  <button className="btn-outline">
                    <Download size={16} />
                    {t('exporterDonnees')}
                  </button>
                  <button className="btn-outline">
                    <Upload size={16} />
                    {t('importerDonnees')}
                  </button>
                </div>

                <div className="setting-divider"></div>

                <div className="danger-zone">
                  <h4>{t('zoneDangereuse')}</h4>
                  <p>{t('actionsIrreversibles')}</p>
                  <div className="danger-actions">
                    <button className="btn-danger">
                      <Trash2 size={16} />
                      {t('viderCache')}
                    </button>
                    <button className="btn-danger">
                      <RefreshCw size={16} />
                      {t('reinitialiserParametres')}
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
