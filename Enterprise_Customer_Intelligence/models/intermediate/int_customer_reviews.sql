WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

reviews AS (

    SELECT *
    FROM {{ ref('stg_reviews') }}

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

    r.review_id,
    r.product_id,
    r.rating,
    r.review_title,
    r.review_text,
    r.review_date

FROM customers c

LEFT JOIN reviews r
    ON c.customer_id = r.customer_id