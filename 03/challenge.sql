-- 1. Creates a report for all orders from 1996 and their customers (152 rows)
SELECT * 
FROM orders o 
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1996;
-- Another option
SELECT * 
FROM orders o 
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE DATE_PART('YEAR', o.order_date) = 1996;

-- 2. Creates a report showing the number of employees and customers for each city that has employees (5 rows)
SELECT e.city,
	COUNT(DISTINCT c.customer_id) AS number_customers,
	COUNT(DISTINCT e.employee_id) AS number_employee
FROM employees e 
LEFT JOIN customers c ON e.city = c.city
GROUP BY e.city
ORDER BY e.city;

-- 3. Creates a report showing the number of employees and customers for each city that has customers (69 rows)
SELECT c.city,
	COUNT(DISTINCT c.customer_id) AS number_customers,
	COUNT(DISTINCT e.employee_id) AS number_employee
FROM employees e 
RIGHT JOIN customers c ON e.city = c.city
GROUP BY c.city
ORDER BY c.city;

-- 4. Creates a report showing the number of employees and customers for each city (71 rows)
SELECT
	COALESCE(e.city, c.city),
	COUNT(DISTINCT e.employee_id) AS numero_de_funcionarios,
	COUNT(DISTINCT c.customer_id) AS numero_de_clientes
FROM employees e 
FULL JOIN customers c ON e.city = c.city
GROUP BY e.city, c.city
ORDER BY e.city, c.city;

-- 5. Creates a report showing the total quantity of ordered products.
-- Show only records for products for which the ordered quantity is less than 200 (5 rows)
SELECT p.product_id, p.product_name,
	SUM(o.quantity) AS total_quantity
FROM products p
LEFT JOIN order_details o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(o.quantity) < 200
ORDER BY p.product_id;

-- 6. Creates a report showing the total number of orders per customer since December 31, 1996.
-- The report should return only rows for which the total orders is greater than 15 (5 rows)
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
WHERE order_date > '1996-12-31'
GROUP BY customer_id
HAVING COUNT(order_id) > 15
ORDER BY total_orders;
