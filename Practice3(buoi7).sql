--bai 1
SELECT NAME
FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME,3), ID ASC;

--bai 2
SELECT user_id 
  , CONCAT( UPPER (LEFT( LOWER (name),1)) , RIGHT( LOWER (name),LENGTH (name)-1)) AS name
FROM Users
ORDER BY user_id;

--bai 3
SELECT 
manufacturer
, CONCAT ( ROUND(SUM (total_sales)/1000000, 0), ' ', 'million')
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY manufacturer ASC;

--BAI 4
SELECT 
  EXTRACT('MONTH'FROM submit_date) AS MTH
  , product_ID AS product
  , ROUND (AVG( starS),2) AS avg_stars
FROM reviews
group by EXTRACT('MONTH'FROM submit_date), product_ID
ORDER BY MTH, product_id;

--bai 5
SELECT 
  sender_id
  , COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = 8
GROUP  BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--BAI 6
SELECT 
    tweet_id
FROM Tweets
WHERE LENGTH (content) >15;

--bai 7
SELECT 
activity_date AS day
, count(DISTINCT user_id) as active_users
FROM Activity
GROUP BY activity_date
HAVING activity_date > '2019-06-27'

--BAI 8
select 
EXTRACT (MONTH FROM joining_date ) AS month
, COUNT (id) AS number_hire 
from employees
GROUP BY EXTRACT (MONTH FROM joining_date)
HAVING EXTRACT (MONTH FROM joining_date) BETWEEN 1 AND 6;

--bai 9
select 
first_name,
POSITION ('a' IN first_name)
from worker
WHERE first_name = 'Amitah';

-bai 10
select 
winery ,
SUBSTRING (title FROM LENGTH(winery) +2 FOR 4) AS YEAR
from winemag_p2;


