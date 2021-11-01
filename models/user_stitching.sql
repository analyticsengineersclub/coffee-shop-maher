with order_price as 

(
    
select 
    orders.id,
    orders.created_at,
    orders.customer_id,
    orders.total,
    order_items.product_id

from `analytics-engineers-club.coffee_shop.orders` orders 
    left join 
    `analytics-engineers-club.coffee_shop.order_items` order_items
    on orders.id = order_items.order_id

),

full_order_price as 

(
select  
    order_price.id,
    order_price.created_at,
    order_price.customer_id,
    order_price.total as total_orders,
    order_price.product_id,
    product_prices.price,
    order_price.total * product_prices.price as total_order_price,
    products.category

from order_price 
left join 
    `analytics-engineers-club.coffee_shop.product_prices` as product_prices
    on order_price.product_id = product_prices.product_id 
    and order_price.created_at between product_prices.created_at and product_prices.ended_at

left join 
    `analytics-engineers-club.coffee_shop.products` as products
    on order_price.product_id = products.id
)

select 
date_trunc(created_at, week) as order_created_at,
category,
sum(total_order_price ) as total_weekly_revenue

from full_order_price 

group by 2,1