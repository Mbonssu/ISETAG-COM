// Récupérer le token CSRF depuis une requête GET
export const fetchCSRFToken = async () => {
  try {
    const response = await fetch('/user_api/ISETAG_COM.users/', {
      method: 'GET',
      credentials: 'include',
    });
    
    // Le token CSRF est généralement dans les cookies
    const csrfToken = document.cookie
      .split('; ')
      .find(row => row.startsWith('csrftoken='))
      ?.split('=')[1];
    
    return csrfToken;
  } catch (error) {
    console.error('Erreur lors de la récupération du CSRF token:', error);
    return null;
  }
};
