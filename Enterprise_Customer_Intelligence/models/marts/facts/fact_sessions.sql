WITH session_data AS (

    SELECT *
    FROM {{ ref('int_customer_sessions') }}

),

customer_dim AS (

    SELECT
        CUSTOMER_KEY,
        CUSTOMER_ID
    FROM {{ ref('dim_customer') }}

),

date_dim AS (

    SELECT
        DATE_KEY,
        DATE_DAY
    FROM {{ ref('dim_date') }}

),

final AS (

    SELECT
        sd.SESSION_ID,

        cd.CUSTOMER_KEY,
        dd.DATE_KEY,

        sd.SESSION_START,
        sd.SESSION_END,

        sd.DEVICE,
        sd.TRAFFIC_SOURCE,
        sd.LANDING_PAGE,
        sd.SESSION_DURATION_SECONDS


    FROM session_data sd

    LEFT JOIN customer_dim cd
        ON sd.CUSTOMER_ID = cd.CUSTOMER_ID

    LEFT JOIN date_dim dd
        ON CAST(sd.SESSION_START AS DATE) = dd.DATE_DAY
    WHERE sd.SESSION_ID IS NOT NULL

)

SELECT *
FROM final