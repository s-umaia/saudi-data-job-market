
-- Most versatile skill (appears in most companies for Data Analyst roles)
SELECT COUNT(DISTINCT c.name) AS company_count, s.skills
FROM job_postings_fact j
JOIN company_dim c ON j.company_id = c.company_id
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE j.job_country LIKE '%Saudi Arabia%' AND job_title_short LIKE '%Data Analyst%'
GROUP BY s.skills
ORDER BY company_count DESC;

-- Skill usage across companies
SELECT COUNT(s.skills) AS skill_frequency, s.skills, c.name
FROM job_postings_fact j
JOIN company_dim c ON j.company_id = c.company_id
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE j.job_country LIKE '%Saudi Arabia%'
GROUP BY c.name, s.skills
ORDER BY skill_frequency DESC;

-- Top skills overall
SELECT s.skills AS skill_name, COUNT(*) AS frequency
FROM job_postings_fact j
JOIN skills_job_dim sj ON j.job_id = sj.job_id
JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE j.job_country LIKE '%Saudi Arabia%'
GROUP BY s.skills
ORDER BY frequency DESC
LIMIT 10;

-- Job type breakdown
SELECT job_schedule_type, COUNT(*) AS count
FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%'
GROUP BY job_schedule_type;

-- Source platforms used (job_via)
SELECT job_via, COUNT(*) AS count
FROM job_postings_fact
WHERE job_country LIKE '%Saudi Arabia%'
GROUP BY job_via
ORDER BY count DESC;
