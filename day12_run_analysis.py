import duckdb
from pathlib import Path

DB_PATH = Path(__file__).resolve().parent.parent / "healthcare.duckdb"
SQL_FILE = Path(__file__).resolve().parent / "day5_healthcare_analysis.sql"

# read SQL script
with open(SQL_FILE, "r") as f:
    sql_script = f.read()

# split queries by semicolon
queries = [q.strip() for q in sql_script.split(";") if q.strip()]

# connect to DuckDB
con = duckdb.connect(DB_PATH)

for i, query in enumerate(queries, 1):
    try:
        result = con.execute(query).fetchdf()
        print(f"\nQuery {i} Results:")
        print(result)
    except Exception as e:
        print(f"\nQuery {i} failed:", e)

con.close()