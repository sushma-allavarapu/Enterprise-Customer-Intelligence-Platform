WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

sessions AS (

    SELECT *
    FROM {{ ref('stg_website_sessions') }}

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

    s.session_id,
    s.session_start,
    s.session_end,
    s.device,
    s.traffic_source,
    s.landing_page,
    s.SESSION_DURATION_SECONDS

FROM customers c

LEFT JOIN sessions s
    ON c.customer_id = s.customer_id