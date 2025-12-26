-- ---------------------------------------
-- Analysis of average length of stay by medical condition
-- ---------------------------------------

SELECT
    medical_condition,
    COUNT(*) AS patient_count,
    AVG(lengthofstay) AS avg_length_of_stay
FROM clean_healthcare_metrics
GROUP BY medical_condition
ORDER BY avg_length_of_stay DESC;

-- Insight:


-- ---------------------------------------
-- Sleep Hours vs Length of Stay
-- ---------------------------------------
SELECT
    sleep_hours,
    COUNT(*) AS cnt,
    AVG(lengthofstay) AS avg_length_of_stay
FROM clean_healthcare_metrics
GROUP BY sleep_hours
ORDER BY sleep_hours;
-- Insight:



-- ---------------------------------------
-- Relationship between HbA1c and medical condition
-- ---------------------------------------

SELECT
    medical_condition,
    COUNT(*) AS cnt,
    AVG(hba1c) AS avg_hba1c
FROM clean_healthcare_metrics
GROUP BY medical_condition
ORDER BY avg_hba1c DESC;

-- Insight:
