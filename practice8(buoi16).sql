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
