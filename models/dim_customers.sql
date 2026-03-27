-- Create dimension for customers

CREATE OR REPLACE TABLE dim_customers AS
SELECT 
    -- surrogate key
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,

    -- business key
    customer_id,

    -- attributes
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name,

    email,
    city,
    country,
    segment,
    is_verified,

    -- dates
    registration_date,
    last_login

FROM raw_customers;

SELECT * FROM dim_customers LIMIT 5;

SELECT COUNT(*) FROM dim_customers;
