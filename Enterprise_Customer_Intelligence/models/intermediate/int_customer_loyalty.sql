WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

loyalty AS (

    SELECT *
    FROM {{ ref('stg_loyalty_transactions') }}

)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    c.age,
    c.city,
    c.state,
    c.country,
    c.customer_segment,
    c.loyalty_tier,

    l.transaction_id,
    l.transaction_date,
    l.transaction_type,
    l.points

FROM customers c

LEFT JOIN loyalty l
    ON c.customer_id = l.customer_id