select
    product_category,
    order.state,
    sum(product_prices.price / 100) as total_sales
from dbt_maher.sales

where year = '2021'

group by 2,1