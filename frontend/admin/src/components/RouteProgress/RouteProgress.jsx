import React, { useEffect, useState, useRef } from 'react';
import { useLocation } from 'react-router-dom';
import './RouteProgress.css';

/**
 * Barre de progression globale en haut de l'écran, façon YouTube/GitHub,
 * qui se déclenche à chaque changement de route.
 *
 * Limite honnête : comme les pages chargent leurs données elles-mêmes
 * (chaque page a son propre `loading`), cette barre ne connaît pas le
 * vrai temps de chargement réel de la page suivante. Elle simule une
 * progression fluide sur une durée courte à chaque navigation, ce qui
 * donne une sensation de réactivité immédiate au clic, sans bloquer
 * l'affichage du contenu (qui, lui, gère toujours son propre skeleton).
 *
 * À monter une seule fois, au niveau racine (App.jsx), au-dessus des Routes.
 */
const RouteProgress = () => {
  const location = useLocation();
  const [progress, setProgress] = useState(0);
  const [visible, setVisible] = useState(false);
  const timeoutsRef = useRef([]);

  useEffect(() => {
    timeoutsRef.current.forEach(clearTimeout);
    timeoutsRef.current = [];

    setVisible(true);
    setProgress(15);

    timeoutsRef.current.push(setTimeout(() => setProgress(45), 80));
    timeoutsRef.current.push(setTimeout(() => setProgress(70), 220));
    timeoutsRef.current.push(setTimeout(() => setProgress(90), 420));
    timeoutsRef.current.push(setTimeout(() => {
      setProgress(100);
      timeoutsRef.current.push(setTimeout(() => {
        setVisible(false);
        setProgress(0);
      }, 200));
    }, 600));

    return () => timeoutsRef.current.forEach(clearTimeout);
  }, [location.pathname]);

  if (!visible) return null;

  return (
    <div className="route-progress-track">
      <div className="route-progress-bar" style={{ width: `${progress}%` }} />
    </div>
  );
};

export default RouteProgress;