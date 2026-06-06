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
import RendezVousList from './pages/RendezVous/RendezVousList';
import SuperviseursList from './pages/Superviseurs/SuperviseursList';
import FichesList from './pages/Fiches/FichesList';

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
          <Route path="/rendezvous" element={<RendezVousList />} />
          <Route path="/agents" element={<AgentsList />} />
          <Route path="/agents/new" element={<AgentForm />} />
          <Route path="/agents/:id" element={<AgentDetail />} />
          <Route path="/agents/edit/:id" element={<AgentForm />} />
          <Route path="/superviseurs" element={<SuperviseursList />} />
          <Route path="/campagnes" element={<CampagnesList />} />
          <Route path="/campagnes/new" element={<CampagneForm />} />
          <Route path="/campagnes/:id" element={<CampagneDetail />} />
          <Route path="/campagnes/edit/:id" element={<CampagneForm />} />
          <Route path="/fiches" element={<FichesList />} />
          <Route path="/affectations" element={<AffectationsList />} />
          <Route path="/affectations/new" element={<AffectationForm />} />
          <Route path="/affectations/edit/:id" element={<AffectationForm />} />
          <Route path="/etablissements" element={<EtablissementsList />} />
          <Route path="/etablissements/new" element={<EtablissementForm />} />
          <Route path="/etablissements/:id" element={<EtablissementDetail />} />
          <Route path="/etablissements/edit/:id" element={<EtablissementForm />} />
          <Route path="/filieres" element={<FilieresList />} />
          <Route path="/filieres/new" element={<FiliereForm />} />
          <Route path="/filieres/edit/:id" element={<FiliereForm />} />
          <Route path="/sources" element={<SourcesList />} />
          <Route path="/sources/new" element={<SourceForm />} />
          <Route path="/sources/edit/:id" element={<SourceForm />} />
          <Route path="/relances" element={<RelancesList />} />
          <Route path="/relances/new" element={<RelanceForm />} />
          <Route path="/relances/:id" element={<RelanceDetail />} />
          <Route path="/relances/edit/:id" element={<RelanceForm />} />
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
