import React, { createContext, useState, useContext, useEffect } from "react";
import { User } from "../models/User";
import authService from "../services/authService";


const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return context;
};

/**
 * Construit un User (models/User.js) à partir des claims du JWT décodé,
 * en repli sur l'email saisi au login si le backend n'a pas ajouté ces
 * infos dans le token (auquel cas seuls email/role minimalistes seront
 * disponibles tant qu'aucun endpoint "profil courant" n'existe côté API).
 */
const buildUserFromToken = (accessToken, fallbackEmail) => {
  const claims = authService.decodeJWT(accessToken) || {};
  return new User({
    idUtilisateur: claims.idUtilisateur || claims.id || claims.user_id || null,
    nom: claims.nom || "",
    prenom: claims.prenom || "",
    email: claims.email || fallbackEmail || "",
    role: claims.role || "",
    username: claims.username || "",
    telephone: claims.telephone || "",
    photoProfil: claims.photoProfil || null,
    is_superuser: claims.is_superuser || false,
  });
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  const resolveLoginError = (error) => {
    if (!error) {
      return { success: false, error: "erreurInconnue" };
    }

    if (error.status === 401) {
      return { success: false, error: "identifiantsInvalides" };
    }

    if (error.errorKey) {
      return { success: false, error: error.errorKey };
    }

    const message =
      typeof error.message === "string" ? error.message.toLowerCase() : "";
    if (
      message.includes("failed to fetch") ||
      message.includes("networkerror") ||
      message.includes("err_name_not_resolved")
    ) {
      return { success: false, error: "erreurReseau" };
    }

    return { success: false, error: "erreurInconnue" };
  };

  useEffect(() => {
    // Restaure la session à partir du localStorage (token + user mis en
    // cache lors du dernier login réussi). Si le token access a expiré,
    // on ne le garde pas tel quel : on nettoie, l'utilisateur devra se
    // reconnecter (pas de refresh silencieux au démarrage pour l'instant).
    const storedToken = localStorage.getItem("auth_token");
    const storedUser = localStorage.getItem("user");

    if (storedToken && storedUser && !authService.isTokenExpired(storedToken)) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (error) {
        localStorage.removeItem("auth_token");
        localStorage.removeItem("refresh_token");
        localStorage.removeItem("user");
        setUser(null);
      }
    } else if (storedToken) {
      // Token présent mais expiré (ou user manquant) -> session invalide
      localStorage.removeItem("auth_token");
      localStorage.removeItem("refresh_token");
      localStorage.removeItem("user");
    }
    setIsLoading(false);
  }, []);

  /**
   * POST /authentification/login/ -> { access, refresh }.
   * Stocke les deux tokens JWT (access utilisé par api.js pour le header
   * Authorization, refresh pour /authentification/refresh/ et /logout/)
   * ainsi qu'un User construit à partir des claims de l'access token.
   *
   * Retourne { success: true } ou { success: false, error: 'code' } pour
   * que le composant Login affiche un message traduit adapté.
   */

  const login = async (email, password) => {
    try {

      const data = await authService.login(email.trim(), password);


      const accessToken = data?.access;
      const refreshToken = data?.refresh;

      if (!accessToken || !refreshToken) {
        return { success: false, error: "identifiantsInvalides" };
      }

      const userData = buildUserFromToken(accessToken, email.trim());

      localStorage.setItem("auth_token", accessToken);
      localStorage.setItem("refresh_token", refreshToken);
      localStorage.setItem("user", JSON.stringify(userData));

      setUser(userData);
      return { success: true };
    } catch (error) {
      return resolveLoginError(error);
    }
  };

  /**
   * Blackliste le refresh token côté serveur (POST /authentification/logout/)
   * puis nettoie la session locale. L'appel serveur est "best effort" :
   * même s'il échoue (serveur injoignable, token déjà expiré...), on
   * déconnecte quand même l'utilisateur côté client.
   */
  const logout = async () => {
    const refreshToken = localStorage.getItem("refresh_token");
    if (refreshToken) {
      try {
        await authService.logout(refreshToken);
      } catch (error) {
        console.error(
          " Logout serveur échoué (déconnexion locale quand même):",
          error,
        );
      }
    }
    setUser(null);
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("user");
  };

  const isAuthenticated = !!user;

  return (
    <AuthContext.Provider
      value={{ user, isLoading, isAuthenticated, login, logout }}
    >
      {children}
    </AuthContext.Provider>
  );
};
