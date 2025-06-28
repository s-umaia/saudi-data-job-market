
SELECT * FROM job_postings_fact;

-- List distinct countries in dataset
SELECT DISTINCT(job_country) FROM job_postings_fact;

-- Check available job roles
SELECT DISTINCT(job_title_short) FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%';

-- Count number of unique job titles
SELECT COUNT(DISTINCT(job_title_short)) FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%';

-- Confirm null salary values
SELECT COUNT(*) FROM job_postings_fact
WHERE job_country LIKE '%Saudi%' AND salary_year_avg IS NOT NULL;

-- View available skills
SELECT DISTINCT(skills) FROM skills_dim;

-- View number of companies posting jobs
SELECT COUNT(DISTINCT(c.name)) FROM company_dim c
JOIN job_postings_fact j ON c.company_id = j.company_id
WHERE job_country LIKE '%Saudi Arabia%';
