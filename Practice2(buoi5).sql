--bai 1
SELECT DISTINCT CITY
FROM STATION
WHERE MOD(ID,2) = 0;

--bai 2
SELECT 
COUNT(CITY) - COUNT(DISTINCT CITY) 
FROM STATION;

--bai4
SELECT
ROUND (cast (sum (item_count*order_occurrences)/sum (order_occurrences) as decimal),1) AS total
FROM items_per_order;

--bai 5
SELECT candidate_id 
FROM candidates
GROUP BY candidate_id
having COUNT(CASE WHEN skill IN ( 'Python', 'Tableau', 'PostgreSQL') then skill
END ) = 3


--bai 6
SELECT 
  user_id , date_part ('day', Max(post_date) - Min(post_date)) AS DAYS
FROM posts
WHERE  post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT (post_id) >= 2;

--bai 7
SELECT 
card_name,
max(issued_amount) - min(issued_amount) as numdiff
FROM monthly_cards_issued
GROUP BY card_name

--bai 8
SELECT 
manufacturer
, abs (sum(total_sales  - cogs) )as loss
FROM pharmacy_sales
WHERE (total_sales)<(cogs) 
GROUP BY manufacturer
ORDER BY abs (sum ((total_sales)-(cogs))) DESC

--bai 9


