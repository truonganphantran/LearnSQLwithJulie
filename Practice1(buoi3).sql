--BAI 1 
SELECT NAME
FROM CITY
WHERE POPULATION > 120000 AND COUNTRYCODE = 'USA';

--BAI 2
SELECT *
FROM CITY
WHERE COUNTRYCODE ='JPN';

--BAI 3
SELECT CITY
    , STATE
FROM STATION;

--BAI 4
SELECT DISTINCT CITY
FROM STATION
WHERE (CITY LIKE 'A%' 
    OR CITY LIKE 'E%' 
    OR CITY LIKE 'I%' 
    OR CITY LIKE 'O%' 
    OR CITY LIKE 'U%');

--BAI 5
SELECT DISTINCT CITY
FROM STATION
WHERE (CITY LIKE '%a' 
    OR CITY LIKE '%e' 
    OR CITY LIKE '%i' 
    OR CITY LIKE '%o' 
    OR CITY LIKE '%u');

--BAI 6
SELECT name
FROM Employee
ORDER BY name ASC;

--BAI 7
SELECT DISTINCT CITY
FROM STATION
WHERE (CITY NOT LIKE 'A%' 
    AND CITY NOT LIKE 'E%' 
    AND CITY NOT LIKE 'I%' 
    AND CITY NOT LIKE 'O%' 
    AND CITY NOT LIKE 'U%');

--BAI 8
SELECT name
FROM Employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id ASC;

--BAI 9
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

--BAI 10
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

--BAI 11
SELECT
    name
    , population
    , area
FROM World
WHERE area >= 300000
    AND population >= 25000000;

--BAI 12

--BAI 13
--BAI 14
--BAI 15

