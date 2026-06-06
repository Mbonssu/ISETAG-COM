import React, { createContext, useState, useContext, useEffect } from 'react';

const LanguageContext = createContext();

const translations = {
  fr: {
    // Menu
    dashboard: 'Tableau de bord',
    prospects: 'Prospects',
    agents: 'Agents',
    campagnes: 'Campagnes',
    affectations: 'Affectations',
    etablissements: 'Établissements',
    filieres: 'Filières & Spécialités',
    sources: 'Sources',
    relances: 'Relances',
    rapports: 'Rapports & Statistiques',
    utilisateurs: 'Utilisateurs',
    parametres: 'Paramètres',
    
    // Actions
    ajouter: 'Ajouter',
    modifier: 'Modifier',
    supprimer: 'Supprimer',
    voir: 'Voir',
    exporter: 'Exporter',
    rechercher: 'Rechercher',
    filtrer: 'Filtrer',
    annuler: 'Annuler',
    sauvegarder: 'Sauvegarder',
    
    // Messages
    bienvenue: 'Bienvenue',
    administrateur: 'Administrateur',
    deconnexion: 'Déconnexion',
    aucunResultat: 'Aucun résultat trouvé',
    chargement: 'Chargement...',
    aucuneRelance: 'Aucune relance ne correspond à votre recherche',
    
    // Pages
    gestionProspects: 'Gestion des Prospects',
    gestionAgents: 'Gestion des Agents',
    gestionCampagnes: 'Gestion des Campagnes',
    gestionAffectations: 'Gestion des Affectations',
    gestionEtablissements: 'Gestion des Établissements',
    gestionFilieres: 'Gestion des Filières',
    gestionSources: 'Gestion des Sources',
    gestionRelances: 'Gestion des Relances',
    gestionUtilisateurs: 'Gestion des Utilisateurs',
    parametresGeneraux: 'Paramètres généraux',
    
    // Descriptions
    descProspects: 'Gérez tous vos prospects, ajoutez-en de nouveaux et suivez leur évolution.',
    descAgents: 'Gérez les agents commerciaux et leurs performances.',
    descCampagnes: 'Gérez vos campagnes marketing, suivez leur performance et créez-en de nouvelles.',
    descAffectations: 'Gérez l\'affectation des agents aux établissements.',
    descEtablissements: 'Gérez les lycées, universités et instituts partenaires.',
    descFilieres: 'Gérez les filières de formation et leurs spécialités.',
    descSources: 'Gérez les différentes sources d\'acquisition de prospects.',
    descRelances: 'Planifiez et suivez les relances auprès des prospects.',
    descUtilisateurs: 'Gérez les accès et les permissions des utilisateurs.',
    descParametres: 'Configurez l\'application selon vos préférences.',
    
    // Champs
    nom: 'Nom',
    email: 'Email',
    telephone: 'Téléphone',
    source: 'Source',
    filiere: 'Filière',
    agent: 'Agent',
    date: 'Date',
    statut: 'Statut',
    actions: 'Actions',
    contact: 'Contact',
    zone: 'Zone',
    prospects: 'Prospects',
    conversions: 'Conversions',
    taux: 'Taux',
    type: 'Type',
    periode: 'Période',
    progression: 'Progression',
    ville: 'Ville',
    adresse: 'Adresse',
    code: 'Code',
    specialites: 'Spécialités',
    evolution: 'Évolution',
    priorite: 'Priorité',
    message: 'Message',
    role: 'Rôle',
    derniereConnexion: 'Dernière connexion',
    dateCreation: 'Date création',
    
    // Statuts
    nouveau: 'Nouveau',
    contacte: 'Contacté',
    aRelancer: 'À relancer',
    qualifie: 'Qualifié',
    converti: 'Converti',
    actif: 'Actif',
    inactif: 'Inactif',
    enCours: 'En cours',
    termine: 'Terminé',
    planifie: 'Planifié',
    enAttente: 'En attente',
    programmee: 'Programmée',
    effectuee: 'Effectuée',
    
    // Jours/Mois
    lundi: 'Lundi', mardi: 'Mardi', mercredi: 'Mercredi', jeudi: 'Jeudi', vendredi: 'Vendredi', samedi: 'Samedi', dimanche: 'Dimanche',
    janvier: 'Janvier', fevrier: 'Février', mars: 'Mars', avril: 'Avril', mai: 'Mai', juin: 'Juin',
    juillet: 'Juillet', aout: 'Août', septembre: 'Septembre', octobre: 'Octobre', novembre: 'Novembre', decembre: 'Décembre',
    
    // Notifications
    exportReussi: 'Export réussi',
    exportErreur: 'Erreur lors de l\'export',
    suppressionReussie: 'supprimé avec succès',
    
    // Graphiques
    evolutionProspects: 'Évolution des prospects',
    totalProspects: 'Total prospects',
    prospectsParSource: 'Prospects par source',
    prospectsParFiliere: 'Prospects par filière',
    activitesRecentes: 'Activités récentes',
    derniersProspects: 'Derniers prospects ajoutés',
    voirTout: 'Voir tout',
    effacerFiltres: 'Effacer les filtres',
    
    // Types de campagne
    email: 'Email',
    sms: 'SMS',
    appel: 'Appel',
    
    // Priorités
    haute: 'Haute',
    moyenne: 'Moyenne',
    basse: 'Basse',
    
    // Rôles
    administrateur: 'Administrateur',
    manager: 'Manager',
    viewer: 'Visualisateur'
  },
  en: {
    // Menu
    dashboard: 'Dashboard',
    prospects: 'Prospects',
    agents: 'Agents',
    campagnes: 'Campaigns',
    affectations: 'Assignments',
    etablissements: 'Establishments',
    filieres: 'Courses & Specialties',
    sources: 'Sources',
    relances: 'Follow-ups',
    rapports: 'Reports & Statistics',
    utilisateurs: 'Users',
    parametres: 'Settings',
    
    // Actions
    ajouter: 'Add',
    modifier: 'Edit',
    supprimer: 'Delete',
    voir: 'View',
    exporter: 'Export',
    rechercher: 'Search',
    filtrer: 'Filter',
    annuler: 'Cancel',
    sauvegarder: 'Save',
    
    // Messages
    bienvenue: 'Welcome',
    administrateur: 'Administrator',
    deconnexion: 'Logout',
    aucunResultat: 'No results found',
    chargement: 'Loading...',
    aucuneRelance: 'No follow-up matches your search',
    
    // Pages
    gestionProspects: 'Prospects Management',
    gestionAgents: 'Agents Management',
    gestionCampagnes: 'Campaigns Management',
    gestionAffectations: 'Assignments Management',
    gestionEtablissements: 'Establishments Management',
    gestionFilieres: 'Courses Management',
    gestionSources: 'Sources Management',
    gestionRelances: 'Follow-ups Management',
    gestionUtilisateurs: 'Users Management',
    parametresGeneraux: 'General Settings',
    
    // Descriptions
    descProspects: 'Manage all your prospects, add new ones and track their progress.',
    descAgents: 'Manage sales agents and their performance.',
    descCampagnes: 'Manage your marketing campaigns, track their performance and create new ones.',
    descAffectations: 'Manage agent assignments to establishments.',
    descEtablissements: 'Manage high schools, universities and partner institutes.',
    descFilieres: 'Manage training courses and their specialties.',
    descSources: 'Manage different prospect acquisition sources.',
    descRelances: 'Schedule and track prospect follow-ups.',
    descUtilisateurs: 'Manage user access and permissions.',
    descParametres: 'Configure the application according to your preferences.',
    
    // Fields
    nom: 'Name',
    email: 'Email',
    telephone: 'Phone',
    source: 'Source',
    filiere: 'Course',
    agent: 'Agent',
    date: 'Date',
    statut: 'Status',
    actions: 'Actions',
    contact: 'Contact',
    zone: 'Zone',
    prospects: 'Prospects',
    conversions: 'Conversions',
    taux: 'Rate',
    type: 'Type',
    periode: 'Period',
    progression: 'Progress',
    ville: 'City',
    adresse: 'Address',
    code: 'Code',
    specialites: 'Specialties',
    evolution: 'Evolution',
    priorite: 'Priority',
    message: 'Message',
    role: 'Role',
    derniereConnexion: 'Last login',
    dateCreation: 'Creation date',
    
    // Statuses
    nouveau: 'New',
    contacte: 'Contacted',
    aRelancer: 'To follow up',
    qualifie: 'Qualified',
    converti: 'Converted',
    actif: 'Active',
    inactif: 'Inactive',
    enCours: 'In progress',
    termine: 'Completed',
    planifie: 'Scheduled',
    enAttente: 'Pending',
    programmee: 'Scheduled',
    effectuee: 'Done',
    
    // Days/Months
    lundi: 'Monday', mardi: 'Tuesday', mercredi: 'Wednesday', jeudi: 'Thursday', vendredi: 'Friday', samedi: 'Saturday', dimanche: 'Sunday',
    janvier: 'January', fevrier: 'February', mars: 'March', avril: 'April', mai: 'May', juin: 'June',
    juillet: 'July', aout: 'August', septembre: 'September', octobre: 'October', novembre: 'November', decembre: 'December',
    
    // Notifications
    exportReussi: 'Export successful',
    exportErreur: 'Export error',
    suppressionReussie: 'successfully deleted',
    
    // Charts
    evolutionProspects: 'Prospects evolution',
    totalProspects: 'Total prospects',
    prospectsParSource: 'Prospects by source',
    prospectsParFiliere: 'Prospects by course',
    activitesRecentes: 'Recent activities',
    derniersProspects: 'Latest prospects added',
    voirTout: 'View all',
    effacerFiltres: 'Clear filters',
    
    // Campaign types
    email: 'Email',
    sms: 'SMS',
    appel: 'Call',
    
    // Priorities
    haute: 'High',
    moyenne: 'Medium',
    basse: 'Low',
    
    // Roles
    administrateur: 'Administrator',
    manager: 'Manager',
    viewer: 'Viewer'
  }
};

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within LanguageProvider');
  }
  return context;
};

export const LanguageProvider = ({ children }) => {
  const [language, setLanguage] = useState(() => {
    const savedLang = localStorage.getItem('language');
    return savedLang === 'fr' || savedLang === 'en' ? savedLang : 'fr';
  });

  const t = (key) => {
    return translations[language][key] || key;
  };

  const changeLanguage = (lang) => {
    setLanguage(lang);
    localStorage.setItem('language', lang);
  };

  useEffect(() => {
    document.documentElement.lang = language;
  }, [language]);

  return (
    <LanguageContext.Provider value={{ language, changeLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  );
};
