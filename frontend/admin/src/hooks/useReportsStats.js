// hooks/useReportsStats.js
//
// Calcule les 4 rapports demandés, chacun avec les données prêtes pour
// UN GRAPHIQUE (Recharts) ET UN TABLEAU statistique équivalent (le
// tableau est ce qu'on utilise pour l'impression/export PDF/Excel — un
// graphique en image ne se prête pas bien à l'impression).

import { useEffect, useState } from 'react';
import { prospectService } from '../services/prospectService';
import { campagneService } from '../services/campagneService';
import { ficheService } from '../services/ficheService';
import { interetService } from '../services/interetService';

const toArray = (raw) => (Array.isArray(raw) ? raw : (raw?.results ?? []));

// ── 1. Évolution des prospects (6 derniers mois, cumulé) ─────────────────
function computeEvolution(prospects, nbMois = 6) {
  const mois = [];
  const maintenant = new Date();
  for (let i = nbMois - 1; i >= 0; i--) {
    const d = new Date(maintenant.getFullYear(), maintenant.getMonth() - i, 1);
    mois.push({ key: `${d.getFullYear()}-${d.getMonth()}`, label: d.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' }), nouveaux: 0 });
  }
  prospects.forEach((p) => {
    if (!p.createdAt) return;
    const d = new Date(p.createdAt);
    const entry = mois.find((m) => m.key === `${d.getFullYear()}-${d.getMonth()}`);
    if (entry) entry.nouveaux += 1;
  });
  let cumul = 0;
  return mois.map((m) => {
    cumul += m.nouveaux;
    return { name: m.label, nouveaux: m.nouveaux, cumul };
  });
}

// ── 2. Performance des agents (via Participation, toutes sorties) ───────
function computePerformanceAgents(participations) {
  const parAgent = {};
  participations.forEach((p) => {
    const u = p.utilisateur_detail;
    const nom = u ? `${u.prenom || ''} ${u.nom || ''}`.trim() || u.email : (p.idUtilisateur || 'Inconnu');
    if (!parAgent[nom]) parAgent[nom] = { agent: nom, totalSorties: 0, effectuees: 0, prevues: 0, annulees: 0 };
    parAgent[nom].totalSorties += 1;
    const s = (p.statut || '').toLowerCase();
    if (s.includes('effectu')) parAgent[nom].effectuees += 1;
    else if (s.includes('annul')) parAgent[nom].annulees += 1;
    else parAgent[nom].prevues += 1;
  });
  return Object.values(parAgent)
    .map((a) => ({ ...a, tauxReussite: a.totalSorties ? Math.round((a.effectuees / a.totalSorties) * 100) : 0 }))
    .sort((a, b) => b.totalSorties - a.totalSorties);
}

// ── 3. Prospects par source (via fiches de collecte) ──────────────────────
function computeParSource(fiches) {
  const counts = {};
  fiches.forEach((f) => {
    const nom = f.source_detail?.libele || f.idSource || 'Source inconnue';
    counts[nom] = (counts[nom] || 0) + 1;
  });
  const total = fiches.length || 1;
  return Object.entries(counts)
    .sort((a, b) => b[1] - a[1])
    .map(([name, value]) => ({ name, value, percentage: Math.round((value / total) * 100) }));
}

// ── 4. Prospects par spécialité choisie + niveau d'intérêt ───────────────
function computeParSpecialite(interets) {
  const parSpecialite = {};
  interets.forEach((i) => {
    const nom = i.specialite_details?.libeleSpecialite || i.specialite_details?.libele || i.idSpecialite || 'Spécialité inconnue';
    if (!parSpecialite[nom]) {
      parSpecialite[nom] = { specialite: nom, total: 0, Faible: 0, Moyen: 0, 'Élevé': 0, 'Très élevé': 0 };
    }
    parSpecialite[nom].total += 1;
    const niveau = i.niveauInteret;
    if (parSpecialite[nom][niveau] !== undefined) parSpecialite[nom][niveau] += 1;
  });
  return Object.values(parSpecialite).sort((a, b) => b.total - a.total);
}

export function useReportsStats() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [reports, setReports] = useState({
    evolution: [], performanceAgents: [], parSource: [], parSpecialite: [],
  });

  useEffect(() => {
    let cancelled = false;
    async function load() {
      try {
        setLoading(true);
        const [prospectsRaw, participationsRaw, fichesRaw, interetsRaw] = await Promise.all([
          prospectService.getAll(),
          campagneService.getAllParticipations(),
          ficheService.getAll(),
          interetService.getAll(),
        ]);
        if (cancelled) return;

        setReports({
          evolution: computeEvolution(toArray(prospectsRaw), 6),
          performanceAgents: computePerformanceAgents(toArray(participationsRaw)),
          parSource: computeParSource(toArray(fichesRaw)),
          parSpecialite: computeParSpecialite(toArray(interetsRaw)),
        });
      } catch (err) {
        console.error(' Erreur chargement rapports:', err);
        if (!cancelled) setError(err);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }
    load();
    return () => { cancelled = true; };
  }, []);

  return { ...reports, loading, error };
}