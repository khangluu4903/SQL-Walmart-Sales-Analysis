# SQL-Walmart-Sales-Analysis

My goal for this personal project is to apply the SQL skills I self-taught by analyzing Walmart Sales data obtained from Kaggle. 
The dataset contains 17 columns and 1000 rows on three different Walmart branches in Myanmar. 

## Steps

1. **Data Wrangling:**

> 1. Build a database
> 2. Create table and insert the data from csv.

2. **Feature Engineering:** 

> 1. Add new column named `time_of_day` to determine whether the sales happened in the Morning, Afternoon or Evening.

> 2. Add new column named `day_name` where I extracted the day of the week when the transaction took place (Mon, Tue, Wed, Thur, Fri).

> 3. Add new column named `month_name` where I extracted the month when the transaction took place (Jan, Feb, Mar). 

2. **Exploratory Data Analysis (EDA):** Wrote queries to answer the following questions. 

### Generic Questions

1. How many unique cities does the data have?
2. In which city is each branch?

### Product Questions

1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
5. What is the city with the largest revenue?
6. What product line had the largest VAT?
7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
8. Which branch sold more products than average product sold?
9. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales Questions

1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent?
4. Which customer type pays the most in VAT?

### Customer Questions

1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?
