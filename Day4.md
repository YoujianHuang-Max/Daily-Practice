# Day 4 – Python Pandas Refresh

## 1. Load Data

```python
import pandas as pd
from sqlalchemy import create_engine

# Option 1: Load CSV files
patients = pd.read_csv("data/patients.csv")
encounters = pd.read_csv("data/encounters.csv")
labs = pd.read_csv("data/lab_results.csv")

# Option 2: Load from PostgreSQL
# engine = create_engine("postgresql+psycopg2://postgres:password@localhost:5432/healthcare")
# patients = pd.read_sql("SELECT * FROM patients", engine)
# encounters = pd.read_sql("SELECT * FROM encounters", engine)
# labs = pd.read_sql("SELECT * FROM lab_results", engine)

# Handle Missing Values
# Fill missing values
df.fillna(value={"column_name": "default_value"})

# Drop rows with missing values
df.dropna(subset=["column_name"])



