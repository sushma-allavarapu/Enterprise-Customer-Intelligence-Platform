WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'REVIEWS') }}

),

cleaned_data AS (

    SELECT
        REVIEW_ID,
        ORDER_ID,
        PRODUCT_ID,
        CUSTOMER_ID,
        RATING,
        UPPER(TRIM(REVIEW_TITLE)) AS REVIEW_TITLE,
        TRIM(REVIEW_TEXT) AS REVIEW_TEXT,
        REVIEW_DATE,
        VERIFIED_PURCHASE,
        HELPFUL_VOTES
    FROM source_data

)

SELECT *
FROM cleaned_data
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY REVIEW_ID
    ORDER BY REVIEW_DATE DESC
) = 1