import React, { useState, useEffect } from 'react';
import { Calendar, Search, Bell, ChevronDown, Menu, X } from 'lucide-react';
import { useLanguage } from '../../context/LanguageContext';
import './Topbar.css';

const Topbar = ({ onMenuClick }) => {
  const { language, changeLanguage, t } = useLanguage();
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [showNotifications, setShowNotifications] = useState(false);
  const [showLanguageMenu, setShowLanguageMenu] = useState(false);
  const [showCalendar, setShowCalendar] = useState(false);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [currentDateText, setCurrentDateText] = useState('');
  
  const notifications = [
    { id: 1, title: t('nouveauProspect') || 'Nouveau prospect ajouté', message: 'Marie L. a ajouté 8 prospects', time: '10:30', read: false },
    { id: 2, title: t('relanceProgrammee') || 'Relance programmée', message: 'Jean M. doit relancer 3 prospects', time: '09:15', read: false },
    { id: 3, title: t('rapportHebdo') || 'Rapport hebdomadaire', message: 'Le rapport est prêt à être consulté', time: 'Hier', read: true },
  ];
  
  const unreadCount = notifications.filter(n => !n.read).length;
  
  useEffect(() => {
    const options = { day: 'numeric', month: 'long', year: 'numeric' };
    const formattedDate = selectedDate.toLocaleDateString(language === 'fr' ? 'fr-FR' : 'en-US', options);
    setCurrentDateText(`${language === 'fr' ? "Aujourd'hui" : "Today"} : ${formattedDate}`);
  }, [selectedDate, language]);
  
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (!event.target.closest('.notifications-container')) setShowNotifications(false);
      if (!event.target.closest('.language-container')) setShowLanguageMenu(false);
      if (!event.target.closest('.date-picker-container')) setShowCalendar(false);
    };
    document.addEventListener('click', handleClickOutside);
    return () => document.removeEventListener('click', handleClickOutside);
  }, []);
  
  const changeLanguageHandler = (lang) => {
    changeLanguage(lang);
    setShowLanguageMenu(false);
  };

  // Drapeaux
  const flags = {
    fr: '🇫🇷',
    en: '🇬🇧'
  };

  return (
    <header className="topbar">
      <button className="menu-btn" onClick={onMenuClick}><Menu size={20} /></button>

      <div className={`search-container ${isSearchOpen ? 'open' : ''}`}>
        {isSearchOpen ? (
          <div className="search-expanded">
            <Search size={18} />
            <input type="text" placeholder={t('rechercher') + "..."} value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} autoFocus />
            <button onClick={() => { setIsSearchOpen(false); setSearchQuery(''); }}><X size={18} /></button>
          </div>
        ) : (
          <button className="topbar-icon search-icon" onClick={() => setIsSearchOpen(true)}><Search size={18} /></button>
        )}
      </div>

      <div className="page-header">
        <div className="page-title">{t('dashboard')} <span className="wave-emoji">👋</span></div>
        <div className="page-sub">{t('bienvenue')} {t('administrateur')}, voici ce qui se passe aujourd'hui.</div>
      </div>

      <div className="topbar-right">
        <div className="date-picker-container">
          <button className="date-pill" onClick={() => setShowCalendar(!showCalendar)}>
            <Calendar size={15} /><span>{currentDateText}</span><ChevronDown size={13} className={`chevron ${showCalendar ? 'rotated' : ''}`} />
          </button>
          {showCalendar && (
            <div className="calendar-dropdown">
              <div className="calendar-header">
                <button onClick={() => setSelectedDate(new Date(selectedDate.getFullYear(), selectedDate.getMonth() - 1, 1))}>‹</button>
                <span>{selectedDate.toLocaleDateString(language === 'fr' ? 'fr-FR' : 'en-US', { month: 'long', year: 'numeric' })}</span>
                <button onClick={() => setSelectedDate(new Date(selectedDate.getFullYear(), selectedDate.getMonth() + 1, 1))}>›</button>
              </div>
              <div className="calendar-footer">
                <button onClick={() => setSelectedDate(new Date())}>{language === 'fr' ? "Aujourd'hui" : "Today"}</button>
              </div>
            </div>
          )}
        </div>

        <div className="notifications-container">
          <button className="topbar-icon notif-icon" onClick={() => setShowNotifications(!showNotifications)}>
            <Bell size={18} />
            {unreadCount > 0 && <span className="notif-badge pulse">{unreadCount}</span>}
          </button>
          {showNotifications && (
            <div className="notifications-dropdown">
              <div className="notif-header"><span>{t('notifications') || 'Notifications'}</span><button className="mark-all-read">Tout marquer comme lu</button></div>
              <div className="notif-list">{notifications.map(notif => (<div key={notif.id} className={`notif-item ${!notif.read ? 'unread' : ''}`}><div className="notif-dot"></div><div className="notif-content"><div className="notif-title">{notif.title}</div><div className="notif-message">{notif.message}</div><div className="notif-time">{notif.time}</div></div></div>))}</div>
              <div className="notif-footer"><button className="view-all">{t('voirTout')}</button></div>
            </div>
          )}
        </div>

        <div className="language-container">
          <button className="lang-pill" onClick={() => setShowLanguageMenu(!showLanguageMenu)}>
            {flags[language]} {language.toUpperCase()}
            <ChevronDown size={12} className={`lang-chevron ${showLanguageMenu ? 'rotated' : ''}`} />
          </button>
          {showLanguageMenu && (
            <div className="language-dropdown">
              <div className="language-option" onClick={() => changeLanguageHandler('fr')}>
                <span>🇫🇷</span><span>Français</span>{language === 'fr' && <span className="check-mark">✓</span>}
              </div>
              <div className="language-option" onClick={() => changeLanguageHandler('en')}>
                <span>🇬🇧</span><span>English</span>{language === 'en' && <span className="check-mark">✓</span>}
              </div>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};

export default Topbar;
