-- Connect first to user
CONNECT SQL3;

-- Insertion des moyens de transport REDO
INSERT ALL
  INTO MoyenTransportTab VALUES(
    MoyenTransportType(
      'B',
      TO_TIMESTAMP('2025-01-01 06:00:00','YYYY-MM-DD HH24:MI:SS'),
      TO_TIMESTAMP('2025-01-01 22:00:00','YYYY-MM-DD HH24:MI:SS'),
      100
    )
  )
  INTO MoyenTransportTab VALUES(
    MoyenTransportType(
      'M',
      TO_TIMESTAMP('2025-01-01 05:30:00','YYYY-MM-DD HH24:MI:SS'),
      TO_TIMESTAMP('2025-01-01 23:30:00','YYYY-MM-DD HH24:MI:SS'),
      200
    )
  )
  INTO MoyenTransportTab VALUES(
    MoyenTransportType(
      'TR',
      TO_TIMESTAMP('2025-01-01 06:00:00','YYYY-MM-DD HH24:MI:SS'),
      TO_TIMESTAMP('2025-01-01 22:30:00','YYYY-MM-DD HH24:MI:SS'),
      150
    )
  )
  INTO MoyenTransportTab VALUES(
    MoyenTransportType(
      'TN',
      TO_TIMESTAMP('2025-01-01 07:00:00','YYYY-MM-DD HH24:MI:SS'),
      TO_TIMESTAMP('2025-01-01 21:00:00','YYYY-MM-DD HH24:MI:SS'),
      300
    )
  )
SELECT * FROM dual; -- meaning run those four inserts one time each

-- insertion des stations
-- Station Principale 1
INSERT INTO StationTab VALUES (
    StationPrincipaleType(
        'SP001', 'Haï El Badr', 3.080000, 36.750000,
        TabMoyenTransport(
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'M'),
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'B')
        )
    )
);

-- Station Principale 2
INSERT INTO StationTab VALUES (
    StationPrincipaleType(
        'SP002', 'El Harrach Centre', 3.100000, 36.760000,
        TabMoyenTransport(
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'M'),
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TR')
        )
    )
);

-- Station Principale 3
INSERT INTO StationTab VALUES (
    StationPrincipaleType(
        'SP003', 'Place des Martyrs', 3.060000, 36.780000,
        TabMoyenTransport(
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'M'),
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TR')
        )
    )
);

-- Station Principale 4
INSERT INTO StationTab VALUES (
    StationPrincipaleType(
        'SP004', 'Khelifa Boukhalfa', 3.060500, 36.775500,
        TabMoyenTransport(
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'B'),
            (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'M')
        )
    )
);



-- Station Secondaire 1
INSERT INTO StationTab VALUES (
    StationSecondaireType(
        'SS001', 'Les Fusillés', 3.090000, 36.755000,
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'M')
    )
);

-- Station Secondaire 2
INSERT INTO StationTab VALUES (
    StationSecondaireType(
        'SS002', 'Agha', 3.105000, 36.765000,
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TR')
    )
);

-- Station Secondaire 3
INSERT INTO StationTab VALUES (
    StationSecondaireType(
        'SS003', 'Bab Ezzouar', 3.170000, 36.710000,
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TR')
    )
);

-- Station Secondaire 4
INSERT INTO StationTab VALUES (
    StationSecondaireType(
        'SS004', 'Bir Mourad Rais', 3.050000, 36.760000,
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'B')
    )
);

-- Station Secondaire 5
INSERT INTO StationTab VALUES (
    StationSecondaireType(
        'SS005', 'Ain Naadja', 3.060000, 36.745000,
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'B')
    )
);

-- Station Secondaire 6
INSERT INTO StationTab VALUES (
    StationSecondaireType(
        'SS006', 'Sidi Bel Abbès', 3.180000, 36.690000,
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TN')
    )
);





-- Insertion de la ligne de bus REDO
INSERT INTO LigneTab VALUES( 
    LigneType(
        'B001', 
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'B'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S001'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S010'),
        NULL,  -- Liste des navettes
        NULL   -- Liste des tronçons
    )
);


-- Insertion de la ligne de métro
INSERT INTO LigneTab VALUES( 
    LigneType(
        'M001', 
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'M'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S001'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S005'),
        NULL,  -- Liste des navettes
        NULL   -- Liste des tronçons
    )
);

-- Insertion de la ligne de tramway
INSERT INTO LigneTab VALUES( 
    LigneType(
        'TR001', 
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TR'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S003'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S008'),
        NULL,  -- Liste des navettes
        NULL   -- Liste des tronçons
    )
);

-- Insertion de la ligne de train
INSERT INTO LigneTab VALUES( 
    LigneType(
        'TN001', 
        (SELECT REF(m) FROM MoyenTransportTab m WHERE m.code_transport = 'TN'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S002'), 
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'S009'),
        NULL,  -- Liste des navettes
        NULL   -- Liste des tronçons
    )
);

-- insertion des tronçons
-- Tronçons pour le Métro
INSERT INTO TronconTab VALUES (
    TronconType(101,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP001'),  -- Haï El Badr
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS001'),  -- Les Fusillés
        1.50,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'M001'),
        NULL
    )
);

INSERT INTO TronconTab VALUES (
    TronconType(102,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS001'),  -- Les Fusillés
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP002'),  -- El Harrach Centre
        1.80,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'M001'),
        NULL
    )
);

INSERT INTO TronconTab VALUES (
    TronconType(103,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP004'),  -- Khelifa Boukhalfa
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP003'),  -- Place des Martyrs
        1.30,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'M001'),
        NULL
    )
);

-- Tronçons pour le Tramway
INSERT INTO TronconTab VALUES (
    TronconType(201,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP002'),  -- El Harrach Centre
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS002'),  -- Agha
        2.20,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TR001'),
        NULL
    )
);

INSERT INTO TronconTab VALUES (
    TronconType(202,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS002'),  -- Agha
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS003'),  -- Bab Ezzouar
        3.10,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TR001'),
        NULL
    )
);

-- Tronçons pour le Bus
INSERT INTO TronconTab VALUES (
    TronconType(301,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP004'),  -- Khelifa Boukhalfa
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS004'),  -- Bir Mourad Rais
        2.00,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'B001'),
        NULL
    )
);

INSERT INTO TronconTab VALUES (
    TronconType(302,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS004'),  -- Bir Mourad Rais
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS005'),  -- Ain Naadja
        2.20,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'B001'),
        NULL
    )
);

-- Tronçons pour le Train
INSERT INTO TronconTab VALUES (
    TronconType(401,
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS003'),  -- Bab Ezzouar
        (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS006'),  -- Sidi Bel Abbès
        6.50,
        (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TN001'),
        NULL
    )
);


-- Insertion des navettes pour les lignes
-- Insertion des navettes pour la ligne B001
INSERT INTO NavetteTab VALUES ('N001', 'Volvo', 2020, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'B001'), NULL);

INSERT INTO NavetteTab VALUES ('N002', 'Mercedes', 2021, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'B001'), NULL);

-- Insertion des navettes pour la ligne M001
INSERT INTO NavetteTab VALUES ('N003', 'Scania', 2019, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'M001'), NULL);
INSERT INTO NavetteTab VALUES ('N004', 'Renault', 2022, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'M001'), NULL);
-- Insertion des navettes pour la ligne TR001
INSERT INTO NavetteTab VALUES ('N005', 'Alstom', 2020, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TR001'), NULL);
INSERT INTO NavetteTab VALUES ('N006', 'Bombardier', 2021, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TR001'), NULL);
-- Insertion des navettes pour la ligne TN001
INSERT INTO NavetteTab VALUES ('N007', 'Siemens', 2020, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TN001'), NULL);
INSERT INTO NavetteTab VALUES ('N008', 'CAF', 2021, (SELECT REF(l) FROM LigneTab l WHERE l.code_ligne = 'TN001'), NULL);


-- Insertion des voyages pour les navettes
-- Insertion du voyage V0001
INSERT INTO VoyageTab VALUES (
    'V0001', 
    TO_DATE('2025-01-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    30, 
    TO_DATE('2025-01-01 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    'Aller', 
    30, 
    'Panne', 
    (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N001')
);

-- Insertion du voyage V0002
INSERT INTO VoyageTab VALUES (
    'V0002', 
    TO_DATE('2025-01-15 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    30, 
    TO_DATE('2025-01-15 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
    'Retour', 
    35, 
    'On Time', 
    (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N001')
);

-- Insertion du voyage V0003
INSERT INTO VoyageTab VALUES (
    'V0003', 
    TO_DATE('2025-02-01 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), 
    30, 
    TO_DATE('2025-02-01 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), 
    'Aller', 
    40, 
    'Arrivé', 
    (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N003')
);

-- Insertion du voyage V0004
INSERT INTO VoyageTab VALUES (
    'V0004', 
    TO_DATE('2025-02-15 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 
    30, 
    TO_DATE('2025-02-15 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 
    'Retour', 
    50, 
    'RAS', 
    (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N003')
);

-- Nouveau voyage 1
INSERT INTO VoyageTab VALUES
('V0005', TO_DATE('2025-01-03 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-03 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Aller', 40, 'Panne', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N002'));

-- Nouveau voyage 2
INSERT INTO VoyageTab VALUES
('V0006', TO_DATE('2025-01-03 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-03 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Retour', 35, 'Retard', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N003'));

-- Nouveau voyage 3
INSERT INTO VoyageTab VALUES
('V0007', TO_DATE('2025-01-04 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-04 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Aller', 45, 'A lheure', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N004'));

-- Nouveau voyage 4
INSERT INTO VoyageTab VALUES
('V0008', TO_DATE('2025-01-04 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-04 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Retour', 40, 'RAS', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N005'));

-- Nouveau voyage 5
INSERT INTO VoyageTab VALUES
('V0009', TO_DATE('2025-01-05 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-05 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Aller', 50, 'Accident', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N006'));

-- Nouveau voyage 6
INSERT INTO VoyageTab VALUES
('V0010', TO_DATE('2025-01-05 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-05 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Retour', 60, 'Retard', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N007'));

-- Nouveau voyage 7
INSERT INTO VoyageTab VALUES
('V0011', TO_DATE('2025-01-06 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-06 07:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Aller', 55, 'Panne', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N008'));

-- Nouveau voyage 8
INSERT INTO VoyageTab VALUES
('V0012', TO_DATE('2025-01-06 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-06 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Retour', 70, 'A lheure', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N001'));

-- Nouveau voyage 9
INSERT INTO VoyageTab VALUES
('V0013', TO_DATE('2025-01-07 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-07 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Aller', 60, 'Retard', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N002'));

-- Nouveau voyage 10
INSERT INTO VoyageTab VALUES
('V0014', TO_DATE('2025-01-07 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, TO_DATE('2025-01-07 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Retour', 50, 'Accident', (SELECT REF(n) FROM NavetteTab n WHERE n.num_navette = 'N003'));

-- updates of table ligne : because of station codes
UPDATE LigneTab l
SET l.station_depart = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP001'),
    l.station_arrivee = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS001'),
    l.liste_navettes = CAST(
        MULTISET(
            SELECT REF(n) FROM NavetteTab n WHERE n.num_navette IN ('N003', 'N004')
        ) AS TabNavette
    ),
    l.liste_troncons = CAST(
        MULTISET(
            SELECT REF(t) FROM TronconTab t WHERE t.num_troncon IN (101, 102, 103)
        ) AS TabTroncon
    )
WHERE l.code_ligne = 'M001';

UPDATE LigneTab l
SET l.station_depart = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP004'),
    l.station_arrivee = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS004'),
    l.liste_navettes = CAST(
        MULTISET(
            SELECT REF(n) FROM NavetteTab n WHERE n.num_navette IN ('N001', 'N002')
        ) AS TabNavette
    ),
    l.liste_troncons = CAST(
        MULTISET(
            SELECT REF(t) FROM TronconTab t WHERE t.num_troncon IN (301, 302)
        ) AS TabTroncon
    )
WHERE l.code_ligne = 'B001';


UPDATE LigneTab l
SET l.station_depart = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SP002'),
    l.station_arrivee = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS003'),
    l.liste_navettes = CAST(
        MULTISET(
            SELECT REF(n) FROM NavetteTab n WHERE n.num_navette IN ('N005', 'N006')
        ) AS TabNavette
    ),
    l.liste_troncons = CAST(
        MULTISET(
            SELECT REF(t) FROM TronconTab t WHERE t.num_troncon IN (201, 202)
        ) AS TabTroncon
    )
WHERE l.code_ligne = 'TR001';

UPDATE LigneTab l
SET l.station_depart = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS003'),
    l.station_arrivee = (SELECT REF(s) FROM StationTab s WHERE s.code_station = 'SS006'),
    l.liste_navettes = CAST(
        MULTISET(
            SELECT REF(n) FROM NavetteTab n WHERE n.num_navette IN ('N007', 'N008')
        ) AS TabNavette
    ),
    l.liste_troncons = CAST(
        MULTISET(
            SELECT REF(t) FROM TronconTab t WHERE t.num_troncon IN (401)
        ) AS TabTroncon
    )
WHERE l.code_ligne = 'TN001';

-- update navette to add liste voyages :
BEGIN
  FOR rec IN (SELECT num_navette FROM NavetteTab) LOOP
    UPDATE NavetteTab n
    SET n.liste_voyages = CAST(
      MULTISET(
        SELECT REF(v)
        FROM VoyageTab v
        WHERE v.navette = REF(n)
      ) AS TabVoyage
    )
    WHERE n.num_navette = rec.num_navette;
  END LOOP;
END;
/
-- verification
select * from NavetteTab;