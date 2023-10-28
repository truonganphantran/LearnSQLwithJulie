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
SELECT
 COUNT (case when time_between  <=CAST( '00:10:00' AS TIME) THEN amount END) AS payment_count
 FROM (SELECT 
    merchant_id
    , credit_card_id	
    , transaction_timestamp
    , amount
    , LAG(transaction_timestamp) OVER(PARTITION BY merchant_id
              , credit_card_id, amount	) AS trans_time
    ,   transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id
              , credit_card_id, amount)	 AS time_between
FROM transactions) AS SUBTABLE

--BÀI 7
WITH CTE1 AS (SELECT category
  , product
   , DENSE_RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rank
   , total_spend
FROM (
SELECT 
  category
  , product
  , spend
  , SUM(spend) OVER(PARTITION BY category, product ORDER BY category) AS total_spend
FROM product_spend) AS table1
GROUP BY category , product, total_spend
  )
SELECT category
  , product
  ,total_spend
FROM CTE1
WHERE rank <3

--bài 8
WITH CTE1 AS (SELECT * 
FROM artists
INNER JOIN songs
ON artists.artist_id= songs.artist_id
INNER JOIN global_song_rank
ON global_song_rank.song_id = songs.song_id
ORDER BY name, rank)
,
 CTE2 AS (SELECT artist_name
     , COUNT(artist_name) 
      , DENSE_RANK() OVER(ORDER BY COUNT(artist_name) DESC) AS artist_rank
  FROM CTE1
  WHERE rank < 11
  GROUP BY artist_name) 
  
SELECT artist_name
        , artist_rank
FROM CTE2 
WHERE artist_rank <6
