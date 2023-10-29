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

--baif 5

