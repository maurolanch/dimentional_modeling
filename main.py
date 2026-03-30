import glob
import os
import duckdb
from datetime import datetime

DB_PATH = "database/warehouse.duckdb"
DATA_PATH = "data"
MODELS_PATH = "models"
ANALYSIS_PATH = "analysis"


# -----------------------------
# Logging helper
# -----------------------------
def log(message):
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {message}")


# -----------------------------
# Execute SQL file
# -----------------------------
def run_sql_file(conn, filepath):
    try:
        with open(filepath, 'r') as file:
            sql = file.read()
        conn.execute(sql)
        log(f"✅ Executed: {os.path.basename(filepath)}")
    except Exception as e:
        log(f"❌ Error in {filepath}: {e}")
        raise


# -----------------------------
# Load raw data (idempotent)
# -----------------------------
def load_raw_tables(conn):
    log("📥 Loading raw tables...")

    csv_files = glob.glob(f"{DATA_PATH}/*.csv")

    for file in csv_files:
        table_name = os.path.basename(file)\
            .replace('ecommerce_', '')\
            .replace('.csv', '')

        conn.execute(f"""
            CREATE OR REPLACE TABLE raw_{table_name} AS
            SELECT * FROM read_csv_auto('{file}')
        """)

        count = conn.execute(
            f"SELECT COUNT(*) FROM raw_{table_name}"
        ).fetchone()[0]

        log(f"   raw_{table_name}: {count} rows")

    log("✅ Raw layer ready\n")


# -----------------------------
# Run models (dim + fact)
# -----------------------------
def run_models(conn):
    log("🏗️ Building models...")

    model_files = [
        "dim_customers.sql",
        "dim_products.sql",
        "dim_date.sql",
        "fct_order_items.sql"
    ]

    for file in model_files:
        path = os.path.join(MODELS_PATH, file)
        run_sql_file(conn, path)

    log("✅ Models built successfully\n")


# -----------------------------
# Run analysis queries
# -----------------------------
def run_analysis(conn):
    log("📊 Running analysis queries...")

    analysis_files = [
        "q1_sales_by_month.sql",
        "q2_top_products.sql",
        "q3_weekend_analysis.sql"
    ]

    for file in analysis_files:
        path = os.path.join(ANALYSIS_PATH, file)

        try:
            log(f"Running {file}...")
            with open(path, 'r') as f:
                sql = f.read()

            output_file = file.replace('.sql', '.csv')

            conn.execute(f"""
            COPY ({sql}) TO 'outputs/{output_file}' (HEADER, DELIMITER ',')
            """)

            log(f"📁 Saved result to outputs/{output_file}")

        except Exception as e:
            log(f"❌ Error running {file}: {e}")
            raise

    log("✅ Analysis completed\n")


# -----------------------------
# Main pipeline
# -----------------------------
def main():
    log("🚀 Starting ETL pipeline")

    try:
        conn = duckdb.connect(DB_PATH)

        load_raw_tables(conn)
        run_models(conn)
        run_analysis(conn)

        log("🎉 Pipeline finished successfully")

    except Exception as e:
        log(f"🔥 Pipeline failed: {e}")

    finally:
        conn.close()


# -----------------------------
# Entry point
# -----------------------------
if __name__ == "__main__":
    main()