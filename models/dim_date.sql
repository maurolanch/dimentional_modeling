-- Crate a dimension for date
-- One row for each date in the complete data range

CREATE OR REPLACE TABLE dim_date AS

WITH date_range AS (
    SELECT 
        CAST(MIN(order_date) AS DATE) AS min_date,
        CAST(MAX(order_date) AS DATE) AS max_date
    FROM raw_orders
),

dates AS (
    SELECT 
        CAST(gs AS DATE) AS full_date
    FROM generate_series(
        (SELECT min_date FROM date_range),
        (SELECT max_date FROM date_range),
        INTERVAL '1 day'
    ) AS t(gs)
)

SELECT 
    -- surrogate key
    ROW_NUMBER() OVER (ORDER BY full_date) AS date_key,

    -- base date
    full_date,

    -- date breakdown
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(MONTH FROM full_date) AS month,
    EXTRACT(DAY FROM full_date) AS day,
    EXTRACT(WEEK FROM full_date) AS week,

    -- names
    DAYNAME(full_date) AS day_name,
    MONTHNAME(full_date) AS month_name,

    -- numeric day of week (0=Sunday en DuckDB)
    EXTRACT(DOW FROM full_date) AS day_of_week,

    -- weekend flag
    CASE 
        WHEN EXTRACT(DOW FROM full_date) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM dates;

SELECT COUNT(*) FROM dim_date;

SELECT MIN(full_date), MAX(full_date) FROM dim_date;

SELECT * FROM dim_date LIMIT 5;