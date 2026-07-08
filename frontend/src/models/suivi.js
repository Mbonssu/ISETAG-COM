/**
 * Modèle Suivi - Correspond aux données RÉELLEMENT renvoyées par le backend
 * (schéma SuiviProspect / SuiviProspectRequest de ISETAG_COM_API.yaml)
 *
 * ⚠️ CORRIGÉ : le backend n'a QUE ces champs. Il n'existe PAS de
 * typeSuivi, idAgent, statut ni prochainAction côté serveur — ces champs
 * ont été retirés (ils n'étaient jamais réellement sauvegardés).
 *
 * Structure exacte du backend :
 * {
 *   idSuivi: "SUIV-75B0C74F",
 *   idProspect: "PROS-001",
 *   prospect_details: { ... },   // objet complet du prospect, en lecture seule
 *   libeleSuivi: "Appel de suivi",
 *   dateSuivi: "2026-06-18T10:00:00Z",   // date-time complet, pas juste une date
 *   commentaire: "Premier contact...",
 *   createdAt: "2026-06-18T10:00:00Z",   // lecture seule
 *   updatedAt: "2026-06-18T10:00:00Z"    // lecture seule
 * }
 */

export class Suivi {
  constructor(data = {}) {
    this.id = data.idSuivi || data.id || null;
    this.idProspect = data.idProspect || '';
    this.libeleSuivi = data.libeleSuivi || '';
    this.dateSuivi = data.dateSuivi || '';
    this.commentaire = data.commentaire || '';
    this.createdAt = data.createdAt || '';
    this.updatedAt = data.updatedAt || '';

    // Objet prospect complet, renvoyé par le backend en lecture seule
    // (utile pour afficher le nom sans requête supplémentaire)
    this.prospectDetails = data.prospect_details || null;
    this.nomProspect = this.prospectDetails?.nomComplet || '';
  }

  /** Date de suivi formatée en français */
  get dateFormatee() {
    if (!this.dateSuivi) return '';
    try {
      const date = new Date(this.dateSuivi);
      return date.toLocaleDateString('fr-FR', {
        day: 'numeric', month: 'long', year: 'numeric',
        hour: '2-digit', minute: '2-digit',
      });
    } catch {
      return this.dateSuivi;
    }
  }

  /**
   * Convertit les données Django (ou une liste) en instance(s) Suivi
   */
  static fromDjango(data) {
    if (data instanceof Suivi) return data;
    if (Array.isArray(data)) return data.map((item) => Suivi.fromDjango(item));
    if (data?.results) return data.results.map((item) => Suivi.fromDjango(item));
    return new Suivi(data);
  }

  /**
   * Convertit l'instance en payload pour l'API (POST/PUT)
   * Champs attendus par SuiviProspectRequest : idSuivi, idProspect,
   * libeleSuivi, dateSuivi, commentaire — tous requis.
   */
  toDjango() {
    return {
      idSuivi: this.id,
      idProspect: this.idProspect,
      libeleSuivi: this.libeleSuivi,
      dateSuivi: this.dateSuivi,
      commentaire: this.commentaire,
    };
  }
}