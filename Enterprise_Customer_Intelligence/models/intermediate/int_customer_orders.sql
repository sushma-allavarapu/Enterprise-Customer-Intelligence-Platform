WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

order_items AS (

    SELECT *
    FROM {{ ref('stg_order_items') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age,
    c.email,
    c.city,
    c.state,
    c.country,
    c.customer_segment,
    c.loyalty_tier,

    o.order_id,
    o.order_date,
    o.order_status,
    o.sales_channel,
    o.total_amount,

    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    oi.line_amount,

    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    p.cost_price,
    p.selling_price

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id

LEFT JOIN order_items oi
    ON o.order_id = oi.order_id

LEFT JOIN products p
    ON oi.product_id = p.product_id

    