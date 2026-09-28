WITH date_spine AS (

    SELECT
        DATEADD(
            DAY,
            SEQ4(),
            '2020-01-01'::DATE
        ) AS DATE_DAY

    FROM TABLE(
        GENERATOR(ROWCOUNT => 3653)
    )

),

final AS (

    SELECT
        DATE_DAY AS DATE_KEY,
        DATE_DAY,

        YEAR(DATE_DAY) AS YEAR,
        QUARTER(DATE_DAY) AS QUARTER,

        MONTH(DATE_DAY) AS MONTH,
        MONTHNAME(DATE_DAY) AS MONTH_NAME,

        WEEK(DATE_DAY) AS WEEK_OF_YEAR,

        DAY(DATE_DAY) AS DAY_OF_MONTH,

        DAYOFWEEKISO(DATE_DAY) AS DAY_OF_WEEK,
        DAYNAME(DATE_DAY) AS DAY_NAME,

        CASE
            WHEN DAYOFWEEKISO(DATE_DAY) IN (6, 7)
            THEN TRUE
            ELSE FALSE
        END AS IS_WEEKEND,

        CASE
            WHEN MONTH(DATE_DAY) IN (1, 2, 3)
                THEN 'Q1'
            WHEN MONTH(DATE_DAY) IN (4, 5, 6)
                THEN 'Q2'
            WHEN MONTH(DATE_DAY) IN (7, 8, 9)
                THEN 'Q3'
            ELSE 'Q4'
        END AS QUARTER_NAME

    FROM date_spine

)

SELECT *
FROM final