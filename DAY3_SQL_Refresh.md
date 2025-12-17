# Day 3 – SQL Refresh

## 1. JOIN Types
- LEFT JOIN keeps all records from the left table
- Useful for identifying missing events (e.g. patients with zero visits)

## 2. COUNT(*) vs COUNT(column)
- COUNT(*) counts rows regardless of NULL
- COUNT(column) counts only non-NULL values
- Important when using LEFT JOIN

## 3. Window Functions
### ROW_NUMBER()
- Assigns sequential numbers within a partition
- Common use: identify first or latest record per entity

Example:
```sql
ROW_NUMBER() OVER (
    PARTITION BY patient_id
    ORDER BY encounter_date DESC
)
