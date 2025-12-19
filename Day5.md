# Day 5 – Data Modeling (Healthcare Data Warehouse)

## 1. What is Data Modeling?

Data modeling is the process of structuring data to support analytics, reporting, and downstream applications.

In data engineering, data modeling focuses on:
- Data consistency
- Query performance
- Clear business meaning
- Scalability

For analytics use cases, **dimensional modeling** is the most common approach.

---

## 2. OLTP vs OLAP

| Aspect | OLTP | OLAP |
|-----|-----|-----|
| Purpose | Daily operations | Analytics & reporting |
| Data shape | Normalized | Denormalized |
| Query type | INSERT / UPDATE | SELECT / AGGREGATE |
| Example | Hospital system | Healthcare analytics warehouse |

### 2.1 OLTP (Online Transaction Processing)

OLTP systems are designed to support **day-to-day operational workloads**.

#### Key Characteristics
- High volume of small transactions
- Frequent INSERT, UPDATE, DELETE
- Highly normalized schema
- Strong data consistency requirements
- Supports business operations

#### Common OLTP Examples
- Hospital management systems
- Appointment booking systems
- Electronic medical records (EMR)
- Billing and payment systems

#### OLTP Table Design Example

-- CREATE TABLE
CREATE TABLE patient_visit (
  visit_id VARCHAR PRIMARY KEY,
  patient_id VARCHAR,
  visit_date DATE,
  provider_id VARCHAR,
  diagnosis_code VARCHAR
);

-- Insert a new visit
INSERT INTO patient_visit
VALUES ('V1001', 'P001', '2024-10-01', 'D12', 'I10');

-- Update diagnosis
UPDATE patient_visit
SET diagnosis_code = 'E11'
WHERE visit_id = 'V1001';

-- Lookup a single visit
SELECT *
FROM patient_visit
WHERE visit_id = 'V1001';


### 2.2 OLAP (Online Analytical Processing)

OLAP systems are designed for analytics, reporting, and decision support.

-- Key Characteristics
 - Read-heavy workloads
 - Large-scale aggregations
 - Historical data
 - Denormalized or dimensional schemas
 - Optimized for complex SELECT queries

-- Common OLAP Examples
 - Data warehouses
 - Business intelligence dashboards
 - Healthcare analytics platforms
 - Financial reporting systems

-- OLAP Dimensional Model Example

- Create Dimension Table
CREATE TABLE dim_patient (
  patient_id VARCHAR PRIMARY KEY,
  birth_date DATE,
  gender VARCHAR
);

- Create Fact Table
CREATE TABLE fact_encounter (
  encounter_id VARCHAR PRIMARY KEY,
  patient_id VARCHAR REFERENCES dim_patient(patient_id),
  visit_date DATE,
  diagnosis VARCHAR,
  length_of_stay INT
);

- Count visits per patient
SELECT
  p.patient_id,
  COUNT(e.encounter_id) AS visit_count
FROM dim_patient p
LEFT JOIN fact_encounter e
  ON p.patient_id = e.patient_id
GROUP BY p.patient_id;

## 3. Dimensional Modeling Overview

Dimensional modeling consists of:

 **Dimension tables (DIM)**  
  Descriptive, relatively static data  
  Example: patient, provider, date

- **Fact tables (FACT)**  
  Events or measurements  
  Example: encounters, lab results

### Star Schema Structure
  -- dim_patient
          |
          |
   fact_encounter
          |
          |
   fact_lab_result
