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


