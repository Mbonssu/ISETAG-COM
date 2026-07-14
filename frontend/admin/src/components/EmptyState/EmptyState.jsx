import React from 'react';
import { SearchX, Inbox, Plus } from 'lucide-react';
import './EmptyState.css';

/**
 * État vide réutilisable, avec 2 variantes :
 *
 * 1. Recherche sans résultat (l'utilisateur a filtré/cherché) :
 *    <EmptyState
 *      variant="search"
 *      searchTerm={searchTerm}
 *      onClearFilters={() => { setSearchTerm(''); setFilterX('all'); }}
 *    />
 *
 * 2. Liste vraiment vide (rien n'a jamais été créé) :
 *    <EmptyState
 *      variant="empty"
 *      title="Aucun prospect pour le moment"
 *      message="Commence par ajouter ton premier prospect."
 *      actionLabel="Ajouter un prospect"
 *      onAction={() => navigate('/prospects/new')}
 *    />
 */
const EmptyState = ({
  variant = 'empty',
  searchTerm = '',
  onClearFilters,
  title,
  message,
  actionLabel,
  onAction,
}) => {
  if (variant === 'search') {
    return (
      <div className="empty-state">
        <SearchX size={48} className="empty-state-icon" />
        <h3>Aucun résultat trouvé</h3>
        <p>
          {searchTerm
            ? <>Rien ne correspond à ta recherche "<strong>{searchTerm}</strong>".</>
            : 'Aucun élément ne correspond aux filtres sélectionnés.'}
        </p>
        {onClearFilters && (
          <button className="btn-outline" onClick={onClearFilters}>Effacer les filtres</button>
        )}
      </div>
    );
  }

  return (
    <div className="empty-state">
      <Inbox size={48} className="empty-state-icon" />
      <h3>{title || 'Rien à afficher pour le moment'}</h3>
      {message && <p>{message}</p>}
      {onAction && (
        <button className="btn-primary" onClick={onAction}>
          <Plus size={16} /> {actionLabel || 'Créer'}
        </button>
      )}
    </div>
  );
};

export default EmptyState;