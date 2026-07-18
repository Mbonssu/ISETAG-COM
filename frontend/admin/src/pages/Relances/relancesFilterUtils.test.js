import { matchesDateRange } from './relancesFilterUtils';

describe('matchesDateRange', () => {
  it('inclut une relance dont la date se situe dans la plage', () => {
    expect(matchesDateRange('2026-07-10T09:00:00Z', '2026-07-01', '2026-07-15')).toBe(true);
  });

  it('exclut une relance en dehors de la plage', () => {
    expect(matchesDateRange('2026-07-20T09:00:00Z', '2026-07-01', '2026-07-15')).toBe(false);
  });

  it('ne filtre pas si aucune date n’est donnée', () => {
    expect(matchesDateRange('2026-07-10T09:00:00Z', '', '')).toBe(true);
  });
});
