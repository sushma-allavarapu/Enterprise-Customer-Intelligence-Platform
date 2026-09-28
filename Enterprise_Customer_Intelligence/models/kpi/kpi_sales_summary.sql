WITH sales AS (

    SELECT
        DATE_KEY,
        ORDER_DATE,
        ORDER_ID,
        ORDER_ITEM_ID,
        CUSTOMER_KEY,
        PRODUCT_KEY,
        SALES_CHANNEL,
        QUANTITY,
        LINE_AMOUNT
    FROM {{ ref('fact_orders') }}

),

product_dim AS (

    SELECT
        PRODUCT_KEY,
        PRODUCT_ID,
        PRODUCT_NAME,
        CATEGORY,
        SUBCATEGORY,
        BRAND
    FROM {{ ref('dim_product') }}

),

aggregated_sales AS (

    SELECT

        s.DATE_KEY,

        s.ORDER_DATE,

        s.SALES_CHANNEL,

        p.PRODUCT_KEY,
        p.PRODUCT_ID,
        p.PRODUCT_NAME,
        p.CATEGORY,
        p.SUBCATEGORY,
        p.BRAND,

        COUNT(DISTINCT s.ORDER_ID)
            AS TOTAL_ORDERS,

        COUNT(DISTINCT s.ORDER_ITEM_ID)
            AS TOTAL_ORDER_ITEMS,

        COUNT(DISTINCT s.CUSTOMER_KEY)
            AS UNIQUE_CUSTOMERS,

        SUM(
            COALESCE(s.QUANTITY, 0)
        ) AS TOTAL_QUANTITY_SOLD,

        SUM(
            COALESCE(s.LINE_AMOUNT, 0)
        ) AS TOTAL_REVENUE,

        AVG(
            s.LINE_AMOUNT
        ) AS AVG_ORDER_ITEM_VALUE

    FROM sales s

    LEFT JOIN product_dim p
        ON s.PRODUCT_KEY = p.PRODUCT_KEY

    GROUP BY

        s.DATE_KEY,
        s.ORDER_DATE,
        s.SALES_CHANNEL,

        p.PRODUCT_KEY,
        p.PRODUCT_ID,
        p.PRODUCT_NAME,
        p.CATEGORY,
        p.SUBCATEGORY,
        p.BRAND

)

SELECT

    DATE_KEY,
    ORDER_DATE,

    SALES_CHANNEL,

    PRODUCT_KEY,
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    SUBCATEGORY,
    BRAND,

    TOTAL_ORDERS,
    TOTAL_ORDER_ITEMS,
    UNIQUE_CUSTOMERS,
    TOTAL_QUANTITY_SOLD,
    TOTAL_REVENUE,
    AVG_ORDER_ITEM_VALUE,

    CASE
        WHEN TOTAL_ORDERS = 0
        THEN 0

        ELSE ROUND(
            TOTAL_REVENUE / TOTAL_ORDERS,
            2
        )
    END AS AVERAGE_ORDER_VALUE

FROM aggregated_sales