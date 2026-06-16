import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout/Layout';

// Pages existantes
import Dashboard from './pages/Dashboard';
import ProspectsList from './pages/Prospects/ProspectsList';
import ProspectForm from './pages/Prospects/ProspectForm';
import ProspectDetail from './pages/Prospects/ProspectDetail';
import AgentsList from './pages/Agents/AgentsList';
import AgentForm from './pages/Agents/AgentForm';
import AgentDetail from './pages/Agents/AgentDetail';
import CampagnesList from './pages/Campagnes/CampagnesList';
import CampagneForm from './pages/Campagnes/CampagneForm';
import CampagneDetail from './pages/Campagnes/CampagneDetail';
import AffectationsList from './pages/Affectations/AffectationsList';
import AffectationForm from './pages/Affectations/AffectationForm';
import EtablissementsList from './pages/Etablissements/EtablissementsList';
import EtablissementForm from './pages/Etablissements/EtablissementForm';
import EtablissementDetail from './pages/Etablissements/EtablissementDetail';
import FilieresList from './pages/Filieres/FilieresList';
import FiliereForm from './pages/Filieres/FiliereForm';
import FiliereDetail from './pages/Filieres/FiliereDetail';
import SourcesList from './pages/Sources/SourcesList';
import SourceForm from './pages/Sources/SourceForm';
import RelancesList from './pages/Relances/RelancesList';
import RelanceForm from './pages/Relances/RelanceForm';
import RelanceDetail from './pages/Relances/RelanceDetail';
import RapportsDashboard from './pages/Rapports/RapportsDashboard';
import UtilisateursList from './pages/Utilisateurs/UtilisateursList';
import UtilisateurForm from './pages/Utilisateurs/UtilisateurForm';
import ParametresGeneraux from './pages/Parametres/ParametresGeneraux';

// Nouvelles pages
import SuivisList from './pages/Suivis/SuivisList';
import SuivisForm from './pages/Suivis/SuivisForm';
import SuivisDetail from './pages/Suivis/SuivisDetail';
import RendezVousList from './pages/RendezVous/RendezVousList';
import RendezVousForm from './pages/RendezVous/RendezVousForm';
import RendezVousDetail from './pages/RendezVous/RendezVousDetail';
import SuperviseursList from './pages/Superviseurs/SuperviseursList';
import SuperviseursForm from './pages/Superviseurs/SuperviseursForm';
import SuperviseursDetail from './pages/Superviseurs/SuperviseursDetail';
import FichesList from './pages/Fiches/FichesList';
import FichesForm from './pages/Fiches/FichesForm';
import FichesDetail from './pages/Fiches/FichesDetail';
import ZonesList from './pages/Zones/ZonesList';
import ZonesForm from './pages/Zones/ZonesForm';
import ZonesDetail from './pages/Zones/ZonesDetail';
import SortiesList from './pages/Sorties/SortiesList';
import SortiesForm from './pages/Sorties/SortiesForm';
import SortiesDetail from './pages/Sorties/SortiesDetail';

function App() {
  return (
    <Router>
      <Layout>
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
          <Route path="/fiches/new" element={<FichesForm />} />
          <Route path="/fiches/:id" element={<FichesDetail />} />
          <Route path="/fiches/edit/:id" element={<FichesForm />} />
          
          <Route path="/affectations" element={<AffectationsList />} />
          <Route path="/affectations/new" element={<AffectationForm />} />
          <Route path="/affectations/edit/:id" element={<AffectationForm />} />
          
          <Route path="/etablissements" element={<EtablissementsList />} />
          <Route path="/etablissements/new" element={<EtablissementForm />} />
          <Route path="/etablissements/:id" element={<EtablissementDetail />} />
          <Route path="/etablissements/edit/:id" element={<EtablissementForm />} />
          
          <Route path="/filieres" element={<FilieresList />} />
          <Route path="/filieres/new" element={<FiliereForm />} />
          <Route path="/filieres/:id" element={<FiliereDetail />} />
          <Route path="/filieres/edit/:id" element={<FiliereForm />} />
          
          <Route path="/sources" element={<SourcesList />} />
          <Route path="/sources/new" element={<SourceForm />} />
          <Route path="/sources/edit/:id" element={<SourceForm />} />
          
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
          
          <Route path="/parametres" element={<ParametresGeneraux />} />
        </Routes>
      </Layout>
    </Router>
  );
}

export default App;
