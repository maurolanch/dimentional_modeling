SELECT 
dp.product_name,
dp.category_name,
sum(oi.quantity) AS total_units_sold,
sum(oi.line_total) AS total_revenue,
sum(oi.line_total) / sum(oi.quantity) AS avg_price_per_unit


from fct_order_items oi
JOIN dim_products dp
    ON oi.product_key = dp.product_key
GROUP BY product_name, category_name
ORDER BY total_revenue DESC
LIMIT 10