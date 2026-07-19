/**
 * Point d'entrée central pour tous les services de l'application
 * 
 * Ce fichier exporte tous les services pour une importation simplifiée.
 * Au lieu d'importer chaque service individuellement :
 *   import { api } from '../services/api';
 *   import { userService } from '../services/userService';
 *   import { prospectService } from '../services/prospectService';
 * 
 * Vous pouvez maintenant importer tous les services depuis un seul endroit :
 *   import { api, userService, prospectService } from '../services';
 * 
 * Cela rend le code plus propre et facilite la maintenance.
 */

// ============================================================
// 1. SERVICE API DE BASE
// ============================================================

/**
 * Exporte l'objet 'api' qui contient les méthodes HTTP (get, post, put, patch, delete)
 * 
 * Utilisation:
 *   import { api } from '../services';
 *   const data = await api.get('/prospects');
 */
export { api } from './api';

// ============================================================
// 2. SERVICES SPÉCIFIQUES PAR ENTITÉ
// ============================================================

/**
 * Service de gestion des prospects
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer tous les prospects
 *   - getById()  : Récupérer un prospect par ID
 *   - create()   : Créer un prospect
 *   - update()   : Mettre à jour un prospect
 *   - delete()   : Supprimer un prospect
 *   - getInterets()     : Récupérer les intérêts d'un prospect
 *   - addInteret()      : Ajouter un intérêt à un prospect
 *   - deleteInteret()   : Supprimer un intérêt
 * 
 * Utilisation:
 *   import { prospectService } from '../services';
 *   const prospects = await prospectService.getAll();
 */
export { prospectService } from './prospectService';

/**
 * Service de gestion des agents
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer tous les agents
 *   - getById()  : Récupérer un agent par ID
 *   - create()   : Créer un agent
 *   - update()   : Mettre à jour un agent
 *   - delete()   : Supprimer un agent
 *   - getStats() : Récupérer les statistiques d'un agent
 * 
 * Utilisation:
 *   import { agentService } from '../services';
 *   const agents = await agentService.getAll();
 */
export { agentService } from './agentService';

/**
 * Service de gestion des campagnes
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les campagnes
 *   - getById()  : Récupérer une campagne par ID
 *   - create()   : Créer une campagne
 *   - update()   : Mettre à jour une campagne
 *   - delete()   : Supprimer une campagne
 *   - getParticipations() : Récupérer les participations d'une campagne
 *   - addParticipation()  : Ajouter une participation à une campagne
 *   - getStats() : Récupérer les statistiques d'une campagne
 * 
 * Utilisation:
 *   import { campagneService } from '../services';
 *   const campagnes = await campagneService.getAll();
 */
export { campagneService } from './campagneService';

/**
 * Service de gestion des établissements
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer tous les établissements
 *   - getById()  : Récupérer un établissement par ID
 *   - create()   : Créer un établissement
 *   - update()   : Mettre à jour un établissement
 *   - delete()   : Supprimer un établissement
 *   - getClasses()   : Récupérer les classes d'un établissement
 *   - addClasse()    : Ajouter une classe à un établissement
 * 
 * Utilisation:
 *   import { etablissementService } from '../services';
 *   const etablissements = await etablissementService.getAll();
 */
export { etablissementService } from './etablissementService';

/**
 * Service de gestion des utilisateurs
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer tous les utilisateurs
 *   - getById()  : Récupérer un utilisateur par ID
 *   - create()   : Créer un utilisateur
 *   - update()   : Mettre à jour un utilisateur
 *   - delete()   : Supprimer un utilisateur
 *   - updateStatus() : Mettre à jour le statut d'un utilisateur
 *   - uploadPhoto()  : Uploader une photo de profil
 * 
 * Utilisation:
 *   import { userService } from '../services';
 *   const users = await userService.getAll();
 */
export { userService } from './userService';

/**
 * Service de gestion des spécialités
 *
 *  CORRIGÉ : ce projet n'a pas de notion de "filière" côté backend.
 * L'API (ISETAG_COM_API.yaml) expose uniquement :
 *   /specialite_api/ISETAG_COM.specialites/
 * Le fichier filiereService.js exporte donc réellement `specialiteService`
 * (pas `filiereService`, qui n'existe pas et faisait planter cet import).
 *
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les spécialités
 *   - getById()  : Récupérer une spécialité par ID
 *   - create()   : Créer une spécialité
 *   - update()   : Mettre à jour une spécialité
 *   - delete()   : Supprimer une spécialité
 * 
 * Utilisation:
 *   import { specialiteService } from '../services';
 *   const specialites = await specialiteService.getAll();
 */
export { specialiteService } from './filiereService';

/**
 * Service de gestion des intérêts (prospect x spécialité x niveau)
 *
 * Fonctions disponibles:
 *   - getAll()          : Récupérer tous les intérêts
 *   - getByProspect(id)  : Récupérer les intérêts d'un prospect
 *   - create/update/delete/syncInterets
 *
 * Utilisation:
 *   import { interetService } from '../services';
 *   const interets = await interetService.getAll();
 */
export { interetService } from './interetService';

/**
 * Service de gestion des sources
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les sources
 *   - getById()  : Récupérer une source par ID
 *   - create()   : Créer une source
 *   - update()   : Mettre à jour une source
 *   - delete()   : Supprimer une source
 * 
 * Utilisation:
 *   import { sourceService } from '../services';
 *   const sources = await sourceService.getAll();
 */
export { sourceService } from './sourceService';

/**
 * Service de gestion des relances
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les relances
 *   - getById()  : Récupérer une relance par ID
 *   - create()   : Créer une relance
 *   - update()   : Mettre à jour une relance
 *   - delete()   : Supprimer une relance
 * 
 * Utilisation:
 *   import { relanceService } from '../services';
 *   const relances = await relanceService.getAll();
 */
export { relanceService } from './relanceService';

/**
 * Service de gestion des zones
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les zones
 *   - getById()  : Récupérer une zone par ID
 *   - create()   : Créer une zone
 *   - update()   : Mettre à jour une zone
 *   - delete()   : Supprimer une zone
 * 
 * Utilisation:
 *   import { zoneService } from '../services';
 *   const zones = await zoneService.getAll();
 */
export { zoneService } from './zoneService';

/**
 * Service de gestion des sorties
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les sorties
 *   - getById()  : Récupérer une sortie par ID
 *   - create()   : Créer une sortie
 *   - update()   : Mettre à jour une sortie
 *   - delete()   : Supprimer une sortie
 * 
 * Utilisation:
 *   import { sortieService } from '../services';
 *   const sorties = await sortieService.getAll();
 */
export { sortieService } from './sortieService';

/**
 * Service de gestion des suivis
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer tous les suivis
 *   - getById()  : Récupérer un suivi par ID
 *   - create()   : Créer un suivi
 *   - update()   : Mettre à jour un suivi
 *   - delete()   : Supprimer un suivi
 * 
 * Utilisation:
 *   import { suiviService } from '../services';
 *   const suivis = await suiviService.getAll();
 */
export { suiviService } from './suiviService';

/**
 * Service de gestion des rendez-vous
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer tous les rendez-vous
 *   - getById()  : Récupérer un rendez-vous par ID
 *   - create()   : Créer un rendez-vous
 *   - update()   : Mettre à jour un rendez-vous
 *   - delete()   : Supprimer un rendez-vous
 * 
 * Utilisation:
 *   import { rendezvousService } from '../services';
 *   const rendezvous = await rendezvousService.getAll();
 */
export { rendezvousService } from './rendezvousService';

/**
 * Service de gestion des fiches
 * 
 * Fonctions disponibles:
 *   - getAll()   : Récupérer toutes les fiches
 *   - getById()  : Récupérer une fiche par ID
 *   - create()   : Créer une fiche
 *   - update()   : Mettre à jour une fiche
 *   - delete()   : Supprimer une fiche
 * 
 * Utilisation:
 *   import { ficheService } from '../services';
 *   const fiches = await ficheService.getAll();
 */
export { ficheService } from './ficheService';

// ============================================================
// 3. NOTE SUR L'AJOUT DE NOUVEAUX SERVICES
// ============================================================

/**
 * Pour ajouter un nouveau service :
 * 
 * 1. Créer le fichier dans le dossier src/services/
 *    Exemple: src/services/nouveauService.js
 * 
 * 2. Exporter le service dans ce fichier
 *    export { nouveauService } from './nouveauService';
 * 
 * 3. Utiliser le service dans les composants
 *    import { nouveauService } from '../services';
 *    const data = await nouveauService.getAll();
 * 
 * Cette approche permet une centralisation et une maintenance facile
 * de tous les services de l'application.
 */

// ============================================================
// 4. IMPORTATION SIMPLIFIÉE DANS LES COMPOSANTS
// ============================================================

/**
 * AVANT (sans index.js) :
 *   import { api } from '../services/api';
 *   import { userService } from '../services/userService';
 *   import { prospectService } from '../services/prospectService';
 * 
 * APRÈS (avec index.js) :
 *   import { api, userService, prospectService } from '../services';
 * 
 *  Code plus propre
 *  Moins d'imports à gérer
 *  Facile à refactoriser
 *  Centralisation des services
 */
