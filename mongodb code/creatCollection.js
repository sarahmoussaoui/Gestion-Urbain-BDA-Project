// 1. Création des collections (simplifiée pour MongoDB 2.6.4)
db.createCollection("moyen_transport");
db.createCollection("station");
db.createCollection("ligne");
db.createCollection("troncon");
db.createCollection("navette");
db.createCollection("voyage");

// 2. Insertion des moyens de transport
/*db.moyen_transport.insert([
  {
    _id: "MET",
    heureOuverture: "05:30",
    heureFermeture: "23:30",
    nbVoyageursMoyen: 200,
    lignes: ["M001"],
    stations_principales: ["SP001"], 
    stations_secondaires: ["SS001"]  
  }
]);

// 3. Insertion des stations (avec héritage simulé)
db.station.insert([
  { // Station principale
    _id: "SP001",
    type: "principale",
    nom_station: "Haï El Badr",
    longitude: 3.080000,
    latitude: 36.750000,
    moyen_transport: ["MET"],  // Réf bidirectionnelle
    ligne_id: "M001",   // Réf bidirectionnelle
    troncon_id: 101
  },
  { // Station secondaire
    _id: "SS001",
    type: "secondaire",
    nom_station: "Les Fusillés",
    longitude: 3.090000,
    latitude: 36.755000,
    moyen_transport_id: "MET",  // Réf bidirectionnelle
    ligne_id: "M001" ,// Réf bidirectionnelle
    troncon_id: 101
  }
]);

// 4. Insertion d'une ligne
db.ligne.insert({
  _id: "M001",
  moyen_transport_id: "MET",       // Réf vers MoyenTransport
  station_depart_id: "SP001",    // Réf bidirectionnelle
  station_arrivee_id: "SS001",   // Réf bidirectionnelle
  troncons: [101],               // Réf bidirectionnelle
  navettes: ["N001"]             // Réf bidirectionnelle
});

// 5. Insertion d'un tronçon
db.troncon.insert({
  _id: 101,
  ligne_id: "M001",              // Réf vers Ligne
  station_depart_id: "SP001",    // Réf bidirectionnelle
  station_arrivee_id: "SS001",   // Réf bidirectionnelle
  longueur: 1.5
});

// 6. Insertion d'une navette
db.navette.insert({
  _id: "N001",
  marque: "Volvo",
  anneeMiseCirculation: 2020,
  ligne_id: "M001",              // Réf vers Ligne
  voyages: ["V0001"]             // Réf bidirectionnelle
});

// 7. Insertion d'un voyage
db.voyage.insert({
  _id: "V0001",
  navette_id: "N001",  // Réf vers navette
  date: new Date("2025-01-01"),
  heureDebut: "07:00",
  duree: 30,
  sens: "aller",
  nbVoyageurs: 30,
  observation: "Panne"
});*/