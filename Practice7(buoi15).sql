--BÀI 1
SELECT 
  EXTRACT(year FROM transaction_date) AS year
  , product_id
  , spend AS curr_year_spend
  , LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(year FROM transaction_date)) AS prev_year_spend
  , ROUND((spend - LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(year FROM transaction_date)))*100/LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(year FROM transaction_date)),2) AS yoy_rate
FROM user_transactions;

--BÀI 2
