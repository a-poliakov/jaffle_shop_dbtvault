WITH sat_with_effective_to AS (
    SELECT 
        scd.CUSTOMER_PK,
        scd.country,
        scd.age,
        scd.EFFECTIVE_FROM,
        LEAD(scd.EFFECTIVE_FROM, 1, date '9999-12-31') OVER(PARTITION BY scd.CUSTOMER_PK ORDER BY scd.EFFECTIVE_FROM) as EFFECTIVE_TO
    FROM 
        {{ref('sat_customer_crm_details')}} scd
)
SELECT 
    vpcd.as_of_date,
    swet.CUSTOMER_PK,
    swet.country,
    swet.age,
    swet.EFFECTIVE_FROM,
    swet.EFFECTIVE_TO
FROM 
    {{ref('pit_customer_crm_details')}} vpcd 
    LEFT JOIN sat_with_effective_to swet ON vpcd.sat_customer_crm_details_pk = swet.CUSTOMER_PK
ORDER BY 
    swet.CUSTOMER_PK,
    vpcd.as_of_date
