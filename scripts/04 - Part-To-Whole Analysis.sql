-- Which categories contribute the most to the overall sales?

WITH category_sales AS (
SELECT
	p.category,
	SUM(s.sales_amount) AS total_sales_category
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category
)
SELECT
	category,
	total_sales_category,
	SUM(total_sales_category) OVER() AS overall_sales,
	CONCAT(ROUND(CAST(total_sales_category AS FLOAT) / SUM(total_sales_category) OVER() * 100, 2), ' %') AS percentage_of_total
FROM category_sales
ORDER BY total_sales_category DESC
