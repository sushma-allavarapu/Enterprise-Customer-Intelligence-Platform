WITH support_data AS (

    SELECT *
    FROM {{ ref('int_customer_support') }}

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
        sd.TICKET_ID,

        cd.CUSTOMER_KEY,
        dd.DATE_KEY,

        sd.ISSUE_TYPE,
        sd.STATUS,
        sd.PRIORITY,

        sd.OPENED_DATETIME,
        sd.RESOLVED_DATETIME

    FROM support_data sd

    LEFT JOIN customer_dim cd
        ON sd.CUSTOMER_ID = cd.CUSTOMER_ID

    LEFT JOIN date_dim dd
        ON CAST(sd.OPENED_DATETIME AS DATE) = dd.DATE_DAY
    WHERE sd.TICKET_ID IS NOT NULL

)

SELECT *
FROM final