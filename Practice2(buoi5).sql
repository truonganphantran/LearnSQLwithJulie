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
