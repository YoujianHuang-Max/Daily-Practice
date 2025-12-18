# Day 4 – Python Pandas Refresh

```python
import pandas as pd
from sqlalchemy import create_engine

# --------------------------
# Load Data
# --------------------------
patients = pd.read_csv("data/patients.csv")
encounters = pd.read_csv("data/encounters.csv")
labs = pd.read_csv("data/lab_results.csv")

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
merged_has_date['lab_link_type'] = 'time_based'

# Merge encounters without date with most recent lab
latest_labs = labs_clean.groupby('patient_id').tail(1)
no_date_merged = no_date.merge(latest_labs, on='patient_id', how='left')
no_date_merged['lab_link_type'] = 'patient_level_fallback'

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





