CREATE DATABASE Superstore;

SELECT * FROM dbo.train;

--Task 1: High-Value Order Identification
--Finance wants to review unusually high-value orders.
--Write a query to fetch all orders where sales are greater than the overall average sales.

SELECT 
	Order_ID,
	Sales
FROM dbo.train
where Sales>(
	SELECT AVG(Sales)
	FROM dbo.train);

--Task 2: City-Level Revenue Concentration
--Management believes that revenue is concentrated in a small number of cities.
--Write a query to retrieve the top 5 cities by total sales, ordered from highest to lowest.

SELECT TOP(5)
	city,
	SUM(Sales) as Total_Sales
FROM dbo.train
GROUP BY city
ORDER BY Total_Sales DESC;

--Task 3: Customer Purchase Behavior
--Marketing wants to identify repeat customers.
--Write a query to find customers who have placed more than 5 orders, along with their total sales.

SELECT	
	Customer_ID,
	COUNT(Order_ID) as order_count,
	SUM(Sales) as Total_Sales
FROM dbo.train
GROUP BY Customer_ID
HAVING COUNT(Order_ID) >5;

--Task 4: Segment Performance Analysis
--Leadership wants to compare customer segments.
--Write a query to calculate total sales and total number of orders for each segment, sorted by total sales.

SELECT
	Segment,
	SUM(Sales) AS total_sales,
	COUNT(Order_ID) AS total_orders
FROM dbo.train
GROUP BY Segment
ORDER BY SUM(Sales) DESC;

--Task 5: Shipping Delay Detection
--Operations wants to detect shipment delays.
--Write a query to identify orders where the shipping duration exceeds 4 days
 --(Ship_Date minus Order_Date greater than 4).

SELECT	
	Order_ID,
	DATEDIFF (DAY,Order_Date,Ship_Date) AS duration
FROM dbo.train
WHERE DATEDIFF (DAY,Order_Date,Ship_Date) >4;

--Task 6: Ship Mode Utilization
--Logistics wants to understand how shipping modes are being used.
--Write a query to calculate the percentage contribution of each ship mode based on the total number of orders.

SELECT 
	Ship_Mode,
	COUNT(*) AS total_orders,
	ROUND(
		COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2)AS percentage_contribution
	FROM dbo.train
	GROUP BY Ship_Mode
	ORDER BY percentage_contribution DESC;




--Task 7: City-Level Sales Ranking
--Sales leadership wants comparative insights at the city level.
--Write a query to rank cities within each country based on total sales using a window function.

SELECT 
	Country,
	City,
	SUM(Sales) AS Total_Sales,
RANK() OVER (
        PARTITION BY Country
        ORDER BY SUM(Sales) DESC
    ) AS City_Rank
FROM dbo.train
GROUP BY Country, City

--Task 8: Monthly Order Trend
--Management wants to analyze order volume trends over time.
--Write a query to calculate the number of orders per month, grouped by year and month using Order_Date.

SELECT
	YEAR(Order_Date) AS order_year,
	MONTH(Order_Date) AS order_month,
	COUNT(Order_ID) AS total_Orders
FROM dbo.train
GROUP BY
	YEAR(Order_Date),
	MONTH(Order_Date)
ORDER BY	
	order_year,
	order_month
	
--Task 9: Data Quality Validation
--Data engineering suspects data inconsistencies.
--Write a query to identify orders where the ship date is earlier than the order date.

SELECT
    Order_ID,
    Order_Date,
    Ship_Date,
    Ship_Mode
FROM dbo.train
WHERE Ship_Date < Order_Date;