// /**
//  * Service d'authentification.
//  *
//  *  Le login n'appelle PAS api.post() : au moment du login on n'a pas
//  * encore de token à mettre dans le header Authorization, et surtout on ne
//  * veut pas qu'une 401 "email/mot de passe invalide" soit transformée en
//  * exception générique par apiRequest avant qu'on ait pu lire le message
//  * du backend. On fait donc un fetch minimal dédié, cohérent avec le reste
//  * (mêmes headers/credentials que api.js) mais avec sa propre gestion
//  * d'erreur adaptée au formulaire de connexion.
//  */


import { api } from './api';

const LOGIN_URL = '/authentification/login/';
const LOGOUT_URL = '/authentification/logout/';
const REFRESH_URL = '/authentification/refresh/';
const VERIFY_URL = '/authentification/verify/';

const authService = {

  login: (email, password) => {
    return api.post(LOGIN_URL, { email, password });
  },

  logout: (refreshToken) => {
    return api.post(LOGOUT_URL, { refresh: refreshToken });
  },

  /** POST /authentification/refresh/ -> { access, refresh } */
  refresh: (refreshToken) => {
    return api.post(REFRESH_URL, { refresh: refreshToken });
  },

  /** POST /authentification/verify/ -> 200 si le token est encore valide */
  verify: (token) => {
    return api.post(VERIFY_URL, { token });
  },
};

/**
 * Décode le payload d'un JWT (access token) sans dépendance externe
 * (pas de jwt-decode dans le projet). Ne vérifie PAS la signature —
 * c'est juste pour lire les claims (id, email, role, nom, prenom...)
 * que le backend a éventuellement ajoutés au token via un
 * CustomTokenObtainPairSerializer. La vérification de validité réelle
 * est faite côté serveur à chaque appel API protégé.
 *
 * @returns {object|null} le payload décodé, ou null si le token est
 *   absent/malformé.
 */
export function decodeJWT(token) {
  if (!token || typeof token !== 'string') return null;
  try {
    const base64Url = token.split('.')[1];
    if (!base64Url) return null;
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const padded = base64.padEnd(base64.length + ((4 - (base64.length % 4)) % 4), '=');
    const json = decodeURIComponent(
      atob(padded)
        .split('')
        .map((c) => '%' + c.charCodeAt(0).toString(16).padStart(2, '0'))
        .join('')
    );
    return JSON.parse(json);
  } catch (error) {
    return null;
  }
}

/** true si le JWT est expiré (claim `exp`, en secondes epoch) */
export function isTokenExpired(token) {
  const payload = decodeJWT(token);
  if (!payload?.exp) return false; // pas de claim exp -> on ne peut pas juger, on laisse passer
  return Date.now() >= payload.exp * 1000;
}

// On ajoute les utilitaires dans le service
authService.decodeJWT = decodeJWT;
authService.isTokenExpired = isTokenExpired;

// Export par défaut
export default authService;