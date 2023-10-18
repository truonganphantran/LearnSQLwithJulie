--bai 1
SELECT  
SUM(CASE WHEN  device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
SUM(CASE WHEN device_type IN ( 'tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership

--bai 2
SELECT x,y,z,
CASE WHEN x+y>z AND y+z>x AND z+x>y THEN 'yes'
ELSE 'no'
end AS triagle
FROM Triangle

--bai 3
---bài bị lỗi không có data
SELECT 
SUM(CASE WHEN (call_category ='n/a' OR call_category IS NULL) THEN 1 ELSE 0 END) /cast( COUNT(policy_holder_id)  AS DECIMAL) 
FROM callers;

--bài 4
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

--bài 5
select 
CASE WHEN pclass = 1 then 'first_class'
 WHEN pclass = 2 then 'second_class'
 WHEN pclass = 3 then 'third_class'
 end as clss
 ,count (CASE WHEN survived = 1 THEN passengerid  END) AS survivors
, count (CASE WHEN survived = 0 THEN passengerid END) AS non_survivors
from titanic
GROUP BY 
 pclass


