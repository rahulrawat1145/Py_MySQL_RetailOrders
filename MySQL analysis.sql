# Creating the database and populating the table with values using import wizard

SELECT *
FROM orders
WHERE ship_mode IS NULL OR ship_mode = '';

# Updating blank values to null

UPDATE orders
SET ship_mode = NULL
WHERE ship_mode = '';

SELECT * FROM orders;

-- Q1. Find top 10 highest revenue generating products
 
  SELECT 
    product_id,
    ROUND(SUM(sale_price),2) AS sales
FROM 
	orders
Group BY product_id
Order by sales DESC
LIMIT 10;

 -- Q2. Find top 5 highest selling products in each region
 
 SELECT distinct region
 FROM orders;
 
 WITH CTE AS(
SELECT 
    region,
    product_id,
    ROUND(SUM(sale_price),2) AS sales
FROM 
	orders
Group BY region, product_id)
SELECT * 
FROM (
SELECT 
	*,
    row_number() over(
						partition by region
						order by sales DESC) as rn
FROM cte) A 
WHERE rn<=5;

 
 -- Q3. Find month over month growth comparision for 2022 and 2023 sales. Eg for jan 2022 Vs jan 2023
 
 
WITH cte AS (
SELECT 
	YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sale_price) AS sales
FROM orders
GROUP BY 1,2
ORDER BY 1,2)
SELECT 
	order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_in_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_in_2023
FROM cte
GROUP BY order_month
ORDER BY order_month ;
 
 
-- Q4) For each category which month has maximum sales?
 
 WITH cte  AS(
 SELECT 
	category,
	YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sale_price) as sales
 FROM orders
 GROUP BY category, YEAR(order_date), MONTH(order_date) 
 -- ORDER BY category, YEAR(order_date), MONTH(order_date) 
 )
 SELECT * FROM(
 SELECT *,
		row_number() OVER ( PARTITION BY category ORDER BY sales DESC) as rn
FROM cte) a
WHERE rn = 1;
 
