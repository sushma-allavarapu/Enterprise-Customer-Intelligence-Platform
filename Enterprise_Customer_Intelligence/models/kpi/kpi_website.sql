WITH sessions AS (

    SELECT
        SESSION_ID,
        CUSTOMER_KEY,
        DATE_KEY,
        SESSION_START,
        SESSION_END,
        DEVICE,
        TRAFFIC_SOURCE,
        LANDING_PAGE

    FROM {{ ref('fact_sessions') }}

),

session_metrics AS (

    SELECT

        DATE_KEY,

        CAST(SESSION_START AS DATE)
            AS SESSION_DATE,

        DEVICE,

        TRAFFIC_SOURCE,

        LANDING_PAGE,

        COUNT(DISTINCT SESSION_ID)
            AS TOTAL_SESSIONS,

        COUNT(DISTINCT CUSTOMER_KEY)
            AS IDENTIFIED_CUSTOMERS,

        COUNT_IF(
            CUSTOMER_KEY IS NULL
        ) AS ANONYMOUS_SESSIONS,

        AVG(
            DATEDIFF(
                SECOND,
                SESSION_START,
                SESSION_END
            )
        ) AS AVG_SESSION_DURATION_SECONDS,

        MAX(
            DATEDIFF(
                SECOND,
                SESSION_START,
                SESSION_END
            )
        ) AS MAX_SESSION_DURATION_SECONDS

    FROM sessions

    GROUP BY

        DATE_KEY,

        CAST(SESSION_START AS DATE),

        DEVICE,

        TRAFFIC_SOURCE,

        LANDING_PAGE

)

SELECT

    DATE_KEY,

    SESSION_DATE,

    DEVICE,

    TRAFFIC_SOURCE,

    LANDING_PAGE,

    TOTAL_SESSIONS,

    IDENTIFIED_CUSTOMERS,

    ANONYMOUS_SESSIONS,

    AVG_SESSION_DURATION_SECONDS,

    MAX_SESSION_DURATION_SECONDS

FROM session_metrics