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
