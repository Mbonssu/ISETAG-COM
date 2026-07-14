export class Prospect {
  constructor(data = {}) {
    // Correspond exactement au modèle Prospect de prospect_api/models.py
    this.id = data.idProspect || null;
    this.nomComplet = data.nomComplet || '';
    this.email = data.email || '';
    this.telephone = data.telephone || '';
    this.adresse = data.adresse || '';
    this.ville = data.ville || '';
    this.codePostal = data.codePostal || '';
    this.pays = data.pays || '';
    this.sexe = data.sexe || '';
    this.dateNaissance = data.dateNaissance || null;
    this.niveauEtude = data.niveauEtude || '';
    this.domaineEtude = data.domaineEtude || '';
    this.typeProspect = data.typeProspect || '';
    this.nomParent = data.nomParent || '';
    this.numeroParent = data.numeroParent || '';
    this.createdAt = data.createdAt || null;
    this.updatedAt = data.updatedAt || null;
  }

  get initials() {
    const parts = this.nomComplet.trim().split(/\s+/);
    const first = parts[0]?.charAt(0) || '';
    const second = parts[1]?.charAt(0) || '';
    return `${first}${second}`.toUpperCase() || 'P';
  }

  get sexeLabel() {
    if (this.sexe === 'M') return 'Masculin';
    if (this.sexe === 'F') return 'Féminin';
    return this.sexe || '-';
  }

  /** true si le prospect est mineur d'après dateNaissance (utile pour exiger un contact parent). */
  get estMineur() {
    if (!this.dateNaissance) return false;
    const naissance = new Date(this.dateNaissance);
    const age = (Date.now() - naissance.getTime()) / (365.25 * 24 * 3600 * 1000);
    return age < 18;
  }

  toJSON() {
    return {
      idProspect: this.id,
      nomComplet: this.nomComplet,
      email: this.email,
      telephone: this.telephone,
      adresse: this.adresse,
      ville: this.ville,
      codePostal: this.codePostal,
      pays: this.pays,
      sexe: this.sexe,
      dateNaissance: this.dateNaissance,
      niveauEtude: this.niveauEtude,
      domaineEtude: this.domaineEtude,
      typeProspect: this.typeProspect,
      nomParent: this.nomParent,
      numeroParent: this.numeroParent,
    };
  }

  static fromDjango(data) {
    return new Prospect(data);
  }

  static fromList(dataList) {
    return (dataList || []).map((item) => Prospect.fromDjango(item));
  }
}