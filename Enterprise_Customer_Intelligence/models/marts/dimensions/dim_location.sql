WITH locations AS (

    SELECT DISTINCT
        CITY,
        STATE,
        COUNTRY

    FROM {{ ref('stg_customers') }}

),

final AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY COUNTRY, STATE, CITY
        ) AS LOCATION_KEY,

        CITY,
        STATE,
        COUNTRY,

        CITY || ', ' || STATE AS CITY_STATE,

        STATE || ', ' || COUNTRY AS STATE_COUNTRY,

        CASE
            WHEN UPPER(COUNTRY) = 'INDIA'
                THEN 'INDIA'
            ELSE 'INTERNATIONAL'
        END AS MARKET_TYPE

    FROM locations

)

SELECT *
FROM final