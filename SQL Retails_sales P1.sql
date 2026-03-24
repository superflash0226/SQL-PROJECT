-- Creating Retails Sales Table

CREATE TABLE retails_sales(

		transactions_id	INT PRIMARY KEY,
		sale_date	DATE,
		sale_time	TIME,
		customer_id	INT,
		gender	VARCHAR(10),
		age	INT,
		category VARCHAR(20),	
		quantiy	INT,
		price_per_unit INT,	
		cogs	FLOAT,
		total_sale FLOAT

);

SELECT * FROM retails_sales
LIMIT 12

SELECT COUNT(*) FROM retails_sales

-- DATA CLEANING

SELECT * FROM retails_sales
WHERE transactions_id IS NULL

SELECT * FROM retails_sales
WHERE sale_date IS NULL

SELECT * FROM retails_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
DELETE FROM retails_sales
where
	transactions_id IS NULL
 	OR
 	sale_date IS NULL
	OR
 	sale_time IS NULL
 	OR
 	customer_id IS NULL
	OR
 	gender IS NULL
 	OR
 	age IS NULL
 	OR
 	category IS NULL
 	OR
 	quantiy IS NULL
 	OR
 	price_per_unit IS NULL
 	OR
 	cogs IS NULL
 	OR
 	total_sale IS NULL;

-- DATA EXPLORATION

-- HOW MANY RECORDS WE HAVE
SELECT COUNT(*) AS total_records from retails_sales;

-- HOW MANY CUSTOMER WE HAVE
SELECT COUNT(DISTINCT customer_id) FROM retails_sales;

-- HOW MANY CATEGORY WE HAVE
SELECT DISTINCT category FROM retails_sales;

-- DATA ANALYSIS PROBLEM

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retails_sales
WHERE sale_date = '2022-11-02'

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--   and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retails_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantiy >= 4;

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) FROM retails_sales
GROUP BY 1;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT AVG(age) FROM retails_sales
WHERE category = 'Beauty';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retails_sales
WHERE total_sale >= 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT DISTINCT category, gender, COUNT(transactions_id) FROM retails_sales
GROUP BY category, gender;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
EXTRACT (YEAR FROM sale_date) AS year,
EXTRACT (MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sales
FROM retails_sales
GROUP BY 1,2
ORDER BY 1,2;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) from retails_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT customer_id) as cnt_unique_cs FROM retail_sales
GROUP BY category

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift