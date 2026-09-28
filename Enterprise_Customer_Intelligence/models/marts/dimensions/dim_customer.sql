WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

final AS (

    SELECT
        ROW_NUMBER() OVER (
            ORDER BY CUSTOMER_ID
        ) AS CUSTOMER_KEY,

        CUSTOMER_ID,

        FIRST_NAME,
        LAST_NAME,
        FIRST_NAME || ' ' || LAST_NAME AS CUSTOMER_NAME,

        GENDER,
        AGE,

        CASE
            WHEN AGE IS NULL THEN 'UNKNOWN'
            WHEN AGE < 18 THEN 'UNDER 18'
            WHEN AGE BETWEEN 18 AND 25 THEN '18-25'
            WHEN AGE BETWEEN 26 AND 35 THEN '26-35'
            WHEN AGE BETWEEN 36 AND 45 THEN '36-45'
            WHEN AGE BETWEEN 46 AND 55 THEN '46-55'
            WHEN AGE BETWEEN 56 AND 65 THEN '56-65'
            ELSE '65+'
        END AS AGE_GROUP,

        EMAIL,
        PHONE,

        CITY,
        STATE,
        COUNTRY,

        REGISTRATION_DATE,

        DATEDIFF(
            MONTH,
            REGISTRATION_DATE,
            CURRENT_DATE()
        ) AS CUSTOMER_TENURE_MONTHS,

        CUSTOMER_SEGMENT,
        LOYALTY_TIER

    FROM customers

)

SELECT *
FROM final