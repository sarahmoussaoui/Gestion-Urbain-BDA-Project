-- Connect first to user
CONNECT SQL3;

-- STEP 1: Define User-Defined Types (UDTs)

-- Type pour la station
CREATE TYPE StationType AS (
    code_station INT,
    nom_station VARCHAR(100),
    longitude DECIMAL(9, 6),
    latitude DECIMAL(9, 6),
)NOT FINAL;


-- Type pour le moyen de transport
CREATE TYPE MoyenTransportType AS (
    code_transport VARCHAR(3),-- MET, BUS, etc. 
    heure_ouverture TIME,
    heure_fermeture TIME,
    nbVoyageursMoyen  INT
);



-- StationPrincipale avec liste de moyens de transport
CREATE TYPE StationPrincipaleType UNDER StationType AS (
    listeMoyensTransport TABLE OF MoyenTransportType
);

-- StationSecondaire avec un seul moyen de transport
CREATE TYPE StationSecondaireType UNDER StationType AS (
    moyenTransport MoyenTransportType
);



-- Type pour une ligne
CREATE TYPE LigneType AS (
    code_ligne INT,
    moyenTransport REF MoyenTransportType,
    station_depart REF StationType,
    station_arrivee REF StationType,
    liste_navettes TABLE OF REF NavetteType
);

-- Type pour un tronçon
CREATE TYPE TronconType AS (
    num_troncon INT,
    stationDebut REF StationType,
    stationFin REF StationType,
    longueur DECIMAL(5, 2),
    lignes_troncon TABLE OF REF LigneType
);

-- Type pour une navette
CREATE TYPE NavetteType AS (
    num_navette INT,
    marque VARCHAR(20),
    anneeMiseCirculation INT,
    ligne REF LigneType,
    liste_voyages TABLE OF VoyageType
);

-- Type pour un voyage
CREATE TYPE VoyageType AS (
    numero_voyage INT,
    date DATE,
    duree INT,
    heureDebut TIME,
    sens VARCHAR(10), -- 'aller' ou 'retour'
    nbVoyageurs INT,
    observation VARCHAR(30),
    navette REF NavetteType,
    troncon REF TronconType
);

-- Type pour la géolocalisation ???????????????
CREATE TYPE GeolocalisationType AS (
    troncon REF TronconType,
    temps_estime DECIMAL(5, 2)
);

-- CREATION OF TABLES

CREATE TABLE Station OF StationType (
    PRIMARY KEY (id_station)
);

CREATE TABLE MoyenDeTransport OF MoyenDeTransportType (
    PRIMARY KEY (id_transport)
);

CREATE TABLE Ligne OF LigneType (
    PRIMARY KEY (id_ligne),
    FOREIGN KEY (transport) REFERENCES MoyenDeTransport,
    FOREIGN KEY (station_depart) REFERENCES Station,
    FOREIGN KEY (station_arrivee) REFERENCES Station
);

CREATE TABLE Troncon OF TronconType (
    PRIMARY KEY (id_troncon),
    FOREIGN KEY (station_depart) REFERENCES Station,
    FOREIGN KEY (station_arrivee) REFERENCES Station,
    FOREIGN KEY (ligne) REFERENCES Ligne
);

CREATE TABLE Navette OF NavetteType (
    PRIMARY KEY (id_navette),
    FOREIGN KEY (ligne) REFERENCES Ligne
);

CREATE TABLE Voyage OF VoyageType (
    PRIMARY KEY (id_voyage),
    FOREIGN KEY (navette) REFERENCES Navette,
    FOREIGN KEY (troncon) REFERENCES Troncon
);

CREATE TABLE Geolocalisation OF GeolocalisationType (
    FOREIGN KEY (troncon) REFERENCES Troncon
);

