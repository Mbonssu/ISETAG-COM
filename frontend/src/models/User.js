export class User {
  constructor(data = {}) {
    // Correspond exactement à la réponse Django
    this.id = data.idUtilisateur || data.id || null;
    this.nom = data.nom || '';
    this.prenom = data.prenom || '';
    this.telephone = data.telephone || '';
    this.email = data.email || '';
    this.role = data.role || '';
    this.statut = data.statut || '';
    this.actif = data.actif !== undefined ? data.actif : true;
    this.dateEmbauche = data.dateEmbauche || null;
    this.photoProfil = data.photoProfil || null;
    this.createdAt = data.createdAt || new Date().toISOString();
    this.username = data.username || '';
    this.is_active = data.is_active || true;
    this.is_superuser = data.is_superuser || false;
  }

  get fullName() {
    return `${this.nom} ${this.prenom}`.trim() || this.username || 'Utilisateur';
  }

  get initials() {
    const first = this.nom?.charAt(0) || '';
    const last = this.prenom?.charAt(0) || '';
    return `${first}${last}`.toUpperCase() || 'U';
  }

  get isActive() {
    return this.actif && this.is_active;
  }

  get displayRole() {
    const roles = {
      'AGENT_COMMERCIAL': 'Agent',
      'ADMINISTRATEUR': 'Administrateur',
      'SUPERVISEUR': 'Superviseur',
      'MANAGER': 'Manager',
    };
    return roles[this.role] || this.role || 'Utilisateur';
  }

  toJSON() {
    return {
      idUtilisateur: this.id,
      nom: this.nom,
      prenom: this.prenom,
      telephone: this.telephone,
      email: this.email,
      role: this.role,
      statut: this.statut,
      actif: this.actif,
      dateEmbauche: this.dateEmbauche,
      photoProfil: this.photoProfil,
      createdAt: this.createdAt,
      username: this.username,
    };
  }

  static fromDjango(data) {
    return new User(data);
  }

  static fromList(dataList) {
    return (dataList || []).map(item => User.fromDjango(item));
  }
}
