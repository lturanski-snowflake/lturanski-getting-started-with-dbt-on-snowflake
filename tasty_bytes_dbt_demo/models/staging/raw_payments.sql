SELECT
    id AS payment_id,
    order_id AS order_id,
    payment_method AS payment_method,
    amount AS amount_cents,
    amount / 100.0 AS amount_dollars,
    CASE
        WHEN payment_method IN ('credit_card', 'bank_transfer') THEN 'standard'
        WHEN payment_method IN ('coupon', 'gift_card') THEN 'promotional'
        ELSE 'other'
    END AS payment_category
FROM {{ ref('raw_payments') }}
