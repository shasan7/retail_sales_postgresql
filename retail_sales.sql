-- Create the Table

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);


--Check after import
-- Record Count: Determine the total number of records in the dataset
-- Customer Count: Find out how many unique customers are in the dataset
-- Category Count: Identify all unique product categories in the dataset


SELECT * FROM retail_sales;

SELECT COUNT(*) AS total_sales FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;


-- Data cleaning
-- Null Value Check: Check for any null values in the dataset and delete records with missing data

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR total_sale IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR total_sale IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


-- Starting analytics to answer business questions

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Write a SQL query to retrieve the quantity of sales made on '2022-11-05' for the 'Clothing' category

SELECT
	category,
	SUM(quantity)
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
GROUP BY 
	category;


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and
-- the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;


-- Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT 
	category,
	SUM(total_sale) AS Sales_per_Category,
	COUNT(transactions_id) AS Total_transactions
FROM retail_sales
GROUP BY 
	category
ORDER BY Sales_per_Category DESC


-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT
	category,
	ROUND(AVG(age), 2) as Avg_age
FROM retail_sales
WHERE
	category = 'Beauty'
GROUP BY
		category;


-- Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * 
FROM retail_sales
WHERE
	total_sale > 1000


-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT
	category,
	gender,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	TO_CHAR(sale_date, 'YYYY-MM') AS Year_Month,
	AVG(total_sale) AS Sales_Avg
FROM retail_sales
GROUP BY
	Year_Month
ORDER BY
	Year_Month


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	Year,
	Month,
	Sales_Avg
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS Year,
		EXTRACT(MONTH FROM sale_date) AS Month,
		AVG(total_sale) AS Sales_Avg,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY
		Year, Month
) AS ranks
WHERE rank = 1;


-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT
	customer_id,
	SUM(total_sale) AS Purchased_Amount
FROM retail_sales
GROUP BY
	customer_id
ORDER BY 
	Purchased_Amount DESC
LIMIT 5;


-- Write a SQL query to find the number of unique customers who purchased items from each category

SELECT
	category,
	COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_sales
GROUP BY
	category
ORDER BY
	Unique_Customers DESC;


-- Write a SQL query to create each shift and number of orders 
-- Example: Morning <12, Afternoon Between 12 & 17, Evening >17

WITH sales_per_shift AS
	(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS Shift
	FROM retail_sales
	)

SELECT
	Shift,
	COUNT(transactions_id) AS Orders
FROM sales_per_shift
GROUP BY Shift
ORDER BY Orders DESC