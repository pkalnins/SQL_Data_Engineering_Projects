-- Array Intro
SELECT ['python','sql','r'] AS skills_array; 

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skill
FROM skills_array; 

