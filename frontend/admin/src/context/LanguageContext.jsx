import React, { createContext, useState, useContext, useEffect } from 'react';

const LanguageContext = createContext();

//  CORRIGÉ : le Sidebar appelle t('suivis'), t('rendezvous'),
// t('superviseurs'), t('fiches'), t('zones'), t('sorties') — mais ces
// clés n'existaient nulle part dans ce fichier. Comme t() retombe sur la
// clé brute quand elle est absente, le menu affichait littéralement
// "suivis", "rendezvous", etc. au lieu d'un vrai libellé traduit, dans
// les deux langues. Toutes les clés manquantes ont été ajoutées, plus
// les titres/descriptions de gestion pour chaque module qui n'en avait
// pas encore (Sorties, Suivis, Sources, Zones, Campagnes, Filières,
// Établissements, Relances, Agents).

const translations = {
  fr: {
    // ── Menu ──────────────────────────────────────────────────────────
    dashboard: 'Tableau de bord',
    prospects: 'Prospects',
    suivis: 'Suivis',
    relances: 'Relances',
    rendezvous: 'Rendez-vous',
    agents: 'Agents',
    superviseurs: 'Superviseurs',
    campagnes: 'Campagnes',
    fiches: 'Fiches de collecte',
    affectations: 'Affectations',
    etablissements: 'Établissements',
    filieres: 'Filières & Spécialités',
    sources: 'Sources',
    zones: 'Zones',
    sorties: 'Sorties',
    rapports: 'Rapports & Statistiques',
    utilisateurs: 'Utilisateurs',
    parametres: 'Paramètres',

    // ── Actions ───────────────────────────────────────────────────────
    ajouter: 'Ajouter',
    modifier: 'Modifier',
    supprimer: 'Supprimer',
    voir: 'Voir',
    exporter: 'Exporter',
    rechercher: 'Rechercher',
    filtrer: 'Filtrer',
    annuler: 'Annuler',
    sauvegarder: 'Sauvegarder',
    creer: 'Créer',
    mettreAJour: 'Mettre à jour',
    retour: 'Retour',
    retourALaListe: 'Retour à la liste',
    confirmerSuppression: 'Confirmer la suppression',
    enregistrementEnCours: 'Enregistrement…',

    // ── Messages ──────────────────────────────────────────────────────
    bienvenue: 'Bienvenue',
    administrateur: 'Administrateur',
    deconnexion: 'Déconnexion',
    aucunResultat: 'Aucun résultat trouvé',
    chargement: 'Chargement...',
    aucuneRelance: 'Aucune relance ne correspond à votre recherche',
    erreurChargement: 'Erreur de chargement',
    reessayer: 'Réessayer',
    champRequis: 'Ce champ est requis',

    // ── Erreurs (messages utilisateur clairs, traduits, jamais le texte
    // technique brut renvoyé par le serveur) ─────────────────────────
    erreurReseau: 'Impossible de contacter le serveur. Vérifiez votre connexion ou réessayez dans un instant.',
    erreur400: 'La requête contient des données invalides. Vérifiez les champs du formulaire.',
    erreur401: 'Votre session a expiré. Merci de vous reconnecter.',
    erreur403: "Vous n'avez pas la permission d'effectuer cette action.",
    erreur404: "L'élément demandé est introuvable. Il a peut-être déjà été supprimé.",
    erreur409: 'Ce contenu a été modifié entre-temps. Rechargez la page et réessayez.',
    erreur500: 'Une erreur est survenue côté serveur. Réessayez dans un instant.',
    erreurInconnue: "Une erreur inattendue s'est produite. Réessayez, ou contactez un administrateur si le problème persiste.",
    erreurValidation: 'Certains champs contiennent des erreurs. Corrigez-les avant de continuer.',
    erreurChargementDonnees: "Impossible de charger les données. Vérifiez votre connexion et réessayez.",
    erreurEnregistrement: "Impossible d'enregistrer. Réessayez dans un instant.",
    erreurSuppression: 'Impossible de supprimer cet élément.',
    erreurApplication: "Quelque chose s'est mal passé dans l'application.",
    rechargerLaPage: 'Recharger la page',
    detailsTechniques: 'Détails techniques',

    // ── Authentification ──────────────────────────────────────────────
    connexion: 'Connexion',
    connexionSousTitre: 'Connectez-vous pour accéder à votre espace.',
    motDePasse: 'Mot de passe',
    seConnecter: 'Se connecter',
    connexionEnCours: 'Connexion…',
    identifiantsInvalides: 'Email ou mot de passe incorrect.',
    identifiantsTest: 'Identifiants de test',
    deconnexionReussie: 'Vous avez été déconnecté avec succès.',

    // ── Titres de gestion (pages liste) ──────────────────────────────
    gestionProspects: 'Gestion des Prospects',
    gestionSuivis: 'Gestion des Suivis',
    gestionRendezVous: 'Gestion des Rendez-vous',
    gestionAgents: 'Gestion des Agents',
    gestionSuperviseurs: 'Gestion des Superviseurs',
    gestionCampagnes: 'Campagnes de prospection',
    gestionFiches: 'Gestion des Fiches de collecte',
    gestionAffectations: 'Gestion des Affectations',
    gestionEtablissements: 'Gestion des Établissements',
    gestionFilieres: 'Spécialités',
    gestionSources: 'Gestion des Sources',
    gestionZones: 'Gestion des Zones',
    gestionSorties: 'Gestion des Sorties',
    gestionRelances: 'Gestion des Relances',
    gestionUtilisateurs: 'Gestion des Utilisateurs',
    parametresGeneraux: 'Paramètres généraux',

    // ── Descriptions (pages liste) ───────────────────────────────────
    descProspects: 'Gérez tous vos prospects, ajoutez-en de nouveaux et suivez leur évolution.',
    descSuivis: "Suivez l'historique des interactions avec les prospects.",
    descRendezVous: 'Planifiez et gérez les rendez-vous avec les prospects.',
    descAgents: 'Gérez les agents commerciaux et leurs performances.',
    descSuperviseurs: 'Gérez les superviseurs et leurs équipes.',
    descCampagnes: 'Gérez vos campagnes de prospection.',
    descFiches: 'Consultez les fiches de collecte issues des sorties terrain.',
    descAffectations: "Gérez l'affectation des agents aux établissements.",
    descEtablissements: 'Gérez les lycées, universités et instituts partenaires.',
    descFilieres: 'Gérez les filières de formation et leurs spécialités.',
    descSources: "Gérez les différentes sources d'acquisition de prospects.",
    descZones: "Définissez et gérez les zones géographiques d'intervention.",
    descSorties: 'Planifiez et suivez les sorties terrain.',
    descRelances: 'Planifiez et suivez les relances auprès des prospects.',
    descUtilisateurs: 'Gérez les accès et les permissions des utilisateurs.',
    descParametres: "Configurez l'application selon vos préférences.",

    // ── Boutons "Nouveau X" ───────────────────────────────────────────
    nouveauProspect: 'Nouveau prospect',
    nouveauSuivi: 'Nouveau suivi',
    nouveauRendezVous: 'Nouveau rendez-vous',
    nouvelAgent: 'Nouvel agent',
    nouveauSuperviseur: 'Nouveau superviseur',
    nouvelleCampagne: 'Nouvelle campagne',
    nouvelleAffectation: 'Nouvelle affectation',
    nouvelEtablissement: 'Nouvel établissement',
    nouvelleFiliere: 'Nouvelle filière',
    nouvelleSource: 'Nouvelle source',
    nouvelleZone: 'Nouvelle zone',
    nouvelleSortie: 'Nouvelle sortie',
    nouvelleRelance: 'Nouvelle relance',

    // ── Champs communs ────────────────────────────────────────────────
    nom: 'Nom',
    nomComplet: 'Nom complet',
    email: 'Email',
    telephone: 'Téléphone',
    adresse: 'Adresse',
    source: 'Source',
    filiere: 'Filière',
    specialite: 'Spécialité',
    agent: 'Agent',
    date: 'Date',
    statut: 'Statut',
    actions: 'Actions',
    contact: 'Contact',
    zone: 'Zone',
    conversions: 'Conversions',
    taux: 'Taux',
    type: 'Type',
    periode: 'Période',
    progression: 'Progression',
    ville: 'Ville',
    codePostal: 'Code postal',
    region: 'Région',
    pays: 'Pays',
    code: 'Code',
    specialites: 'Spécialités',
    evolution: 'Évolution',
    priorite: 'Priorité',
    message: 'Message',
    role: 'Rôle',
    derniereConnexion: 'Dernière connexion',
    dateCreation: 'Date création',
    description: 'Description',
    commentaire: 'Commentaire',
    objectif: 'Objectif',
    sujet: 'Sujet',
    libele: 'Libellé',
    quartier: 'Quartier',
    lieuDepart: 'Lieu de départ',
    lieuArrivee: "Lieu d'arrivée",
    dateDebut: 'Date de début',
    dateFin: 'Date de fin',
    heureArrivee: "Heure d'arrivée",
    heureDepart: 'Heure de départ',
    observation: 'Observation',

    // ── Statuts ───────────────────────────────────────────────────────
    nouveau: 'Nouveau',
    contacte: 'Contacté',
    aRelancer: 'À relancer',
    qualifie: 'Qualifié',
    converti: 'Converti',
    actif: 'Actif',
    inactif: 'Inactif',
    enCours: 'En cours',
    termine: 'Terminé',
    effectue: 'Effectué',
    annule: 'Annulé',
    reportee: 'Reportée',
    planifiee: 'Planifiée',
    enAttente: 'En attente',
    programmee: 'Programmée',

    // ── Jours / Mois ──────────────────────────────────────────────────
    lundi: 'Lundi', mardi: 'Mardi', mercredi: 'Mercredi', jeudi: 'Jeudi', vendredi: 'Vendredi', samedi: 'Samedi', dimanche: 'Dimanche',
    janvier: 'Janvier', fevrier: 'Février', mars: 'Mars', avril: 'Avril', mai: 'Mai', juin: 'Juin',
    juillet: 'Juillet', aout: 'Août', septembre: 'Septembre', octobre: 'Octobre', novembre: 'Novembre', decembre: 'Décembre',

    // ── Notifications ─────────────────────────────────────────────────
    exportReussi: 'Export réussi',
    exportErreur: "Erreur lors de l'export",
    suppressionReussie: 'supprimé avec succès',
    creationReussie: 'créé avec succès',
    modificationReussie: 'modifié avec succès',

    // ── Graphiques / Rapports ─────────────────────────────────────────
    evolutionProspects: 'Évolution des prospects',
    totalProspects: 'Total prospects',
    prospectsParSource: 'Prospects par source',
    prospectsParFiliere: 'Prospects par filière',
    performanceAgents: 'Performance des agents',
    activitesRecentes: 'Activités récentes',
    derniersProspects: 'Derniers prospects ajoutés',
    voirTout: 'Voir tout',
    effacerFiltres: 'Effacer les filtres',

    // ── Types de campagne ─────────────────────────────────────────────
    sms: 'SMS',
    appel: 'Appel',

    // ── Priorités ─────────────────────────────────────────────────────
    haute: 'Haute',
    moyenne: 'Moyenne',
    basse: 'Basse',

    // ── Niveaux d'intérêt ─────────────────────────────────────────────
    faible: 'Faible',
    moyen: 'Moyen',
    eleve: 'Élevé',
    tresEleve: 'Très élevé',

    // ── Rôles ─────────────────────────────────────────────────────────
    manager: 'Manager',
    viewer: 'Visualisateur',
  },

  en: {
    // ── Menu ──────────────────────────────────────────────────────────
    dashboard: 'Dashboard',
    prospects: 'Prospects',
    suivis: 'Follow-ups',
    relances: 'Reminders',
    rendezvous: 'Appointments',
    agents: 'Agents',
    superviseurs: 'Supervisors',
    campagnes: 'Campaigns',
    fiches: 'Collection sheets',
    affectations: 'Assignments',
    etablissements: 'Establishments',
    filieres: 'Courses & Specialties',
    sources: 'Sources',
    zones: 'Zones',
    sorties: 'Field visits',
    rapports: 'Reports & Statistics',
    utilisateurs: 'Users',
    parametres: 'Settings',

    // ── Actions ───────────────────────────────────────────────────────
    ajouter: 'Add',
    modifier: 'Edit',
    supprimer: 'Delete',
    voir: 'View',
    exporter: 'Export',
    rechercher: 'Search',
    filtrer: 'Filter',
    annuler: 'Cancel',
    sauvegarder: 'Save',
    creer: 'Create',
    mettreAJour: 'Update',
    retour: 'Back',
    retourALaListe: 'Back to list',
    confirmerSuppression: 'Confirm deletion',
    enregistrementEnCours: 'Saving…',

    // ── Messages ──────────────────────────────────────────────────────
    bienvenue: 'Welcome',
    administrateur: 'Administrator',
    deconnexion: 'Logout',
    aucunResultat: 'No results found',
    chargement: 'Loading...',
    aucuneRelance: 'No follow-up matches your search',
    erreurChargement: 'Loading error',
    reessayer: 'Retry',
    champRequis: 'This field is required',

    // ── Errors (clear, translated user messages — never the raw
    // technical text returned by the server) ─────────────────────────
    erreurReseau: 'Unable to reach the server. Check your connection or try again shortly.',
    erreur400: 'The request contains invalid data. Please check the form fields.',
    erreur401: 'Your session has expired. Please sign in again.',
    erreur403: "You don't have permission to perform this action.",
    erreur404: 'The requested item could not be found. It may have already been deleted.',
    erreur409: 'This content was changed in the meantime. Reload the page and try again.',
    erreur500: 'A server error occurred. Please try again shortly.',
    erreurInconnue: 'An unexpected error occurred. Try again, or contact an administrator if the problem persists.',
    erreurValidation: 'Some fields contain errors. Please fix them before continuing.',
    erreurChargementDonnees: 'Unable to load data. Check your connection and try again.',
    erreurEnregistrement: 'Unable to save. Please try again shortly.',
    erreurSuppression: 'Unable to delete this item.',
    erreurApplication: 'Something went wrong in the application.',
    rechargerLaPage: 'Reload page',
    detailsTechniques: 'Technical details',

    // ── Authentication ─────────────────────────────────────────────────
    connexion: 'Sign in',
    connexionSousTitre: 'Sign in to access your workspace.',
    motDePasse: 'Password',
    seConnecter: 'Sign in',
    connexionEnCours: 'Signing in…',
    identifiantsInvalides: 'Incorrect email or password.',
    identifiantsTest: 'Test credentials',
    deconnexionReussie: 'You have been successfully signed out.',

    // ── Titres de gestion (pages liste) ──────────────────────────────
    gestionProspects: 'Prospects Management',
    gestionSuivis: 'Follow-ups Management',
    gestionRendezVous: 'Appointments Management',
    gestionAgents: 'Agents Management',
    gestionSuperviseurs: 'Supervisors Management',
    gestionCampagnes: 'Prospecting Campaigns',
    gestionFiches: 'Collection Sheets Management',
    gestionAffectations: 'Assignments Management',
    gestionEtablissements: 'Establishments Management',
    gestionFilieres: 'Specialties',
    gestionSources: 'Sources Management',
    gestionZones: 'Zones Management',
    gestionSorties: 'Field Visits Management',
    gestionRelances: 'Reminders Management',
    gestionUtilisateurs: 'Users Management',
    parametresGeneraux: 'General Settings',

    // ── Descriptions (pages liste) ───────────────────────────────────
    descProspects: 'Manage all your prospects, add new ones and track their progress.',
    descSuivis: 'Track the history of interactions with prospects.',
    descRendezVous: 'Schedule and manage appointments with prospects.',
    descAgents: 'Manage sales agents and their performance.',
    descSuperviseurs: 'Manage supervisors and their teams.',
    descCampagnes: 'Manage your prospecting campaigns.',
    descFiches: 'View collection sheets from field visits.',
    descAffectations: 'Manage agent assignments to establishments.',
    descEtablissements: 'Manage high schools, universities and partner institutes.',
    descFilieres: 'Manage training courses and their specialties.',
    descSources: 'Manage different prospect acquisition sources.',
    descZones: 'Define and manage geographic intervention zones.',
    descSorties: 'Plan and track field visits.',
    descRelances: 'Schedule and track prospect follow-ups.',
    descUtilisateurs: 'Manage user access and permissions.',
    descParametres: 'Configure the application according to your preferences.',

    // ── Boutons "Nouveau X" ───────────────────────────────────────────
    nouveauProspect: 'New prospect',
    nouveauSuivi: 'New follow-up',
    nouveauRendezVous: 'New appointment',
    nouvelAgent: 'New agent',
    nouveauSuperviseur: 'New supervisor',
    nouvelleCampagne: 'New campaign',
    nouvelleAffectation: 'New assignment',
    nouvelEtablissement: 'New establishment',
    nouvelleFiliere: 'New course',
    nouvelleSource: 'New source',
    nouvelleZone: 'New zone',
    nouvelleSortie: 'New field visit',
    nouvelleRelance: 'New reminder',

    // ── Champs communs ────────────────────────────────────────────────
    nom: 'Name',
    nomComplet: 'Full name',
    email: 'Email',
    telephone: 'Phone',
    adresse: 'Address',
    source: 'Source',
    filiere: 'Course',
    specialite: 'Specialty',
    agent: 'Agent',
    date: 'Date',
    statut: 'Status',
    actions: 'Actions',
    contact: 'Contact',
    zone: 'Zone',
    conversions: 'Conversions',
    taux: 'Rate',
    type: 'Type',
    periode: 'Period',
    progression: 'Progress',
    ville: 'City',
    codePostal: 'Postal code',
    region: 'Region',
    pays: 'Country',
    code: 'Code',
    specialites: 'Specialties',
    evolution: 'Evolution',
    priorite: 'Priority',
    message: 'Message',
    role: 'Role',
    derniereConnexion: 'Last login',
    dateCreation: 'Creation date',
    description: 'Description',
    commentaire: 'Comment',
    objectif: 'Objective',
    sujet: 'Subject',
    libele: 'Label',
    quartier: 'District',
    lieuDepart: 'Departure location',
    lieuArrivee: 'Arrival location',
    dateDebut: 'Start date',
    dateFin: 'End date',
    heureArrivee: 'Arrival time',
    heureDepart: 'Departure time',
    observation: 'Observation',

    // ── Statuts ───────────────────────────────────────────────────────
    nouveau: 'New',
    contacte: 'Contacted',
    aRelancer: 'To follow up',
    qualifie: 'Qualified',
    converti: 'Converted',
    actif: 'Active',
    inactif: 'Inactive',
    enCours: 'In progress',
    termine: 'Completed',
    effectue: 'Done',
    annule: 'Cancelled',
    reportee: 'Postponed',
    planifiee: 'Planned',
    enAttente: 'Pending',
    programmee: 'Scheduled',

    // ── Jours / Mois ──────────────────────────────────────────────────
    lundi: 'Monday', mardi: 'Tuesday', mercredi: 'Wednesday', jeudi: 'Thursday', vendredi: 'Friday', samedi: 'Saturday', dimanche: 'Sunday',
    janvier: 'January', fevrier: 'February', mars: 'March', avril: 'April', mai: 'May', juin: 'June',
    juillet: 'July', aout: 'August', septembre: 'September', octobre: 'October', novembre: 'November', decembre: 'December',

    // ── Notifications ─────────────────────────────────────────────────
    exportReussi: 'Export successful',
    exportErreur: 'Export error',
    suppressionReussie: 'successfully deleted',
    creationReussie: 'successfully created',
    modificationReussie: 'successfully updated',

    // ── Graphiques / Rapports ─────────────────────────────────────────
    evolutionProspects: 'Prospects evolution',
    totalProspects: 'Total prospects',
    prospectsParSource: 'Prospects by source',
    prospectsParFiliere: 'Prospects by course',
    performanceAgents: 'Agents performance',
    activitesRecentes: 'Recent activities',
    derniersProspects: 'Latest prospects added',
    voirTout: 'View all',
    effacerFiltres: 'Clear filters',

    // ── Types de campagne ─────────────────────────────────────────────
    sms: 'SMS',
    appel: 'Call',

    // ── Priorités ─────────────────────────────────────────────────────
    haute: 'High',
    moyenne: 'Medium',
    basse: 'Low',

    // ── Niveaux d'intérêt ─────────────────────────────────────────────
    faible: 'Low',
    moyen: 'Medium',
    eleve: 'High',
    tresEleve: 'Very high',

    // ── Rôles ─────────────────────────────────────────────────────────
    manager: 'Manager',
    viewer: 'Viewer',
  },
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