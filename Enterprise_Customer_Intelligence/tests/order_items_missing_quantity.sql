{{ config(
    severity='warn',
    warn_if='>0',
    error_if='>10000'
) }}

SELECT
    ORDER_ITEM_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    LINE_AMOUNT
FROM {{ ref('stg_order_items') }}
WHERE QUANTITY IS NULL