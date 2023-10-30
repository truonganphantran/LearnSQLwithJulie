---BÀI 1
SELECT 
     COUNT(CASE WHEN first_order=pref_date THEN customer_id END)*100/ COUNT(distinct customer_id) AS immediate_percentage    
FROM (SELECT 
    customer_id
    ,  FIRST_VALUE(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS first_order 
    , customer_pref_delivery_date AS pref_date
FROM delivery
) AS subquery

  
--BÀI 2
SELECT ROUND(COUNT(CASE WHEN date_diff = 1 THEN player_id END)/COUNT(distinct player_id), 2) AS fraction
FROM (SELECT player_id
        , event_date
        , LAG(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS date_2
        , event_date - LAG(event_date) OVER(PARTITION BY player_id ORDER BY event_date) as date_diff
FROM activity) AS subtable

--BÀI 3

SELECT id
    ,CASE WHEN MOD(id,2)=1 AND col1 IS NOT NULL THEN col1 
          WHEN MOD(id,2)=1 AND col1 IS NULL THEN student 
          WHEN MOD(id,2)=0 THEN col2 
          END AS student
FROM (SELECT id
    , student
    , LEAD(student) OVER() AS col1
    , LAG(student) OVER() AS col2
FROM seat) AS subtable

--bài 4
WITH CTE1 AS (
SELECT 
    visited_on
    ,SUM(amount) AS amount
FROM customer
GROUP BY visited_on
), 
CTE2 AS (
SELECT
    visited_on
    ,SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount
    ,ROUND(AVG(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) as average_amount
    ,DENSE_RANK() OVER(ORDER BY visited_on) as rnk
FROM result
) 
SELECT 
	visited_on
    ,amount
    ,average_amount
FROM CTE2
WHERE rnk > 6

	
--bài 5
SELECT
    SUM(CASE WHEN filter_latlon =1 AND filter_tiv2015>1 THEN tiv_2016 END) AS tiv_2016
FROM (SELECT 
    *
    , COUNT(pid) OVER(PARTITION BY lat, lon ) AS filter_latlon
    , COUNT(pid) OVER(PARTITION BY tiv_2015 ) AS filter_tiv2015
FROM insurance
ORDER BY pid) AS subtable

--bai 6
WITH CTE1 AS(SELECT department.name as department
        , employee.name as employee
        , salary
FROM employee
INNER JOIN department
ON employee.departmentId = department.id
)
, CTE2 AS(SELECT
*
, DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS RANK_SALARY
FROM CTE1
)
SELECT
        department
        , employee
        , salary
FROM CTE2
WHERE RANK_SALARY <4

--BAI 7
 SELECT  person_name   
 FROM
(SELECT person_name
        , weight
        , turn
        , SUM(weight) OVER(ORDER BY turn) AS total_weight
        , 1000 - SUM(weight) OVER(ORDER BY turn) as diff
FROM queue) as subtable
WHERE diff >=0
order by diff 
limit  1

--bai 8
WITH CTE2 AS (SELECT product_id,
 MAX(new_price) as price
FROM (
SELECT product_id
        , new_price
        , change_date
        , DATEDIFF("2019-08-16" , change_date) as diff
        , RANK() over(PARTITION BY product_id ORDER BY change_date)
FROM products 
) AS subtable
WHERE diff>=0
GROUP BY product_id
)
SELECT sub.product_id
       , CASE WHEN price IS NULL THEN 10 ELSE price END AS price
 FROM (SELECT products.product_id
       , price
FROM products
LEFT JOIN CTE2
ON products.product_id = CTE2.product_id
GROUP BY products.product_id
) as sub

