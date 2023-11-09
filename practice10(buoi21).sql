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
