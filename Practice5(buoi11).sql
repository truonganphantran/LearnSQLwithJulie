--bai 1

--bai 2
SELECT 
CAST (count(distinct emails.email_id) AS DECIMAL)/ (SELECT COUNT(distinct email_id) FROM emails ) AS confirm_rate
FROM emails
INNER JOIN texts
ON emails.email_id = texts.email_id

--bai 3
SELECT
age_bucket
   ,ROUND(SUM(CASE when activity_type = 'open' THEN time_spent END)*100/ SUM(CASE when activity_type IN ( 'send','open') THEN time_spent END),2 )AS open_perc
  ,ROUND (SUM(CASE when activity_type = 'send' THEN time_spent END)*100/SUM(CASE when activity_type IN ( 'send','open') THEN time_spent END),2) AS send_perc
FROM age_breakdown
INNER JOIN activities
ON age_breakdown.user_id = activities.user_id
GROUP BY age_bucket;

--bài 4
SELECT pro.product_id
, product_category
, product_name
 FROM customer_contracts cus
RIGHT JOIN products pro
on pro.product_id = cus.product_id
GROUP BY pro.product_id, product_category
, product_name
ORDER BY pro.product_id;

-bai 5
SELECT  
      emp.employee_id
      , emp.name
      ,COUNT(CASE WHEN report_.reports_to IS NOT NULL THEN emp.employee_id END) AS reports_count 
      , ROUND (AVG(CASE WHEN report_.reports_to IS NOT NULL THEN report_.age END), 0) AS average_age
      FROM EMPLOYEES AS emp
INNER JOIN EMPLOYEES AS report_
ON emp.employee_id = report_.reports_to
GROUP BY employee_id;

--BÀI 6
SELECT 
    products.product_name
    , SUM(unit) AS TOTAL_UNIT
FROM products
INNER JOIN Orders
ON products.product_id = orders.product_id
WHERE EXTRACT(MONTH FROM order_date) = 2
GROUP BY product_name
HAVING SUM(unit) >= 100

--BÀI 7
SELECT pages.page_id 
FROM page_likes
 FULL OUTER JOIN pages
ON page_likes.page_id = pages.page_id
WHERE liked_date IS NULL;



