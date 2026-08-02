-- ============================================
-- Query 15: Cohort Retention Analysis
-- ============================================

WITH customer_cohort AS (
    SELECT
        customer_id,
        date(
            registration_date,
            'start of month'
        ) AS cohort_month
    FROM customers
),

customer_orders AS (
    SELECT DISTINCT
        o.customer_id,
        date(
            o.order_date,
            'start of month'
        ) AS order_month
    FROM orders o
),

cohort_activity AS (
    SELECT
        cc.customer_id,

        cc.cohort_month,

        co.order_month,

        (
            (
                CAST(strftime('%Y', co.order_month) AS INTEGER)
                -
                CAST(strftime('%Y', cc.cohort_month) AS INTEGER)
            ) * 12
            +
            (
                CAST(strftime('%m', co.order_month) AS INTEGER)
                -
                CAST(strftime('%m', cc.cohort_month) AS INTEGER)
            )
        ) AS month_number

    FROM customer_cohort cc

    JOIN customer_orders co
    ON cc.customer_id = co.customer_id

),

cohort_size AS (

    SELECT

        cohort_month,

        COUNT(*) AS cohort_size

    FROM customer_cohort

    GROUP BY cohort_month

)

SELECT
    ca.cohort_month,
    cs.cohort_size,
    COUNT(DISTINCT CASE WHEN month_number = 0 THEN customer_id END) AS month_0,
    COUNT(DISTINCT CASE WHEN month_number = 1 THEN customer_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN month_number = 2 THEN customer_id END) AS month_2,
    COUNT(DISTINCT CASE WHEN month_number = 3 THEN customer_id END) AS month_3,
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 1 THEN customer_id END) * 100.0 / cs.cohort_size, 2) AS retention_month_1,
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 2 THEN customer_id END) * 100.0 / cs.cohort_size, 2) AS retention_month_2,
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 3 THEN customer_id END) * 100.0 / cs.cohort_size, 2) AS retention_month_3


FROM cohort_activity ca

JOIN cohort_size cs
ON ca.cohort_month = cs.cohort_month

GROUP BY

    ca.cohort_month,
    cs.cohort_size

ORDER BY

    ca.cohort_month;