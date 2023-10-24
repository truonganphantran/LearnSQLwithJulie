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


--
