-- Connect first to user
CONNECT SQL3;

CREATE TABLE MoyenTransportTab OF MoyenTransportType (
    PRIMARY KEY (code_transport)
);


CREATE TABLE StationTab OF StationType (
    PRIMARY KEY (code_station)
);



CREATE TABLE LigneTab OF LigneType (
    PRIMARY KEY (code_ligne)
)
NESTED TABLE liste_navettes STORE AS TabNavettesStore
NESTED TABLE liste_troncons STORE AS TabTronçonsStore;



CREATE TABLE TronconTab OF TronconType (
    PRIMARY KEY (num_troncon)
);


CREATE TABLE NavetteTab OF NavetteType (
    PRIMARY KEY (num_navette)
)
NESTED TABLE liste_voyages STORE AS TabVoyagesStore;


CREATE TABLE VoyageTab OF VoyageType (
    PRIMARY KEY (numero_voyage)
);

DESC VoyageType;