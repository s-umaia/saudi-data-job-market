
-- Top cities by job postings
SELECT job_location , COUNT(job_location) AS Frequency
FROM job_postings_fact 
WHERE job_country LIKE '%Saudi Arabia' 
GROUP BY job_location 
ORDER BY Frequency DESC;

-- Top companies hiring
SELECT COUNT(j.job_title_short) AS job_postings , c.name
FROM job_postings_fact j
JOIN company_dim c ON j.company_id = c.company_id
WHERE j.job_country LIKE '%Saudi Arabia%'
GROUP BY c.name
ORDER BY job_postings DESC;

-- Job posting timeline
SELECT job_posted_date, COUNT(*) AS job_count
FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%'
GROUP BY job_posted_date
ORDER BY job_posted_date;

-- Top 10 job titles
SELECT j.job_title_short AS job_title, COUNT(*) AS frequency
FROM job_postings_fact j
WHERE j.job_country LIKE '%Saudi Arabia%'
GROUP BY j.job_title_short
ORDER BY frequency DESC;

-- Top 10 skills in demand
SELECT s.skills AS skill_name, COUNT(*) AS frequency
FROM job_postings_fact j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE j.job_country LIKE '%Saudi Arabia%'
GROUP BY s.skills
ORDER BY frequency DESC
LIMIT 10;

-- Top skills for a specific role (e.g., Data Analyst)
SELECT s.skills AS skill_name, COUNT(*) AS frequency
FROM job_postings_fact j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE j.job_country LIKE '%Saudi Arabia%' AND j.job_title_short = 'Data Analyst'
GROUP BY s.skills
ORDER BY frequency DESC
LIMIT 10;

-- Jobs with no degree mention
SELECT COUNT(*) AS jobs_without_degree
FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%' AND job_required_degree IS NULL;

-- Full-time job count
SELECT COUNT(*) AS full_time_jobs
FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%' AND job_schedule_type = 'Full-time';

-- Top 2 companies per city
WITH company_postings AS (
  SELECT c.name AS company_name, j.job_location AS city, COUNT(*) AS jobs
  FROM job_postings_fact j
  JOIN company_dim c ON j.company_id = c.company_id
  WHERE j.job_country ILIKE '%Saudi Arabia%'
  GROUP BY c.name, j.job_location
),
ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY city ORDER BY jobs DESC) AS rank
  FROM company_postings
)
SELECT company_name, city, jobs
FROM ranked
WHERE rank <= 2
ORDER BY city, rank;

-- Top 3 skills per company
WITH ranked_skills AS (
  SELECT 
    c.name AS company_name,
    s.skills AS skill_name,
    COUNT(*) AS skill_frequency,
    ROW_NUMBER() OVER(PARTITION BY c.name ORDER BY COUNT(*) DESC) AS rank
  FROM job_postings_fact j
  JOIN company_dim c ON j.company_id = c.company_id
  JOIN skills_job_dim sj ON j.job_id = sj.job_id
  JOIN skills_dim s ON sj.skill_id = s.skill_id
  WHERE j.job_country LIKE '%Saudi Arabia%'
  GROUP BY c.name, s.skills
)
SELECT company_name, skill_name, skill_frequency
FROM ranked_skills 
WHERE rank <= 3
ORDER BY company_name, skill_frequency DESC;

-- Top 5 skills per company and role
WITH SkillCounts AS (
    SELECT c.name AS company_name, j.job_title_short, s.skills, COUNT(*) AS skill_count
    FROM job_postings_fact j
    JOIN company_dim c ON j.company_id = c.company_id
    JOIN skills_job_dim sj ON j.job_id = sj.job_id
    JOIN skills_dim s ON sj.skill_id = s.skill_id
    GROUP BY c.name, j.job_title_short, s.skills
),
RankedSkills AS (
    SELECT company_name, job_title_short, skills, skill_count,
           ROW_NUMBER() OVER (PARTITION BY company_name, job_title_short ORDER BY skill_count DESC) AS skill_rank
    FROM SkillCounts
)
SELECT company_name, job_title_short, STRING_AGG(skills, ', ') AS top_5_skills
FROM RankedSkills
WHERE skill_rank <= 5
GROUP BY company_name, job_title_short
ORDER BY company_name, job_title_short;
