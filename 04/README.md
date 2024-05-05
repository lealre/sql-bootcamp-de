# Day 04 - Window Functions

The objectives was to perform Window Functions in SQL.

### Challenge

1. Rank the best-selling products using RANK(), DENSE_RANK(), and ROW_NUMBER() .This question has 2 implementations, see one that uses a subquery and one that does not use.

```sql
SELECT  
  o.order_id, 
  p.product_name, 
  (o.unit_price * o.quantity) AS total_sale,
  ROW_NUMBER() OVER (ORDER BY (o.unit_price * o.quantity) DESC) AS order_rn, 
  RANK() OVER (ORDER BY (o.unit_price * o.quantity) DESC) AS order_rank, 
  DENSE_RANK() OVER (ORDER BY (o.unit_price * o.quantity) DESC) AS order_dense
FROM  
  order_details o
JOIN 
  products p ON p.product_id = o.product_id;
-- Subquery
SELECT  
  sales.product_name, 
  total_sale,
  ROW_NUMBER() OVER (ORDER BY total_sale DESC) AS order_rn, 
  RANK() OVER (ORDER BY total_sale DESC) AS order_rank, 
  DENSE_RANK() OVER (ORDER BY total_sale DESC) AS order_dense
FROM (
  SELECT 
    p.product_name, 
    SUM(o.unit_price * o.quantity) AS total_sale
  FROM  
    order_details o
  JOIN 
    products p ON p.product_id = o.product_id
  GROUP BY p.product_name
) AS sales
ORDER BY sales.product_name;
```
	
2. List employees dividing them into 3 groups using NTILE

```sql
SELECT 
	first_name, last_name, title,
	NTILE(3) OVER (ORDER BY first_name) AS group_number
FROM employees;
```

3. Sorting shipping costs paid by customers according to their order dates, showing the previous cost and the next cost using LAG and LEAD.

```sql
SELECT 
  customer_id, 
  TO_CHAR(order_date, 'YYYY-MM-DD') AS order_date, 
  shippers.company_name AS shipper_name, 
  LAG(freight) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS previous_order_freight, 
  freight AS order_freight, 
  LEAD(freight) OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS next_order_freight
FROM 
  orders
JOIN 
  shippers ON shippers.shipper_id = orders.ship_via;
```

### Notes

- **Windows function** 

    - Calculations within specific partitions or rows.
    - Similar results to using `GROUP BY`, but does not reduce the number of rows.
    - Maintains the same number of rows while performing aggregation calculations, only adding new columns.

- **Windows function structure**

    ```sql
    window_function_name(arg1, arg2, ...) OVER (
    [PARTITION BY partition_expression, ...]
    [ORDER BY sort_expression [ASC | DESC], ...]
    )
    ```
    - *window_function_name*: This is the name of the window function you want to use, such as SUM, RANK, LEAD, etc.
    - *arg1, arg2, ...:* These are the arguments you pass to the window function, if it requires any. For example, for the SUM function, you would specify the column you want to sum.
    - *OVER*: Main concept of window functions, it creates the "window" where our calculations are performed.
    - *PARTITION BY:* This optional clause divides the result set into partitions or groups. The window function operates independently within each partition.
    - *ORDER BY:* This optional clause specifies the order in which rows are processed within each partition. You can specify ascending (ASC) or descending (DESC) order.

- **Example**

    ```sql
    -- Calculate: How many unique products are there? How many products in total? What is the total amount paid?
    -- With Group BY
    SELECT order_id,
        COUNT(order_id) AS unique_product,
        SUM(quantity) AS total_quantity,
        SUM(unit_price * quantity) AS total_price
    FROM order_details
    GROUP BY order_id
    ORDER BY order_id;
    -- With Window Function
    SELECT DISTINCT order_id,
        COUNT(order_id) OVER (PARTITION BY order_id) AS unique_product,
        SUM(quantity) OVER (PARTITION BY order_id) AS total_quantity,
        SUM(unit_price * quantity) OVER (PARTITION BY order_id) AS total_price
    FROM order_details
    ORDER BY order_id;
    ```

- **Ranking Commands of Window Functions**

    - `ROW_NUMBER()` → Each row receives a unique value, regardless of being repeated values. The tie-breaking criterion is non-deterministic.
    - `RANK()` → Equal values receive the same rank, and the count continues by the number of rows (1, 1, 3, 4, 4, 6, ...).
    - `DENSE_RANK()` → Equal values receive the same rank, and the count continues by the rank sequence (1, 1, 2, 3, 4, 4, 5, ...).
    - `PERCENT_RANK()` and `CUME_DIST()` → Rankings on percentile of the distribution.
    - `NTILE(n)` → Divide the result set into a specified number of approximately equal parts or "buckets" and assigns a group number or "bucket" to each row based on its position within the ordered result set.

- **Value Commands of Window Functions**

    - `LAG()` → Accesses the value of the previous row.
    - `LEAD()` → Accesses the value of the next row.
    - `FIRST_VALUE()`, `LAST_VALUE()`, `NTH_VALUE()`

- **Other SQL commands**

    - `EXPLAIN ANALYSE` → Command to describe performance details of the query

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-04)



