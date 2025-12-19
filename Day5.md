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

### 3.Role Boundary: OLTP, Data Engineering, and OLAP

Understanding role boundaries helps clarify responsibilities across the data lifecycle and avoids common misconceptions.

---

### OLTP Systems (Operational Layer)

OLTP systems support day-to-day business operations and transactional workloads.

- Owned and maintained by application or backend engineering teams
- Optimized for high-volume INSERT, UPDATE, and DELETE operations
- Examples include hospital registration systems, appointment scheduling systems, and billing systems

Data engineers typically **do not own or design OLTP systems**, but they rely on them as data sources.

---

### Data Engineering (Pipeline & Modeling Layer)

Data engineers operate **between OLTP and OLAP systems**.

Their responsibilities include:
- Extracting data from OLTP systems
- Building ETL or ELT pipelines
- Cleaning, validating, and transforming raw data
- Designing analytical schemas (fact and dimension tables)
- Ensuring data quality, reliability, and low latency

The goal is to convert operational data into **analytics-ready datasets**.

---

### OLAP Systems (Analytics Layer)

OLAP systems are designed for analytics, reporting, and decision support.

- Typically implemented as data warehouses
- Data models are curated and maintained by data engineers
- Optimized for complex SELECT queries and aggregations

Data analysts, BI analysts, and data scientists:
- Query OLAP tables using SQL
- Build metrics, dashboards, and reports
- Perform trend analysis and exploratory analysis

Analysts work on **engineer-prepared data**, avoiding direct access to OLTP systems.

---

### Role Boundary Summary

| Layer | System | Primary Owner | Typical Work |
|----|----|----|----|
| Operational | OLTP | Application Engineers | Transactions, CRUD |
| Pipeline | ETL / ELT | Data Engineers | Ingestion, modeling |
| Analytics | OLAP | Analysts / BI | Queries, insights |

