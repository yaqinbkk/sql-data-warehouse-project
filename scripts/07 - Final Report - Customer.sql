/*
=============================================================================================================================================================
CUSTOMER REPORT
=============================================================================================================================================================
Purpose:

	- This report consolidates key customer metrics and behaviors


Highlights:

	1. Gathers essential fields such as names, ages and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:

		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)

	4. Calculates valuable Key Performance Indicators (KPI):

		- recency (months since last order)
		- average order value
		- average monthly spent

=============================================================================================================================================================
*/

 CREATE VIEW gold.report_customers AS	-- Final phase of the report, we put it in a view
 WITH base_query AS (					-- CTE #1 for the main fields
 SELECT
 s.order_number,
 s.product_key,
 s.order_date,
 s.sales_amount,
 s.quantity,
 c.customer_key,
 c.customer_number,
 CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
 DATEDIFF(year, c.birthdate, GETDATE()) AS age
 FROM gold.fact_sales AS s
 LEFT JOIN gold.dim_customers AS c
 ON s.customer_key = c.customer_key
 WHERE order_date IS NOT NULL
 )
 , customer_aggregation AS (			-- CTE #2 for the customer aggregation
 SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_month
 FROM base_query
 GROUP BY
	customer_key,
	customer_number,
	customer_name,
	age
)
SELECT									-- Final Query
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Under 20'
	 WHEN age BETWEEN 20 AND 29 THEN '20-29'
	 WHEN age BETWEEN 30 AND 39 THEN '30-39'
	 WHEN age BETWEEN 40 AND 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE WHEN lifespan_month >= 12 AND total_sales > 5000 THEN 'VIP'
	 WHEN lifespan_month >= 12 AND total_sales <= 5000 THEN 'Regular'
	 ELSE 'New'
END AS customer_segment,
last_order,
DATEDIFF(month, last_order, GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan_month,
-- Compute the average order value (AVO)
total_sales / total_orders AS avg_order_value,
-- Compute the average monthly spent
CASE WHEN lifespan_month = 0 THEN total_sales
	 ELSE total_sales / lifespan_month
END AS avg_monthly_spent
FROM customer_aggregation