
--find top 10 highest revenue generating products
select top 10 product_id,sum(profit) as revenue from df_orders
group by product_id
order by revenue desc

--find top 10 highest sales generating products
select top 10 product_id,sum(sale_price) as topsale from df_orders
group by product_id
order by topsale desc





--find top 5 highest selling products in each region
with cte as(
select region,product_id,sum(sale_price)as sales from df_orders
group by region,product_id)
select * from(
select *
,rank() over(partition by region order by sales desc) as rn from cte) AS A
where rn<=5


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

with cte as(
select year(order_date) as years, month(order_date) as months,sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date))
select months
,sum(case when years=2022 then sales else 0 end) as sale_2022
,sum(case when years=2023 then sales else 0 end) as sale_2023
from cte
group by months
order by months


--for each category which month had highest sales 

with cte as (
select category,format(order_date,'yyyy-MM') as order_year_month,sum(sale_price) as sales
from df_orders
group by category,format(order_date,'yyyy-MM'))
select * from (
select * 
,rank() over(partition by category order by sales desc) as ranked
from cte) a
where ranked=1;



--which sub category had highest growth by profit in 2023 compare to 2022

with cte as(
select sub_category,year(order_date) as years, sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date))
, cte2 as(
select sub_category
,sum(case when years=2022 then sales else 0 end) as sale_2022
,sum(case when years=2023 then sales else 0 end) as sale_2023
from cte
group by sub_category) 
select *,(sale_2023-sale_2022)*100/sale_2022 as year_prof_psnt from cte2
order by (sale_2023-sale_2022)*100/sale_2022 desc 


select * from df_orders