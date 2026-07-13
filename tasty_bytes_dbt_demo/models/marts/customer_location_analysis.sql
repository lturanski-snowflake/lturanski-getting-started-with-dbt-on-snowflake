SELECT
    country,
    city,
    COUNT(*) AS customer_count,
    COUNT(DISTINCT company) AS unique_companies,
    MIN(subscription_date) AS earliest_subscription,
    MAX(subscription_date) AS latest_subscription
FROM {{ ref('raw_customers') }}
GROUP BY country, city
ORDER BY customer_count DESC
