--BÀI 1
SELECT 
  EXTRACT(year FROM transaction_date) AS year
  , product_id
  , spend AS curr_year_spend
  , LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(year FROM transaction_date)) AS prev_year_spend
  , ROUND((spend - LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(year FROM transaction_date)))*100/LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(year FROM transaction_date)),2) AS yoy_rate
FROM user_transactions;

--BÀI 2
SELECT *
FROM
(SELECT
card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS amount
FROM monthly_cards_issued) AS table1
GROUP BY card_name, amount

--bài 3
SELECT user_id
  ,spend 
  , transaction_date
FROM  (SELECT 
  user_id
  ,spend
  ,ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as thutu
  , transaction_date
FROM transactions) AS subtable
WHERE thutu = '3';

--bài 4
SELECT *
FROM (
SELECT 
  FIRST_VALUE(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as trans_date
  , user_id
  , COUNT(product_id) OVER (PARTITION BY user_id) as purchase_count
FROM user_transactions) AS subtable
GROUP BY user_id, trans_date, purchase_count

--BÀI 5
WITH CTE1 AS (SELECT 
  user_id
  , tweet_date
  , tweet_count
  , LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) AS count_1
  ,LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) AS COUNT_2
FROM tweets)
SELECT user_id
  , tweet_date
  , tweet_count
  , CASE WHEN count_1 IS NULL THEN tweet_count
         WHEN count_2 IS NULL THEN ROUND (CAST((count_1+tweet_count) AS DECIMAL)/2,2)
         ELSE ROUND (CAST((tweet_count+count_1+count_2) AS DECIMAL)/3,2)
         END AS rolling_avg_3d
         FROM CTE1

--bài 6

