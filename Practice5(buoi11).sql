--bai 1

--bai 2
SELECT 
CAST (count(distinct emails.email_id) AS DECIMAL)/ (SELECT COUNT(distinct email_id) FROM emails )
FROM emails
INNER JOIN texts
ON emails.email_id = texts.email_id


