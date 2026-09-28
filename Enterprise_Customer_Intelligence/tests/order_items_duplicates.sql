SELECT
    ORDER_ITEM_ID,
    COUNT(*) AS CNT
FROM {{ ref('stg_order_items') }}
GROUP BY ORDER_ITEM_ID
HAVING COUNT(*) > 1