// useDashboardStats.js
// Un seul hook pour tout le dashboard : on appelle chaque route CRUD UNE FOIS
// (Promise.all), puis on calcule toutes les stats côté front (statsService).
// Ça évite que chaque composant (KPICards, EvolutionChart, SourceDonut...)
// refasse les mêmes appels réseau en parallèle.
//
// ⚠️ Il n'existe pas de hooks/apiClient.js ni de méthodes api.getProspects()
// dans ce projet : les vrais appels réseau passent par les services dédiés
// (src/services/*.js), qui eux-mêmes utilisent `api` (src/services/api.js).

import { useEffect, useState, useCallback } from 'react';
import {
  prospectService,
  rendezvousService,
  suiviService,
  relanceService,
  sortieService,
  ficheService,
  agentService,
  interetService,
} from '../services';
import {
  computeKPIs,
  computeEvolution,
  computeSourceDistribution,
  computeFiliereDistribution,
  computeRecentActivities,
  computeProspectsTableRows,
} from '../services/statsService';

const EMPTY_STATS = {
  kpis: [],
  evolution: { labels: [], total: [], relance: [] },
  sourceDistribution: [],
  filiereDistribution: [],
  recentActivities: [],
  prospects: [],
  tableRows: [],
};

export function useDashboardStats() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState(EMPTY_STATS);
  const [version, setVersion] = useState(0);

  // Permet de relancer manuellement le chargement (ex: bouton "Rafraîchir").
  const refresh = useCallback(() => setVersion((v) => v + 1), []);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      try {
        setLoading(true);
        setError(null);

        const [
          prospects,
          rendezVous,
          suivis,
          relances,
          sorties,
          fichesSortie,
          agents,
          interets,
        ] = await Promise.all([
          prospectService.getAll(),
          rendezvousService.getAll(),
          suiviService.getAll(),
          relanceService.getAll(),
          sortieService.getAll(),
          ficheService.getAll(),
          agentService.getAll(),
          interetService.getAll(),
        ]);

        if (cancelled) return;

        setStats({
          prospects,
          kpis: computeKPIs({ prospects, relances, sorties, agents }),
          evolution: computeEvolution(prospects, relances, 7),
          sourceDistribution: computeSourceDistribution(fichesSortie),
          filiereDistribution: computeFiliereDistribution(interets),
          recentActivities: computeRecentActivities(
            { fichesSortie, rendezVous, suivis, relances },
            10
          ),
          tableRows: computeProspectsTableRows(prospects, relances, 8),
        });
      } catch (err) {
        if (!cancelled) setError(err);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    return () => {
      cancelled = true;
    };
  }, [version]);

  return { ...stats, loading, error, refresh };
}