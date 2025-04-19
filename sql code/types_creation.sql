-- Connexion
CONNECT SQL3;


-- TYPE de base
CREATE OR REPLACE TYPE StationType AS OBJECT (
    code_station VARCHAR(10),
    nom_station VARCHAR2(100),
    longitude DECIMAL(9, 6),
    latitude DECIMAL(9, 6),
    
    MEMBER PROCEDURE ChangerNomSiBEZ
) NOT FINAL;

CREATE OR REPLACE TYPE BODY StationType AS
    MEMBER PROCEDURE ChangerNomSiBEZ IS
    BEGIN
        IF nom_station = 'BEZ' THEN
            -- Changement local
            SELF.nom_station := 'Univ';

            -- Mise à jour persistante dans la table
            UPDATE StationTab s
            SET VALUE(s) = SELF
            WHERE s.code_station = SELF.code_station;
        END IF;
    END;
END;


-- Type de retour de la fonction NbVoyagesEtVoyageurs
CREATE OR REPLACE TYPE NbVoyagesVoyageursType AS OBJECT (
    nb_voyages INT,
    nb_voyageurs INT
);


-- Pré-déclarations nécessaires pour les références circulaires
CREATE OR REPLACE TYPE VoyageType;
CREATE OR REPLACE TYPE NavetteType;
CREATE OR REPLACE TYPE TronconType;
CREATE OR REPLACE TYPE LigneType;
CREATE OR REPLACE TYPE MoyenTransportType;


-- Types de collections
CREATE OR REPLACE TYPE TabVoyage AS TABLE OF REF VoyageType;
CREATE OR REPLACE TYPE TabNavette AS TABLE OF REF NavetteType;
CREATE OR REPLACE TYPE TabTroncon AS TABLE OF REF TronconType;
CREATE OR REPLACE TYPE TabMoyenTransport AS TABLE OF REF MoyenTransportType;


-- Définition des types de base
CREATE OR REPLACE TYPE VoyageType AS OBJECT (
    numero_voyage VARCHAR(10),
    date_voyage DATE,
    duree INT,
    heureDebut DATE,
    sens VARCHAR2(10),
    nbVoyageurs INT,
    observation VARCHAR2(30),
    navette REF NavetteType
);


CREATE OR REPLACE TYPE NavetteType AS OBJECT (
    num_navette VARCHAR(10),
    marque VARCHAR(20),
    anneeMiseCirculation INT,
    ligne REF LigneType,
    liste_voyages TabVoyage,

    MEMBER FUNCTION NbTotalVoyages RETURN INT
) NOT FINAL;

CREATE OR REPLACE TYPE BODY NavetteType AS
    MEMBER FUNCTION NbTotalVoyages RETURN INT IS
    BEGIN
        RETURN liste_voyages.COUNT;
    END;
END;

CREATE OR REPLACE TYPE TronconType AS OBJECT (
    num_troncon INT,
    stationDebut REF StationType,
    stationFin REF StationType,
    longueur DECIMAL(5, 2),
    ligne1 REF LigneType,
    ligne2 REF LigneType,

    MEMBER FUNCTION CalculerDuree(type_transport VARCHAR2) RETURN NUMBER
) NOT FINAL;



CREATE OR REPLACE TYPE BODY TronconType AS
    MEMBER FUNCTION CalculerDuree(type_transport VARCHAR2) RETURN NUMBER IS
        vitesse_moyenne NUMBER;
        duree NUMBER;
    BEGIN
        CASE type_transport
            WHEN 'BUS' THEN vitesse_moyenne := 20;
            WHEN 'MET' THEN vitesse_moyenne := 40;
            WHEN 'TRA' THEN vitesse_moyenne := 25;
            WHEN 'TRN' THEN vitesse_moyenne := 60;
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Transport inconnu');
        END CASE;
        duree := SELF.longueur / vitesse_moyenne * 60;
        RETURN duree;
    END;

END;



CREATE OR REPLACE TYPE LigneType AS OBJECT (
    code_ligne VARCHAR(10),
    moyenTransport REF MoyenTransportType,
    station_depart REF StationType,
    station_arrivee REF StationType,
    liste_navettes TabNavette,
    liste_troncons TabTroncon,

    MEMBER FUNCTION NavettesDesservantes RETURN TabNavette,
    MEMBER FUNCTION NbVoyagesDansPeriode(date_debut DATE, date_fin DATE) RETURN INT
) NOT FINAL;



CREATE OR REPLACE TYPE BODY LigneType AS
    MEMBER FUNCTION NavettesDesservantes RETURN TabNavette IS
    BEGIN
        RETURN liste_navettes;
    END;

    MEMBER FUNCTION NbVoyagesDansPeriode(date_debut DATE, date_fin DATE) RETURN INT IS
        total INT := 0;
        v_nav NavetteType;
        v_voy VoyageType;
    BEGIN
        FOR idx_nav IN 1 .. SELF.liste_navettes.COUNT LOOP
            -- récupérer l'objet Navette via REF
            SELECT DEREF(SELF.liste_navettes(idx_nav)) INTO v_nav FROM DUAL;

            IF v_nav.liste_voyages IS NOT NULL THEN
                FOR idx_voy IN 1 .. v_nav.liste_voyages.COUNT LOOP
                    -- récupérer l'objet Voyage via REF
                    SELECT DEREF(v_nav.liste_voyages(idx_voy)) INTO v_voy FROM DUAL;
                    IF v_voy.date_voyage BETWEEN date_debut AND date_fin THEN
                        total := total + 1;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        RETURN total;
    END;

END;

CREATE OR REPLACE TYPE MoyenTransportType AS OBJECT (
    code_transport VARCHAR(3),
    heure_ouverture TIMESTAMP,
    heure_fermeture TIMESTAMP,
    nbVoyageursMoyen INT,

    MEMBER FUNCTION NbVoyagesEtVoyageurs(date_cible DATE) RETURN NbVoyagesVoyageursType
) NOT FINAL;


CREATE OR REPLACE TYPE BODY MoyenTransportType AS
    MEMBER FUNCTION NbVoyagesEtVoyageurs(date_cible DATE) RETURN NbVoyagesVoyageursType IS
        nb_voyages INT := 0;
        nb_voyageurs INT := 0;
        v_ligne LigneType;
        v_navette NavetteType;
        v_voyage VoyageType;
    BEGIN
        FOR ligne_rec IN (
            SELECT REF(l) AS ref_ligne
            FROM LigneTab l
            WHERE DEREF(l.moyenTransport).code_transport = SELF.code_transport
        ) LOOP
            SELECT DEREF(ligne_rec.ref_ligne) INTO v_ligne FROM DUAL;

            FOR i IN 1 .. v_ligne.liste_navettes.COUNT LOOP
                SELECT DEREF(v_ligne.liste_navettes(i)) INTO v_navette FROM DUAL;

                FOR j IN 1 .. v_navette.liste_voyages.COUNT LOOP
                    SELECT DEREF(v_navette.liste_voyages(j)) INTO v_voyage FROM DUAL;

                    IF v_voyage.date_voyage = date_cible THEN
                        nb_voyages := nb_voyages + 1;
                        nb_voyageurs := nb_voyageurs + v_voyage.nbVoyageurs;
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;

        RETURN NbVoyagesVoyageursType(nb_voyages, nb_voyageurs);
    END;
END;



-- Types dérivés de Station
CREATE OR REPLACE TYPE StationPrincipaleType UNDER StationType (
    listeMoyensTransport TabMoyenTransport
);


CREATE OR REPLACE TYPE StationSecondaireType UNDER StationType (
    moyenTransport REF MoyenTransportType
);
