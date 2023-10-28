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

--
