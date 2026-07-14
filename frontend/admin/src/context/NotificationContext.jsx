import React, { createContext, useContext, useState, useEffect, useCallback, useRef } from 'react';
import { relanceService } from '../services/relanceService';

/**
 * Système de notifications centralisé de l'app.
 *
 * ⚠️ Remplace l'ancien tableau `notifications` codé en dur dans Topbar.jsx
 * (qui n'était connecté à rien du tout).
 *
 * Aujourd'hui : détecte les relances dont l'heure est arrivée (comme
 * l'ancien hook useRelanceNotifications, maintenant fusionné ici pour
 * n'avoir qu'une seule source de vérité entre la cloche du Topbar et les
 * notifications système du navigateur).
 *
 * Extensible : pour ajouter une nouvelle source (ex: rendez-vous du jour,
 * nouveaux prospects...), ajouter une fonction verifierXxx() suivant le
 * même modèle que verifierRelances() et l'appeler dans le même intervalle.
 *
 * Persistance :
 * - "notifications_items_v1"  -> la liste des notifications elles-mêmes (avec read/unread)
 * - "notifications_vus_v1"    -> les IDs déjà détectés, pour ne jamais créer 2x la même notif
 */

const NotificationContext = createContext(null);

const POLL_INTERVAL_MS = 30 * 1000;
const OVERDUE_WINDOW_MS = 60 * 60 * 1000; // ne remonte que les relances dues dans la dernière heure
const STORAGE_ITEMS = 'notifications_items_v1';
const STORAGE_VUS = 'notifications_vus_v1';
const MAX_NOTIFICATIONS = 50;

const charger = (key, fallback) => {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch {
    return fallback;
  }
};

const sauvegarder = (key, value) => {
  try {
    localStorage.setItem(key, JSON.stringify(value));
  } catch {
    // localStorage indisponible : tant pis, pas bloquant
  }
};

export const NotificationProvider = ({ children }) => {
  const [notifications, setNotifications] = useState(() => charger(STORAGE_ITEMS, []));
  const vusRef = useRef(new Set(charger(STORAGE_VUS, [])));

  const persister = useCallback((list) => {
    sauvegarder(STORAGE_ITEMS, list.slice(0, MAX_NOTIFICATIONS));
    sauvegarder(STORAGE_VUS, Array.from(vusRef.current).slice(-500));
  }, []);

  const ajouterNotification = useCallback((notif) => {
    setNotifications((prev) => {
      const next = [notif, ...prev].slice(0, MAX_NOTIFICATIONS);
      persister(next);
      return next;
    });
  }, [persister]);

  // ── Source : relances dont l'heure est arrivée ──────────────────────────
  const verifierRelances = useCallback(async () => {
    try {
      const raw = await relanceService.getAll();
      const liste = Array.isArray(raw) ? raw : (raw?.results ?? []);
      const maintenant = Date.now();

      liste.forEach((relance) => {
        if (!relance.dateRelance || !relance.idRelance) return;
        const cleUnique = `relance:${relance.idRelance}`;
        if (vusRef.current.has(cleUnique)) return;

        const dateMs = new Date(relance.dateRelance).getTime();
        if (Number.isNaN(dateMs)) return;

        const estArrivee = dateMs <= maintenant;
        const estRecente = dateMs > maintenant - OVERDUE_WINDOW_MS;
        if (!estArrivee || !estRecente) return;

        const nomProspect = relance.prospect_details?.nomComplet || relance.idProspect;

        ajouterNotification({
          id: cleUnique,
          type: 'relance',
          title: `Relance : ${relance.sujet || 'Sans sujet'}`,
          message: `${nomProspect}${relance.description ? ' — ' + relance.description : ''}`,
          time: new Date().toISOString(),
          read: false,
          link: `/relances/${relance.idRelance}`,
        });

        // Notification système du navigateur (marche même onglet en arrière-plan)
        if (typeof Notification !== 'undefined' && Notification.permission === 'granted') {
          try {
            new Notification(`🔔 Relance : ${relance.sujet || 'Sans sujet'}`, {
              body: nomProspect,
              tag: cleUnique,
            });
          } catch {
            // certains navigateurs mobiles n'autorisent pas new Notification() directement
          }
        }

        vusRef.current.add(cleUnique);
      });
    } catch (err) {
      console.warn('⚠️ Impossible de vérifier les relances pour notification:', err);
    }
  }, [ajouterNotification]);

  useEffect(() => {
    if (typeof Notification !== 'undefined' && Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }, []);

  useEffect(() => {
    verifierRelances();
    const interval = setInterval(verifierRelances, POLL_INTERVAL_MS);
    return () => clearInterval(interval);
  }, [verifierRelances]);

  const markAsRead = useCallback((id) => {
    setNotifications((prev) => {
      const next = prev.map((n) => (n.id === id ? { ...n, read: true } : n));
      persister(next);
      return next;
    });
  }, [persister]);

  const markAllAsRead = useCallback(() => {
    setNotifications((prev) => {
      const next = prev.map((n) => ({ ...n, read: true }));
      persister(next);
      return next;
    });
  }, [persister]);

  const removeNotification = useCallback((id) => {
    setNotifications((prev) => {
      const next = prev.filter((n) => n.id !== id);
      persister(next);
      return next;
    });
  }, [persister]);

  const unreadCount = notifications.filter((n) => !n.read).length;

  return (
    <NotificationContext.Provider value={{ notifications, unreadCount, markAsRead, markAllAsRead, removeNotification }}>
      {children}
    </NotificationContext.Provider>
  );
};

export const useNotifications = () => {
  const ctx = useContext(NotificationContext);
  if (!ctx) throw new Error('useNotifications doit être utilisé dans un <NotificationProvider>');
  return ctx;
};