--Beginner
--1. List the top 10 orders with the highest sales from the EachOrderBreakdown table.

SELECT TOP 10 * FROM EachOrderBreakdown
ORDER BY SALES DESC

--2. Show the number of orders for each product category in the EachOrderBreakdown table.

SELECT CATEGORY, COUNT(*) AS number_of_orders FROM EachOrderBreakdown
GROUP BY CATEGORY

--3. Find the total profit for each sub-category in the EachOrderBreakdown table.

SELECT subcategory, SUM(profit) AS Total_profit
FROM eachorderbreakdown
GROUP BY subcategory



--Intermediate

--1. Identify the customer with the highest total sales across all orders.


SELECT TOP 1 customername, SUM(sales) AS Total_sales
FROM OrdersList od
JOIN EachOrderBreakdown eo
ON od.OrderID = eo.OrderID
GROUP BY customername
ORDER BY Total_sales DESC



--2. Find the month with the highest average sales in the OrdersList table.

SELECT TOP 1 MONTH(orderdate) AS month, AVG(sales) AS average_sales
FROM orderslist od
JOIN eachorderbreakdown eo
ON eo.orderId = od.orderId
GROUP BY MONTH(ORDERDATE)
ORDER BY average_sales DESC



--3. Find out the average quantity ordered by customers whose first name starts with an alphabet
--'s'?


SELECT AVG(quantity) AS avg_q
FROM orderslist od
JOIN eachorderbreakdown eo
ON eo.orderId = od.orderId
WHERE customername LIKE 'S%'



--Advanced

--1. Find out how many new customers were acquired in the year 2014



WITH cte AS
(
SELECT CustomerName
FROM OrdersList
GROUP BY customername
HAVING YEAR(MIN(Orderdate)) = '2014'
)
SELECT COUNT(*) AS totalcustomers 
FROM cte

--2. Calculate the percentage of total profit contributed by each sub-category to the overall profit.

SELECT subcategory, SUM(profit) AS category_profit,
SUM(profit)/(SELECT SUM(profit) FROM EachOrderBreakdown) * 100 AS Percentage_category_profit
FROM EachOrderBreakdown
GROUP BY subcategory
ORDER BY category_profit DESC


--3. Find the average sales per customer, considering only customers who have made more than one
--order.

WITH cte AS (
SELECT customername,COUNT(sales) AS totalsales, AVG(sales) AS avg_sales
FROM OrdersList od
JOIN EachOrderbreakdown eo
ON od.OrderID = eo.OrderID
GROUP BY customername
)
SELECT CUSTOMERNAME, AVG_SALES
FROM cte
WHERE TOTALSALES > 1


--4. Identify the top-performing subcategory in each category based on total sales. Include the sub-
--category name, total sales, and a ranking of sub-category within each category.


SELECT category, subcategory, SUM(SALES) AS totalSales, 
RANK() OVER(PARTITION BY category ORDER BY SUM(sales) DESC) AS SubCategoryRank
FROM EachOrderBreakdown
GROUP BY category, subcategory
ORDER  BY category


