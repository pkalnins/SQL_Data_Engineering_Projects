-- Array Intro
SELECT ['python','sql','r'] AS skills_array; 

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skill, 
    skills[2] AS second_skill, 
    skills[3] AS third_skill
FROM skills_array; 

-- STRUCT
SELECT { skill:'python', type: 'programming'} AS skill_struct; 

WITH skills_struct AS (
    SELECT
        STRUCT_PACK(
            skill := 'python', 
            type := 'programming'
        ) AS s
)
SELECT
    s.skill, 
    s.type
FROM skills_struct; 

-- JSON
WITH raw_skill_json AS (
    SELECT
        '{"skills":"python", "type":"programming"}'::JSON AS skill_json
)
SELECT
    skill_json 
FROM raw_skill_json; 

-- Arrays - Final Example 
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table 

CREATE OR REPLACE TEMP TABLE job_skills_array AS 
SELECT 
    jpf.job_id, 
    jpf.job_title_short, 
    jpf.salary_year_avg, 
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL; 

-- Analyze the median salary per skill 

WITH flat_skills AS (
    SELECT 
        job_id, 
        job_title_short, 
        salary_year_avg, 
        UNNEST(skills_array) AS skill 
    FROM
        job_skills_array 
)
SELECT
    skill, 
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC; 



-- Array of Structs - Final Example
-- Build a flat skill & type table for co-workers to access job titles, salary info, skills, and type in one table 

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT 
    jpf.job_id, 
    jpf.job_title_short, 
    jpf.salary_year_avg, 
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type, 
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL; 

-- From the persepctive of a data analyst, analyze the median salary per type of skill

WITH flat_skills AS (
    SELECT 
        job_id, 
        job_title_short, 
        salary_year_avg, 
        UNNEST(skills_type).skill_type AS skill_type, 
        UNNEST(skills_type).skill_name AS skill_name
    FROM 
        job_skills_array_struct
)
SELECT
    skill_type, 
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill_type; 