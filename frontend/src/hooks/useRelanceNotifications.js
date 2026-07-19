import { useState, useEffect, useRef, useCallback } from 'react';
import { relanceService } from '../services/relanceService';

/**
 * Hook global de notification des relances.
 *
 *  Limite honnête : ceci vérifie périodiquement (toutes les 30s) pendant
 * que l'application est ouverte dans le navigateur. Ça ne peut PAS envoyer
 * une notification si l'app est complètement fermée (pas d'onglet ouvert) —
 * ça demanderait des notifications push serveur (Web Push + backend dédié),
 * qui n'existent pas dans l'API actuelle (aucune route de ce type dans le
 * YAML). Tant que le navigateur est ouvert (même onglet en arrière-plan ou
 * minimisé), la notification système sortira normalement.
 *
 * Fonctionnement :
 * 1. Demande la permission de notification au navigateur au montage.
 * 2. Toutes les POLL_INTERVAL_MS, récupère toutes les relances.
 * 3. Pour chaque relance dont dateRelance est arrivée (entre "il y a
 *    OVERDUE_WINDOW_MS" et "maintenant") et qui n'a pas déjà été notifiée
 *    (mémorisé dans localStorage, donc persiste même après un rechargement
 *    de page), déclenche une notification navigateur + un toast interne.
 *
 * Utilisation : à monter UNE SEULE FOIS au niveau racine de l'app (App.jsx),
 * pas dans chaque page, sinon les vérifications se dupliqueraient.
 */

const POLL_INTERVAL_MS = 30 * 1000;        // vérifie toutes les 30 secondes
const OVERDUE_WINDOW_MS = 60 * 60 * 1000;  // ne notifie que les relances dues dans la dernière heure
const STORAGE_KEY = 'relances_notifiees_v1';

const chargerIdsNotifiees = () => {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? new Set(JSON.parse(raw)) : new Set();
  } catch {
    return new Set();
  }
};

const sauvegarderIdsNotifiees = (set) => {
  try {
    // On ne garde que les 500 dernières pour ne pas faire grossir le localStorage indéfiniment
    const arr = Array.from(set).slice(-500);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(arr));
  } catch {
    // localStorage indisponible (mode privé strict, quota dépassé...) : tant pis, pas bloquant
  }
};

export const useRelanceNotifications = () => {
  const [toasts, setToasts] = useState([]);
  const notifiedIdsRef = useRef(chargerIdsNotifiees());

  const addToast = useCallback((message, type = 'info') => {
    const id = Date.now() + Math.random();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 8000); // 8s, un peu plus long qu'un toast normal vu l'importance
  }, []);

  const removeToast = useCallback((id) => {
    setToasts(prev => prev.filter(t => t.id !== id));
  }, []);

  // Demande la permission de notification une seule fois au montage
  useEffect(() => {
    if (typeof Notification !== 'undefined' && Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }, []);

  const verifierRelances = useCallback(async () => {
    try {
      const data = await relanceService.getAll();
      const liste = Array.isArray(data) ? data : (data?.results ?? []);
      const maintenant = Date.now();

      liste.forEach((relance) => {
        if (!relance.dateRelance || !relance.idRelance) return;
        if (notifiedIdsRef.current.has(relance.idRelance)) return;

        const dateRelanceMs = new Date(relance.dateRelance).getTime();
        if (Number.isNaN(dateRelanceMs)) return;

        const estArrivee = dateRelanceMs <= maintenant;
        const estRecente = dateRelanceMs > maintenant - OVERDUE_WINDOW_MS;

        if (estArrivee && estRecente) {
          const nomProspect = relance.prospect_details?.nomComplet || relance.idProspect;
          const titre = `🔔 Relance : ${relance.sujet || 'Sans sujet'}`;
          const corps = `${nomProspect} — ${relance.description || ''}`.trim();

          // Notification système du navigateur
          if (typeof Notification !== 'undefined' && Notification.permission === 'granted') {
            try {
              new Notification(titre, { body: corps, tag: relance.idRelance });
            } catch {
              // certains navigateurs mobiles n'autorisent pas `new Notification()` directement
            }
          }

          // Toast interne (complément, ou solution de secours si permission refusée)
          addToast(`${titre} — ${nomProspect}`, 'info');

          notifiedIdsRef.current.add(relance.idRelance);
        }
      });

      sauvegarderIdsNotifiees(notifiedIdsRef.current);
    } catch (err) {
      console.warn(' Impossible de vérifier les relances pour notification:', err);
    }
  }, [addToast]);

  useEffect(() => {
    verifierRelances(); // premier check immédiat au montage
    const interval = setInterval(verifierRelances, POLL_INTERVAL_MS);
    return () => clearInterval(interval);
  }, [verifierRelances]);

  return { toasts, removeToast };
};