import duckdb
from pathlib import Path

# -----------------------------
# Paths
# -----------------------------
# define DuckDB database path
DB_PATH = Path(__file__).resolve().parent.parent / "healthcare.duckdb"

# sql file path for analysis
SQL_FILE = Path(__file__).resolve().parent / "day14_clean_layer_analysis.sql"

# -----------------------------
# read SQL script
# -----------------------------
with open(SQL_FILE, "r") as f:
    sql_script = f.read()

# -----------------------------
# connect to DuckDB
# -----------------------------
con = duckdb.connect(DB_PATH)

# -----------------------------
# split SQL script into individual statements
# -----------------------------
sql_statements = [stmt.strip() for stmt in sql_script.split(';') if stmt.strip()]

# -----------------------------
# execute each SQL statement and print results
# -----------------------------
for i, stmt in enumerate(sql_statements, start=1):
    print(f"\n--- Query {i} Results ---")
    try:
        result = con.execute(stmt).fetchdf()
        print(result)
    except Exception as e:
        print(f"Error in query {i}: {e}")

# -----------------------------
# close connection
# -----------------------------
con.close()