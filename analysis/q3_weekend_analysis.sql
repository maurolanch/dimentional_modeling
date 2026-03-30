SELECT 
    CASE 
        WHEN d.is_weekend THEN 'Weekend' 
        ELSE 'Weekday' 
    END as type_day,

    SUM(oi.line_total) as total_sales,

    COUNT(DISTINCT oi.order_id) as order_quantity,

    SUM(oi.quantity) as items_quantity,

    SUM(oi.line_total) / COUNT(DISTINCT oi.order_id) as avg_order_value

FROM fct_order_items oi
JOIN dim_date d 
    ON oi.date_key = d.date_key

GROUP BY d.is_weekend