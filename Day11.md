# Data Quality Checks – Clean Layer

This document defines the data quality validation rules applied after the
Transform step of the Healthcare ETL Pipeline.

The goal is to ensure that cleaned data is reliable, consistent, and ready
for analytical queries.

---

## 1. Table Existence Checks

The DuckDB database must contain the following tables:

- `raw_healthcare_metrics`
- `clean_healthcare_metrics`

These tables confirm that both Extract and Transform steps completed successfully.

---

## 2. Row Count Consistency

- The number of rows in `clean_healthcare_metrics` should match
  `raw_healthcare_metrics`.

**Purpose:**  
Ensure that no records are unintentionally dropped during transformation.

---

## 3. Column Structure Validation

### 3.1 Column Naming Standard
All column names must:
- Be lowercase
- Use snake_case
- Contain no spaces

**Example:**
- `Diet Score` → `diet_score`
- `Sleep Hours` → `sleep_hours`

---

### 3.2 Noise Column Removal
The following columns must NOT exist in the clean layer:
- `random_notes`
- `noise_col`

These fields are considered non-analytical noise.

---

## 4. Missing Value Handling

- All missing values are standardized as `"Unknown"`.
- This ensures consistent handling during analysis and aggregation.

---

## 5. Field-Level Validation Rules

### 5.1 Sleep Hours
- Valid numeric range: `0–24`
- Numeric values outside the range are labeled as `"Out of range"`
- Non-numeric values (e.g. `"Unknown"`) remain unchanged

**Expected values include:**
- Numeric values (e.g. `6`, `7.5`)
- `"Unknown"`
- `"Out of range"`

---

## 6. Manual Verification Queries (Examples)

```sql
-- Check row counts
SELECT COUNT(*) FROM raw_healthcare_metrics;
SELECT COUNT(*) FROM clean_healthcare_metrics;

-- Check sleep_hours distribution
SELECT sleep_hours, COUNT(*)
FROM clean_healthcare_metrics
GROUP BY sleep_hours
ORDER BY COUNT(*) DESC;

-- Check column names
PRAGMA table_info('clean_healthcare_metrics');
