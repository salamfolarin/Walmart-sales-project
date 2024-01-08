CREATE DATABASE IF NOT EXISTS walmartsalesdata;

CREATE TABLE IF NOT EXISTS transactions(
    invoice_id varchar(30) NOT NULL PRIMARY KEY,
    branch varchar (5) NOT NULL,
    city varchar (30) NOT NULL,
    customer_type varchar (30) NOT NULL,
    gender varchar(10) NOT NULL,
    product_line varchar (100) NOT NULL,
    unit_price decimal (10) NOT NULL,
    quantity int NOT NULL,
    VAT float  NOT NULL,
    total DECIMAL( 12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR (15) NOT NULL,
    cogs DECIMAL (10, 2) NOT NULL,
    gross_margin_pct FLOAT NOT NULL,
    gross_income DECIMAL (12, 4) NOT NULL,
    rating FLOAT
);













-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------ Feature Engineering -----------------------------------------------------------------------------

SELECT DISTINCT
    time,
    (CASE 
        WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "afternoon"
        ELSE "Evening"
       END )AS time_of_data
FROM transactions
LIMIT 10;

ALTER TABLE transactions ADD COLUMN time_of_day VARCHAR(20);

UPDATE transactions
SET time_of_day = (CASE 
        WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "morning"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "afternoon"
        ELSE "Evening"
  END
 );

SELECT COUNT(*) AS total_rows
FROM walmartsalesdata.transactions


-- Day_Name------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	date,
    DAYNAME(date) AS day_name
FROM transactions;

ALTER TABLE transactions ADD COLUMN day_name VARCHAR (10);

UPDATE transactions
SET day_name = DAYNAME(date);

-- month_name

SELECT 
     date,
     MONTHNAME(date)
FROM transactions;

ALTER TABLE  transactions ADD COLUMN month_name VARCHAR(10);

UPDATE transactions
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------GENERIC---------------------------------------------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT
     DISTINCT city 
FROM transactions;

-- How many unique branches does the data have 
SELECT
     DISTINCT branch
FROM transactions;
 
 
 -- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- -------------------------------------------------------------------PRODUCTS----------------------------------------------------------------------------------------------
 -- ----------------------------------How many unique product line does a data have 
 


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------Most common payment method-------------------------------------------------------------


SELECT 
    payment_method,
    COUNT(payment_method) AS method_count
FROM transactions
GROUP BY payment_method
ORDER BY method_count DESC;

-- ------------------------------------ What is the most selling product line?
SELECT 
    product_line,
    COUNT(product_line) AS pdl
FROM transactions
GROUP BY product_line
ORDER BY pdl DESC;

-- ------------------------------------------- What is the total revenue by month?
SELECT
     month_name AS month,
     SUM(totAL) AS total_revenue
FROM transactions
GROUP BY month_name
ORDER BY total_revenue DESC; 

-- -------------------------Month with the highest COGS?


SELECT 
     month_name AS MONTH,
     SUM(cogs) AS cogs
FROM transactions
GROUP BY month_name
ORDER BY cogs DESC;

-- -----------------------What product line has the highest revenue?
SELECT 
      product_line, 
      SUM(total) AS total_revenue
FROM transactions
GROUP BY product_line
ORDER BY total_revenue DESC;

-- -------------------------- What city has the largest revenue?
SELECT 
      city, 
      SUM(total) AS total_revenue
FROM transactions
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- ---------------------Whta product line has the highest VAT (value added tax)
SELECT 
     product_line,
     AVG(VAt)AS avg_tax
FROM transactions
GROUP BY product_line
ORDER BY avg_tax DESC;

-- ------------- what branch sold more products than average product sold?
SELECT 
     branch,
     SUM(quantity) AS qty
FROM transactions
GROUP BY branch 
HAVING SUM(quantity) > (select AVG(quantity) FROM transactions);

-- ------------------------ Most product line by gender 
SELECT 
     gender
     product_line,
     COUNT(gender) AS total_cnt
FROM transactions
GROUP BY gender, product_line
ORDER BY total_cnt DESC;


-- -------------------------Average rating of each product line?
SELECT
      ROUND (AVG(rating), 2) AS avg_rating,
      product_line
FROM transactions
GROUP BY product_line
ORDER BY avg_rating DESC;





