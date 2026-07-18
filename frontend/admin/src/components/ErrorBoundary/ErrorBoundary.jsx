import React from 'react';
import { AlertTriangle, RotateCcw } from 'lucide-react';
import './ErrorBoundary.css';

/**
 * Filet de sécurité global : si un composant plante pendant le rendu
 * (erreur JS non capturée — ex: import cassé, prop manquante, etc.),
 * React affiche normalement un écran blanc avec une stack trace illisible
 * pour l'utilisateur final. Ce composant intercepte ça et affiche un
 * message clair et traduit à la place, avec un bouton pour recharger.
 *
 * Doit être une classe (React exige componentDidCatch / getDerivedState,
 * pas encore disponible en hooks à ce jour).
 *
 * Usage : englober l'app entière dans App.jsx.
 * Les traductions sont injectées via prop `t` (le contexte de langue
 * n'est pas fiable ici : si LE PROBLÈME vient justement du contexte,
 * mieux vaut passer t en prop depuis un point stable au-dessus).
 */
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, info) {
    console.error(' Erreur non capturée (ErrorBoundary):', error, info);
  }

  handleReload = () => {
    window.location.reload();
  };

  render() {
    const { t } = this.props;
    const tr = (key, fallback) => (typeof t === 'function' ? t(key) : fallback);

    if (this.state.hasError) {
      return (
        <div className="error-boundary-screen">
          <AlertTriangle size={56} color="#ef4444" />
          <h2>{tr('erreurApplication', "Quelque chose s'est mal passé dans l'application.")}</h2>
          <p>{tr('erreurInconnue', "Une erreur inattendue s'est produite. Réessayez, ou contactez un administrateur si le problème persiste.")}</p>
          <button className="btn-primary" onClick={this.handleReload}>
            <RotateCcw size={16} /> {tr('rechargerLaPage', 'Recharger la page')}
          </button>
          {process.env.NODE_ENV === 'development' && this.state.error && (
            <details className="error-boundary-details">
              <summary>{tr('detailsTechniques', 'Détails techniques')}</summary>
              <pre>{String(this.state.error.stack || this.state.error.message || this.state.error)}</pre>
            </details>
          )}
        </div>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;