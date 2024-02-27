CREATE DATABASE walmart;
CREATE TABLE walmart_sales(invoice_id VARCHAR(30) PRIMARY KEY,
         branch VARCHAR(5) NOT NULL,
         city VARCHAR(50) NOT NULL,
         customer_type VARCHAR(50) NOT NULL,
         gender VARCHAR(25) NOT NULL,
         product_line VARCHAR(255) NOT NULL,
         unit_price DECIMAL(10, 2) NOT NULL,
         quantity INT NOT NULL,
         VAT FLOAT(6, 4) NOT NULL,
         total DECIMAL(10, 2) NOT NULL,
         date date NOT NULL,
         time time NOT NULL,
         payment_method VARCHAR(50) NOT NULL,
         cogs DECIMAL(10, 2) NOT NULL,
         gross_margin_percentage FLOAT(11, 9) NOT NULL,
         gross_income DECIMAL(10, 2) NOT NULL,
         rating FLOAT(2, 1) NOT NULL
         );
	-- -------------------------------------------
    -- ----- FEATURE ENGINEERIG------------------
    --   now adding new column with name time_of_day 
    ALTER TABLE walmart_sales
    ADD COLUMN time_of_day VARCHAR(25);

-- NOW ADDING VALUES

UPDATE walmart_sales
SET time_of_day = (
CASE
WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
WHEN time BETWEEN '12:00:00' AND '16:00:00' THEN 'afternoon'
ELSE 'evening'
END);
-- -----------------------------
-- ADDING COLUMN NAME DAY_NAME ----
ALTER TABLE walmart_sales
ADD COLUMN day_name VARCHAR(20);

UPDATE walmart_sales
SET day_name = DAYNAME(date);

-- -----------------------------
-- adding new column month of year
ALTER TABLE walmart_sales
ADD COLUMN month VARCHAR(20);
UPDATE walmart_sales
SET month = MONTHNAME(date);

-- ------- find number of unique cities and unique branch in that city ------------
SELECT DISTINCT city,branch
from walmart_sales; -- only three cities
-- -----------------------------
-- PRODUCT QUESTIONS ---------------

-- Q1 How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) from walmart_sales;

-- Q2. What is the most common payment method? --- 
SELECT payment_method ,count(payment_method) as count from walmart_sales
GROUP BY payment_method
ORDER BY count DESC
LIMIT 1;

-- Q3. What is the most selling product line?
SELECT product_line,count(product_line) as count  from walmart_sales
GROUP BY product_line
ORDER BY count DESC
LIMIT 1;

-- Q4. What is the total revenue by month?
SELECT month,SUM(total) as revenue from walmart_sales
group by month
ORDER BY revenue DESC;

-- Q5. WHICH  month had the largest COGS?
SELECT month, SUM(cogs) AS largest_cogs FROM walmart_sales
GROUP BY month 
ORDER BY largest_cogs DESC LIMIT 1;

-- Q6. WhICH product line had the largest revenue?
SELECT product_line,SUM(total) as revenue  from walmart_sales
GROUP BY product_line
ORDER BY revenue DESC
LIMIT 1;
-- Q7. What is the city with the largest revenue?
SELECT city,SUM(total) as city_revenue FROM walmart_sales
GROUP BY city
ORDER BY city_revenue DESC
LIMIT 1;
-- Q8. which product line had the largest VAT?
SELECT product_line,SUM(VAT) as VAT  from walmart_sales
GROUP BY product_line
ORDER BY VAT DESC
LIMIT 1;
-- Q9 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT product_line,avg(quantity),
CASE
    WHEN AVG(quantity) > 6 THEN 'Good'
    ELSE 'Bad'
    END AS checked
FROM walmart_sales
GROUP BY product_line,quantity;

            
-- Q10. Which branch sold more products than average product sold?
SELECT branch,SUM(quantity) AS quantity FROM walmart_sales
GROUP BY branch
HAVING SUM(quantity) > AVG(quantity) ;

-- Q11. What is the most common product line by gender?
SELECT gender,product_line,count(product_line) from walmart_sales
group by product_line,gender
ORDER BY count(product_line) DESC;
-- ---------------------------------------

-- Q12. What is the average rating of each product line?
SELECT product_line,ROUND(AVG(rating),2) as Avg_rating FROM walmart_sales
GROUP BY product_line
ORDER BY Avg_rating DESC;
-- --------------------------------------------------------------------

-- --------------------------- SALES'S QUERRY ---------------------------

-- Q1.Number of sales made in each time of the day per weekend?
SELECT time_of_day, COUNT(*) 
FROM walmart_sales
WHERE day_name = 'Sunday'
group by time_of_day

ORDER BY COUNT(*) DESC;
-- ------------------------------
-- Q2.Which of the customer types brings the most revenue?

SELECT customer_type,SUM(total) AS revenu 
FROM walmart_sales
GROUP BY customer_type
ORDER BY revenu DESC;
-- ------------------------------------

-- Q3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city ,ROUND(AVG(VAT),2) AS avg_tax
FROM walmart_sales
GROUP BY city
ORDER BY avg_tax DESC;
-- ----------------------------------
-- Q4.Which customer type pays the most in VAT?
SELECT customer_type,SUM(VAT) AS most_pay_tax
FROM walmart_sales
GROUP BY customer_type
ORDER BY most_pay_tax;
--  --------------------------------------
--  --------------------------------------

-- CUSTOMER'S QUERRY ----------------------------
-- Q1. How many unique customer types does the data have?
SELECT customer_type,COUNT(customer_type) as number_customers
FROM walmart_sales
GROUP BY customer_type;
-- --------------------

-- Q2. How many unique payment methods does the data have?
SELECT payment_method,COUNT(payment_method) as number_payment_method
FROM walmart_sales
GROUP BY payment_method;

-- -------------------------------------------
-- Q3. What is the most common customer type?

SELECT customer_type,COUNT(customer_type) as number_customers
FROM walmart_sales
GROUP BY customer_type
ORDER BY number_customers DESC
LIMIT 1;
-- --------------------------------------
-- Q4. Which customer type buys the most quantity?
SELECT customer_type,SUM(quantity) AS buy_most
FROM walmart_sales
GROUP BY customer_type 
ORDER BY buy_most
limit 1;

-- ------------------------------------------
-- Q5. What is the gender of most of the customers?
SELECT gender,COUNT(gender) as number_gender
FROM walmart_sales
GROUP BY gender
ORDER BY number_gender DESC
LIMIT 1;
-- -----------------------
-- Q6. What is the gender distribution per branch?
SELECT branch,gender,COUNT(gender) AS gender_number
FROM walmart_sales
GROUP BY branch,gender
ORDER BY branch;
-- ----------------------------------

-- Q7. Which time of the day do customers give most ratings?
SELECT time_of_day,AVG(rating) AS ratings
from walmart_sales
GROUP BY time_of_day
ORDER BY ratings DESC
LIMIT 1;
-- ------------------------

-- Q8. Which time of the day do customers give most ratings per branch?
SELECT branch,time_of_day,AVG(rating) AS ratings
from walmart_sales
GROUP BY branch,time_of_day
ORDER BY branch;

-- ---------------------------------------
-- Q9. Which day fo the week has the best avg ratings?
SELECT day_name,ROUND(AVG(rating),2) AS avg_rating
FROM walmart_sales
GROUP BY day_name
ORDER BY avg_rating DESC
LIMIT 1;
-- -----------------------------------
-- Q10. Which day of the week has the best average ratings per branch?

SELECT branch,day_name,(ROUND(AVG(rating),2)) AS avg_rating
FROM walmart_sales

GROUP BY branch, day_name
ORDER BY AVG(rating) DESC
LIMIT 3;
-- ------------------






