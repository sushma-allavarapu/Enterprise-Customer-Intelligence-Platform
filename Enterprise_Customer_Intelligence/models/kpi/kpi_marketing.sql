WITH marketing AS (

    SELECT
        EVENT_ID,
        CUSTOMER_KEY,
        CAMPAIGN_KEY,
        DATE_KEY,
        EVENT_TYPE,
        start_date,
        end_date
    FROM {{ ref('fact_marketing') }}

),

campaign_dim AS (

    SELECT
        CAMPAIGN_KEY,
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
        CHANNEL,
        START_DATE,
        END_DATE,
        BUDGET,
        BUDGET_CATEGORY
    FROM {{ ref('dim_campaign') }}

),

aggregated_marketing AS (

    SELECT

        m.DATE_KEY,
        CAST(m.start_date AS DATE) AS EVENT_DATE,

        m.CAMPAIGN_KEY,

        c.CAMPAIGN_ID,
        c.CAMPAIGN_NAME,
        c.CHANNEL,
        c.BUDGET,
        c.BUDGET_CATEGORY,

        m.EVENT_TYPE,

        COUNT(DISTINCT m.EVENT_ID)
            AS TOTAL_EVENTS,

        COUNT(DISTINCT m.CUSTOMER_KEY)
            AS UNIQUE_CUSTOMERS

    FROM marketing m

    LEFT JOIN campaign_dim c
        ON m.CAMPAIGN_KEY = c.CAMPAIGN_KEY

    GROUP BY

        m.DATE_KEY,
        CAST(m.start_date AS DATE),

        m.CAMPAIGN_KEY,

        c.CAMPAIGN_ID,
        c.CAMPAIGN_NAME,
        c.CHANNEL,
        c.BUDGET,
        c.BUDGET_CATEGORY,

        m.EVENT_TYPE

)

SELECT *

FROM aggregated_marketing