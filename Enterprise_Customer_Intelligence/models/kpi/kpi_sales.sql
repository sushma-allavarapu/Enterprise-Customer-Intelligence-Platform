WITH sales_metrics AS (

    SELECT
        DATE_KEY,
        PRODUCT_KEY,
        CUSTOMER_KEY,
        ORDER_ID,
        ORDER_ITEM_ID,
        ORDER_DATE,
        ORDER_STATUS,
        SALES_CHANNEL,
        QUANTITY,
        UNIT_PRICE,
        DISCOUNT_PCT,
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

customer_dim AS (

    SELECT
        CUSTOMER_KEY,
        CUSTOMER_ID,
        CUSTOMER_SEGMENT,
        LOYALTY_TIER

    FROM {{ ref('dim_customer') }}

),

final AS (

    SELECT
        s.DATE_KEY,
        s.ORDER_DATE,

        s.ORDER_ID,
        s.ORDER_ITEM_ID,

        s.CUSTOMER_KEY,
        c.CUSTOMER_ID,
        c.CUSTOMER_SEGMENT,
        c.LOYALTY_TIER,

        s.PRODUCT_KEY,
        p.PRODUCT_ID,
        p.PRODUCT_NAME,
        p.CATEGORY,
        p.SUBCATEGORY,
        p.BRAND,

        s.ORDER_STATUS,
        s.SALES_CHANNEL,

        s.QUANTITY,
        s.UNIT_PRICE,
        s.DISCOUNT_PCT,
        s.LINE_AMOUNT

    FROM sales_metrics s

    LEFT JOIN product_dim p
        ON s.PRODUCT_KEY = p.PRODUCT_KEY

    LEFT JOIN customer_dim c
        ON s.CUSTOMER_KEY = c.CUSTOMER_KEY

)

SELECT
    DATE_KEY,
    ORDER_DATE,

    ORDER_ID,
    ORDER_ITEM_ID,

    CUSTOMER_KEY,
    CUSTOMER_ID,
    CUSTOMER_SEGMENT,
    LOYALTY_TIER,

    PRODUCT_KEY,
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    SUBCATEGORY,
    BRAND,

    ORDER_STATUS,
    SALES_CHANNEL,

    QUANTITY,
    UNIT_PRICE,
    DISCOUNT_PCT,
    LINE_AMOUNT

FROM final