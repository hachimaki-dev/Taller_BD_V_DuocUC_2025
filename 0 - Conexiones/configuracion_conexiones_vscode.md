ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER user_biblioteca IDENTIFIED BY "mypassword123"
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";
ALTER USER user_biblioteca QUOTA UNLIMITED ON USERS;
GRANT CREATE SESSION TO user_biblioteca;
GRANT "RESOURCE" TO user_biblioteca;
ALTER USER user_biblioteca DEFAULT ROLE "RESOURCE";

SELECT name FROM v$database;
-- O también:
SHOW PARAMETER service_names;
-- O también:
SELECT value FROM v$parameter WHERE name = 'service_names';