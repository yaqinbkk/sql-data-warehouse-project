WITH customers_spending AS (
SELECT
	c.customer_key, -- Query #6: we use the customer_key (different outcome at the end compared with using the concatenate full name). SEE Query #5
	SUM(s.sales_amount) AS total_spending,
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_month
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP by c.customer_key
)

SELECT
	customers_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT
		customer_key,
		total_spending,
		lifespan_month,
		CASE WHEN lifespan_month >= 12 AND total_spending > 5000 THEN 'VIP'
			 WHEN lifespan_month >= 12 AND total_spending <= 5000 THEN 'Regular'
			 ELSE 'New'
		END AS customers_segment
	FROM customers_spending
	)t
GROUP BY customers_segment
ORDER BY total_customers DESC