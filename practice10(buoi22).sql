--III. Tạo metric trước khi dựng dashboard
--bài 1
WITH table_sum_2 AS (
SELECT month
  , year 
  , category as Product_category
  , SUM (TPV) OVER(PARTITION BY month, year) AS TPV
  , SUM (TPO) OVER(PARTITION BY month, year) AS TPO
  , SUM(total_cost) OVER(PARTITION BY month, year) AS total_cost
  , SUM (total_profit) OVER(PARTITION BY month, year) AS total_profit
  , SUM (total_profit) OVER(PARTITION BY month, year) /SUM(total_cost) OVER(PARTITION BY month, year) as Profit_to_cost_ratio
FROM (
SELECT 
    FORMAT_DATE('%Y-%m', DATE (created_at)) as month
    , EXTRACT(YEAR FROM created_at) AS year
    , category
    , SUM (sale_price) AS TPV
    , SUM (order_id) AS TPO
    , SUM(cost) AS total_cost
    , SUM (sale_price - cost) AS total_profit
FROM bigquery-public-data.thelook_ecommerce.order_items AS order_items
INNER JOIN bigquery-public-data.thelook_ecommerce.products AS products
ON products.id = order_items.product_id
WHERE  status = 'Complete' 
GROUP BY FORMAT_DATE('%Y-%m', DATE (created_at)), EXTRACT(YEAR FROM created_at), category
) as table_sum
)
SELECT 
    Month
    ,Year
    ,Product_category
    ,TPV
    ,TPO
    , FORMAT('%s%%', CAST(ROUND( (Total_profit - LAG (Total_profit) OVER(PARTITION BY year, Product_category  ORDER BY month))*100/Total_profit , 2) AS STRING))  AS Revenue_growth
    ,FORMAT('%s%%', CAST(ROUND( (TPO - LAG (TPO) OVER(PARTITION BY year, Product_category  ORDER BY month) )*100/ TPO , 2) AS STRING))AS Order_growth--
    ,Total_cost
    ,Total_profit
    ,Profit_to_cost_ratio
FROM table_sum_2




  
--BÀI 2
--Tạo retention cohort analysis.

WITH table_2 as (SELECT *
            , FORMAT_DATE('%Y-%m', DATE (first_order_month )) as first_month
            , DATE_DIFF ( cast (created_at as datetime ), cast (first_order_month  as datetime) , MONTH)  AS monthdiff
FROM (SELECT 
            user_id
            , created_at
            , MIN (created_at) OVER (PARTITION BY user_id) as first_order_month 
        FROM bigquery-public-data.thelook_ecommerce.order_items
    ) as table_1
)
SELECT first_month 
        , FORMAT ('%s%%', CAST(ROUND (COUNT (DISTINCT user_id)*100/COUNT (DISTINCT user_id),2) AS STRING) ) as rate_1st_month
        , FORMAT ('%s%%', CAST(ROUND (COUNT (DISTINCT (CASE WHEN monthdiff = 1 THEN user_id END))*100/COUNT (DISTINCT user_id),2) AS STRING) ) as rate_2nd_month
        , FORMAT ('%s%%', CAST(ROUND (COUNT (DISTINCT (CASE WHEN monthdiff = 2 THEN user_id END))*100/COUNT (DISTINCT user_id),2) AS STRING) ) as rate_3rd_month
        , FORMAT ('%s%%', CAST(ROUND (COUNT (DISTINCT (CASE WHEN monthdiff = 3 THEN user_id END))*100/COUNT (DISTINCT user_id),2) AS STRING) ) as rate_4th_month
FROM table_2
GROUP BY first_month
ORDER BY first_month 

