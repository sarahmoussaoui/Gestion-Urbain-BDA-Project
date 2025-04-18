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


CREATE OR TYPE NavetteType;
CREATE OR TYPE TronconType;
-- Type pour une ligne
CREATE TYPE LigneType AS (
    code_ligne INT,
    moyenTransport REF MoyenTransportType,
    station_depart REF StationType,
    station_arrivee REF StationType,
    liste_navettes TABLE OF REF NavetteType,
    liste_tronçons TABLE OF REF TronconType
);

-- Type pour un tronçon
CREATE OR REPLACE TYPE TronconType AS (
    num_troncon INT,
    stationDebut REF StationType,
    stationFin REF StationType,
    longueur DECIMAL(5, 2),
    ligne1 LigneType,
    ligne2 LigneType
    
    MEMBER FUNCTION CalculerDuree (type_transport VARCHAR2) RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY TronconType AS

    MEMBER FUNCTION CalculerDuree (type_transport VARCHAR2) RETURN NUMBER IS
        vitesse_moyenne NUMBER;
        duree NUMBER;
    BEGIN
        -- Déterminer la vitesse selon le type de transport
        CASE type_transport
            WHEN 'BUS' THEN vitesse_moyenne := 20;
            WHEN 'MET' THEN vitesse_moyenne := 40;
            WHEN 'TRA' THEN vitesse_moyenne := 25;
            WHEN 'TRN' THEN vitesse_moyenne := 60;
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Transport inconnu');
        END CASE;

        -- Calcul de durée = longueur / vitesse (en heures) * 60 => minutes
        duree := SELF.longueur / vitesse_moyenne * 60;
        RETURN duree;
    END;

END;


CREATE TYPE VoyageType;
-- Type pour une navette
CREATE OR REPLACE TYPE NavetteType AS (
    num_navette INT,
    marque VARCHAR(20),
    anneeMiseCirculation INT,
    ligne REF LigneType,
    liste_voyages TABLE OF VoyageType
);

-- Type pour un voyage
CREATE OR REPLACE TYPE VoyageType AS (
    numero_voyage INT,
    date DATE,
    duree INT,
    heureDebut TIME,
    sens VARCHAR(10), -- 'aller' ou 'retour'
    nbVoyageurs INT,
    observation VARCHAR(30),
    navette REF NavetteType
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





