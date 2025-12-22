# Day 7 - Data Understanding & ETL Design

## 1. Data Description
This dataset contains raw healthcare metrics collected from patients, including demographics, clinical measurements, hospitalization data, lipid panel, metabolic indicators, behavioral and lifestyle factors, and genetic history.

Each row represents a single patient health record collected during a medical visit or health check.

---

## 2. Data Layer Design

### Raw Layer
- **Table name:** raw_healthcare_metrics  
- **Description:** Raw data ingested directly from CSV files without modification.

### Clean Layer
- **Table name:** clean_healthcare_metrics  
- **Description:** Cleaned and validated data ready for analytical queries.

---

## 3. Column Categories
- **Demographics:** Age, Gender  
- **Medical Condition:** Medical Condition  
- **Clinical Metrics:** Glucose, Blood Pressure, BMI, Oxygen Saturation  
- **Hospitalization:** LengthOfStay  
- **Lipid Panel:** Cholesterol, Triglycerides  
- **Metabolic Indicators:** HbA1c  
- **Behavioral Factors:** Smoking, Alcohol, Physical Activity  
- **Lifestyle Indicators:** Diet Score, Stress Level, Sleep Hours  
- **Genetic Factors:** Family History  
- **Noise Columns:** random_notes, noise_col  

---

## 4. Data Quality Rules

### Demographics
- **Age:** Keep all actual values. Missing values → `"Unknown"`  
- **Gender:** Missing values → `"Unknown"`; unify capitalization.

### Clinical Metrics
- Glucose, Blood Pressure, BMI, Oxygen Saturation, HbA1c:  
  - Keep all actual values  
  - Missing values → `"Unknown"`  
  - No upper or lower limit enforced

### Behavioral & Lifestyle Indicators
- Smoking, Alcohol, Family History:  
  - Legal values: 0 or 1  
  - Other values or missing → `"Unknown"`  
- Physical Activity, Diet Score:  
  - Keep all actual values  
  - Missing values → `"Unknown"`  
- Stress Level:  
  - Keep all actual values, no upper limit  
  - Missing values → `"Unknown"`  
- Sleep Hours:  
  - Values outside 0–24 → `"Out of range"`  
  - Missing values → `"Unknown"`  

---

## 5. Column Removal Rules
- Remove non-business / noisy columns during transformation:  
  - `random_notes`  
  - `noise_col`  

---

## 6. ETL Flow

```text
CSV Files
     │
     ▼
Extract: Read raw data
     │
     ▼
Transform:
- Type conversion
- Fill all missing values with "Unknown"
- Mark Sleep Hours outside 0–24 as "Out of range"
- Standardize categories (Gender, Smoking, Alcohol, Family History)
- Remove noise columns
     │
     ▼
Load: Store clean data in DuckDB
