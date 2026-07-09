import { useSearchParams } from 'react-router-dom';
import { useCallback } from 'react';

/**
 * Comme useState, mais synchronisé avec un paramètre de l'URL (?cle=valeur).
 *
 * Avantages :
 * - Revenir en arrière (bouton retour du navigateur) restaure la recherche/le filtre
 * - Un lien copié-collé garde le filtre appliqué
 * - Rafraîchir la page (F5) ne perd plus la recherche en cours
 *
 * Usage (remplace un simple useState) :
 *   const [searchTerm, setSearchTerm] = useUrlState('q', '');
 *   const [filterType, setFilterType] = useUrlState('type', 'all');
 *
 * Si la valeur === defaultValue, elle est retirée de l'URL (reste propre).
 */
export function useUrlState(key, defaultValue = '') {
  const [searchParams, setSearchParams] = useSearchParams();
  const value = searchParams.get(key) ?? defaultValue;

  const setValue = useCallback((newValue) => {
    setSearchParams((prev) => {
      const next = new URLSearchParams(prev);
      if (!newValue || newValue === defaultValue) {
        next.delete(key);
      } else {
        next.set(key, newValue);
      }
      return next;
    }, { replace: true });
  }, [key, defaultValue, setSearchParams]);

  return [value, setValue];
}