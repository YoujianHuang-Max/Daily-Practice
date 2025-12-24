import pandas as pd
import duckdb
from pathlib import Path

# =========================
# Paths & Table Names
# =========================

BASE_DIR = Path(__file__).resolve().parent.parent
DB_PATH = BASE_DIR / "healthcare.duckdb"

RAW_TABLE = "raw_healthcare_metrics"
CLEAN_TABLE = "clean_healthcare_metrics"

# =========================
# Load Raw Data
# =========================

def load_raw_data(db_path: Path) -> pd.DataFrame:
    con = duckdb.connect(db_path)
    df = con.execute(f"SELECT * FROM {RAW_TABLE}").fetchdf()
    con.close()
    return df

# =========================
# Transform Functions
# =========================

def standardize_column_names(df: pd.DataFrame) -> pd.DataFrame:
    """
    Standardize column names:
    - lowercase
    - replace spaces with underscores
    """
    df.columns = (
        df.columns
        .str.lower()
        .str.strip()
        .str.replace(" ", "_")
    )
    return df


def clean_missing_values(df: pd.DataFrame) -> pd.DataFrame:
    """Replace all missing values with 'Unknown'"""
    return df.fillna("Unknown")

# 
def clean_sleep_hours(df: pd.DataFrame) -> pd.DataFrame:
    """
    Sleep hours:
    - Valid range: 0–24
    - Out of range or invalid → 'Out of range'
    """
    if "sleep hours" not in df.columns:
        return df

    def validate_sleep(x):
        try:
            val = float(x)
        except (ValueError, TypeError):
            return x

        if 0 <= val <= 24:
            return val
        else:
            return "Out of range"

    df["sleep hours"] = df["sleep hours"].apply(validate_sleep)
    return df


def drop_noise_columns(df: pd.DataFrame) -> pd.DataFrame:
    """Remove non-analytical noise columns"""
    cols_to_drop = ["random_notes", "noise_col"]
    return df.drop(columns=[c for c in cols_to_drop if c in df.columns])


def transform(df: pd.DataFrame) -> pd.DataFrame:
    """
    Main transform pipeline (Clean Layer)
    Order matters:
    1. Standardize column names
    2. Handle missing values
    3. Apply field-level rules
    4. Drop noise columns
    """
    df = standardize_column_names(df)
    df = clean_missing_values(df)
    df = clean_sleep_hours(df)
    df = drop_noise_columns(df)
    return df

# =========================
# Load Clean Table
# =========================

def load_clean_table(df: pd.DataFrame, db_path: Path):
    con = duckdb.connect(db_path)
    con.execute(f"""
        CREATE OR REPLACE TABLE {CLEAN_TABLE} AS
        SELECT * FROM df
    """)
    con.close()

# =========================
# Main Execution
# =========================

if __name__ == "__main__":
    raw_df = load_raw_data(DB_PATH)
    clean_df = transform(raw_df)
    load_clean_table(clean_df, DB_PATH)
    print("Clean layer table created successfully.")