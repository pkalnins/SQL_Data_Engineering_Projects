-- Count rows aggregation only 

SELECT
    COUNT(*)
FROM 
    job_postings_fact; 


-- Count rows window function 
SELECT 
    job_id, 
    COUNT(*) OVER ()
FROM 
    job_postings_fact; 

-- PARTITION BY
SELECT  
    job_id, 
    job_title_short, 
    company_id, 
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short, company_id
    ) AS avg_hourly_by_title
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM(); 

-- ORDER BY
SELECT
    job_id, 
    job_title_short, 
    salary_hour_avg, 
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM  
    job_postings_fact
ORDER BY 
    salary_hour_avg DESC
LIMIT 10; 

-- Partition and Order By
SELECT
    job_posted_date, 
    job_title_short, 
    salary_hour_avg, 
    AVG (salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hourly_by_title
FROM
    job_postings_fact
WHERE  
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY
    job_title_short, 
    job_posted_date
LIMIT 10; 

-- Row and Rank Functions

SELECT
    job_id, 
    job_title_short, 
    salary_hour_avg, 
    DENSE_RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM  
    job_postings_fact
ORDER BY 
    salary_hour_avg DESC
LIMIT 140; 

-- ROW_NUMBER()
SELECT
    *, 
    ROW_NUMBER() OVER (
        ORDER BY job_posted_date
    )
FROM
    job_postings_fact
ORDER BY 
    job_posted_date
LIMIT 20; 

-- Navigation Functions
SELECT
    job_id, 
    company_id, 
    job_title, 
    job_title_short, 
    job_posted_date, 
    salary_year_avg,
    LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary, 
    salary_year_avg - LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60; 