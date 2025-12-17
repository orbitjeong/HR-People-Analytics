/* =========================================================
   HR People Analytics - Schema (Portfolio)
   - Source files:
     1) people_data.csv
     2) people_employment_history.csv
   ========================================================= */

-- Drop tables if they exist (optional - depends on your DB)
-- DROP TABLE IF EXISTS employment_history;
-- DROP TABLE IF EXISTS people;

-- 1) Dimension table: people (employee master data)
CREATE TABLE people (
    employee_id            INT            PRIMARY KEY,
    -- Keep these columns aligned with people_data.csv
    first_name             VARCHAR(100),
    last_name              VARCHAR(100),
    gender                 VARCHAR(50),
    department             VARCHAR(100),
    job_title              VARCHAR(150),
    employment_type        VARCHAR(50),
    location               VARCHAR(100)
);

-- 2) Fact table: employment history (hire/term dates)
CREATE TABLE employment_history (
    employee_id            INT            NOT NULL,
    hire_date              DATE           NOT NULL,
    term_date              DATE           NULL,
    -- Optional fields if your CSV has them
    status                 VARCHAR(50)    NULL,

    CONSTRAINT fk_employment_history_people
        FOREIGN KEY (employee_id) REFERENCES people(employee_id)
);

