-- 1. Get all columns from the Customers, Orders, and Suppliers tables
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM suppliers;

-- 2. Get all Customers in alphabetical order by country and name
SELECT * FROM customers
ORDER BY country, company_name;

-- 3. Get the 5 oldest orders
SELECT * FROM orders
ORDER BY order_date ASC
LIMIT 5;

-- 4. Get the count of all orders made during 1997
SELECT COUNT(order_date) AS count_orders_1997
FROM orders
WHERE order_date BETWEEN '1997-01-01' AND '1997-12-31';

-- 5. Get the names of all contact persons where the person is a manager, in alphabetical order
SELECT contact_name, contact_title
FROM customers
WHERE contact_title LIKE '%Manager%'
ORDER BY contact_name;

-- 6. Get all orders made on May 19, 1997
SELECT *
FROM orders
WHERE order_date = '1997-05-19';
