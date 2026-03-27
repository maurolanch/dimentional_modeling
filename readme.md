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