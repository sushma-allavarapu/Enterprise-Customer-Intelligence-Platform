WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'CAMPAIGN_EVENTS') }}

),

cleaned_data AS (

    SELECT
        EVENT_ID,
        CAMPAIGN_ID,
        CUSTOMER_ID,
        UPPER(TRIM(EVENT_TYPE)) AS EVENT_TYPE,
        EVENT_TIMESTAMP AS EVENT_TIMESTAMP
    FROM source_data

)

SELECT *
FROM cleaned_data
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY EVENT_ID
    ORDER BY EVENT_ID
) = 1
