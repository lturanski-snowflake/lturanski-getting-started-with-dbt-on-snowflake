SELECT
    "Index" AS customer_index,
    "Customer Id" AS customer_id,
    "First Name" AS first_name,
    "Last Name" AS last_name,
    "Company" AS company,
    "City" AS city,
    "Country" AS country,
    "Phone 1" AS phone_1,
    "Phone 2" AS phone_2,
    "Email" AS email,
    "Subscription Date" AS subscription_date,
    "Website" AS website
FROM {{ ref('customers-100') }}
