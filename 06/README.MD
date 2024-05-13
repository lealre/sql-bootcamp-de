# Day 06 - CTE vs Subqueries vs Views vs Temporary Tables vs Materialized Views

The objective was to understand the main difference between CTE, Subqueries, Views, Temporary Tables and Materialized Views

### Notes

- **CTE (Common Table Expressions)**: Useful when you need to break down a query into more manageable parts or when you want to reuse a subquery multiple times in the same main query.
    ```sql
    WITH <cte_name> AS (
	<cte_query>
    )
    ```

- **Subqueries**: Useful when you need intermediate results to filter or aggregate data in a main query.

- **Refactoring a subquery into a CTE**
    - Subquery
    ```sql
    SELECT 
	product_id FROM (
        SELECT product_id 
        FROM (
            SELECT product_id, rank
            FROM (SELECT 
                    product_id,
                    SUM( det.quantity * det.unit_price * ( 1 - det.discount )) sold_value,
                    RANK() OVER (ORDER BY SUM( det.quantity * det.unit_price * ( 1 - det.discount )) DESC) rank -- WINDOWS FUNCTION
                FROM order_details det
                GROUP BY det.product_id
                ORDER BY rank)
            WHERE rank <= 5 )
    WHERE product_id BETWEEN 35 and 65 )
    ORDER BY product_id DESC
    ```
    - CTE
    ```sql
    WITH CalculatedValues AS (
        -- Calcula o valor vendido e o rank para cada produto
        SELECT 
            product_id,
            SUM(det.quantity * det.unit_price * (1 - det.discount)) AS sold_value,
            RANK() OVER (ORDER BY SUM(det.quantity * det.unit_price * (1 - det.discount)) DESC) AS rank
        FROM order_details det
        GROUP BY product_id
    ), 
    TopRankedProducts AS ( 
        -- Seleciona apenas os produtos com rank entre os top 5 
        SELECT product_id FROM CalculatedValues WHERE rank <= 5 
    ), 
    FilteredProducts AS ( 
        -- Filtra os produtos com IDs entre 35 e 65 
        SELECT product_id FROM TopRankedProducts WHERE product_id BETWEEN 35 AND 65 
    ) 
    -- Seleciona e ordena os produtos finais 
    SELECT product_id FROM FilteredProducts ORDER BY product_id DESC;
    ```

- **Views**: They are useful when you need to reuse a query in multiple queries or when you want to simplify complex queries by breaking them down into smaller parts.
    ```sql
    CREATE VIEW <view_name> AS (
	<view_query>
    )
    ```
    - One of the advantages is allowing specific access to views instead of full access to the database.
    - Every time it is called, we incur the processing cost of the query.

- **Temporary Tables / Staging / ETL Testing**: Useful when you need to store temporary data for use in a database session or in a specific query.
    ```sql
    CREATE TEMP TABLE <table_name> AS (
	<table_query>
    )
    ```
    - Stores the table in the database, but we don't have the processing cost of queries as in views.

- **Materialized Views / Snapshot**: They are useful when you need to pre-calculate and store results of complex queries for frequent queries or performance analysis.
    - [Oracle definition](https://oracle-base.com/articles/misc/materialized-views)
    - Differently from Views, the data is not updated until the execution of the `REFRESH MATERIALIZED VIEW` command.

- **Materialized view vs Table**

|                               | Table                         | Materialized View                    |
|-------------------------------|--------------------------------------|--------------------------------------|
| **Storage of Data**           | Data is stored physically in the database. | Results of a query are stored as a physical table. |
| **Automatic Update**          | Data is updated manually or automatically through insertion, update, and deletion operations. | Data is not updated automatically. It needs to be manually updated using the `REFRESH MATERIALIZED VIEW` command. |
| **Performance**               | Queries are executed directly on the data stored in the table. | Queries are executed on the data stored in the materialized view, which can improve the performance of complex or frequently used queries. |
| **Disk Space Usage**          | May occupy more disk space due to physical storage of data. | May occupy less disk space, as it stores only the query results, not raw data. |
| **Flexibility**               | Data is updated in real-time and can be manipulated directly. | Query results are static and need to be manually updated. They are primarily used to store results of complex queries that do not change frequently. |

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-06)
