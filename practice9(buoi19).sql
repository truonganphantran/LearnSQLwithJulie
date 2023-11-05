create table SALES_DATASET_RFM_PRJ_1
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 



--1)	Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj_1
ALTER COLUMN  orderdate     type timestamp USING (orderdate ::timestamp),
ALTER COLUMN  ordernumber TYPE int USING (ordernumber ::int),
ALTER COLUMN  quantityordered TYPE INT USING ( quantityordered ::int),
ALTER COLUMN  priceeach       TYPE FLOAT USING ( priceeach    :: float ),
ALTER COLUMN  orderlinenumber TYPE INT USING (orderlinenumber ::int),
ALTER COLUMN  sales           TYPE FLOAT USING ( sales    :: float ),
ALTER COLUMN  msrp             TYPE INT USING (msrp ::int)


--2)	Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT *
FROM SALES_DATASET_RFM_PRJ_1
WHERE 
ORDERNUMBER IS NULL 
OR QUANTITYORDERED IS NULL 
OR PRICEEACH IS NULL 
OR ORDERLINENUMBER IS NULL 
OR SALES IS NULL 
OR ORDERDATE IS NULL 
--> KHÔNG CÓ DÒNG NÀO BỊ NULL TRONG CÁC CỘT TRÊN



/*3)	Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
Gợi ý: ( ADD column sau đó INSERT) 
*/
ALTER TABLE SALES_DATASET_RFM_PRJ_1
ADD COLUMN  contactfirstname VARCHAR ,
ADD COLUMN  contactlastname VARCHAR 
update SALES_DATASET_RFM_PRJ_1 set
contactfirstname = INITCAP(LEFT( contactfullname, POSITION('-' IN contactfullname) -1 )),
contactlastname = INITCAP( RIGHT( contactfullname, LENGTH(contactfullname) - POSITION('-' IN contactfullname) ));


/*
4)	Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */
ALTER TABLE  SALES_DATASET_RFM_PRJ_1
ADD COLUMN QTR_ID INT
,ADD COLUMN MONTH_ID INT
,ADD COLUMN YEAR_ID INT
UPDATE SALES_DATASET_RFM_PRJ_1
SET QTR_ID =EXTRACT(QUARTER FROM ORDERDATE) 
, MONTH_ID = EXTRACT(MONTH FROM ORDERDATE) 
, YEAR_ID = EXTRACT(YEAR FROM ORDERDATE) 


/*
5)	Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
*/ 
SELECT *
FROM SALES_DATASET_RFM_PRJ_1

--cách 1
WITH CTE1 AS (SELECT QUANTITYORDERED
					, (SELECT AVG(QUANTITYORDERED) FROM SALES_DATASET_RFM_PRJ_1) AS avg
					, (SELECT STDDEV(QUANTITYORDERED) FROM SALES_DATASET_RFM_PRJ_1) AS std
			 FROM SALES_DATASET_RFM_PRJ_1
),
outlier AS (SELECT QUANTITYORDERED
			FROM CTE1
			WHERE (QUANTITYORDERED-avg)/std > 2
		   )
DELETE FROM SALES_DATASET_RFM_PRJ_1
WHERE QUANTITYORDERED IN (SELECT QUANTITYORDERED FROM outlier)


--CÁCH 2
WITH interquatile AS 	
(SELECT 
	  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY  QUANTITYORDERED) AS Q1
	 , PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY  QUANTITYORDERED) AS Q3
	 , PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY  QUANTITYORDERED) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY  QUANTITYORDERED) AS IQR
 FROM SALES_DATASET_RFM_PRJ_1
)
 , outlier AS (SELECT  *
			 FROM SALES_DATASET_RFM_PRJ_1
			 WHERE QUANTITYORDERED < (SELECT  Q1-1.5*IQR FROM  interquatile) OR
					QUANTITYORDERED >( SELECT  Q3+1.5*IQR FROM  interquatile )
				)
DELETE FROM SALES_DATASET_RFM_PRJ_1
WHERE QUANTITYORDERED IN (SELECT QUANTITYORDERED FROM outlier)


/*6)	Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
Lưu ý: với lệnh DELETE ko nên chạy trước khi bài được review
*/

CREATE OR REPLACE VIEW SALES_DATASET_RFM_PRJ_CLEAN AS (
     WITH interquatile AS 	
(SELECT 
	  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY  QUANTITYORDERED) AS Q1
	 , PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY  QUANTITYORDERED) AS Q3
	 , PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY  QUANTITYORDERED) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY  QUANTITYORDERED) AS IQR
 FROM SALES_DATASET_RFM_PRJ_1
)
 , outlier AS (SELECT  *
			 FROM SALES_DATASET_RFM_PRJ_1
			 WHERE QUANTITYORDERED < (SELECT  Q1-1.5*IQR FROM  interquatile) OR
					QUANTITYORDERED >( SELECT  Q3+1.5*IQR FROM  interquatile )
				)
DELETE FROM SALES_DATASET_RFM_PRJ_1
WHERE QUANTITYORDERED IN (SELECT QUANTITYORDERED FROM outlier)
);
