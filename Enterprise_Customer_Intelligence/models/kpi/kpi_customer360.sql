WITH customer_dim AS (

    SELECT
        CUSTOMER_KEY,
        CUSTOMER_ID,
        CUSTOMER_NAME,
        GENDER,
        AGE,
        AGE_GROUP,
        CITY,
        STATE,
        COUNTRY,
        CUSTOMER_SEGMENT,
        LOYALTY_TIER,
        REGISTRATION_DATE,
        CUSTOMER_TENURE_MONTHS
    FROM {{ ref('dim_customer') }}

),

/* =========================================================
   ORDER METRICS
   ========================================================= */

order_metrics AS (

    SELECT
        CUSTOMER_KEY,

        COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS,

        COUNT(DISTINCT ORDER_ITEM_ID) AS TOTAL_ORDER_ITEMS,

        SUM(LINE_AMOUNT) AS TOTAL_REVENUE,

        AVG(LINE_AMOUNT) AS AVG_ORDER_ITEM_VALUE,

        MIN(ORDER_DATE) AS FIRST_ORDER_DATE,

        MAX(ORDER_DATE) AS LAST_ORDER_DATE

    FROM {{ ref('fact_orders') }}

    GROUP BY CUSTOMER_KEY

),

/* =========================================================
   SESSION METRICS
   ========================================================= */

session_metrics AS (

    SELECT
        CUSTOMER_KEY,

        COUNT(DISTINCT SESSION_ID) AS TOTAL_SESSIONS,

        AVG(
            DATEDIFF(
                SECOND,
                SESSION_START,
                SESSION_END
            )
        ) AS AVG_SESSION_DURATION_SECONDS,

        MAX(SESSION_START) AS LAST_SESSION_DATE

    FROM {{ ref('fact_sessions') }}

    GROUP BY CUSTOMER_KEY

),

/* =========================================================
   MARKETING METRICS
   ========================================================= */

marketing_metrics AS (

    SELECT
        CUSTOMER_KEY,

        COUNT(DISTINCT EVENT_ID) AS TOTAL_MARKETING_EVENTS,

        COUNT(DISTINCT CAMPAIGN_KEY) AS UNIQUE_CAMPAIGNS

    FROM {{ ref('fact_marketing') }}

    WHERE CUSTOMER_KEY IS NOT NULL

    GROUP BY CUSTOMER_KEY

),

/* =========================================================
   SUPPORT METRICS
   ========================================================= */

support_metrics AS (

    SELECT
        CUSTOMER_KEY,

        COUNT(DISTINCT TICKET_ID) AS TOTAL_SUPPORT_TICKETS,

        AVG(
            DATEDIFF(
                SECOND,
                OPENED_DATETIME,
                RESOLVED_DATETIME
            )
        ) / 3600.0 AS AVG_RESOLUTION_TIME_HOURS,

        MAX(OPENED_DATETIME) AS LAST_SUPPORT_DATE

    FROM {{ ref('fact_support') }}

    GROUP BY CUSTOMER_KEY

)

/* =========================================================
   CUSTOMER 360 FINAL TABLE
   ========================================================= */

SELECT

    /* ==========================================
       CUSTOMER INFORMATION
       ========================================== */

    c.CUSTOMER_KEY,

    c.CUSTOMER_ID,

    c.CUSTOMER_NAME,

    c.GENDER,

    c.AGE,

    c.AGE_GROUP,

    c.CITY,

    c.STATE,

    c.COUNTRY,

    c.CUSTOMER_SEGMENT,

    c.LOYALTY_TIER,

    c.REGISTRATION_DATE,

    c.CUSTOMER_TENURE_MONTHS,


    /* ==========================================
       ORDER KPIs
       ========================================== */

    COALESCE(
        o.TOTAL_ORDERS,
        0
    ) AS TOTAL_ORDERS,

    COALESCE(
        o.TOTAL_ORDER_ITEMS,
        0
    ) AS TOTAL_ORDER_ITEMS,

    COALESCE(
        o.TOTAL_REVENUE,
        0
    ) AS TOTAL_REVENUE,

    COALESCE(
        o.AVG_ORDER_ITEM_VALUE,
        0
    ) AS AVG_ORDER_ITEM_VALUE,

    o.FIRST_ORDER_DATE,

    o.LAST_ORDER_DATE,


    /* ==========================================
       SESSION KPIs
       ========================================== */

    COALESCE(
        s.TOTAL_SESSIONS,
        0
    ) AS TOTAL_SESSIONS,

    COALESCE(
        s.AVG_SESSION_DURATION_SECONDS,
        0
    ) AS AVG_SESSION_DURATION_SECONDS,

    s.LAST_SESSION_DATE,


    /* ==========================================
       MARKETING KPIs
       ========================================== */

    COALESCE(
        m.TOTAL_MARKETING_EVENTS,
        0
    ) AS TOTAL_MARKETING_EVENTS,

    COALESCE(
        m.UNIQUE_CAMPAIGNS,
        0
    ) AS UNIQUE_CAMPAIGNS,


    /* ==========================================
       SUPPORT KPIs
       ========================================== */

    COALESCE(
        sp.TOTAL_SUPPORT_TICKETS,
        0
    ) AS TOTAL_SUPPORT_TICKETS,

    COALESCE(
        sp.AVG_RESOLUTION_TIME_HOURS,
        0
    ) AS AVG_RESOLUTION_TIME_HOURS,

    sp.LAST_SUPPORT_DATE,


    /* ==========================================
       CUSTOMER VALUE SEGMENT
       ========================================== */

    CASE

        WHEN COALESCE(
            o.TOTAL_ORDERS,
            0
        ) = 0

        THEN 'NO ORDERS'

        WHEN COALESCE(
            o.TOTAL_REVENUE,
            0
        ) >= 10000

        THEN 'HIGH VALUE'

        WHEN COALESCE(
            o.TOTAL_REVENUE,
            0
        ) >= 5000

        THEN 'MEDIUM VALUE'

        ELSE 'LOW VALUE'

    END AS CUSTOMER_VALUE_SEGMENT,


    /* ==========================================
       CUSTOMER ACTIVITY STATUS
       ========================================== */

    CASE

        WHEN COALESCE(
            o.TOTAL_ORDERS,
            0
        ) = 0

        THEN 'INACTIVE'

        WHEN o.LAST_ORDER_DATE >= DATEADD(
            MONTH,
            -3,
            CURRENT_DATE()
        )

        THEN 'ACTIVE'

        ELSE 'AT RISK'

    END AS CUSTOMER_ACTIVITY_STATUS,


    /* ==========================================
       SESSION TO ORDER CONVERSION
       ========================================== */

    CASE

        WHEN COALESCE(
            s.TOTAL_SESSIONS,
            0
        ) = 0

        THEN 0

        ELSE ROUND(
            COALESCE(
                o.TOTAL_ORDERS,
                0
            ) * 100.0
            / s.TOTAL_SESSIONS,
            2
        )

    END AS SESSION_TO_ORDER_CONVERSION_PCT


FROM customer_dim c

LEFT JOIN order_metrics o
    ON c.CUSTOMER_KEY = o.CUSTOMER_KEY

LEFT JOIN session_metrics s
    ON c.CUSTOMER_KEY = s.CUSTOMER_KEY

LEFT JOIN marketing_metrics m
    ON c.CUSTOMER_KEY = m.CUSTOMER_KEY

LEFT JOIN support_metrics sp
    ON c.CUSTOMER_KEY = sp.CUSTOMER_KEY