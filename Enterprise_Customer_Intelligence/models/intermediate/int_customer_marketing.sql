WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

campaign_events AS (

    SELECT *
    FROM {{ ref('stg_campaign_events') }}

),

campaigns AS (

    SELECT *
    FROM {{ ref('stg_marketing_campaigns') }}

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

    ce.event_id,
    ce.campaign_id,
    ce.event_type,
    ce.EVENT_TIMESTAMP,

    mc.campaign_name,
    mc.CHANNEL,
    mc.start_date,
    mc.end_date,
    mc.budget

FROM customers c

LEFT JOIN campaign_events ce
    ON c.customer_id = ce.customer_id

LEFT JOIN campaigns mc
    ON ce.campaign_id = mc.campaign_id