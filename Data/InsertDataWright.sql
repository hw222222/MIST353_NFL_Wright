-- -- Step 1: Create a login at the server level

-- use master;

-- CREATE LOGIN NandaSurendra

-- WITH PASSWORD = 'MI$T353Instructor';



-- -- Step 2: Switch to your target database

-- --USE MIST353_NFL_RDB_Wright;



-- -- Step 3: Create a database user mapped to the login

-- CREATE USER NandaSurendra

-- FOR LOGIN NandaSurendra;



-- -- Step 4: Grant EXECUTE permission on all stored procedures and UDFs

-- GRANT EXECUTE TO NandaSurendra;



-- -- Read access to all tables

-- GRANT SELECT TO NandaSurendra;

use master;

-- connectionstring Server=localhost;Database=MIST353_NFL_RDB_Wright;Trusted_Connection=True;
SELECT name
FROM sys.databases
ORDER BY name;