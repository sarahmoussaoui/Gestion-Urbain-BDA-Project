-- Connexion à l'utilisateur SQL3
CONNECT SQL3;

-- Suppression des tables et des types en toute sécurité
DECLARE
    PROCEDURE SafeDropTable(tableName VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE ' || tableName || ' CASCADE CONSTRAINTS';
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- Ignore si la table n'existe pas
    END;

    PROCEDURE SafeDropType(typeName VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'DROP TYPE ' || typeName || ' FORCE';
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- Ignore si le type n'existe pas
    END;
BEGIN
    -- D'abord supprimer les tables (dans l'ordre inverse des dépendances)
    SafeDropTable('VoyageTab');
    SafeDropTable('NavetteTab');
    SafeDropTable('TronconTab');
    SafeDropTable('LigneTab');
    SafeDropTable('StationTab');
    SafeDropTable('MoyenTransportTab');

    -- Ensuite supprimer les types (collections et objets)
    SafeDropType('TabVoyage');
    SafeDropType('VoyageType');
    SafeDropType('TabNavette');
    SafeDropType('NavetteType');
    SafeDropType('TabTroncon');
    SafeDropType('TronconType');
    SafeDropType('LigneType');

    -- Types de station
    SafeDropType('StationSecondaireType');
    SafeDropType('StationPrincipaleType');
    SafeDropType('StationType');

    -- Moyens de transport
    SafeDropType('TabMoyenTransport');
    SafeDropType('MoyenTransportType');
END;
/

-- if needed 
--DROP TABLE LigneTab PURGE;

-- 2) Drop the type body, then the type itself:
--DROP TYPE BODY LigneType;
--DROP TYPE LigneType FORCE;