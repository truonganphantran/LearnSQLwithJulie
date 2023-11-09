/*Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm) , total_user, total_ordeR
Insight là gì? ( nhận xét về sự tăng giảm theo thời gian)
*/
SELECT *
FROM (SELECT
EXTRACT(MONTH FROM shipped_at) AS MONTH
,EXTRACT(YEAR FROM shipped_at) AS YEAR
, COUNT (DISTINCT user_id) AS total_customer
, COUNT (order_id) AS total_order 
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE  status = 'Complete' 
      AND shipped_at >= '2019-01-01'
      AND shipped_at <= '2022-04-30'
GROUP BY EXTRACT(MONTH FROM shipped_at) 
,EXTRACT(YEAR FROM shipped_at)
) AS table_1
ORDER BY  YEAR ,MONTH


--> INSIGHT: số lượng đơn hàng lẫn khách hàng đều gia tăng theo thời gian trong khoảng  1/2019-4/2022


/*2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm), distinct_users, average_order_value
*/
SELECT *, 
 AVG(sale_price) OVER(PARTITION BY MONTH, YEAR ) AS average_order_value
FROM (SELECT 
 EXTRACT(MONTH FROM shipped_at) AS MONTH
 ,EXTRACT(YEAR FROM shipped_at) AS YEAR
 ,user_id
 , sale_price
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE  status = 'Complete' 
      AND shipped_at >= '2019-01-01'
      AND shipped_at <= '2022-04-30'
) AS table_1
ORDER BY MONTH, YEAR


/3 *Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
*/

SELECT  first_name, last_name, gender, age
      , CASE WHEN age = (SELECT MAX (age) 
                FROM bigquery-public-data.thelook_ecommerce.users
                WHERE gender = 'F' ) THEN 'youngest '
                ELSE 'oldest' END AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE   gender = 'F'
        AND (age = (SELECT MAX (age) 
                FROM bigquery-public-data.thelook_ecommerce.users
                WHERE gender = 'F' ) 
        OR  age = (SELECT MIN (age) 
                FROM bigquery-public-data.thelook_ecommerce.users
                WHERE gender = 'F' ) )            
UNION ALL
SELECT  first_name, last_name, gender, age
      , CASE WHEN age = (SELECT MAX (age) 
                FROM bigquery-public-data.thelook_ecommerce.users
                WHERE gender = 'M' ) THEN 'youngest '
                ELSE 'oldest' END AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE   gender = 'M'
        AND (age = (SELECT MAX (age) 
                FROM bigquery-public-data.thelook_ecommerce.users
                WHERE gender = 'M' ) 
        OR  age = (SELECT MIN (age) 
                FROM bigquery-public-data.thelook_ecommerce.users
                WHERE gender = 'M' ) )


      
/*4.Top 5 sản phẩm mỗi tháng.
Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).
Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month 
*/
with table_ as (SELECT EXTRACT(MONTH FROM shipped_at) AS MONTH
        ,EXTRACT(YEAR FROM shipped_at) AS YEAR 
        ,items.product_id
        , name as product_name
      ,  sale_price
      ,  cost
      ,  sale_price - cost AS  profit
FROM bigquery-public-data.thelook_ecommerce.products AS prod
INNER JOIN bigquery-public-data.thelook_ecommerce.order_items AS items
ON prod.id = items.product_id
WHERE  status = 'Complete' 
      AND shipped_at >= '2019-01-01'
      AND shipped_at <= '2022-04-30') 
, table_1 AS (SELECT  *, DENSE_RANK () over(PARTITION BY MONTH,YEAR ORDER BY profit DESC ) AS RANK 
FROM  table_)
SELECT  *
FROM table_1
WHERE RANK <6

/5*Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue
*/
SELECT *
FROM (SELECT EXTRACT(date FROM shipped_at) AS day
         , category as product_categogy
      , SUM( sale_price) AS revenue   
FROM bigquery-public-data.thelook_ecommerce.products AS prod
INNER JOIN bigquery-public-data.thelook_ecommerce.order_items AS items
ON prod.id = items.product_id
WHERE  status = 'Complete' 
      AND shipped_at >= '2022-01-15'
      AND shipped_at <= '2022-04-15'
GROUP BY category, EXTRACT(date FROM shipped_at) )AS table_
ORDER BY day
