-- perform an advanced behavioral and geolocation analysis on e-commerce customers to uncover churn risks, 
-- repeat purchase cycles, and regional performance trends using window fucntions, cohort analysis and order-level metrics




-- Question 1. To evaluate the delivery performance of the e-commerce platform  by calculating the number of days each order was delivered early or late
--  compared to the estimated delivery date

SELECT 
    order_id,
    estimated_delivery_date,
    actual_delivery_date,
    DATEDIFF(actual_delivery_date , estimated_delivery_date) AS delivery_delay_days
FROM
    (SELECT 
        order_id,
        DATE(order_estimated_delivery_date) AS estimated_delivery_date,
        DATE(order_delivered_customer_date) AS actual_delivery_date
    FROM
        orders) AS delivery
WHERE actual_delivery_date IS NOT NULL 
  AND estimated_delivery_date IS NOT NULL;


-- Question 2. Which regions experience the highest average delivery delays?


 with delivery as (
 SELECT 
c.customer_state,
        o.order_id,
        DATE(o.order_estimated_delivery_date) AS estimated_delivery_date,
        DATE(o.order_delivered_customer_date) AS actual_delivery_date
    FROM
        orders as o
        join customer as c
        on c.customer_id = o.customer_id), 
delays as (
select    customer_state,     
 estimated_delivery_date,
    actual_delivery_date,
    DATEDIFF(actual_delivery_date , 
estimated_delivery_date) AS delivery_delay_days
    from delivery),
avgs as 
(select customer_state, round(avg(delivery_delay_days),2) as avg_delay
from delays
group by customer_state
order by round(avg(delivery_delay_days),2) desc )
select * from avgs;


-- Question 3. Do certain product categories experience more delivery delays than others?


with delivery as ( select 
pc.product_category_name_english,
o.order_id,
        DATE(o.order_estimated_delivery_date) AS estimated_delivery_date,
        DATE(o.order_delivered_customer_date) AS actual_delivery_date
    FROM
        orders as o
        join order_item as oi
        on o.order_id = oi.order_id
        join products as p
        on p.product_id = oi.product_id
        join product_category as pc
        on p.product_category_name = pc.product_category_name),
delays as (
select
 product_category_name_english,
 datediff(actual_delivery_date,estimated_delivery_date) 
as delaydays from delivery),
avgs as (
select product_category_name_english as product_category,
 round(avg(delaydays),2) as average_delay_days
 from delays
 group by  product_category_name_english 
 order by avg(delaydays) desc)
select * from avgs;


-- Question 4. Which product categories contribute the most to total revenue?


with revenue as ( select
pc.product_category_name_english as product_category, round(sum(oi.price),2) as total_revenue
from order_item as oi
join products as p
on p.product_id =oi.product_id
join product_category as pc
on p.product_category_name = pc.product_category_name
group by pc.product_category_name_english)
select * from revenue
order by total_revenue desc;


-- Question 5. Top 5 most active cities by order volumme


with total_orders as (
select c.customer_city ,
 count(*) as total_order
from customer as c
join orders as o
on o.customer_id = c.customer_id
group by c.customer_city
)
select customer_city , total_order
from total_orders 
order by total_order desc
limit 5;


-- Question 6. What is the average delivery delay per seller, and who are the most and least reliable sellers?


with delivery as (
select s.seller_id ,
datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) as delaydays
from orders as o
join order_item as oi
on oi.order_id = o.order_id
join seller as s
on s.seller_id = oi.seller_id
),
avgs as(
select seller_id , count(*) as totals,
avg(delaydays) as avgdelay
from delivery
group by seller_id
having count(*)>5)
select * from avgs
order by avgdelay desc;


-- Question 7. Identify customers in the  top 10% of total spend.


with pay as (
select  c.customer_id,
		round(sum(oi.price),2) as totals
from  
		customer AS c
        JOIN orders AS o ON o.customer_id = c.customer_id
		JOIN order_item AS oi ON oi.order_id = o.order_id
		GROUP BY c.customer_id
),
percentiles as (
select customer_id,totals,
	   percent_rank()over(order by totals) as spend_percentile from pay
       )
select * from percentiles 
		where spend_percentile >0.9
		order  by totals desc;



-- Question 8. Which product categories generate the highest revenue and margin?.


with revenue as (
select 
		pc.product_category_name_english as product_category, 
		round(sum(oi.price),2) as total_revenue,
		round(sum(oi.price-oi.freight_value),2) as profit,
		round(avg((oi.price-oi.freight_value)/oi.price),2)*100 as avg_margin
from 
		order_item AS oi
		JOIN products AS p 
		ON p.product_id = oi.product_id
		JOIN product_category AS pc 
		ON p.product_category_name = pc.product_category_name
GROUP BY 
    pc.product_category_name_english
)
    select product_category,
			total_revenue , 
            profit,avg_margin
    from revenue
    order by total_revenue desc;
    
    
-- Question 9. How has the monthly sales trend evolved over time?   
 
 
with monthly_sales as (
	select 
    date_format(o.order_purchase_timestamp, '%Y-%m') as order_month,
	round(sum(oi.price),2) as total_revenue,
	count(distinct o.order_id) as total_orders
from 
	orders as o
	join order_item as oi
	on oi.order_id = o.order_id
	group by date_format(o.order_purchase_timestamp, '%Y-%m')
    )
	select * from monthly_sales
	order by order_month ;
    

-- Question 10. What is the Average Order Value (AOV) each month, and how has it evolved over time?

WITH monthly_data AS (
  SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
  FROM  
	orders AS o
	JOIN order_item AS oi 
    ON o.order_id = oi.order_id
	GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT 
  order_month,
  ROUND(total_revenue / total_orders, 2) AS avg_order_value
FROM monthly_data
ORDER BY order_month;

