/*
=============================================================================================================================================================
PRODUCT REPORT
=============================================================================================================================================================
Purpose:

	- This report consolidates key product metrics and behaviors


Highlights:

	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range and Low-Performers.
	3. Aggregates product-level metrics:

		- total orders
		- total sales
		- total quantity sold
		- total products (unique)
		- lifespan (in months)

	4. Calculates valuable Key Performance Indicators (KPI):

		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue

=============================================================================================================================================================
*/
CREATE VIEW gold.report_products AS
WITH base_query AS (
SELECT
s.order_number,
s.order_date,
s.sales_amount,
s.quantity,
s.price,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
)

, product_aggregation AS(
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	COUNT(order_number) AS total_orders,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_month,
	COUNT(DISTINCT product_key) AS total_products,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(price AS FLOAT)), 2) AS avg_price,
	ROUND(AVG(CAST(cost AS FLOAT)), 2) AS avg_cost
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory
)

SELECT
	product_key,
	product_name,
	category,
	subcategory,
	total_orders,
	total_sales / total_orders AS avg_order_revenue,
	last_order,
	DATEDIFF(month, last_order, GETDATE()) AS recency,
	lifespan_month,
	CASE WHEN lifespan_month = 0 THEN total_sales
		 ELSE total_sales / lifespan_month
	END AS avg_monthly_revenue,
	total_products,
	total_sales,
	CASE WHEN total_sales > 1000000 THEN 'High Performer'
		 WHEN total_sales BETWEEN 100000 AND 1000000 THEN 'Mid-Range'
		 ELSE 'Low Performer'
	END AS product_segment,
	total_quantity,
	avg_price,
	avg_cost
FROM product_aggregation
