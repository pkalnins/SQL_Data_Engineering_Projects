-- DDL -- 

/* Idempotent Operations
Definition: denoting an element of a set which is unchanged in value when multiplied or otherwise operated on by itself
.read Lessons/1.21/1.21_DDL_DML_Pt1.sql
*/

USE data_jobs; 

-- Drop database: use caution! --
-- DROP DATABASE jobs_mart; 
-- Drop only if exists -- 
DROP DATABASE IF EXISTS jobs_mart; 

-- Create new database -- 
-- CREATE DATABASE jobs_mart; 
-- Creates only if it doesn't already exist -- 
CREATE DATABASE IF NOT EXISTS jobs_mart; 

-- Show databses in DuckDB -- 
SHOW DATABASES; 

-- Show schemas in DuckDB -- 
SELECT *
FROM information_schema.schemata; 

-- Changes default database -- 
USE jobs_mart; 

-- Create schema if doesn't exist -- 
CREATE SCHEMA IF NOT EXISTS staging; 

-- Drop schema in main -- 
-- DROP SCHEMA staging; 

-- Show schemas in DuckDB -- 
SELECT *
FROM information_schema.schemata; 


/* CREATE TABLE
Notes: 
- CREATE TABLE defines a new table and its columns
- You can scope it to a schema with `schema_name.table_name`

CREATE TABLE IF NOT EXISTS table_name (
    id_column INTEGER PRIMARY KEY, 
    column_name2 datatype, 
    column_name 3 datatype, 
    foreign_key_column datatype, 
    FOREIGN KEY (foreign_key_column) REFERENCES parent_table()
); 
*/

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY, 
    role_name VARCHAR
); 

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart'; 

-- DROP TABLE IF EXISTS main.preferred_roles; 

/* INSERT
`INSERT INTO` adds new rows to a table
`VALUES` lets you insert one or many rows at once

Basic pattern: 
INSERT INTO table_name (col1, col2, ...)
VALUES (val1, va12, ...)

*/

INSERT INTO staging.preferred_roles(role_id, role_name)
VALUES
    (1,'Data Engineer'), 
    (2,'Senior Data Engineer'), 
    (3,'Software Engineer'); 

SELECT *
FROM staging.preferred_roles; 

-- ALTER TABLE: ADD, DROP COLUMN -- 

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN; 
    
-- UPDATE: row level modification; add data to new column -- 

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2; 

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3; 

-- Rename and Alter Columns -- 

-- Rename Table -- 
ALTER TABLE staging.preferred_roles
RENAME TO priority_roles; 


-- Rename Column -- 
ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl; 

-- Change values in a column -- 
ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER; 

UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3; 

SELECT *
FROM staging.priority_roles; 