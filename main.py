import glob
import os
import duckdb

# Look for the downloaded csv files in the data directory
csv_files = glob.glob('data/*.csv')
print(f"Found {len(csv_files)} CSV files.")

for csv_file in csv_files:
    print(f"   - {os.path.basename(csv_file)}")


# Create a DuckDB connection
conn = duckdb.connect()
# Load each CSV file into DuckDB as a raw table
for file in csv_files:
    # We strip the filename by _ and take the second part as the table name and then remove the .csv extension
    table_name = os.path.basename(file).split('_')[1].split('.')[0]
    print(f"Loading {file} into DuckDB as table '{table_name}'...")
    conn.execute(f"CREATE TABLE raw_{table_name} AS SELECT * FROM read_csv_auto('{file}')")
    count = conn.execute(f"SELECT COUNT(*) FROM raw_{table_name}").fetchone()[0]
    print(f"raw_{table_name}: {count} rows")


# Explore db structure for raw_orders
print("\nExploring the structure of the raw_orders table:")
result = conn.execute("DESCRIBE raw_orders").fetchall()
print(result)

# Explore first 5 rows of raw_orders
print("\nFirst 5 rows of raw_orders:")
result = conn.execute("SELECT * FROM raw_orders LIMIT 5").fetchall()
print(result)