WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

tickets AS (

    SELECT *
    FROM {{ ref('stg_support_tickets') }}

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

    t.ticket_id,
    t.issue_type,
    t.status,
    t.priority,
    t.opened_datetime,
    t.resolved_datetime

FROM customers c

LEFT JOIN tickets t
    ON c.customer_id = t.customer_id