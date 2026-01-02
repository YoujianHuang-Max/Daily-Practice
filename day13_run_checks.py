import duckdb
from pathlib import Path

# define database path and SQL file path
DB_PATH = Path(__file__).resolve().parent.parent / "healthcare.duckdb"
SQL_FILE = Path(__file__).resolve().parent / "day13_data_quality_checks.sql"

# read SQL script
with open(SQL_FILE, "r") as f:
    sql_script = f.read()

# connect to DuckDB
con = duckdb.connect(DB_PATH)

# DuckDB executes multiple statements separated by semicolons.
sql_statements = [stmt.strip() for stmt in sql_script.split(';') if stmt.strip()]

for i, stmt in enumerate(sql_statements, start=1):
    print(f"\n--- Query {i} ---")
    try:
        result = con.execute(stmt).fetchdf()
        print(result)
    except Exception as e:
        print(f"Error in query {i}: {e}")

con.close()