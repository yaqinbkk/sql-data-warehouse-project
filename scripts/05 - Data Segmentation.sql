-- Segment products into cost ranges and count how many products fall into each segment.

WITH products_segment AS (
SELECT
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Low Cost'
		 WHEN cost BETWEEN 100 AND 500 THEN 'Medium Cost'
		 ELSE 'High Cost'
	END AS segment_cost
FROM gold.dim_products)

SELECT
	segment_cost,
	COUNT(product_key) AS total_products
FROM products_segment
GROUP BY segment_cost
ORDER BY total_products DESC


/* Group customers into 3 segments based on their spending behavior.
VIP: customers with at least 12 months of history and spending more than 5,000 euros.
Regular: customers with at least 12 months of history but spending 5,000 euros or less.
New: customers with a lifespan of less than 12 months.
Find the total number of customers for each group. */


WITH customers_spending AS (
SELECT
CONCAT(c.first_name, ' ', c.last_name) AS full_name,  -- Query #5: we use the concatenate full name (different outcome at the end compared with using the customer_key). SEE Query #6
MIN(s.order_date) AS earliest_sale,
MAX(s.order_date) AS latest_sale,
DATEDIFF(month, MIN(s.order_date), MAX(s.order_date)) AS month_lifespan,
SUM(s.sales_amount) AS total_spending
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY CONCAT(c.first_name, ' ', c.last_name)
)

SELECT
	segment_customers,
	COUNT(full_name) AS total_customers
FROM(
	SELECT
		full_name,
		CASE WHEN month_lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN month_lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS segment_customers
	FROM customers_spending)t
GROUP BY segment_customers
ORDER BY total_customers