WITH campaigns AS (

    SELECT *
    FROM {{ ref('stg_marketing_campaigns') }}

),

final AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY CAMPAIGN_ID
        ) AS CAMPAIGN_KEY,

        CAMPAIGN_ID,
        CAMPAIGN_NAME,

        CHANNEL,

        START_DATE,
        END_DATE,

        DATEDIFF(
            DAY,
            START_DATE,
            END_DATE
        ) + 1 AS CAMPAIGN_DURATION_DAYS,

        BUDGET,

        CASE
            WHEN BUDGET < 10000 THEN 'LOW'
            WHEN BUDGET < 50000 THEN 'MEDIUM'
            ELSE 'HIGH'
        END AS BUDGET_CATEGORY

    FROM campaigns

)

SELECT *
FROM final