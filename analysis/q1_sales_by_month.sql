SELECT 

dd.year,
dd.month,
dd.month_name,
sum(oi.line_total) AS total_sales, 
count(DISTINCT oi.order_id) AS total_orders,
count(DISTINCT oi.product_key) AS unique_products_sold,
count(DISTINCT oi.customer_key) AS unique_customers,
SUM(oi.line_total) / COUNT(DISTINCT oi.order_id) AS avg_order_value,
SUM(oi.line_total) / COUNT(DISTINCT oi.customer_key) AS revenue_per_customer,
sum(oi.quantity) AS total_units_sold

FROM fct_order_items oi
JOIN dim_date dd
    ON oi.date_key = dd.date_key
GROUP BY dd.year, dd.month, dd.month_name
ORDER BY dd.year, dd.month DESC