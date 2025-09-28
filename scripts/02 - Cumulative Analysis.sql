-- Calculate the total sales per month.
-- Calculate the running total of sales over time.


-- Total Sales per Month:
SELECT
	MONTH(order_date) AS order_month,	--We can also use the DATETRUNC function
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY SUM(sales_amount) DESC


-- Running Total of Sales over time:
SELECT
	order_month,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,		-- Window Function
	AVG(avg_price) OVER (ORDER BY order_month) AS moving_average_price			-- Window Function (this one calculates the moving average of the price)
FROM (
	SELECT
		MONTH(order_date) AS order_month,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY MONTH(order_date)
	)t
