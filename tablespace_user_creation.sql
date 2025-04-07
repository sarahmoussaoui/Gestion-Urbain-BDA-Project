-- Section B: Création des Tablespaces et utilisateur

-- 3. Création des deux Tablespaces
CREATE TABLESPACE SQL3_TBS
DATAFILE 'SQL3_TBS.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 50M
MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO;

CREATE TEMPORARY TABLESPACE SQL3_TempTBS
TEMPFILE 'SQL3_TempTBS.dbf'
SIZE 50M
AUTOEXTEND ON NEXT 25M
MAXSIZE 200M
EXTENT MANAGEMENT LOCAL;

-- 4. Création de l'utilisateur SQL3 avec les Tablespaces
CREATE USER SQL3 IDENTIFIED BY "BDA_2025"
DEFAULT TABLESPACE SQL3_TBS
TEMPORARY TABLESPACE SQL3_TempTBS
QUOTA UNLIMITED ON SQL3_TBS;

-- 5. Attribution des privilèges
GRANT CONNECT, RESOURCE TO SQL3;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, 
CREATE CREATE PROCEDURE, CREATE TRIGGER,
GRANT UNLIMITED TABLESPACE TO SQL3;


-- verifification
SELECT username, default_tablespace, temporary_tablespace
FROM dba_users WHERE username = 'SQL3';

SELECT tablespace_name, status, contents 
FROM dba_tablespaces;