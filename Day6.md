### Day 6 ETL Practice Notes

### 1. Objective
- Learn ETL workflow using Python and PostgreSQL.
- Extract data from CSV or generated DataFrames.
- Transform data for consistency and integrity.
- Load into PostgreSQL tables: `dim_patient`, `fact_encounter`, `fact_lab_result`.

### 2. Setup
- Python environment: `healthcare` (conda)
- Libraries: `pandas`, `sqlalchemy`, `psycopg2`
- PostgreSQL: Tables created in pgAdmin, empty, ready for load.
- Tables:
  - `dim_patient(patient_id INT PRIMARY KEY, birth_date DATE, gender VARCHAR(1))`
  - `fact_encounter(encounter_id INT PRIMARY KEY, patient_id INT, visit_date DATE, encounter_type VARCHAR(50))`
  - `fact_lab_result(lab_result_id INT PRIMARY KEY, encounter_id INT, lab_test VARCHAR(50), result_value FLOAT, test_date DATE)`

### 3. ETL Steps
1. **Extract**
   - Load CSV or generate sample data in Python DataFrames.
   - Ensure columns match target tables.
2. **Transform**
   - Check data types (dates, integers, strings).
   - Handle missing values if any.
   - Ensure unique keys (avoid duplicate primary keys).
3. **Load**
   - Use `pandas.to_sql()` with SQLAlchemy engine.
   - Load each table separately.
   - Example:
     ```python
     df.to_sql('dim_patient', engine, if_exists='append', index=False)
     ```
   - Handle errors:
     - `IntegrityError`: duplicate primary key.
     - `ProgrammingError`: column mismatch with database table.

### 4. Troubleshooting
- If column mismatch occurs:
  1. Check table definition in pgAdmin.
  2. Recreate table if necessary.
  3. Make sure DataFrame columns exactly match table columns.
- If foreign key constraint error occurs:
  - Load parent table first (`dim_patient`) before dependent table (`fact_encounter`, `fact_lab_result`).

### 5. Lessons Learned
- Always create or verify empty tables in pgAdmin before loading data.
- DataFrame column names must exactly match table columns.
- Load tables in dependency order: dimension → fact tables.
- Use `if_exists='append'` to add data; `replace` will drop and recreate tables.
- ETL errors often indicate schema mismatch or key constraint violation.
