WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'ORDER_ITEMS') }}

),

cleaned_data AS (

    SELECT

        ORDER_ITEM_ID,

        ORDER_ID,

        PRODUCT_ID,

        QUANTITY,

        UNIT_PRICE,

        DISCOUNT_PCT,

        CASE

            /* Repair negative amounts when quantity and price
               are available */
            WHEN LINE_AMOUNT < 0
                 AND QUANTITY IS NOT NULL
                 AND UNIT_PRICE IS NOT NULL
            THEN
                ROUND(
                    QUANTITY
                    * UNIT_PRICE
                    * (
                        1
                        - COALESCE(DISCOUNT_PCT, 0) / 100
                    ),
                    2
                )

            /* Keep NULL when the amount cannot be
               reliably recalculated */
            WHEN LINE_AMOUNT < 0
                 AND (
                     QUANTITY IS NULL
                     OR UNIT_PRICE IS NULL
                 )
            THEN NULL

            /* Keep valid existing amounts */
            ELSE LINE_AMOUNT

        END AS LINE_AMOUNT

    FROM source_data

)

SELECT *
FROM cleaned_data

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY ORDER_ITEM_ID
    ORDER BY ORDER_ITEM_ID
) = 1