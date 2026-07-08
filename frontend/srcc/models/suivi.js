/**
 * Modèle Suivi - Correspond aux données renvoyées par le backend Django
 * 
 * Structure exacte du backend :
 * {
 *   idSuivi: "SUIV-75B0C74F",
 *   idProspect: "PROS-001",
 *   dateSuivi: "2026-06-18",
 *   typeSuivi: "Appel",
 *   commentaire: "Premier contact...",
 *   prochainAction: "Rappeler dans 2 jours",
 *   idAgent: "AGT-001",
 *   statut: "Effectué",
 *   createdAt: "2026-06-18T10:00:00Z"
 * }
 */

export class Suivi {
  constructor(data = {}) {
    // Champs exacts du backend
    this.id = data.idSuivi || data.id || null;
    this.idProspect = data.idProspect || data.prospectId || '';
    this.dateSuivi = data.dateSuivi || '';
    this.typeSuivi = data.typeSuivi || 'Appel';
    this.commentaire = data.commentaire || '';
    this.prochainAction = data.prochainAction || '';
    this.idUtilisateur = data.idUtiisateur || data.idUtilisateur || '';
    this.statut = data.statut || 'En attente';
    this.createdAt = data.createdAt || new Date().toISOString();
    
    // Champs supplémentaires (pour affichage)
    this.nomProspect = data.nomProspect || '';
    this.nomUtilisateur = data.nomUtilisateur || '';
  }

  // ============================================================
  // PROPRIÉTÉS CALCULÉES (getters)
  // ============================================================

  /** Type de suivi en français */
  get typeLabel() {
    const types = {
      'Appel': '📞 Appel',
      'Email': '✉️ Email',
      'Visite': '🏢 Visite',
      'SMS': '📱 SMS',
      'Autre': '📋 Autre'
    };
    return types[this.typeSuivi] || this.typeSuivi;
  }

  /** Statut en français */
  get statutLabel() {
    const statuts = {
      'En attente': '⏳ En attente',
      'Effectué': '✅ Effectué',
      'Annulé': '❌ Annulé',
      'Reporté': '🔄 Reporté'
    };
    return statuts[this.statut] || this.statut;
  }

  /** Date formatée */
  get dateFormatee() {
    if (!this.dateSuivi) return '';
    try {
      const date = new Date(this.dateSuivi);
      return date.toLocaleDateString('fr-FR', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
      });
    } catch {
      return this.dateSuivi;
    }
  }

  /** Date complète avec heure */
  get dateComplete() {
    if (!this.createdAt) return this.dateFormatee;
    try {
      const date = new Date(this.createdAt);
      return date.toLocaleDateString('fr-FR', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch {
      return this.dateFormatee;
    }
  }

  // ============================================================
  // MÉTHODES DE CONVERSION
  // ============================================================

  /**
   * Convertit les données Django en instance Suivi
   */
  static fromDjango(data) {
    if (data instanceof Suivi) return data;
    if (Array.isArray(data)) {
      return data.map(item => Suivi.fromDjango(item));
    }
    return new Suivi(data);
  }

  /**
   * Convertit l'instance en objet pour l'API Django
   */
  toDjango() {
    return {
      idSuivi: this.id,
      idProspect: this.idProspect,
      dateSuivi: this.dateSuivi,
      typeSuivi: this.typeSuivi,
      commentaire: this.commentaire,
      prochainAction: this.prochainAction,
      idAgent: this.idAgent,
      statut: this.statut,
    };
  }

  /**
   * Convertit en objet simple (pour affichage)
   */
  toJSON() {
    return {
      id: this.id,
      idProspect: this.idProspect,
      nomProspect: this.nomProspect,
      dateSuivi: this.dateSuivi,
      dateFormatee: this.dateFormatee,
      dateComplete: this.dateComplete,
      typeSuivi: this.typeSuivi,
      typeLabel: this.typeLabel,
      commentaire: this.commentaire,
      prochainAction: this.prochainAction,
      idAgent: this.idAgent,
      nomAgent: this.nomAgent,
      statut: this.statut,
      statutLabel: this.statutLabel,
      createdAt: this.createdAt,
    };
  }
}
