
db.moyen_transport.insertMany([
  {
    code_transport: "BUS",
    heureOuverture: "06:00",
    heureFermeture: "22:00",
    nbVoyageursMoyen: 180,  
    lignes: ["B001", "TB001"],
    stations_principales: ["SP004", "SP005"],
    stations_secondaires: ["SS004", "SS005", "SS007", "SS008"]
  },
  {
    code_transport: "MET",
    heureOuverture: "04:30",
    heureFermeture: "23:30",
    nbVoyageursMoyen: 880,  
    lignes: ["M001", "MTR001", "FRT001"],
    stations_principales: ["SP001", "SP002", "SP003", "SP004", "SP008", "SP010"],
    stations_secondaires: ["SS001", "SS010", "SS011", "SS012"]
  },
  {
    code_transport: "TR",
    heureOuverture: "05:00",
    heureFermeture: "23:00",
    nbVoyageursMoyen: 400,  
    lignes: ["TR001", "TRM001"],
    stations_principales: ["SP002", "SP003", "SP006", "SP007"],
    stations_secondaires: ["SS002", "SS003", "SS009"]
  },
  {
    code_transport: "TN",
    heureOuverture: "00:00",
    heureFermeture: "23:59",
    nbVoyageursMoyen: 302,  
    lignes: ["TN001", "VL001"],
    stations_principales: ["SP009"],
    stations_secondaires: ["SS003", "SS006"]
  }
]);


// 2. Insertion des Stations Principales
db.station.insert([
    {
      _id: "SP001",
      type: "principale",
      nom_station: "Haï El Badr",
      longitude: 3.080000,
      latitude: 36.750000,
      moyen_transport_id: "MET",
      ligne_id: "M001",
      troncon_id: 101
    },
    {
      _id: "SP002",
      type: "principale",
      nom_station: "El Harrach Centre",
      longitude: 3.100000,
      latitude: 36.760000,
      moyen_transport_id: "MET",
      ligne_id: "M001",
      troncon_id: 102
    },
    {
      _id: "SP003",
      type: "principale",
      nom_station: "Place des Martyrs",
      longitude: 3.060000,
      latitude: 36.780000,
      moyen_transport_id: "TR",
      ligne_id: "TR001",
      troncon_id: 202
    },
    {
      _id: "SP004",
      type: "principale",
      nom_station: "Khelifa Boukhalfa",
      longitude: 3.060500,
      latitude: 36.775500,
      moyen_transport_id: "BUS",
      ligne_id: "B001",
      troncon_id: 301
    }
  ]);
  db.station.insert([
    {
        _id: "SP005",
        type: "principale",
        nom_station: "El Madania",
        longitude: 3.051000,
        latitude: 36.761000,
        moyen_transport_id: "BUS",
        ligne_id: "TB001",
        troncon_id: 501
    },
    {
        _id: "SP006",
        type: "principale",
        nom_station: "Bir Mourad Raïs",
        longitude: 3.048000,
        latitude: 36.765000,
        moyen_transport_id: "TR",
        ligne_id: "TRM001",
        troncon_id: 601
    },
    {
        _id: "SP007",
        type: "principale",
        nom_station: "Kouba",
        longitude: 3.080500,
        latitude: 36.725500,
        moyen_transport_id: "TR",
        ligne_id: "TRM001",
        troncon_id: 602
    },
    {
        _id: "SP008",
        type: "principale",
        nom_station: "Dar El Beida",
        longitude: 3.200000,
        latitude: 36.720000,
        moyen_transport_id: "MET",
        ligne_id: "FRT001",
        troncon_id: 701
    },
    {
        _id: "SP009",
        type: "principale",
        nom_station: "Cité Climat de France",
        longitude: 3.070000,
        latitude: 36.770000,
        moyen_transport_id: "TN",
        ligne_id: "VL001",
        troncon_id: 801
    }
]);
db.station.insert([
  {
    _id: "SP010",
    type: "principale",
    nom_station: "Université de Bab Ezzouar",
    longitude: 3.210500,
    latitude: 36.700000,
    moyen_transport_id: "MET",
    ligne_id: "M001",
    troncon_id: 103
  },
  {
    _id: "SP011",
    type: "principale",
    nom_station: "Cité des Pins Maritimes",
    longitude: 3.150000,
    latitude: 36.740000,
    moyen_transport_id: "BUS",
    ligne_id: "TB001",
    troncon_id: 504
  }
]);

db.station.insert([
  {
      _id: "SS012",
      type: "secondaire",
      nom_station: "Bab El Oued",
      longitude: 3.080000,
      latitude: 36.750500,
      moyen_transport_id: "TR",
      ligne_id: "TR001",
      troncon_id: 203
  },
  {
      _id: "SS013",
      type: "secondaire",
      nom_station: "Sidi M'Hamed",
      longitude: 3.120500,
      latitude: 36.760500,
      moyen_transport_id: "MET",
      ligne_id: "MTR001",
      troncon_id: 902
  }
]);


// 3. Insertion des Stations Secondaires
db.station.insert([
    {
      _id: "SS001",
      type: "secondaire",
      nom_station: "Les Fusillés",
      longitude: 3.090000,
      latitude: 36.755000,
      moyen_transport_id: "MET",
      ligne_id: "M001",
      troncon_id: 101
    },
    {
      _id: "SS002",
      type: "secondaire",
      nom_station: "Agha",
      longitude: 3.105000,
      latitude: 36.765000,
      moyen_transport_id: "TR",
      ligne_id: "TR001",
      troncon_id: 201
    },
    {
      _id: "SS003",
      type: "secondaire",
      nom_station: "Bab Ezzouar",
      longitude: 3.170000,
      latitude: 36.710000,
      moyen_transport_id: "TR",
      ligne_id: "TR001",
      troncon_id: 202
    },
    {
      _id: "SS004",
      type: "secondaire",
      nom_station: "Bir Mourad Rais",
      longitude: 3.050000,
      latitude: 36.760000,
      moyen_transport_id: "BUS",
      ligne_id: "B001",
      troncon_id: 301
    },
    {
      _id: "SS005",
      type: "secondaire",
      nom_station: "Ain Naadja",
      longitude: 3.060000,
      latitude: 36.745000,
      moyen_transport_id: "BUS",
      ligne_id: "B001",
      troncon_id: 302
    },
    {
      _id: "SS006",
      type: "secondaire",
      nom_station: "Sidi Bel Abbès",
      longitude: 3.180000,
      latitude: 36.690000,
      moyen_transport_id: "TN",
      ligne_id: "TN001",
      troncon_id: 401
    }
  ]);
  db.station.insert([
    {
        _id: "SS007",
        type: "secondaire",
        nom_station: "El Harrach Gare",
        longitude: 3.101000,
        latitude: 36.751000,
        moyen_transport_id: "BUS",
        ligne_id: "TB001",
        troncon_id: 502
    },
    {
        _id: "SS008",
        type: "secondaire",
        nom_station: "Oued Smar",
        longitude: 3.120000,
        latitude: 36.740000,
        moyen_transport_id: "BUS",
        ligne_id: "TB001",
        troncon_id: 503
    },
    {
        _id: "SS009",
        type: "secondaire",
        nom_station: "Bachdjerrah",
        longitude: 3.110000,
        latitude: 36.730000,
        moyen_transport_id: "TR",
        ligne_id: "TRM001",
        troncon_id: 603
    },
    {
        _id: "SS010",
        type: "secondaire",
        nom_station: "Bordj El Kiffan",
        longitude: 3.210000,
        latitude: 36.730000,
        moyen_transport_id: "MET",
        ligne_id: "FRT001",
        troncon_id: 702
    },
    {
        _id: "SS011",
        type: "secondaire",
        nom_station: "Tafourah",
        longitude: 3.060000,
        latitude: 36.780000,
        moyen_transport_id: "MET",
        ligne_id: "MTR001",
        troncon_id: 901
    }
]);

// 4. Insertion des Lignes
db.ligne.insert([
    {
      _id: "B001",
      moyen_transport_id: "BUS",
      station_depart_id: "SP004",
      station_arrivee_id: "SS004",
      troncons: [301, 302],
      navettes: ["N001", "N002"]
    },
    {
      _id: "M001",
      moyen_transport_id: "MET",
      station_depart_id: "SP001",
      station_arrivee_id: "SS001",
      troncons: [101, 102, 103],
      navettes: ["N003", "N004"]
    },
    {
      _id: "TR001",
      moyen_transport_id: "TR",
      station_depart_id: "SP002",
      station_arrivee_id: "SS003",
      troncons: [201, 202],
      navettes: ["N005", "N006"]
    },
    {
      _id: "TN001",
      moyen_transport_id: "TN",
      station_depart_id: "SS003",
      station_arrivee_id: "SS006",
      troncons: [401],
      navettes: ["N007", "N008"]
    }
  ]);
  db.ligne.insert([
    {
        _id: "TB001",
        moyen_transport_id: "BUS",
        station_depart_id: "SP005",
        station_arrivee_id: "SS007",
        troncons: [501, 502, 503],
        navettes: ["N009", "N010"]
    },
    {
        _id: "TRM001",
        moyen_transport_id: "TR",
        station_depart_id: "SP006",
        station_arrivee_id: "SS009",
        troncons: [601, 602, 603],
        navettes: ["N011"]
    },
    {
        _id: "FRT001",
        moyen_transport_id: "MET",
        station_depart_id: "SP008",
        station_arrivee_id: "SS010",
        troncons: [701, 702],
        navettes: ["N012"]
    },
    {
        _id: "VL001",
        moyen_transport_id: "TN",
        station_depart_id: "SP009",
        station_arrivee_id: "SP009",
        troncons: [801],
        navettes: ["N013"]
    },
    {
        _id: "MTR001",
        moyen_transport_id: "MET",
        station_depart_id: "SP010",
        station_arrivee_id: "SS011",
        troncons: [901, 902],
        navettes: ["N014"]
    }
]);
db.ligne.insert([
  {
    _id: "B002",
    moyen_transport_id: "BUS",
    station_depart_id: "SP010",
    station_arrivee_id: "SS012",
    troncons: [505],
    navettes: ["N015"]
  },
  {
    _id: "M002",
    moyen_transport_id: "MET",
    station_depart_id: "SP010",
    station_arrivee_id: "SS013",
    troncons: [103],
    navettes: ["N016"]
  }
]);


// 5. Insertion des Tronçons
db.troncon.insert([
    { _id: 101, ligne_id: "M001", station_depart_id: "SP001", station_arrivee_id: "SS001", longueur: 1.5 },
    { _id: 102, ligne_id: "M001", station_depart_id: "SS001", station_arrivee_id: "SP002", longueur: 1.8 },
    { _id: 103, ligne_id: "M001", station_depart_id: "SP004", station_arrivee_id: "SP003", longueur: 1.3 },
    { _id: 201, ligne_id: "TR001", station_depart_id: "SP002", station_arrivee_id: "SS002", longueur: 2.2 },
    { _id: 202, ligne_id: "TR001", station_depart_id: "SS002", station_arrivee_id: "SS003", longueur: 3.1 },
    { _id: 301, ligne_id: "B001", station_depart_id: "SP004", station_arrivee_id: "SS004", longueur: 2.0 },
    { _id: 302, ligne_id: "B001", station_depart_id: "SS004", station_arrivee_id: "SS005", longueur: 2.2 },
    { _id: 401, ligne_id: "TN001", station_depart_id: "SS003", station_arrivee_id: "SS006", longueur: 6.5 },
    { _id: 501, ligne_id: "TB001", station_depart_id: "SP005", station_arrivee_id: "SS007", longueur: 1.7 },
    { _id: 502, ligne_id: "TB001", station_depart_id: "SS007", station_arrivee_id: "SS008", longueur: 2.0 },
    { _id: 503, ligne_id: "TB001", station_depart_id: "SS008", station_arrivee_id: "SP004", longueur: 1.5 },
    { _id: 601, ligne_id: "TRM001", station_depart_id: "SP006", station_arrivee_id: "SP007", longueur: 3.0 },
    { _id: 602, ligne_id: "TRM001", station_depart_id: "SP007", station_arrivee_id: "SS009", longueur: 2.5 },
    { _id: 603, ligne_id: "TRM001", station_depart_id: "SS009", station_arrivee_id: "SP002", longueur: 1.2 },
    { _id: 701, ligne_id: "FRT001", station_depart_id: "SP008", station_arrivee_id: "SS010", longueur: 7.0 },
    { _id: 702, ligne_id: "FRT001", station_depart_id: "SS010", station_arrivee_id: "SP001", longueur: 6.0 },
    { _id: 801, ligne_id: "VL001", station_depart_id: "SP009", station_arrivee_id: "SP009", longueur: 0.0 },
    { _id: 901, ligne_id: "MTR001", station_depart_id: "SP010", station_arrivee_id: "SS011", longueur: 2.8 }
]);
db.troncon.insert([
  { _id: 505, ligne_id: "B002", station_depart_id: "SP010", station_arrivee_id: "SS012", longueur: 2.0 },
  { _id: 104, ligne_id: "M002", station_depart_id: "SP010", station_arrivee_id: "SS013", longueur: 1.5 }
]);


// 6. Insertion des Navettes
db.navette.insert([
    { _id: "N001", marque: "Volvo", anneeMiseCirculation: 2020, ligne_id: "B001", voyages: ["V0001", "V0002"] },
    { _id: "N002", marque: "Mercedes", anneeMiseCirculation: 2021, ligne_id: "B001", voyages: [] },
    { _id: "N003", marque: "Scania", anneeMiseCirculation: 2019, ligne_id: "M001", voyages: ["V0003", "V0004","V0007"] },
    { _id: "N004", marque: "Renault", anneeMiseCirculation: 2022, ligne_id: "M001", voyages: [] },
    { _id: "N005", marque: "Alstom", anneeMiseCirculation: 2020, ligne_id: "TR001", voyages: [] },
    { _id: "N006", marque: "Bombardier", anneeMiseCirculation: 2021, ligne_id: "TR001", voyages: [] },
    { _id: "N007", marque: "Siemens", anneeMiseCirculation: 2020, ligne_id: "TN001", voyages: [] },
    { _id: "N008", marque: "CAF", anneeMiseCirculation: 2021, ligne_id: "TN001", voyages: [] },
    { _id: "N009", marque: "MAN", anneeMiseCirculation: 2018, ligne_id: "TB001", voyages: ["V0005", "V0006"] },
    { _id: "N010", marque: "Setra", anneeMiseCirculation: 2021, ligne_id: "TB001", voyages: [] },
    { _id: "N011", marque: "Bombardier", anneeMiseCirculation: 2020, ligne_id: "TRM001", voyages: ["V0008"] },
    { _id: "N012", marque: "Alstom", anneeMiseCirculation: 2019, ligne_id: "FRT001", voyages: ["V0009"] },
    { _id: "N013", marque: "Peugeot", anneeMiseCirculation: 2022, ligne_id: "VL001", voyages: [] },
    { _id: "N014", marque: "Hyundai", anneeMiseCirculation: 2023, ligne_id: "MTR001", voyages: [] }
  ]);
  db.navette.insert([
    { _id: "N015", marque: "Iveco", anneeMiseCirculation: 2023, ligne_id: "B002", voyages: [] },
    { _id: "N016", marque: "Kia", anneeMiseCirculation: 2024, ligne_id: "M002", voyages: [] }
]);


// 7. Insertion des Voyages
db.voyage.insert([
    { _id: "V0001", navette_id: "N001", date: new Date("2025-01-01"), heureDebut: "07:00", duree: 30, sens: "aller", nbVoyageurs: 400, observation: "Panne" },
    { _id: "V0002", navette_id: "N001", date: new Date("2025-01-13"), heureDebut: "08:00", duree: 35, sens: "aller", nbVoyageurs: 220, observation: "On Time" },
    { _id: "V0003", navette_id: "N003", date: new Date("2025-02-01"), heureDebut: "07:30", duree: 40, sens: "aller", nbVoyageurs: 200, observation: "Arrivé" },
    { _id: "V0004", navette_id: "N003", date: new Date("2025-02-15"), heureDebut: "08:30", duree: 50, sens: "aller", nbVoyageurs: 150, observation: "RAS" },
    { _id: "V0005", navette_id: "N009", date: new Date("2025-03-01"), heureDebut: "07:15", duree: 20, sens: "aller", nbVoyageurs: 300, observation: "RAS" },
    { _id: "V0006", navette_id: "N009", date: new Date("2025-01-01"), heureDebut: "08:15", duree: 22, sens: "retour", nbVoyageurs: 456, observation: "Léger retard" },
    { _id: "V0007", navette_id: "N003", date: new Date("2025-01-03"), heureDebut: "09:00", duree: 25, sens: "aller", nbVoyageurs: 250, observation: "RAS" },
    { _id: "V0008", navette_id: "N011", date: new Date("2025-01-01"), heureDebut: "06:45", duree: 30, sens: "aller", nbVoyageurs: 380, observation: "On Time" },
    { _id: "V0009", navette_id: "N012", date: new Date("2025-03-05"), heureDebut: "10:00", duree: 40, sens: "aller", nbVoyageurs: 420, observation: "Panne mineure" }
]);
db.voyage.insert([
  { _id: "V0010", navette_id: "N015", date: new Date("2025-03-06"), heureDebut: "07:00", duree: 25, sens: "aller", nbVoyageurs: 180, observation: "RAS" },
  { _id: "V0011", navette_id: "N016", date: new Date("2025-03-07"), heureDebut: "08:00", duree: 30, sens: "aller", nbVoyageurs: 220, observation: "On Time" }
]);
db.voyage.insert([
  { _id: "V0012", navette_id: "N002", date: new Date("2025-03-10"), heureDebut: "09:15", duree: 30, sens: "aller", nbVoyageurs: 270, observation: "RAS" },
  { _id: "V0013", navette_id: "N004", date: new Date("2025-01-11"), heureDebut: "10:00", duree: 28, sens: "retour", nbVoyageurs: 310, observation: "Retard 5 min" },
  { _id: "V0014", navette_id: "N005", date: new Date("2025-03-12"), heureDebut: "07:40", duree: 32, sens: "aller", nbVoyageurs: 360, observation: "RAS" },
  { _id: "V0015", navette_id: "N006", date: new Date("2025-02-12"), heureDebut: "08:45", duree: 36, sens: "aller", nbVoyageurs: 390, observation: "RAS" },
  { _id: "V0016", navette_id: "N007", date: new Date("2025-01-13"), heureDebut: "09:30", duree: 34, sens: "aller", nbVoyageurs: 410, observation: "Panne mineure" },
  { _id: "V0017", navette_id: "N008", date: new Date("2025-03-13"), heureDebut: "10:30", duree: 37, sens: "retour", nbVoyageurs: 370, observation: "RAS" },
  { _id: "V0018", navette_id: "N010", date: new Date("2025-02-14"), heureDebut: "07:20", duree: 26, sens: "aller", nbVoyageurs: 290, observation: "RAS" },
  { _id: "V0019", navette_id: "N013", date: new Date("2025-03-15"), heureDebut: "11:00", duree: 20, sens: "retour", nbVoyageurs: 180, observation: "RAS" },
  { _id: "V0020", navette_id: "N014", date: new Date("2025-01-16"), heureDebut: "08:00", duree: 23, sens: "aller", nbVoyageurs: 200, observation: "RAS" },
  { _id: "V0021", navette_id: "N015", date: new Date("2025-02-17"), heureDebut: "07:30", duree: 27, sens: "retour", nbVoyageurs: 175, observation: "RAS" },
  { _id: "V0022", navette_id: "N016", date: new Date("2025-03-18"), heureDebut: "09:00", duree: 31, sens: "retour", nbVoyageurs: 230, observation: "RAS" }
]);


     
  
  