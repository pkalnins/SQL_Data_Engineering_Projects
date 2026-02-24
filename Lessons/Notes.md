# SQL Notes

[MotherDuckApp](https://app.motherduck.com/)

CRUD Operations: 
- Create (SQL: Create)
- Read (SQL: Select)
- Update (SQL: Update)
- Delete (SQL: Delete)

Three types of SQL language: 
- DQL: Data query language
	- Read databases
- DML: Data manipulation language
	- Update/delete data
- DDL: Data definition language
	- Create new database

Databases: 
- Location
	- Local
	- Cloud
- Relational databases: 
	- Data stored in tables (rows and columns)
	- Principal key to link varies tables
- Non-relationship databases
	- Data stored in multiple forms

Data warehouses
- Subject-oriented
- Non-volatile 
- Integrated
- Time-variant 

***
### SQL Keywords

SELECT *
FROM job_postings_fact

(* means all columns)

LIMIT x
(where x specifies the number of rows; always place at end)

SELECT DISTINCT

Best practice: place semi-colon at end of query 

WHERE
(to filter job titles; place after FROM)

Comments: 
-- This is a comment --
Multiline comment: /* comments */

ORDER BY
	Column name
(Sorts in ascending order; can also do DESC after column name)


Order to write commands: 
SELECT column 1, column 2, ...
FROM table_name
WHERE condition 
GROUP BY column
HAVING condition
ORDER BY column 1 [ASC|DESC]
LIMIT number; 

***
#### Operators
Comparison Operators
- Equal: =
- Not equal to: != or <>
- Greater than/less than: >, <, >=, <=
- Within a range (inclusive): BETWEEN (e.g. salary_year_avg BETWEEN 50000 AND 750000)
- Matches any value in a list: IN (e.g. job_title_short IN('Data Analyst', 'Business Analyst'))
- Pattern match: LIKE (e.g. job_title LIKE '%Engineer%')
- Tests for NULL: IS NULL, IS NOT NULL

Logical Operators
- AND
- OR
- NOT

Boolean Operators
- TRUE
- FALSE

Where are operators used: 
- WHERE (e.g. WHERE dept = 'Sales' AND salary > 60000)
- HAVING (e.g. HAVING AVG(salary) > 70000 AND COUNT(*) > 5)
- JOIN
- CASE

Alias: AS
Can create table names that are helpful for the user

***
### Arithmetic Operators 

| Clause              | Description                   | Example                             |     |
| ------------------- | ----------------------------- | ----------------------------------- | --- |
| SELECT              | Calculate values in output    | SELECT salary \*0.1 AS bonus        |     |
| WHERE               | Filter rows with conditions   | WHERE quantity \* unit_price \> 100 |     |
| ORDER By            | Sort results by expressions   | ORDER BY salary \* 12               |     |
| GROUP BY and HAVING | Group and filter aggregations | HAVING SUM(salary) \> 100000        |     |
Operators: +, -,* *, /, %

***
### Aggregate Functions

COUNT()
etc. 


### Terminal
Commands

| Task                   | bash/zsh              |     |
| ---------------------- | --------------------- | --- |
| List files             | ls                    |     |
| Change directory       | cd                    |     |
| Working directory      | cmd                   |     |
| Create file            | touch filename        |     |
| Create directory       | mkdir dirname         |     |
| Remove file            | rm filename           |     |
| Copy file              | cp source dest        |     |
| Move/rename file       | mv source dest        |     |
| View file              | cat filename          |     |
| Search for a pattern   | grep <pattern> [file] |     |
| Display a line of text | echo <text>           |     |
### Data Types

- Numeric
	- INT
	- FLOAT
	- DOUBLE
	- DECIMAL (p, s) = (total digits, digits after decimal)
	- NUMERIC (p, s)

- Character
	- CHAR(n) (n) = max number of characters
	- VARCHAR(n)
	- TEXT (unlimited length)

- BOOLEAN (true/false)

- DATE/TIME
	- DATE
	- TIME
	- TIMESTAMP
	- TIMESTAMPZ (has time zone)

- Other
	- ARRAY
	- JSON
	- UUID
	- BINARY

***
## DDL & DML

DQL -> Data query language (SQL commands covered so far)

**DML**
Manipulate data within tables
- SELECT
- INSERT
- UPDATE

- DELETE
    - Row-level removal 
    - Keeps schema
    - Optional WHERE
    - Slower on huge tables
    - Best for targeted deletes
    DELETE FROM table_name
    WHERE condition; 

- MERGE
    

**DDL** 
Data definition language; create/delete tables/objects
Used for database setup 

- CREATE

- ALTER

- DROP 
     - Use caution!
     - Removes schema + data
     - Breaks dependencies
     - Must recreate table to use again 

- TRUNCATE
    - Fast wipe of all rows 
    - Keeps schema
    - NO WHERE (all rows)
    - Very fast
    - Resets table to empty 

Data --> Data Warehouse --> Data Mart

Other DDL table commands: 

- CTAS (Create table as Select)
    - Physical table
    - Stored on disk 
    - Snapshot at creation time
    - Fast reads
    - A persistent snapshot
    CREATE [OR REPLACE] TABLE AS (...)

- VIEW
    - Stored query definition 
    - Virtual table 
    - Query runs at read time
    - Always reflects last data
    - Can be slower (recomputes)
    CREATE [OR REPLACE] VIEW AS (...)

- TEMP TABLE
    - Session-scoped table 
    - Materialized data
    - Session-only scope
    - Auto-deleted on disconnect
    - Great for debugging/staging
    CREATE [OR REPLACE] TEMP TABLE 

### Subqueries & Common Table Expressions (CTE's)

Subqueries
```sql
SELECT *
FROM
    (
      SELECT *
      FROM job_postings
      WHERE job_title_short = 'Data Engineer'  
    ) AS data_engineering_jobs
```

### Common Table Expressions (CTE's)
```sql
WITH data_engineer_jobs AS (
    SELECT *
    FROM job_postings
    WHERE job_title_short = 'Data Engineer'
)
SELECT *
FROM data_engineer_jobs

```
CTE: a temporary result set that you can reference within: 
- FROM: used like a table
- JOIN: join it to any other table
- Other CTE's: later CTE's can reference earlier ones
- SELECT/INSERT/UPDATE/DELETE: main statement

`WITH`: used to define CTE at the beginning of a query 
Exists only during the execution of a query


## Data Modeling

Database -> Schema -> Tables 

ERD Diagrams
Star schemas
Primary & foreign keys
Relationships: one-to-one, one-to-many, etc. 

*Why is Data Modeling Important?*
- Different sources use different designs
- Modeling brings structure & consistency
- Can combine individual databases into a single data warehouse

Pipeline: 
Source system -> ELT -> Analytical systems (data warehouse, etc.)

Common Analytical Systems:
- Data warehouse
- Data Mart
- Data lakehouse

Common source systems: 
- ERP systems (Enterprise resource planning)
    - Purpose: Run the entire business
    - Focus: back-end operations
    - Core modules: 
        - Finance: GL, AP, AR, budgeting
        - Supply chain: inventory, procurement
        - HR: payroll, benefits
    - Data role: system of record for operational truth
    - Question it answers: "How is the business running internally?"

- CRM systems (Customer relationship management)
    - Purpose: grow revenue
    - Focus: front-office interactions
    - Core modules: 
        - Sales: leads, opportunities, pipelines
        - Marketing: campaigns, attribution
        - Support: tickets, customer success
    - Data role: system of engagement
    - Question it answers: "How do we acquire, convert, and retain customers?"

- App backend
- Normalized tables 

All these solutions use specific databases (e.g. Oracle database, PostgreSQL, SAPHana, etc.)

Choosing a database
**OLTP (Online transaction processing)**
- Purpose: operate apps and capture live transactions
- Optimized for: high-velocity writes, low-latency point reads
- Structure: many narrow, related tables; strict FK's; minimal redundancy
- Examples: SQLite, PostgreSQL, MySQL, MS SQL Server, Oracle, MariaDB

**OLAP (Online analytical processing)**
- Purpose: analyze historical data and report
- Optimized for: large scans, aggregations, filters, time-series
- Structure: fact tables (measures) + dimension tables (who/what/when/where)
- Examples: DuckDB, GCP BigQuery, Amazon Redshit, Databricks, Snowflake, Clickhouse

Core Design Patterns (7)

1. Star Schema
    - One central fact table, surrounded by dimension tables
    - Most popular within analytical systems (OLAP)

2. Normalized Schema
    - Data split into multiple related tables
    - Often hundreds of different tables linked together
    - Most popular within transaction systems (OLTP)

3. Constellation/Galaxy Schema
    - A type of star schema: multiple star schemas
    - Used in enterprise companies with many teams
    - Each fact table specific to a specific team

4. Snowflake Schema
    - Variation of star schema
    - Central fact table, dim tables with their own stars
    - More common in legacy schemas

5. Factless Fact Table
    - Another variation of star schema
    - Central table only contains Id's (no numerical measures)

6. Bridge Table
    - Helps resolve many-many relationships by acting a as intermediary 

7. Flat (Wide) Table
    - Take a star schema -> convert to a single table
    - Common in reporting tools 


### Maintaining Data Models
Slowly changing dimensions (SCD)
- Type 0 - 6 changes
- Type 0: fixed dimension,can't overwrite
- Type 1: overwrite
- Type 2: add new row
- Type 3: add new attribute (column)
- Type 4: history table 
- Type 5 & 6 are hybrids of the above


## CASE Expressions

```sql
CASE
    WHEN condition_1 THEN result_1
    [ WHEN condition_2 THEN result_2 ]
    [ ELSE result_default ]
END
```
Can use inside a SELECT, etc. 

Example: 
```sql
SELECT
    CASE
        WHEN salary_hour_avg > 40
            THEN 'High Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM job_postings
```

4 popular use cases: 

- Bucketing data: group values in ranges (`CASE WHEN salary <25`)
- Handling NULL data: handle NULLs explicitly (`CASE WHEN salary IS NULL`)
- Categorizing values: normalize inconsistent text (`CASE WHEN job_title LIKE '%Analyst%' THEN 'Data Analyst'`)
- Conditional aggregation: aggregate subsets into one query (`COUNT(CASE WHEN salary IS NOT NULL THEN 1 END)`)






