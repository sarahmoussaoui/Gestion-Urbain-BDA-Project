-- Connect first to user
CONNECT SQL3;


-- 10. Lister tous les voyages (num, date, moyen de transport, navette) ayant enregistré un quelconque problème (panne, retard, accident, ...) 
SELECT 
    v.numero_voyage, 
    v.date_voyage, 
    mt.code_transport AS moyen_transport, 
    n.num_navette
FROM VoyageTab v
JOIN NavetteTab n ON REF(n) = v.navette
JOIN LigneTab l ON l.code_ligne = DEREF(v.navette).ligne.code_ligne
JOIN MoyenTransportTab mt ON REF(mt) = l.moyenTransport
WHERE v.observation IN ('Panne', 'Retard', 'Accident', 'Autre');


-- 11. Lister toutes les lignes (numéro, début et fin) comportant une station principale 
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


-- 12. Quelles sont les navettes (numéro, type de transport, année de mise en service) ayant effectué le maximum de voyages durant le mois de janvier 2025 ? Préciser le nombre de voyages. 
SELECT *
FROM (
SELECT n.num_navette, 
       n.ligne.moyenTransport AS moyen_transport, 
       n.anneeMiseCirculation,
       COUNT(*) AS nb_voyages
FROM NavetteTab n,
     TABLE(n.liste_voyages) lv
WHERE VALUE(lv).date_voyage BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') 
                         AND TO_DATE('2025-01-31', 'YYYY-MM-DD')
GROUP BY n.num_navette, n.ligne.moyenTransport, n.anneeMiseCirculation
ORDER BY nb_voyages DESC
)
WHERE ROWNUM = 1;


-- 13. Quelles sont les stations offrant au moins 2 moyens de transport ? (préciser la station et les moyens de transport offerts) 
SELECT TREAT(VALUE(s) AS StationPrincipaleType).nom_station AS nom_station,
       VALUE(mt).code_transport as moyen
FROM StationTab s,
     TABLE(TREAT(VALUE(s) AS StationPrincipaleType).listeMoyensTransport) mt
WHERE VALUE(s) IS OF (ONLY StationPrincipaleType)
AND (
    -- sous-requête qui compte les moyens distincts pour la station s
    SELECT COUNT(DISTINCT VALUE(m2).code_transport)
    FROM TABLE(
           TREAT(VALUE(s) AS StationPrincipaleType).listeMoyensTransport
         ) m2
  ) >= 2
ORDER BY s.nom_station, moyen;


