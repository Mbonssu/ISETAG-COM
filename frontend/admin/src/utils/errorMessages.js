/**
 * Convertit une erreur JS/API brute en message utilisateur clair et
 * TRADUIT (fr/en), à afficher dans un toast, une bannière d'erreur, etc.
 *
 * Ne jamais afficher error.message directement à l'utilisateur : c'est
 * souvent du texte technique Django/DRF en anglais/français mélangé
 * ("ProspectView.delete() got multiple values for argument 'pk'"...).
 * Cette fonction choisit un message propre selon error.errorKey (posé
 * par services/api.js), avec repli raisonnable si errorKey est absent.
 *
 * Usage dans un composant :
 *   import { getErrorMessage } from '../../utils/errorMessages';
 *   const { t } = useTranslation();
 *   ...
 *   catch (err) {
 *     addToast(getErrorMessage(err, t), 'error');
 *   }
 */
export function getErrorMessage(error, t) {
  if (!error) return t('erreurInconnue');

  // Erreur avec clé de traduction déjà posée par api.js
  if (error.errorKey && typeof t === 'function') {
    return t(error.errorKey);
  }

  // Erreur réseau native du navigateur, pas encore passée par api.js
  // (ex: fetch direct ailleurs, timeout AbortController...)
  if (error instanceof TypeError || error.name === 'TypeError') {
    return t ? t('erreurReseau') : 'Impossible de contacter le serveur.';
  }

  // Dernier repli : le message brut de l'erreur, s'il existe, sinon générique
  return error.message || (t ? t('erreurInconnue') : 'Une erreur est survenue.');
}

/**
 * Variante qui retourne aussi les erreurs de validation détaillées par
 * champ (utile pour afficher, en plus du message général, la liste des
 * champs en erreur renvoyés par le backend — ex: { nom: ["requis"] }).
 *
 * Retourne { message: string, fieldErrors: string|null }
 */
export function getErrorDetails(error, t) {
  return {
    message: getErrorMessage(error, t),
    fieldErrors: error?.fieldErrors || null,
  };
}