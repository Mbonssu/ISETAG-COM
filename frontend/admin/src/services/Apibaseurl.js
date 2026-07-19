/**
 * Résolution de l'URL de base de l'API, avec bascule automatique :
 *
 *   1. En priorité : l'URL ngrok (accessible depuis n'importe où, même
 *      hors du réseau local — utile pour tester/démontrer à distance).
 *   2. Si ngrok est injoignable (tunnel fermé, ngrok arrêté, coupure
 *      réseau externe...) : bascule automatiquement sur l'adresse IP
 *      locale statique du serveur (accessible uniquement sur le même
 *      réseau local/LAN, mais ne dépend pas d'internet).
 *
 * Les deux URLs sont lues depuis les variables d'environnement (fichier
 * .env à la racine du projet), PAS codées en dur dans le code — comme ça,
 * changer d'adresse ngrok ou d'IP locale ne demande jamais de modifier
 * le code, juste le .env (voir .env.example fourni à côté).
 */

const NGROK_URL = process.env.REACT_APP_NGROK_URL || '';
const LOCAL_URL = process.env.REACT_APP_LOCAL_URL || '';

// Délai max qu'on laisse à chaque adresse pour répondre avant de passer
// à la suivante. Court exprès : si ngrok ne répond pas en 4s, ce n'est
// pas la peine d'attendre plus longtemps, mieux vaut basculer vite.
const HEALTH_CHECK_TIMEOUT_MS = 4000;

// Une fois basculé sur le local suite à un échec ngrok, on retentera
// ngrok automatiquement après ce délai (pour revenir dessus s'il redevient
// disponible), plutôt que de rester bloqué sur le local indéfiniment.
const RETRY_PRIMARY_AFTER_MS = 5 * 60 * 1000; // 5 minutes

let currentBaseUrl = null;   // URL actuellement utilisée (résolue au 1er appel)
let lastSwitchToFallbackAt = 0;

/**
 * Teste si une URL répond, avec un timeout court. On ne regarde pas le
 * status HTTP (même une 404 prouve que le serveur est joignable) — on
 * regarde juste si la requête réseau elle-même aboutit ou échoue/timeout.
 *
 *  Si LOCAL_URL est en HTTPS avec un certificat auto-signé (cas courant
 * pour un Django en local), ce test échouera TANT QUE l'utilisateur n'a
 * pas déjà accepté manuellement ce certificat dans son navigateur (visite
 * directe de l'URL + "Continuer quand même"). C'est une limite du
 * navigateur, aucun code ne peut la contourner. Si le failover semble ne
 * jamais fonctionner vers le local, c'est la première chose à vérifier.
 */
async function isReachable(baseUrl) {
  if (!baseUrl) return false;
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), HEALTH_CHECK_TIMEOUT_MS);
  try {
    await fetch(baseUrl, { method: 'GET', signal: controller.signal, mode: 'cors' });
    return true; // toute réponse HTTP, même une erreur 4xx/5xx, prouve la joignabilité
  } catch {
    return false; // timeout, DNS injoignable, tunnel fermé, CORS bloqué au niveau réseau...
  } finally {
    clearTimeout(timeoutId);
  }
}

/**
 * Résout et retourne l'URL de base à utiliser MAINTENANT. Résultat mis en
 * cache en mémoire pour éviter de re-tester à chaque requête ; seuls les
 * cas suivants déclenchent une nouvelle résolution :
 *  - premier appel de la session (currentBaseUrl encore null)
 *  - on est actuellement sur le fallback local ET RETRY_PRIMARY_AFTER_MS
 *    s'est écoulé depuis la bascule -> on retente ngrok
 */
export async function resolveApiBaseUrl() {
  const isOnFallback = currentBaseUrl && currentBaseUrl === LOCAL_URL;
  const shouldRetryPrimary = isOnFallback && (Date.now() - lastSwitchToFallbackAt > RETRY_PRIMARY_AFTER_MS);

  if (currentBaseUrl && !shouldRetryPrimary) {
    return currentBaseUrl;
  }

  if (NGROK_URL && (await isReachable(NGROK_URL))) {
    if (currentBaseUrl !== NGROK_URL) {
      ('API : utilisation de ngrok ->', NGROK_URL);
    }
    currentBaseUrl = NGROK_URL;
    return currentBaseUrl;
  }

  if (LOCAL_URL) {
    console.warn(' ngrok injoignable, bascule sur le serveur local ->', LOCAL_URL);
    currentBaseUrl = LOCAL_URL;
    lastSwitchToFallbackAt = Date.now();
    return currentBaseUrl;
  }

  // Aucune des deux configurée/joignable : on retombe sur '' (relatif),
  // le comportement d'origine du projet.
  console.error('Ni ngrok ni le serveur local ne sont joignables.');
  currentBaseUrl = '';
  return currentBaseUrl;
}

/**
 * Force une nouvelle résolution au prochain appel — utilisé par api.js
 * quand une requête échoue en cours de route (ngrok tombe en plein
 * milieu d'une session utilisateur), pour basculer immédiatement sans
 * attendre les 5 minutes de retry automatique.
 */
export function invalidateBaseUrlCache() {
  currentBaseUrl = null;
}

/** Utilisé par api.js pour savoir si l'échec courant justifie un failover. */
export function getLastKnownBaseUrl() {
  return currentBaseUrl;
}