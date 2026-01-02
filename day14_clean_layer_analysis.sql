-- =====================================================
-- Day 14: Full Clean Layer Analysis (Safe for Non-Numeric)
-- =====================================================

-- 1️⃣ Behavioral & Lifestyle vs Hospitalization
SELECT
    sleep_hours_group,
    COUNT(*) AS patient_count,
    AVG(lengthofstay_num) AS avg_length_of_stay
FROM (
    SELECT
        CAST(lengthofstay AS DOUBLE) AS lengthofstay_num,
        CASE
            WHEN CAST(sleep_hours AS DOUBLE) < 1 THEN '<1'
            WHEN CAST(sleep_hours AS DOUBLE) >= 1 AND CAST(sleep_hours AS DOUBLE) < 2 THEN '1-2'
            WHEN CAST(sleep_hours AS DOUBLE) >= 2 AND CAST(sleep_hours AS DOUBLE) < 3 THEN '2-3'
            WHEN CAST(sleep_hours AS DOUBLE) >= 3 AND CAST(sleep_hours AS DOUBLE) < 4 THEN '3-4'
            WHEN CAST(sleep_hours AS DOUBLE) >= 4 AND CAST(sleep_hours AS DOUBLE) < 5 THEN '4-5'
            WHEN CAST(sleep_hours AS DOUBLE) >= 5 AND CAST(sleep_hours AS DOUBLE) < 6 THEN '5-6'
            WHEN CAST(sleep_hours AS DOUBLE) >= 6 AND CAST(sleep_hours AS DOUBLE) < 7 THEN '6-7'
            WHEN CAST(sleep_hours AS DOUBLE) >= 7 AND CAST(sleep_hours AS DOUBLE) < 8 THEN '7-8'
            ELSE '8+'
        END AS sleep_hours_group
    FROM clean_healthcare_metrics
    WHERE CAST(sleep_hours AS VARCHAR) NOT IN ('Unknown', 'Out of range')
      AND CAST(lengthofstay AS VARCHAR) NOT IN ('Unknown', 'Out of range')
) t
GROUP BY sleep_hours_group
ORDER BY
    CASE
        WHEN sleep_hours_group = '<1' THEN 1
        WHEN sleep_hours_group = '1-2' THEN 2
        WHEN sleep_hours_group = '2-3' THEN 3
        WHEN sleep_hours_group = '3-4' THEN 4
        WHEN sleep_hours_group = '4-5' THEN 5
        WHEN sleep_hours_group = '5-6' THEN 6
        WHEN sleep_hours_group = '6-7' THEN 7
        WHEN sleep_hours_group = '7-8' THEN 8
        ELSE 9
    END;


-- Physical Activity vs LengthOfStay
SELECT
    CAST(physical_activity AS DOUBLE) AS physical_activity,
    COUNT(*) AS patient_count,
    AVG(CAST(lengthofstay AS DOUBLE)) AS avg_length_of_stay
FROM clean_healthcare_metrics
WHERE CAST(physical_activity AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(lengthofstay AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY CAST(physical_activity AS DOUBLE)
ORDER BY CAST(physical_activity AS DOUBLE);

-- Diet Score vs LengthOfStay
SELECT
    CAST(diet_score AS DOUBLE) AS diet_score,
    COUNT(*) AS patient_count,
    AVG(CAST(lengthofstay AS DOUBLE)) AS avg_length_of_stay
FROM clean_healthcare_metrics
WHERE CAST(diet_score AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(lengthofstay AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY CAST(diet_score AS DOUBLE)
ORDER BY CAST(diet_score AS DOUBLE);


-- 2️⃣ Clinical Metrics vs Medical Condition
-- Glucose
SELECT
    medical_condition,
    COUNT(*) AS patient_count,
    AVG(CAST(glucose AS DOUBLE)) AS avg_glucose
FROM clean_healthcare_metrics
WHERE CAST(glucose AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY medical_condition
ORDER BY avg_glucose DESC;

-- HbA1c
SELECT
    medical_condition,
    COUNT(*) AS patient_count,
    AVG(CAST(hba1c AS DOUBLE)) AS avg_hba1c
FROM clean_healthcare_metrics
WHERE CAST(hba1c AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY medical_condition
ORDER BY avg_hba1c DESC;

-- Cholesterol
SELECT
    medical_condition,
    COUNT(*) AS patient_count,
    AVG(CAST(cholesterol AS DOUBLE)) AS avg_cholesterol
FROM clean_healthcare_metrics
WHERE CAST(cholesterol AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY medical_condition
ORDER BY avg_cholesterol DESC;


-- 3️⃣ Grouped Statistics
-- By Gender
SELECT
    gender,
    COUNT(*) AS patient_count,
    AVG(CAST(lengthofstay AS DOUBLE)) AS avg_length_of_stay,
    AVG(CAST(glucose AS DOUBLE)) AS avg_glucose,
    AVG(CAST(hba1c AS DOUBLE)) AS avg_hba1c
FROM clean_healthcare_metrics
WHERE CAST(gender AS VARCHAR) != 'Unknown'
  AND CAST(lengthofstay AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(glucose AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(hba1c AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY gender
ORDER BY gender;

-- By Age Group
SELECT
    CASE
        WHEN CAST(age AS DOUBLE) < 20 THEN '0-19'
        WHEN CAST(age AS DOUBLE) < 40 THEN '20-39'
        WHEN CAST(age AS DOUBLE) < 60 THEN '40-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    AVG(CAST(lengthofstay AS DOUBLE)) AS avg_length_of_stay,
    AVG(CAST(glucose AS DOUBLE)) AS avg_glucose,
    AVG(CAST(hba1c AS DOUBLE)) AS avg_hba1c
FROM clean_healthcare_metrics
WHERE CAST(age AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(lengthofstay AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(glucose AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(hba1c AS VARCHAR) NOT IN ('Unknown', 'Out of range')
GROUP BY age_group
ORDER BY age_group;


-- 4️⃣ Outlier & Exceptional Value Checks
-- LengthOfStay > 30
SELECT COUNT(*) AS outlier_lengthofstay_count
FROM clean_healthcare_metrics
WHERE CAST(lengthofstay AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(lengthofstay AS DOUBLE) > 30;

-- Glucose high (>200)
SELECT COUNT(*) AS high_glucose_count
FROM clean_healthcare_metrics
WHERE CAST(glucose AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(glucose AS DOUBLE) > 200;

-- HbA1c high (>10)
SELECT COUNT(*) AS high_hba1c_count
FROM clean_healthcare_metrics
WHERE CAST(hba1c AS VARCHAR) NOT IN ('Unknown', 'Out of range')
  AND CAST(hba1c AS DOUBLE) > 10;

-- BMI out of range
SELECT COUNT(*) AS outlier_bmi_count
FROM clean_healthcare_metrics
WHERE CAST(bmi AS VARCHAR) = 'Out of range';