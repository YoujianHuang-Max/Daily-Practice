import pandas as pd
import duckdb
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

RAW_DATA_PATH = BASE_DIR / "data" / "raw" / "healthcare_raw.csv"
DB_PATH = BASE_DIR / "healthcare.duckdb"

# Function to extract CSV data into a pandas DataFrame
def extract_csv(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path)
    return df

# Function to load DataFrame into DuckDB
def load_raw_table(df: pd.DataFrame, db_path: Path):
    con = duckdb.connect(db_path)
    con.execute("""
        CREATE TABLE IF NOT EXISTS raw_healthcare_metrics AS
        SELECT * FROM df
    """)
    con.close()

# Main execution
if __name__ == "__main__":
    df_raw = extract_csv(RAW_DATA_PATH)
    load_raw_table(df_raw, DB_PATH)
    print("Raw data loaded successfully.")