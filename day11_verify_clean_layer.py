import duckdb

con = duckdb.connect("healthcare.duckdb")

# Verify that the clean_healthcare_metrics table exists
tables = con.execute("SHOW TABLES").fetchall()
print("Tables in database:")
print(tables)

# Verify row counts in raw and clean tables
raw_count = con.execute(
    "SELECT COUNT(*) FROM raw_healthcare_metrics"
).fetchone()[0]

clean_count = con.execute(
    "SELECT COUNT(*) FROM clean_healthcare_metrics"
).fetchone()[0]

print("Raw row count:", raw_count)
print("Clean row count:", clean_count)

# Verify schema of clean_healthcare_metrics table
columns = con.execute(
    "PRAGMA table_info('clean_healthcare_metrics')"
).fetchdf()

print(columns[["name"]])

#
sleep_distribution = con.execute("""
    SELECT sleep_hours, COUNT(*) AS cnt
    FROM clean_healthcare_metrics
    GROUP BY sleep_hours
    ORDER BY cnt DESC
""").fetchdf()

print(sleep_distribution)

# Close the connection
con.close()