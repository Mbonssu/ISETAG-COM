/**
 *  DONNÉES TEMPORAIRES (MOCK) — à remplacer par un vrai login JWT
 * contre le backend (POST /user_api/... ou équivalent) dès qu'il sera
 * prêt côté serveur. Pour l'instant, la connexion vérifie juste ces
 * comptes en dur, côté client.
 *
 * Remplacer par un vrai appel API plus tard : voir services/authService.js
 * (à créer) qui fera POST vers l'endpoint de login réel, stockera le
 * token JWT renvoyé, etc. — la structure de AuthContext.jsx a été pensée
 * pour que ce remplacement soit simple (seule la fonction login() change).
 */
export const MOCK_USERS = [
  { id: 'USR-001', email: 'admin@isetag.com', password: 'admin123', nom: 'ISETAG', prenom: 'Admin', role: 'Admin' },
  { id: 'USR-002', email: 'manager@isetag.com', password: 'manager123', nom: 'Kamga', prenom: 'Sophie', role: 'Manager' },
];