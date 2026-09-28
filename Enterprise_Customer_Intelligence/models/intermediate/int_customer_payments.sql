WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

payments AS (

    SELECT *
    FROM {{ ref('stg_payments') }}

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

    p.payment_id,
    p.order_id,
    p.payment_date,
    p.payment_amount,
    p.payment_method,
    p.payment_status

FROM customers c

LEFT JOIN payments p
    ON c.customer_id = p.customer_id