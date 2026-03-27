-- Create dimension for products

CREATE OR REPLACE TABLE dim_products AS
SELECT 
    -- surrogate key
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key,

    -- business key
    p.product_id,

    -- core attributes
    p.product_name,
    p.sku,

    -- enriched attributes from joins
    c.category_name,
    b.brand_name,

    -- descriptive metrics
    p.price,
    p.cost,
    p.weight_kg,

    -- flags
    p.is_active,

    -- dates
    p.created_at,
    p.updated_at

FROM raw_products p

LEFT JOIN raw_categories c
    ON p.category_id = c.category_id

LEFT JOIN raw_brands b
    ON p.brand_id = b.brand_id;