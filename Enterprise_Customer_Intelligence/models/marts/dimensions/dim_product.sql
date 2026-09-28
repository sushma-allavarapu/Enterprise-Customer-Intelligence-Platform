WITH products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

),

final AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY PRODUCT_ID
        ) AS PRODUCT_KEY,

        PRODUCT_ID,

        PRODUCT_NAME,

        CATEGORY,
        SUBCATEGORY,
        BRAND,

        COST_PRICE,
        SELLING_PRICE,

        SELLING_PRICE - COST_PRICE AS UNIT_PROFIT,

        CASE
            WHEN COST_PRICE = 0 THEN NULL
            ELSE ROUND(
                ((SELLING_PRICE - COST_PRICE) / COST_PRICE) * 100,
                2
            )
        END AS PROFIT_MARGIN_PCT,

        STOCK_QUANTITY,

        CASE
            WHEN STOCK_QUANTITY = 0 THEN 'OUT OF STOCK'
            WHEN STOCK_QUANTITY <= 10 THEN 'LOW STOCK'
            ELSE 'IN STOCK'
        END AS STOCK_STATUS,

        SUPPLIER_ID,
        LAUNCH_DATE,
        IS_ACTIVE

    FROM products

)

SELECT *
FROM final