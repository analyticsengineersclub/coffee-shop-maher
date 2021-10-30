select 

distinct (customer_id) as unique_customer_id,
device_type,
count(*) as total

from `analytics-engineers-club.web_tracking.pageviews`
where customer_id is not null
group by 2,1