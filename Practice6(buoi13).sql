--bài 4
SELECT pages.page_id 
FROM pages
LEFT JOIN page_likes
ON pages.page_id = page_likes.page_id
WHERE liked_date IS NULL;

--bài 5
with CTE1 AS (SELECT  
     EXTRACT(MONTH FROM event_date) AS month
    , COUNT(DISTINCT user_id) as count 
FROM user_actions
WHERE  EXTRACT(MONTH FROM event_date) = 7
   GROUP BY user_id, EXTRACT(MONTH FROM event_date)
   HAVING COUNT(user_id) > 1) 
select month
      ,count (count)
FROM CTE1
GROUP BY month


--bài 6
SELECT 
EXTRACT(YEAR_MONTH FROM trans_date) AS month --khúc này em không biết làm sao để nó có dấu '-' ở giữa nữa chị
, country
, COUNT(id) AS trans_count
, COUNT(CASE WHEN state = 'approved' THEN id END) AS approved_count
, SUM(amount) AS total_amount
, SUM(CASE WHEN state = 'approved' THEN amount END) AS approve_total_amount
FROM Transactions
GROUP BY EXTRACT(YEAR_MONTH FROM trans_date) , country


--bài 7
WITH CTE1 AS (SELECT 
       sale_id
    , sales.product_id
    , MIN(year) as first_year
FROM sales
GROUP BY  sales.product_id)
SELECT CTE1.product_id
      , first_year
      , quantity
      , price
  FROM CTE1
  INNER JOIN product
  ON CTE1.product_id = product.product_id
  INNER JOIN sales
  ON CTE1.sale_id = sales.sale_id

--bài 8
SELECT 
    customer_id
FROM customer 
INNER JOIN product
on ProDUCT.PRODUCT_KEY=CUSTOMER.PRODUCT_KEY
GROUP BY customer_id
HAVING COUNT(DISTINCT customer.product_key) = (SELECT COUNT(product_key) FROM product)

--bài 9
SELECT 
    employee_id
FROM employees
WHERE salary < 30000 AND
         manager_id NOT IN  (SELECT employee_id FROM employees ) 

--BÀI 10
with cte1 as (SELECT 
    COMPANY_ID
FROM job_listings
GROUP BY company_id, title, description
having    COUNT (company_id) > 1
)
SELECT COUNT (COMPANY_ID) AS duplicate_companies
FROM CTE1





