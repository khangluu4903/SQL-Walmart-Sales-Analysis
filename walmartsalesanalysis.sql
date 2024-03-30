### Data Wrangling ###

## Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

## Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

### Feature Engineering ### 

## Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

## Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

## Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

### Generic Questions ###

## How many unique cities does the data have?
SELECT 
	COUNT(DISTINCT city) AS number_of_unique_cities
FROM sales;

-- In which city is each branch?
SELECT 
	branch,
    city
FROM sales
GROUP BY city, branch;


### Product Questions ###

## How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line) AS number_of_product_lines
FROM sales;

## What is the most selling product line
SELECT
	product_line,
	SUM(quantity) as qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

## What is the total revenue by month
SELECT
	month_name AS month,
	ROUND(SUM(total),2) AS total_revenue
FROM sales
GROUP BY month;

## What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs DESC;

## What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

## What is the city with the largest revenue?
SELECT
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city 
ORDER BY total_revenue DESC;

## What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

## Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	product_line,
    ROUND(AVG(total),2) As avg_sales,
    (CASE
		WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN "Good"
        ELSE "Bad"
	END) AS Remarks
FROM sales
GROUP BY product_line;

## Which branch sold more products than average product sold?
WITH branch_product_counts AS (
    SELECT branch, SUM(quantity) AS total_products_sold
    FROM sales
    GROUP BY branch
),
average_products_sold AS (
    SELECT AVG(total_products_sold) AS avg_products_sold
    FROM branch_product_counts
)
SELECT branch, total_products_sold
FROM branch_product_counts
CROSS JOIN average_products_sold
WHERE total_products_sold > avg_products_sold;

## What is the most common product line by gender
WITH line_counts AS (
    SELECT gender, product_line, COUNT(*) AS frequency
    FROM sales
    GROUP BY gender, product_line
),
ranked_lines AS (
    SELECT gender, product_line, frequency,
           ROW_NUMBER() OVER(PARTITION BY gender ORDER BY frequency DESC) AS rn
    FROM line_counts
)
SELECT gender, product_line, frequency
FROM ranked_lines
WHERE rn = 1;

## What is the average rating of each product line
SELECT
	product_line,
	ROUND(AVG(rating), 2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


### Sales QUestions ###

## Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Tuesday"    # replace with desired day of the week
GROUP BY day_name,time_of_day
ORDER BY total_sales DESC;

## Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    ROUND(SUM(total),2) as revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

## Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
	city,
    AVG(tax_pct) as VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

## Which customer type pays the most in VAT?
SELECT 
	customer_type,
    AVG(tax_pct) as VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


### Customer Questions ###

## How many unique customer types does the data have?
SELECT 
	COUNT(DISTINCT customer_type) 
FROM sales;

## How many unique payment methods does the data have?
SELECT 
	COUNT(DISTINCT payment) 
FROM sales;

## What is the most common customer type?
SELECT
	customer_type,
    COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

## Which customer type buys the most?
SELECT
	customer_type,
    ROUND(SUM(total), 2) AS total_spent
FROM sales
GROUP BY customer_type
ORDER BY total_spent DESC;

## What is the gender of most of the customers?
SELECT 
	gender,
	COUNT(*) AS count
FROM sales
GROUP BY gender
ORDER BY count DESC;

## What is the gender distribution per branch?
SELECT 
	branch, gender,
	COUNT(*) AS count
FROM sales
GROUP BY branch, gender
ORDER BY branch;

## Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    AVG(rating) AS rating
FROM sales
GROUP BY time_of_day
ORDER BY rating DESC;

## Which time of the day do customers give most ratings per branch?
SELECT
	branch, time_of_day,
    AVG(rating) AS rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, time_of_day, rating DESC;

## Which day of the week has the best avg ratings?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

## Which day of the week has the best average ratings per branch?
SELECT branch, 
       day_name,
       avg_rating
FROM (
    SELECT 
        branch, 
        day_name,
        AVG(rating) AS avg_rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS row_num
    FROM sales
    GROUP BY branch, day_name
) AS subquery
WHERE row_num = 1;