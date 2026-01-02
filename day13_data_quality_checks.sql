-- =====================================================
-- Day 6: Data Quality Checks for Clean Healthcare Data
-- Table: clean_healthcare_metrics
-- Purpose: Validate data completeness, validity, and consistency
-- =====================================================

-- -------------------------------------
-- 1. Table-level checks
-- -------------------------------------
-- Table existence
SELECT
    table_name
FROM information_schema.tables
WHERE table_name = 'clean_healthcare_metrics';

-- Row count
SELECT
    COUNT(*) AS row_count
FROM clean_healthcare_metrics;


-- -------------------------------------
-- 2. Column-level checks
-- -------------------------------------

-- Age: numeric check and business rule (1-120)
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(age AS DOUBLE) IS NULL THEN 1 ELSE 0 END) AS non_numeric_count,
    SUM(CASE WHEN TRY_CAST(age AS DOUBLE) IS NOT NULL 
             AND (TRY_CAST(age AS DOUBLE) < 1 OR TRY_CAST(age AS DOUBLE) > 120) THEN 1 ELSE 0 END) AS out_of_range_count
FROM clean_healthcare_metrics;

-- Gender distribution
SELECT
    CAST(gender AS VARCHAR) AS gender,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(gender AS VARCHAR);

-- Glucose: numeric + Unknown/Out of range
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(glucose AS DOUBLE) IS NULL 
             AND CAST(glucose AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_count,
    SUM(CASE WHEN CAST(glucose AS VARCHAR) IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS unknown_or_out_of_range
FROM clean_healthcare_metrics;

-- Blood Pressure: numeric + Unknown/Out of range
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(blood_pressure AS DOUBLE) IS NULL 
             AND CAST(blood_pressure AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_count,
    SUM(CASE WHEN CAST(blood_pressure AS VARCHAR) IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS unknown_or_out_of_range
FROM clean_healthcare_metrics;

-- BMI: numeric + Unknown/Out of range
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(bmi AS DOUBLE) IS NULL 
             AND CAST(bmi AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_bmi,
    SUM(CASE WHEN CAST(bmi AS VARCHAR) IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS unknown_or_out_of_range
FROM clean_healthcare_metrics;

-- HbA1c: numeric + Unknown/Out of range
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(hba1c AS DOUBLE) IS NULL 
             AND CAST(hba1c AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_hba1c,
    SUM(CASE WHEN CAST(hba1c AS VARCHAR) IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS unknown_or_out_of_range
FROM clean_healthcare_metrics;

-- Sleep Hours: numeric + Unknown/Out of range
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(sleep_hours AS DOUBLE) IS NULL 
             AND CAST(sleep_hours AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_sleep_hours,
    SUM(CASE WHEN CAST(sleep_hours AS VARCHAR) IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS unknown_or_out_of_range
FROM clean_healthcare_metrics;

-- Smoking / Alcohol / Family History: should be 0,1, or Unknown
SELECT
    CAST(smoking AS VARCHAR) AS smoking,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(smoking AS VARCHAR);

SELECT
    CAST(alcohol AS VARCHAR) AS alcohol,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(alcohol AS VARCHAR);

SELECT
    CAST(family_history AS VARCHAR) AS family_history,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(family_history AS VARCHAR);


-- -------------------------------------
-- 3. Domain / Business rule checks
-- -------------------------------------
-- Age out of expected range (1-120)
SELECT
    COUNT(*) AS invalid_age_count
FROM clean_healthcare_metrics
WHERE TRY_CAST(age AS DOUBLE) IS NULL
   OR TRY_CAST(age AS DOUBLE) < 1
   OR TRY_CAST(age AS DOUBLE) > 120;

-- Sleep Hours distribution
SELECT
    CAST(sleep_hours AS VARCHAR) AS sleep_hours,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(sleep_hours AS VARCHAR)
ORDER BY sleep_hours;

-- Smoking / Alcohol / Family History value check
SELECT
    CAST(smoking AS VARCHAR) AS smoking,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(smoking AS VARCHAR);

SELECT
    CAST(alcohol AS VARCHAR) AS alcohol,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(alcohol AS VARCHAR);

SELECT
    CAST(family_history AS VARCHAR) AS family_history,
    COUNT(*) AS cnt
FROM clean_healthcare_metrics
GROUP BY CAST(family_history AS VARCHAR);

-- Glucose numeric check (excluding Unknown / Out of range)
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(glucose AS DOUBLE) IS NULL 
             AND CAST(glucose AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_glucose
FROM clean_healthcare_metrics;

-- Blood Pressure numeric check
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(blood_pressure AS DOUBLE) IS NULL 
             AND CAST(blood_pressure AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_bp
FROM clean_healthcare_metrics;

-- BMI numeric check
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(bmi AS DOUBLE) IS NULL 
             AND CAST(bmi AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_bmi
FROM clean_healthcare_metrics;

-- HbA1c numeric check
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN TRY_CAST(hba1c AS DOUBLE) IS NULL 
             AND CAST(hba1c AS VARCHAR) NOT IN ('Unknown','Out of range') THEN 1 ELSE 0 END) AS invalid_numeric_hba1c
FROM clean_healthcare_metrics;