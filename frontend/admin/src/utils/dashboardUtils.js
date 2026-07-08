// src/utils/dashboardUtils.js

// ---------- KPI ----------

export const calculateKPIs = (data) => ({
    totalProspects: data.prospects.length,
    totalCampagnes: data.campagnes.length,
    totalRendezVous: data.rendezVous.length,
    totalRelances: data.relances.length,
    totalSuivis: data.suivis.length,
});


// ---------- Evolution mensuelle ----------

export const calculateEvolution = (prospects) => {

    const months = {};

    prospects.forEach((prospect) => {

        if (!prospect.createdAt) return;

        const month = new Date(prospect.createdAt)
            .toLocaleString("fr-FR", {
                month: "short",
                year: "numeric",
            });

        months[month] = (months[month] || 0) + 1;
    });

    return Object.entries(months).map(([mois, total]) => ({
        mois,
        total,
    }));
};


// ---------- Répartition par filière ----------

export const calculateFilieres = (prospects) => {

    const stats = {};

    prospects.forEach((prospect) => {

        (prospect.specialiteInteret || []).forEach((specialite) => {

            stats[specialite] = (stats[specialite] || 0) + 1;

        });

    });

    return Object.entries(stats).map(([nom, valeur]) => ({
        nom,
        valeur,
    }));

};


// ---------- Répartition par sexe ----------

export const calculateSexes = (prospects) => {

    const stats = {};

    prospects.forEach((prospect) => {

        const sexe = prospect.sexe || "Non renseigné";

        stats[sexe] = (stats[sexe] || 0) + 1;

    });

    return Object.entries(stats).map(([nom, valeur]) => ({
        nom,
        valeur,
    }));

};


// ---------- Répartition par ville ----------

export const calculateVilles = (prospects) => {

    const stats = {};

    prospects.forEach((prospect) => {

        const ville = prospect.ville || "Inconnue";

        stats[ville] = (stats[ville] || 0) + 1;

    });

    return Object.entries(stats).map(([nom, valeur]) => ({
        nom,
        valeur,
    }));

};


// ---------- Répartition par niveau ----------

export const calculateNiveaux = (prospects) => {

    const stats = {};

    prospects.forEach((prospect) => {

        const niveau = prospect.niveauEtude || "Non renseigné";

        stats[niveau] = (stats[niveau] || 0) + 1;

    });

    return Object.entries(stats).map(([nom, valeur]) => ({
        nom,
        valeur,
    }));

};


// ---------- Sources ----------

export const calculateSources = (fichesSortie) => {

    const stats = {};

    fichesSortie.forEach((fiche) => {

        const source =
            fiche.source_detail?.nomSource ||
            fiche.source_detail?.libelle ||
            "Inconnue";

        stats[source] = (stats[source] || 0) + 1;

    });

    return Object.entries(stats).map(([name, value]) => ({
        name,
        value,
    }));

};


// ---------- Activités récentes ----------

export const calculateRecentActivities = (data) => {

    const activities = [];

    data.prospects.forEach((item) => {

        activities.push({
            type: "Prospect",
            titre: item.nomComplet,
            date: item.createdAt,
        });

    });

    data.rendezVous.forEach((item) => {

        activities.push({
            type: "Rendez-vous",
            titre: item.idRendezVous,
            date: item.createdAt,
        });

    });

    data.relances.forEach((item) => {

        activities.push({
            type: "Relance",
            titre: item.idRelance,
            date: item.createdAt,
        });

    });

    data.suivis.forEach((item) => {

        activities.push({
            type: "Suivi",
            titre: item.idSuivi,
            date: item.createdAt,
        });

    });

    return activities
        .sort((a, b) => new Date(b.date) - new Date(a.date))
        .slice(0, 10);

};