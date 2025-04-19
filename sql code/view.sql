CONNECT SQL3;
-- requete 1
CREATE OR REPLACE VIEW vw_voyages_incidents AS
SELECT v.numero_voyage,
       v.date_voyage,
       mt.code_transport AS moyen_transport,
       DEREF(v.navette).num_navette AS num_navette
FROM VoyageTab v
JOIN NavetteTab n ON REF(n) = v.navette
JOIN LigneTab l ON l.code_ligne = DEREF(v.navette).ligne.code_ligne
JOIN MoyenTransportTab mt ON REF(mt) = l.moyenTransport
WHERE v.observation IN ('Panne', 'Retard', 'Accident', 'Autre');
COMMIT;

-- requete 2
CREATE OR REPLACE VIEW vw_lignes_station_principale AS
SELECT l.code_ligne,
       l.station_depart.code_station AS depart,
       l.station_arrivee.code_station AS arrivee
FROM LigneTab l
WHERE l.station_depart IN (
    SELECT REF(s) FROM StationTab s 
    WHERE TREAT(VALUE(s) AS StationPrincipaleType) IS NOT NULL
)
OR l.station_arrivee IN (
    SELECT REF(s) FROM StationTab s 
    WHERE TREAT(VALUE(s) AS StationPrincipaleType) IS NOT NULL
);
COMMIT;

-- requete 3
CREATE OR REPLACE VIEW vw_navette_plus_active AS
SELECT *
FROM (
    SELECT n.num_navette,
           n.ligne.moyenTransport.code_transport AS moyen_transport,
           n.anneeMiseCirculation,
           COUNT(*) AS nb_voyages
    FROM NavetteTab n, TABLE(n.liste_voyages) lv
    WHERE VALUE(lv).date_voyage BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                                     AND TO_DATE('2025-01-31', 'YYYY-MM-DD')
    GROUP BY n.num_navette, n.ligne.moyenTransport, n.anneeMiseCirculation
    ORDER BY nb_voyages DESC
)
WHERE ROWNUM = 1;
COMMIT;

-- requete 4
CREATE OR REPLACE VIEW vw_station_principale_moyens AS
SELECT TREAT(VALUE(s) AS StationPrincipaleType).nom_station AS nom_station,
       VALUE(mt).code_transport AS moyen
FROM StationTab s,
     TABLE(TREAT(VALUE(s) AS StationPrincipaleType).listeMoyensTransport) mt
WHERE VALUE(s) IS OF (ONLY StationPrincipaleType)
AND (
    SELECT COUNT(DISTINCT VALUE(m2).code_transport)
    FROM TABLE(TREAT(VALUE(s) AS StationPrincipaleType).listeMoyensTransport) m2
) >= 2;
COMMIT;

-- TESTS
SELECT * FROM vw_voyages_incidents;
SELECT * FROM vw_lignes_station_principale;
SELECT * FROM vw_navette_plus_active;
SELECT * FROM vw_station_principale_moyens;

