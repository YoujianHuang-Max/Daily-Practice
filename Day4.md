# Day 4 – Python Pandas Refresh

```python
import pandas as pd
from sqlalchemy import create_engine

# --------------------------
# Load Data
# engine = create_engine("postgresql+psycopg2://postgres:password@localhost:5432/healthcare")
# patients = pd.read_sql("SELECT * FROM patients", engine)
# encounters = pd.read_sql("SELECT * FROM encounters", engine)
# labs = pd.read_sql("SELECT * FROM lab_results", engine)

# --------------------------
# Handle Missing Values
# --------------------------
# Fill missing example
# df.fillna(value={"column_name": "default_value"})
# Drop rows example
# df.dropna(subset=["column_name"])

# --------------------------
# Date Formatting
# --------------------------
encounters['encounter_date'] = pd.to_datetime(encounters['encounter_date'])
labs['test_date'] = pd.to_datetime(labs['test_date'])

# --------------------------
# Merge Tables
# --------------------------
has_date = encounters[encounters['encounter_date'].notna()].sort_values(['patient_id', 'encounter_date'])
no_date = encounters[encounters['encounter_date'].isna()]

labs_clean = labs.dropna(subset=['test_date']).sort_values(['patient_id', 'test_date'])

# Time-aware merge
merged_has_date = pd.merge_asof(
    has_date,
    labs_clean,
    by='patient_id',
    left_on='encounter_date',
    right_on='test_date',
    direction='forward'
)


# Merge encounters without date with most recent lab
no_date_merged = no_date.merge(labs, on='patient_id', how='left')

# Combine all
full_df = pd.concat([merged_has_date, no_date_merged], ignore_index=True)

# --------------------------
# Clean Lab Flags
# --------------------------
full_df['lab_flag'] = full_df['lab_flag'].str.upper()
full_df['lab_flag'] = full_df['lab_flag'].replace({'H': 'HIGH', 'L': 'LOW', 'N': 'NORMAL'})

# --------------------------
# Inspect
# --------------------------
print(full_df.head())





