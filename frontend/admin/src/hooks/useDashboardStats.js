import { useEffect, useState } from 'react';
import { prospectService } from '../services/prospectService';
import { relanceService } from '../services/relanceService';
import { suiviService } from '../services/suiviService';
import { campagneService } from '../services/campagneService';
import { ficheService } from '../services/ficheService';

const toArray = (raw) => (Array.isArray(raw) ? raw : (raw?.results ?? []));

// ── KPIs : 4 chiffres clés ────────────────────────────────────────────────
function computeKPIs({ prospects, relances, campagnes, suivis }) {
  const maintenant = Date.now();
  const dans7Jours = maintenant + 7 * 24 * 60 * 60 * 1000;

  const relancesAVenir = relances.filter((r) => {
    const t = new Date(r.dateRelance).getTime();
    return !Number.isNaN(t) && t >= maintenant && t <= dans7Jours;
  }).length;

  const campagnesActives = campagnes.filter((c) => {
    const debut = new Date(c.dateDebut).getTime();
    const fin = new Date(c.dateFin).getTime();
    return !Number.isNaN(debut) && !Number.isNaN(fin) && debut <= maintenant && maintenant <= fin;
  }).length;

  const debutMois = new Date();
  debutMois.setDate(1);
  debutMois.setHours(0, 0, 0, 0);
  const suivisCeMois = suivis.filter((s) => new Date(s.dateSuivi) >= debutMois).length;

  return [
    { icon: '👥', label: 'Total Prospects', value: prospects.length, color: 'green' },
    { icon: '🔔', label: 'Relances (7 prochains jours)', value: relancesAVenir, color: 'yellow' },
    { icon: '📋', label: 'Suivis ce mois-ci', value: suivisCeMois, color: 'green' },
    { icon: '📣', label: 'Campagnes actives', value: campagnesActives, color: 'yellow' },
  ];
}

// ── Évolution des prospects sur les N derniers mois ─────────────────────
function computeEvolution(prospects, nbMois = 6) {
  const mois = [];
  const maintenant = new Date();
  for (let i = nbMois - 1; i >= 0; i--) {
    const d = new Date(maintenant.getFullYear(), maintenant.getMonth() - i, 1);
    mois.push({ key: `${d.getFullYear()}-${d.getMonth()}`, label: d.toLocaleDateString('fr-FR', { month: 'short' }), total: 0 });
  }
  prospects.forEach((p) => {
    if (!p.createdAt) return;
    const d = new Date(p.createdAt);
    const key = `${d.getFullYear()}-${d.getMonth()}`;
    const entry = mois.find((m) => m.key === key);
    if (entry) entry.total += 1;
  });
  // Cumul (courbe croissante, plus lisible qu'un décompte mensuel brut)
  let cumul = 0;
  return mois.map((m) => {
    cumul += m.total;
    return { name: m.label, total: cumul, nouveaux: m.total };
  });
}

// ── Répartition par source (via les fiches de collecte) ──────────────────
function computeSourceDistribution(fiches) {
  const counts = {};
  fiches.forEach((f) => {
    const nom = f.source_detail?.libele || f.idSource || 'Source inconnue';
    counts[nom] = (counts[nom] || 0) + 1;
  });
  const total = fiches.length || 1;
  const palette = ['#2d7a3a', '#f5c842', '#78909c', '#b0bec5', '#dde3e7', '#5c9e6a'];
  return Object.entries(counts)
    .sort((a, b) => b[1] - a[1])
    .map(([name, value], i) => ({
      name, value,
      percentage: Math.round((value / total) * 100),
      color: palette[i % palette.length],
    }));
}

// ── Activités récentes (fusion relances + suivis, triées par date) ───────
function computeRecentActivities({ relances, suivis }, limit = 10) {
  const items = [
    ...relances.map((r) => ({
      type: 'relance',
      title: `Relance : ${r.sujet || 'Sans sujet'}`,
      subtitle: r.prospect_details?.nomComplet || r.idProspect,
      date: r.dateRelance,
    })),
    ...suivis.map((s) => ({
      type: 'suivi',
      title: `Suivi : ${s.libeleSuivi || ''}`,
      subtitle: s.commentaire,
      date: s.dateSuivi,
    })),
  ];
  return items
    .filter((i) => i.date)
    .sort((a, b) => new Date(b.date) - new Date(a.date))
    .slice(0, limit);
}

// ── Domaine d'étude : champ réel du Prospect (contrairement à "filière"
// qui nécessiterait un appel coûteux par prospect via interetSpecialite,
// sans route groupée disponible côté backend) ────────────────────────────
function computeDomaineDistribution(prospects) {
  const counts = {};
  prospects.forEach((p) => {
    const domaine = p.domaineEtude?.trim() || 'Non renseigné';
    counts[domaine] = (counts[domaine] || 0) + 1;
  });
  const total = prospects.length || 1;
  return Object.entries(counts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 6)
    .map(([name, value]) => ({ name, value, percentage: Math.round((value / total) * 100) }));
}

// ── Enrichit chaque prospect avec le nom de sa source (via les fiches) ───
function enrichProspectsWithSource(prospects, fiches) {
  const sourceParProspect = {};
  fiches.forEach((f) => {
    if (f.idProspect) sourceParProspect[f.idProspect] = f.source_detail?.libele || null;
  });
  return prospects.map((p) => ({ ...p, sourceNom: sourceParProspect[p.idProspect] || null }));
}


export function useDashboardStats() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState({
    kpis: [], evolution: [], sourceDistribution: [], recentActivities: [], prospects: [], domaineDistribution: [],
  });

  useEffect(() => {
    let cancelled = false;

    async function load() {
      try {
        setLoading(true);
        const [prospectsRaw, relancesRaw, suivisRaw, campagnesRaw, fichesRaw] = await Promise.all([
          prospectService.getAll(),
          relanceService.getAll(),
          suiviService.getAll(),
          campagneService.getAll(),
          ficheService.getAll(),
        ]);
        if (cancelled) return;

        const prospects = toArray(prospectsRaw);
        const relances = toArray(relancesRaw);
        const suivis = toArray(suivisRaw);
        const campagnes = toArray(campagnesRaw);
        const fiches = toArray(fichesRaw);

        const prospectsEnrichis = enrichProspectsWithSource(prospects, fiches)
          .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

        setStats({
          prospects: prospectsEnrichis,
          kpis: computeKPIs({ prospects, relances, campagnes, suivis }),
          evolution: computeEvolution(prospects, 6),
          sourceDistribution: computeSourceDistribution(fiches),
          domaineDistribution: computeDomaineDistribution(prospects),
          recentActivities: computeRecentActivities({ relances, suivis }, 10),
        });
      } catch (err) {
        console.error(' Erreur chargement stats dashboard:', err);
        if (!cancelled) setError(err);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    return () => { cancelled = true; };
  }, []);

  return { ...stats, loading, error };
}