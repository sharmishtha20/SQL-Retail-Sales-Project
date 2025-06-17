-- SQL A nalysis Retail Sales
CREATE DATABASE sql_p2;

--create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
			transactions_id INT,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,	
			cogs FLOAT,
			total_sale FLOAT

);

SELECT *
FROM retail_sales
LIMIT 10;

SELECT 
COUNT(*)
FROM retail_sales;

-- DELETING NULL VALUES
SELECT *
FROM retail_sales 
WHERE
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
;

DELETE FROM retail_sales
WHERE
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
;
--DATA EXPLORATION 
--how many sales we have?

SELECT COUNT(*) AS total_sale FROM retail_sales

--how many UNIQUE customer we have?

SELECT COUNT(DISTINCT customer_id) AS CUS FROM retail_sales

-- CATEGORY
SELECT COUNT(DISTINCT category) AS category FROM retail_sales;

-- data analysis
--.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sola is more than in
--month of Nov-2022
--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

--Q.1
SELECT*
FROM retail_sales
WHERE sale_date = '2022-11-05';

--2.
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4

--3
SELECT
	category,
	SUM (total_sale) AS net_sales,
		COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

--4
SELECT category , AVG(age)
FROM retail_sales
WHERE 
	category = 'Beauty'
GROUP BY 1;

--5
SELECT *
FROM retail_sales
WHERE
	total_sale > 1000;

-- 6
SELECT category ,
	   gender,
	   COUNT(*) AS total_trans
FROM retail_sales	
GROUP BY category, gender 
;

--7
SELECT 
	YEAR,
	MONTH,
	avg_sale
FROM
(
SELECT EXTRACT (YEAR from sale_date) AS YEAR,
	   EXTRACT (MONTH from sale_date) AS MONTH,
	   AVG(total_sale) AS avg_sale,
	   RANK() OVER (PARTITION BY EXTRACT (YEAR from sale_date) ORDER BY AVG(total_sale) DESC) AS RANK 
FROM retail_sales
GROUP BY 1,2
--ORDER BY 1,3 DESC;
) AS T1
WHERE 
	RANK= 1
;

--8
SELECT customer_id,
		SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

--9
SELECT COUNT(DISTINCT customer_id),category
FROM retail_sales
GROUP BY 2

 --10
WITH hourly_sales
AS
(
 SELECT
 	CASE
 		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift  				
FROM retail_sales
)
SELECT shift,
		COUNT(*) AS hourly_sale
FROM hourly_sales
GROUP BY 1
ORDER BY 1 DESC 	

--END--
		
