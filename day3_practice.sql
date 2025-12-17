CREATE TABLE patients(
		patient_id INT PRIMARY KEY,
		gender VARCHAR(10),
		birth_date DATE
);


CREATE TABLE encounters(
		encounter_id INT PRIMARY KEY,
		patient_id INT,
		encounter_date DATE,
		encounter_type VARCHAR(50)
);


CREATE TABLE lab_results(
		lab_id INT PRIMARY KEY,
		patient_id INT,
		test_name VARCHAR(50),
		test_value NUMERIC,
		test_date DATE
);




-- ########################################


INSERT INTO patients VALUES
(1, 'M', '1980-01-01'),
(2, 'F', '1990-05-12'),
(3, 'M', '1975-09-30');


INSERT INTO encounters VALUES
(101, 1, '2024-01-10', 'Checkup'),
(102, 1, '2024-02-15', 'Emergency'),
(103, 2, '2024-03-20', 'Checkup');


INSERT INTO lab_results VALUES
(201, 1, 'Glucose', 6.2, '2024-01-11'),
(202, 1, 'Cholesterol', 5.4, '2024-02-16'),
(203, 3, 'Glucose', 7.1, '2024-04-01');


-- ############## Practice ######################

-- ============================================
-- 1️⃣ COUNT(*) vs COUNT(column)
-- Purpose: Demonstrate difference between counting all rows vs non-NULL column values
-- ============================================
SELECT
    p.patient_id,                       -- Patient ID
    COUNT(*) AS cnt_all,                 -- Count all rows (including patients without encounters)
    COUNT(e.encounter_id) AS cnt_encounters  -- Count non-NULL encounter IDs
FROM patients p
LEFT JOIN encounters e
    ON p.patient_id = e.patient_id      -- LEFT JOIN preserves all patients
GROUP BY p.patient_id;

-- ============================================
-- 2️⃣ Assign visit order per patient using ROW_NUMBER()
-- Purpose: Number each encounter per patient sequentially
-- ============================================
SELECT
    patient_id,
    encounter_date,
    ROW_NUMBER() OVER (
        PARTITION BY patient_id         -- Partition by patient
        ORDER BY encounter_date         -- Order by encounter date ascending
    ) AS visit_order
FROM encounters;


-- ============================================
-- 3️⃣ Latest lab result per patient (window function)
-- Purpose: Get the most recent lab test for each patient
-- ============================================
SELECT
    patient_id,
    test_name,
    test_value,
    test_date
FROM (
    SELECT
        patient_id,
        test_name,
        test_value,
        test_date,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id       -- Partition by patient
            ORDER BY test_date DESC       -- Order by test date descending (latest first)
        ) AS rn
    FROM lab_results
) t
WHERE rn = 1;                         -- Keep only the latest record per patient


-- ============================================
-- 4️⃣ Example: Visit count per patient
-- Purpose: Combine JOIN and aggregation
-- ============================================
SELECT
    p.patient_id,
    COUNT(e.encounter_id) AS visit_count   -- Number of encounters per patient
FROM patients p
LEFT JOIN encounters e
    ON p.patient_id = e.patient_id
GROUP BY p.patient_id;