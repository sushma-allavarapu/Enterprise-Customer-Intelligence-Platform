WITH order_data AS (

    SELECT *
    FROM {{ ref('int_customer_orders') }}

),

customer_dim AS (

    SELECT
        CUSTOMER_KEY,
        CUSTOMER_ID
    FROM {{ ref('dim_customer') }}

),

product_dim AS (

    SELECT
        PRODUCT_KEY,
        PRODUCT_ID
    FROM {{ ref('dim_product') }}

),

date_dim AS (

    SELECT
        DATE_KEY,
        DATE_DAY
    FROM {{ ref('dim_date') }}

),

final AS (

    SELECT
        od.ORDER_ITEM_ID,
        od.ORDER_ID,

        cd.CUSTOMER_KEY,
        pd.PRODUCT_KEY,
        dd.DATE_KEY,

        od.ORDER_DATE,
        od.ORDER_STATUS,
        od.SALES_CHANNEL,

        od.QUANTITY,
        od.UNIT_PRICE,
        od.DISCOUNT_PCT,
        od.LINE_AMOUNT,
        od.TOTAL_AMOUNT

    FROM order_data od

    LEFT JOIN customer_dim cd
        ON od.CUSTOMER_ID = cd.CUSTOMER_ID

    LEFT JOIN product_dim pd
        ON od.PRODUCT_ID = pd.PRODUCT_ID

    LEFT JOIN date_dim dd
        ON od.ORDER_DATE = dd.DATE_DAY
    WHERE od.ORDER_ITEM_ID IS NOT NULL
)

SELECT *
FROM final