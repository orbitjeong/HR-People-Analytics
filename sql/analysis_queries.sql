/* =========================================================
   HR People Analytics - Analysis Queries (Portfolio)
   Tables:
     - people
     - employment_history
   ========================================================= */

-- ---------------------------------------------------------
-- 0) Quick sanity checks
-- ---------------------------------------------------------
SELECT COUNT(*) AS people_rows FROM people;
SELECT COUNT(*) AS history_rows FROM employment_history;

-- Employees with missing people record (should be 0 in ideal data)
SELECT COUNT(*) AS history_without_people
FROM employment_history eh
LEFT JOIN people p ON p.employee_id = eh.employee_id
WHERE p.employee_id IS NULL;

-- ---------------------------------------------------------
-- 1) Headcount as of a specific date
--    Definition:
--      hired on/before AsOfDate AND (no term_date OR term_date > AsOfDate)
-- ---------------------------------------------------------
-- Change this date as needed:
-- (If your DB supports variables you can use them; this is portable SQL)
SELECT COUNT(DISTINCT eh.employee_id) AS headcount_as_of
FROM employment_history eh
WHERE eh.hire_date <= DATE '2025-09-30'
  AND (eh.term_date IS NULL OR eh.term_date > DATE '2025-09-30');

-- Headcount by department (as of date)
SELECT
    p.department,
    COUNT(DISTINCT eh.employee_id) AS headcount_as_of
FROM employment_history eh
JOIN people p ON p.employee_id = eh.employee_id
WHERE eh.hire_date <= DATE '2025-09-30'
  AND (eh.term_date IS NULL OR eh.term_date > DATE '2025-09-30')
GROUP BY p.department
ORDER BY headcount_as_of DESC;

-- ---------------------------------------------------------
-- 2) Departing Employees in a period (leavers)
--    Definition:
--      term_date within [StartDate, EndDate]
-- ---------------------------------------------------------
SELECT COUNT(DISTINCT employee_id) AS departing_employees
FROM employment_history
WHERE term_date IS NOT NULL
  AND term_date >= DATE '2025-09-01'
  AND term_date <= DATE '2025-09-30';

-- Departing employees by department (period)
SELECT
    p.department,
    COUNT(DISTINCT eh.employee_id) AS departing_employees
FROM employment_history eh
JOIN people p ON p.employee_id = eh.employee_id
WHERE eh.term_date IS NOT NULL
  AND eh.term_date >= DATE '2025-09-01'
  AND eh.term_date <= DATE '2025-09-30'
GROUP BY p.department
ORDER BY departing_employees DESC;

-- ---------------------------------------------------------
-- 3) Average Headcount in a period (simple approach)
--    A common simplified method:
--      AvgHeadcount = (Headcount at Start + Headcount at End) / 2
-- ---------------------------------------------------------
-- Start Headcount (as of StartDate)
SELECT COUNT(DISTINCT employee_id) AS headcount_start
FROM employment_history
WHERE hire_date <= DATE '2025-09-01'
  AND (term_date IS NULL OR term_date > DATE '2025-09-01');

-- End Headcount (as of EndDate)
SELECT COUNT(DISTINCT employee_id) AS headcount_end
FROM employment_history
WHERE hire_date <= DATE '2025-09-30'
  AND (term_date IS NULL OR term_date > DATE '2025-09-30');

-- ---------------------------------------------------------
-- 4) Turnover Rate (period)
--    Turnover = DepartingEmployees / AvgHeadcount
--    (Below is written in a readable CTE style)
-- ---------------------------------------------------------
WITH
hc_start AS (
  SELECT COUNT(DISTINCT employee_id) AS n
  FROM employment_history
  WHERE hire_date <= DATE '2025-09-01'
    AND (term_date IS NULL OR term_date > DATE '2025-09-01')
),
hc_end AS (
  SELECT COUNT(DISTINCT employee_id) AS n
  FROM employment_history
  WHERE hire_date <= DATE '2025-09-30'
    AND (term_date IS NULL OR term_date > DATE '2025-09-30')
),
leavers AS (
  SELECT COUNT(DISTINCT employee_id) AS n
  FROM employment_history
  WHERE term_date IS NOT NULL
    AND term_date >= DATE '2025-09-01'
    AND term_date <= DATE '2025-09-30'
)
SELECT
  leavers.n AS departing_employees,
  (hc_start.n + hc_end.n) / 2.0 AS avg_headcount,
  CASE
    WHEN (hc_start.n + hc_end.n) = 0 THEN 0
    ELSE leavers.n / ((hc_start.n + hc_end.n) / 2.0)
  END AS turnover_rate
FROM hc_start, hc_end, leavers;

-- ---------------------------------------------------------
-- 5) Retention Rate (simple cohort retention - optional)
--    This varies by definition across companies.
--    Example approach:
--      Retained = employees active at StartDate who are still active at EndDate
--      Retention = Retained / Headcount at StartDate
-- ---------------------------------------------------------
WITH
start_active AS (
  SELECT DISTINCT employee_id
  FROM employment_history
  WHERE hire_date <= DATE '2025-09-01'
    AND (term_date IS NULL OR term_date > DATE '2025-09-01')
),
retained AS (
  SELECT sa.employee_id
  FROM start_active sa
  JOIN employment_history eh ON eh.employee_id = sa.employee_id
  WHERE eh.hire_date <= DATE '2025-09-30'
    AND (eh.term_date IS NULL OR eh.term_date > DATE '2025-09-30')
)
SELECT
  (SELECT COUNT(*) FROM retained) AS retained_employees,
  (SELECT COUNT(*) FROM start_active) AS starting_headcount,
  CASE
    WHEN (SELECT COUNT(*) FROM start_active) = 0 THEN 0
    ELSE (SELECT COUNT(*) FROM retained) * 1.0 / (SELECT COUNT(*) FROM start_active)
  END AS retention_rate;
