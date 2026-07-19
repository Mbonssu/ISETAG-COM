import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout/Layout';
import Login from './pages/Login/Login';
import ProtectedRoute from './components/ProtectedRoute/ProtectedRoute';
import { NotificationProvider } from './context/NotificationContext';
import RouteProgress from './components/RouteProgress/RouteProgress';
import ErrorBoundary from './components/ErrorBoundary/ErrorBoundary';
import { useTranslation } from './hooks/useTranslation';

//  CORRIGÉ : toutes les pages étaient importées directement, donc TOUT
// le code JS de l'application (~40 pages) était téléchargé et évalué dès
// le premier chargement, même les pages jamais visitées. Passage en
// React.lazy() : chaque page est maintenant un fichier JS séparé,
// téléchargé uniquement au moment où l'utilisateur navigue vers cette
// route. Ça réduit fortement le temps de premier chargement de l'app.

const Dashboard = lazy(() => import('./pages/Dashboard'));

const ProspectsList = lazy(() => import('./pages/Prospects/ProspectsList'));
const ProspectForm = lazy(() => import('./pages/Prospects/ProspectForm'));
const ProspectDetail = lazy(() => import('./pages/Prospects/ProspectDetail'));

const AgentsList = lazy(() => import('./pages/Agents/AgentsList'));
const AgentForm = lazy(() => import('./pages/Agents/AgentForm'));
const AgentDetail = lazy(() => import('./pages/Agents/AgentDetail'));

const CampagnesList = lazy(() => import('./pages/Campagnes/CampagnesList'));
const CampagneForm = lazy(() => import('./pages/Campagnes/CampagneForm'));
const CampagneDetail = lazy(() => import('./pages/Campagnes/CampagneDetail'));

const AffectationsList = lazy(() => import('./pages/Affectations/AffectationsList'));
const AffectationForm = lazy(() => import('./pages/Affectations/AffectationForm'));

const EtablissementsList = lazy(() => import('./pages/Etablissements/EtablissementsList'));
const EtablissementForm = lazy(() => import('./pages/Etablissements/EtablissementForm'));
const EtablissementDetail = lazy(() => import('./pages/Etablissements/EtablissementDetail'));

const FilieresList = lazy(() => import('./pages/Filieres/FilieresList'));
const FiliereForm = lazy(() => import('./pages/Filieres/FiliereForm'));
// FiliereDetail toujours désactivé : fichier entièrement commenté côté source (pas d'export default)

const SourcesList = lazy(() => import('./pages/Sources/SourcesList'));
const SourceForm = lazy(() => import('./pages/Sources/SourceForm'));
const SourceDetail = lazy(() => import('./pages/Sources/SourceDetail'));

const RelancesList = lazy(() => import('./pages/Relances/RelancesList'));
const RelanceForm = lazy(() => import('./pages/Relances/RelanceForm'));
const RelanceDetail = lazy(() => import('./pages/Relances/RelanceDetail'));

const RapportsDashboard = lazy(() => import('./pages/Rapports/RapportsDashboard'));

const UtilisateursList = lazy(() => import('./pages/Utilisateurs/UtilisateursList'));
const UtilisateurForm = lazy(() => import('./pages/Utilisateurs/UtilisateurForm'));
const UtilisateurDetail = lazy(() => import('./pages/Utilisateurs/UtilisateurDetail'));

const ParametresGeneraux = lazy(() => import('./pages/Parametres/ParametresGeneraux'));

const SuivisList = lazy(() => import('./pages/Suivis/SuivisList'));
const SuivisForm = lazy(() => import('./pages/Suivis/SuivisForm'));
const SuivisDetail = lazy(() => import('./pages/Suivis/SuivisDetail'));

const RendezVousList = lazy(() => import('./pages/RendezVous/RendezVousList'));
const RendezVousForm = lazy(() => import('./pages/RendezVous/RendezVousForm'));
const RendezVousDetail = lazy(() => import('./pages/RendezVous/RendezVousDetail'));

const SuperviseursList = lazy(() => import('./pages/Superviseurs/SuperviseursList'));
const SuperviseursForm = lazy(() => import('./pages/Superviseurs/SuperviseursForm'));
const SuperviseursDetail = lazy(() => import('./pages/Superviseurs/SuperviseursDetail'));

const FichesList = lazy(() => import('./pages/Fiches/FichesList'));
// FichesForm retiré : les fiches sont créées uniquement depuis l'app mobile
// terrain, jamais depuis cet espace admin (lecture seule sur ce module).
const FichesDetail = lazy(() => import('./pages/Fiches/FichesDetail'));

const ZonesList = lazy(() => import('./pages/Zones/ZonesList'));
const ZonesForm = lazy(() => import('./pages/Zones/ZonesForm'));
const ZonesDetail = lazy(() => import('./pages/Zones/ZonesDetail'));

const SortiesList = lazy(() => import('./pages/Sorties/SortiesList'));
const SortiesForm = lazy(() => import('./pages/Sorties/SortiesForm'));
const SortiesDetail = lazy(() => import('./pages/Sorties/SortiesDetail'));

// Fallback minimal pendant le téléchargement du code JS de la page.
// RouteProgress (barre du haut) donne déjà le feedback principal ; ceci
// n'apparaît que si le téléchargement prend un peu plus de temps.
const PageFallback = () => <div style={{ padding: 24 }} />;

function App() {
  const { t } = useTranslation();
  return (
    <ErrorBoundary t={t}>
    <NotificationProvider>
    <Router>
      <RouteProgress />
      <Routes>
        {/* Route publique : pas de Sidebar/Topbar, pas de protection */}
        <Route path="/login" element={<Login />} />

        {/* Tout le reste de l'app exige d'être connecté */}
        <Route
          path="/*"
          element={
            <ProtectedRoute>
              <Layout>
                <Suspense fallback={<PageFallback />}>
                <Routes>
          <Route path="/" element={<Dashboard />} />

          <Route path="/prospects" element={<ProspectsList />} />

          <Route path="/prospects/new" element={<ProspectForm />} />
          <Route path="/prospects/:id" element={<ProspectDetail />} />
          <Route path="/prospects/edit/:id" element={<ProspectForm />} />

          <Route path="/suivis" element={<SuivisList />} />
          <Route path="/suivis/new" element={<SuivisForm />} />
          <Route path="/suivis/:id" element={<SuivisDetail />} />
          <Route path="/suivis/edit/:id" element={<SuivisForm />} />

          <Route path="/rendezvous" element={<RendezVousList />} />
          <Route path="/rendezvous/new" element={<RendezVousForm />} />
          <Route path="/rendezvous/:id" element={<RendezVousDetail />} />
          <Route path="/rendezvous/edit/:id" element={<RendezVousForm />} />

          <Route path="/agents" element={<AgentsList />} />
          <Route path="/agents/new" element={<AgentForm />} />
          <Route path="/agents/:id" element={<AgentDetail />} />
          <Route path="/agents/edit/:id" element={<AgentForm />} />

          <Route path="/superviseurs" element={<SuperviseursList />} />
          <Route path="/superviseurs/new" element={<SuperviseursForm />} />
          <Route path="/superviseurs/:id" element={<SuperviseursDetail />} />
          <Route path="/superviseurs/edit/:id" element={<SuperviseursForm />} />

          <Route path="/campagnes" element={<CampagnesList />} />
          <Route path="/campagnes/new" element={<CampagneForm />} />
          <Route path="/campagnes/:id" element={<CampagneDetail />} />
          <Route path="/campagnes/edit/:id" element={<CampagneForm />} />

          <Route path="/fiches" element={<FichesList />} />
          <Route path="/fiches/:id" element={<FichesDetail />} />
          {/* Pas de route new/edit : fiches créées uniquement côté mobile terrain */}

          <Route path="/affectations" element={<AffectationsList />} />
          <Route path="/affectations/new" element={<AffectationForm />} />
          <Route path="/affectations/edit/:id" element={<AffectationForm />} />

          <Route path="/etablissements" element={<EtablissementsList />} />
          <Route path="/etablissements/new" element={<EtablissementForm />} />
          <Route path="/etablissements/:id" element={<EtablissementDetail />} />
          <Route path="/etablissements/edit/:id" element={<EtablissementForm />} />

          <Route path="/filieres" element={<FilieresList />} />
          <Route path="/filieres/new" element={<FiliereForm />} />
          {/* <Route path="/filieres/:id" element={<FiliereDetail />} /> */}
          {/*  Route désactivée : FiliereDetail.jsx est entièrement commenté, à réécrire avec specialiteService */}
          <Route path="/filieres/edit/:id" element={<FiliereForm />} />

          <Route path="/sources" element={<SourcesList />} />
          <Route path="/sources/new" element={<SourceForm />} />
          <Route path="/sources/edit/:id" element={<SourceForm />} />
          <Route path="/sources/:id" element={<SourceDetail />} />


          <Route path="/relances" element={<RelancesList />} />
          <Route path="/relances/new" element={<RelanceForm />} />
          <Route path="/relances/:id" element={<RelanceDetail />} />
          <Route path="/relances/edit/:id" element={<RelanceForm />} />

          <Route path="/zones" element={<ZonesList />} />
          <Route path="/zones/new" element={<ZonesForm />} />
          <Route path="/zones/:id" element={<ZonesDetail />} />
          <Route path="/zones/edit/:id" element={<ZonesForm />} />

          <Route path="/sorties" element={<SortiesList />} />
          <Route path="/sorties/new" element={<SortiesForm />} />
          <Route path="/sorties/:id" element={<SortiesDetail />} />
          <Route path="/sorties/edit/:id" element={<SortiesForm />} />

          <Route path="/rapports" element={<RapportsDashboard />} />

          <Route path="/utilisateurs" element={<UtilisateursList />} />
          <Route path="/utilisateurs/new" element={<UtilisateurForm />} />
          <Route path="/utilisateurs/edit/:id" element={<UtilisateurForm />} />
          <Route path="/utilisateurs/:id" element={<UtilisateurDetail />} />

          <Route path="/parametres" element={<ParametresGeneraux />} />
                </Routes>
                </Suspense>
              </Layout>
            </ProtectedRoute>
          }
        />
      </Routes>
    </Router>
    </NotificationProvider>
    </ErrorBoundary>
  );
}

export default App;