# Retail Sales Analysis with PostgreSQL

The project showcases SQL skills for data analytics, focusing on exploring, cleaning, and analyzing retail sales data through database setup, exploratory data analysis (EDA), and SQL queries to answer business questions.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM retail_sales;
SELECT COUNT(*) AS total_sales FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05':**
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:**
```sql
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category:**
```sql
SELECT 
	category,
	SUM(total_sale) AS Sales_per_Category,
	COUNT(transactions_id) AS Total_transactions
FROM retail_sales
GROUP BY 
	category
ORDER BY Sales_per_Category DESC
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:**
```sql
SELECT
	category,
	ROUND(AVG(age), 2) as Avg_age
FROM retail_sales
WHERE
	category = 'Beauty'
GROUP BY
		category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000:**
```sql
SELECT * 
FROM retail_sales
WHERE
	total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:**
```sql
SELECT
	category,
	gender,
	COUNT(transactions_id)
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:**
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales:**
```sql
SELECT
	customer_id,
	SUM(total_sale) AS Purchased_Amount
FROM retail_sales
GROUP BY
	customer_id
ORDER BY 
	Purchased_Amount DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category:**
```sql
SELECT
	category,
	COUNT(DISTINCT customer_id) AS Unique_Customers
FROM retail_sales
GROUP BY
	category
ORDER BY
	Unique_Customers DESC;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening > 17):**
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
