// statsService.js
//
// Toute la logique de calcul des statistiques du dashboard à partir des
// données brutes renvoyées par les endpoints CRUD existants. Il n'y a
// AUCUN appel réseau ici : on ne fait que transformer des tableaux déjà
// récupérés par useDashboardStats (voir src/hooks/useDashboardStats.js).
//
// L'API (ISETAG_COM_API.yaml) n'expose pas de endpoint "/stats", donc tout
// est recalculé côté front à partir de :
//   - prospect_api/ISETAG_COM.prospects/      -> prospects
//   - prospect_api/ISETAG_COM.rendezvous/     -> rendezVous
//   - prospect_api/ISETAG_COM.relances/       -> relances
//   - prospect_api/ISETAG_COM.suivis/         -> suivis
//   - campagne_api/ISETAG_COM.campagnes/      -> campagnes
//   - campagne_api/ISETAG_COM.sorties/        -> sorties
//   - campagne_api/ISETAG_COM.fiches-sortie/  -> fichesSortie
//   - user_api/ISETAG_COM.users/ (role=agent) -> agents

const MONTHS_FR = [
  'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
  'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc',
];

const SOURCE_COLORS = ['#2d7a3a', '#f5c842', '#b0bec5', '#78909c', '#dde3e7', '#8fb996'];

// ---------- helpers ----------
const monthKey = (d) => `${d.getFullYear()}-${d.getMonth()}`;

const formatDateFR = (isoDate) => {
  if (!isoDate) return '-';
  const d = new Date(isoDate);
  if (Number.isNaN(d.getTime())) return '-';
  return d.toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric' });
};

const initialsOf = (nomComplet = '') => {
  const parts = nomComplet.trim().split(/\s+/).filter(Boolean);
  const first = parts[0]?.charAt(0) || '';
  const second = parts[1]?.charAt(0) || '';
  return `${first}${second}`.toUpperCase() || 'P';
};

// ---------- 1. KPI CARDS ----------
// Chaque carte ne porte de "trend" que si on a vraiment de quoi le calculer
// (comparaison mois courant / mois précédent). Sinon on l'omet plutôt que
// d'inventer un chiffre.
export function computeKPIs({ prospects, relances, sorties, agents }) {
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const startOfPrevMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);

  const nouveauxCeMois = prospects.filter(
    (p) => p.createdAt && new Date(p.createdAt) >= startOfMonth
  ).length;

  const nouveauxMoisPrecedent = prospects.filter((p) => {
    if (!p.createdAt) return false;
    const d = new Date(p.createdAt);
    return d >= startOfPrevMonth && d < startOfMonth;
  }).length;

  const variationTotal =
    nouveauxMoisPrecedent === 0
      ? null
      : Math.round(
          ((nouveauxCeMois - nouveauxMoisPrecedent) / nouveauxMoisPrecedent) * 100
        );

  // "Établissements visités" = nombre d'établissements distincts couverts
  // par les sorties (idEtablissement), sur toutes les sorties enregistrées.
  const etablissementsVisites = new Set(
    sorties.map((s) => s.idEtablissement).filter(Boolean)
  ).size;

  return [
    {
      key: 'total',
      icon: '👥',
      label: 'Total Prospects',
      value: prospects.length,
      color: 'green',
      ...(variationTotal !== null && {
        trend: `${variationTotal >= 0 ? '+' : ''}${variationTotal}%`,
        vs: 'vs mois dernier',
      }),
    },
    {
      key: 'relances',
      icon: '📋',
      label: 'À relancer',
      value: relances.length,
      color: 'yellow',
    },
    {
      key: 'etablissements',
      icon: '🏫',
      label: 'Établissements visités',
      value: etablissementsVisites,
      color: 'green',
    },
    {
      key: 'agents',
      icon: '👤',
      label: 'Agents actifs',
      value: agents.length,
      color: 'yellow',
    },
  ];
}

// ---------- 2. EVOLUTION CHART ----------
// Regroupe prospects (createdAt) et relances (dateRelance) par mois, sur
// les N derniers mois, pour tracer les deux courbes du graphe.
export function computeEvolution(prospects, relances, monthsBack = 7) {
  const now = new Date();
  const buckets = [];

  for (let i = monthsBack - 1; i >= 0; i--) {
    const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
    buckets.push({ key: monthKey(d), label: `${MONTHS_FR[d.getMonth()]} ${d.getFullYear()}`, total: 0, relance: 0 });
  }

  prospects.forEach((p) => {
    if (!p.createdAt) return;
    const bucket = buckets.find((b) => b.key === monthKey(new Date(p.createdAt)));
    if (bucket) bucket.total += 1;
  });

  // Le total est cumulatif (comme dans la maquette d'origine : la courbe
  // "Total prospects" grimpe mois après mois), la relance reste un compte
  // par mois (nombre de relances créées ce mois-là).
  let running = 0;
  buckets.forEach((b) => {
    running += b.total;
    b.total = running;
  });

  relances.forEach((r) => {
    if (!r.dateRelance) return;
    const bucket = buckets.find((b) => b.key === monthKey(new Date(r.dateRelance)));
    if (bucket) bucket.relance += 1;
  });

  return {
    labels: buckets.map((b) => b.label),
    total: buckets.map((b) => b.total),
    relance: buckets.map((b) => b.relance),
  };
}

// ---------- 3. SOURCE DONUT ----------
// Regroupe les fiches de sortie par source (source_detail.libele / idSource)
export function computeSourceDistribution(fichesSortie) {
  const counts = {};

  fichesSortie.forEach((f) => {
    const libele = f.source_detail?.libele || f.idSource || 'Inconnue';
    counts[libele] = (counts[libele] || 0) + 1;
  });

  const total = fichesSortie.length || 1;

  return Object.entries(counts)
    .map(([name, value], idx) => ({
      name,
      value,
      percentage: Math.round((value / total) * 100),
      color: SOURCE_COLORS[idx % SOURCE_COLORS.length],
    }))
    .sort((a, b) => b.value - a.value);
}

// ---------- 4. FILIERE BARS ----------
// Regroupe les prospects par domaine d'étude (domaineEtude)
export function computeFiliereDistribution(prospects) {
  const counts = {};

  prospects.forEach((p) => {
    const filiere = p.domaineEtude || 'Non renseigné';
    counts[filiere] = (counts[filiere] || 0) + 1;
  });

  const total = prospects.length || 1;

  return Object.entries(counts)
    .map(([name, value]) => ({
      name,
      value,
      percentage: Math.round((value / total) * 100),
    }))
    .sort((a, b) => b.value - a.value);
}

// ---------- 5. RECENT ACTIVITIES ----------
// Fusionne fiches de sortie, rendez-vous, suivis et relances en un seul flux
// chronologique, trié du plus récent au plus ancien.
export function computeRecentActivities({ fichesSortie, rendezVous, suivis, relances }, limit = 10) {
  const activities = [];

  fichesSortie.forEach((f) =>
    activities.push({
      icon: '👤',
      iconType: 'person',
      title: `Nouveau prospect collecté${f.prospect_detail?.nomComplet ? ' : ' + f.prospect_detail.nomComplet : ''}`,
      subtitle: f.source_detail?.libele || '',
      date: f.createdAt,
    })
  );

  rendezVous.forEach((r) =>
    activities.push({
      icon: '🕐',
      iconType: 'clock',
      title: `RDV programmé : ${r.sujet || ''}`,
      subtitle: formatDateFR(r.dateRendezVous),
      date: r.createdAt || r.dateRendezVous,
    })
  );

  suivis.forEach((s) =>
    activities.push({
      icon: '📝',
      iconType: 'build',
      title: `Suivi ajouté : ${s.libeleSuivi || ''}`,
      subtitle: formatDateFR(s.dateSuivi),
      date: s.createdAt || s.dateSuivi,
    })
  );

  relances.forEach((r) =>
    activities.push({
      icon: '📋',
      iconType: 'clock',
      title: `Relance : ${r.sujet || ''}`,
      subtitle: formatDateFR(r.dateRelance),
      date: r.createdAt || r.dateRelance,
    })
  );

  return activities
    .filter((a) => a.date)
    .sort((a, b) => new Date(b.date) - new Date(a.date))
    .slice(0, limit)
    .map((a) => ({ ...a, time: formatDateFR(a.date) }));
}

// ---------- 6. PROSPECTS TABLE ----------
// Construit les lignes du tableau "Derniers prospects ajoutés" à partir des
// vrais prospects, avec un statut déduit (pas de champ "statut" natif côté
// backend) : "À relancer" si une relance existe pour ce prospect, "Nouveau"
// si créé ce mois-ci, sinon "Contacté".
export function computeProspectsTableRows(prospects, relances, limit = 8) {
  const idsWithRelance = new Set(relances.map((r) => r.idProspect).filter(Boolean));
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

  return [...prospects]
    .filter((p) => p.createdAt)
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
    .slice(0, limit)
    .map((p) => {
      let status = 'Contacté';
      let statusType = 'contacte';
      if (idsWithRelance.has(p.idProspect)) {
        status = 'À relancer';
        statusType = 'relancer';
      } else if (new Date(p.createdAt) >= startOfMonth) {
        status = 'Nouveau';
        statusType = 'nouveau';
      }

      return {
        initials: initialsOf(p.nomComplet),
        name: p.nomComplet || 'Prospect',
        source: p.ville || '-',
        filiere: p.domaineEtude || 'Non renseigné',
        agent: p.niveauEtude || '-',
        date: formatDateFR(p.createdAt),
        status,
        statusType,
      };
    });
}
