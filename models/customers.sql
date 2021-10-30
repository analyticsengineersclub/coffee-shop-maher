{{ config(
    materialized='table'
)
}}

with cte_1 as( 
    select 

created_at
,customer_id 
,rank () OVER (PARTITION BY customer_id ORDER BY created_at) AS rank

from {{ source('coffee_shop','orders') }} 

GROUP BY 2,1
ORDER BY 2,1),

cte_2 as (
SELECT 
cte_1.created_at as first_order_at
,cte_1.customer_id
,cte_1.rank
,count(distinct o.created_at) as number_of_orders
FROM cte_1 join {{ source('coffee_shop','orders') }}  as o 
ON cte_1.customer_id = o.customer_id
WHERE rank = 1 
GROUP BY 1,2,3)

SELECT 
cte_2.customer_id
,name
,email
,cte_2.first_order_at 
,cte_2.number_of_orders 
FROM cte_2 JOIN {{ source('coffee_shop','customers') }}  as c
ON cte_2.customer_id = c.id

order by first_order_at 
-- limit 5

