import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';

/**
 * Enveloppe les routes qui exigent d'être connecté. Redirige vers /login
 * si personne n'est authentifié, en gardant en mémoire la page visée
 * (location.state.from) pour y revenir automatiquement après connexion.
 */
const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, isLoading } = useAuth();
  const location = useLocation();

  if (isLoading) {
    // Évite un flash de redirection vers /login pendant la lecture du
    // localStorage au tout premier rendu.
    return null;
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return children;
};

export default ProtectedRoute;