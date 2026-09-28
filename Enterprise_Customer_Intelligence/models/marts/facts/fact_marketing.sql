WITH marketing_data AS (

    SELECT *
    FROM {{ ref('int_customer_marketing') }}

),

customer_dim AS (

    SELECT
        CUSTOMER_KEY,
        CUSTOMER_ID
    FROM {{ ref('dim_customer') }}

),

campaign_dim AS (

    SELECT
        CAMPAIGN_KEY,
        CAMPAIGN_ID
    FROM {{ ref('dim_campaign') }}

),

date_dim AS (

    SELECT
        DATE_KEY,
        DATE_DAY
    FROM {{ ref('dim_date') }}

),

final AS (

    SELECT
        md.EVENT_ID,

        cd.CUSTOMER_KEY,
        camd.CAMPAIGN_KEY,
        dd.DATE_KEY,

        md.EVENT_TYPE,
        md.start_date,
        md.end_date

    FROM marketing_data md

    LEFT JOIN customer_dim cd
        ON md.CUSTOMER_ID = cd.CUSTOMER_ID

    LEFT JOIN campaign_dim camd
        ON md.CAMPAIGN_ID = camd.CAMPAIGN_ID

    LEFT JOIN date_dim dd
        ON CAST(md.start_date AS DATE) = dd.DATE_DAY
    WHERE md.EVENT_ID IS NOT NULL

)

SELECT *
FROM final