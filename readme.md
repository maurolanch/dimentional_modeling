📊 Data Pipeline with DuckDB (ETL + Dimensional Modeling)
🧠 Overview

This project implements an end-to-end data pipeline using Python and DuckDB. It ingests raw CSV data, builds a dimensional model (star schema), and generates analytical outputs.

The pipeline follows a structured ETL/ELT approach:

Raw Data → Staging → Dimensions → Fact Table → Analytics
⚙️ Tech Stack
Python (orchestration)
DuckDB (analytical database)
SQL (data modeling & analysis)
Pandas (optional) (data processing)
File-based storage (CSV)
📁 Project Structure
```bash
project/
│
├── data/                # Raw CSV files
├── database/            # DuckDB database file
├── models/              # SQL models (dimensions & fact)
│   ├── dim_customers.sql
│   ├── dim_products.sql
│   ├── dim_date.sql
│   └── fct_order_items.sql
│
├── analysis/            # Analytical queries
│   ├── q1_sales_by_month.sql
│   ├── q2_top_products.sql
│   └── q3_weekend_analysis.sql
│
├── outputs/             # Generated CSV outputs
├── main.py              # Pipeline entrypoint
└── README.md
```
⭐ STAR SCHEMA — ECOMMERCE

```bash
                         ┌────────────────────┐
                         │   dim_customers    │
                         │────────────────────│
                         │ customer_key (PK)  │
                         │ customer_id        │
                         │ name               │
                         │ email              │
                         │ city               │
                         │ country            │
                         └─────────┬──────────┘
                                   │
                                   │
                                   │
        ┌────────────────────┐     │     ┌────────────────────┐
        │    dim_products    │     │     │      dim_date      │
        │────────────────────│     │     │────────────────────│
        │ product_key (PK)   │     │     │ date_key (PK)      │
        │ product_id         │     │     │ full_date          │
        │ name               │     │     │ year               │
        │ category           │     │     │ quarter            │
        │ price              │     │     │ month              │
        └─────────┬──────────┘     │     │ day                │
                  │                │     │ day_of_week        │
                  │                │     │ is_weekend         │
                  │                │     └─────────┬──────────┘
                  │                │               │
                  │                │               │
                  ▼                ▼               ▼
               ┌──────────────────────────────────────────┐
               │           fact_order_items               │
               │──────────────────────────────────────────│
               │ order_item_key (PK, surrogate)           │
               │ customer_key (FK)                        │
               │ product_key (FK)                         │
               │ date_key (FK)                            │
               │ order_id (degenerate dimension)          │
               │                                          │
               │ quantity                                 │
               │ unit_price                               │
               │ line_total                               │
               │ discount_amount                          │
               └──────────────────────────────────────────┘

```
🚀 How It Works
1. Load Raw Data
Automatically detects CSV files in /data
Loads them into DuckDB as raw_* tables
Uses idempotent logic (CREATE OR REPLACE)
2. Build Data Models
Creates:
dim_customers
dim_products
dim_date
fct_order_items
Implements a star schema:
Fact table with surrogate keys
Dimension tables for analytics
3. Run Analysis

Executes SQL queries and exports results to CSV:

📊 Sales by month
🏆 Top products
📅 Weekend vs weekday analysis
▶️ Run the Pipeline
python main.py
📦 Outputs

Results are saved in:

outputs/

Example:

q1_sales_by_month.csv
q2_top_products.csv
q3_weekend_analysis.csv
🧠 Key Features
✅ Idempotent pipeline (safe to rerun)
✅ Modular SQL-based transformations
✅ Separation of concerns (models vs analysis)
✅ Lightweight & fast (DuckDB)
✅ Production-like structure
🎯 What This Project Demonstrates
Data modeling (star schema)
ETL/ELT pipeline design
SQL analytics
Python orchestration
File-based data ingestion
Analytical thinking
🔥 Future Improvements
Add Airflow orchestration
Convert to dbt project
Add data quality checks
Implement incremental loads
Add logging & monitoring (Datadog style)
👤 Author

Mauricio Lancheros
Data Engineer

GitHub: https://github.com/maurolanch
LinkedIn: https://www.linkedin.com/in/mauriciolancheros/