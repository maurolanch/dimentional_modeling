-- Create fact table for order items

CREATE OR REPLACE TABLE fct_order_items AS
SELECT 
    -- surrogate key
    ROW_NUMBER() OVER (ORDER BY oi.order_item_id) AS order_item_key,

    -- business key
    oi.order_item_id,

    -- foreign keys (dimensional model)
    dc.customer_key,
    dp.product_key,
    dd.date_key,

    -- degenerate dimension
    oi.order_id,

    -- metrics
    oi.quantity,
    oi.unit_price,
    oi.subtotal AS line_total,

    -- extra context
    o.status,
    o.payment_method

FROM raw_order_items oi

LEFT JOIN raw_orders o
    ON oi.order_id = o.order_id

LEFT JOIN dim_customers dc
    ON o.customer_id = dc.customer_id

LEFT JOIN dim_products dp
    ON oi.product_id = dp.product_id

LEFT JOIN dim_date dd
    ON CAST(o.order_date AS DATE) = dd.full_date;