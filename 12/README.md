# Day 12 - Database Indexing


## Notes

- **Indexes**
    - Indexes in databases are structures used to improve the efficiency of queries, allowing for quick access to data.
    - There are several types of indexes, including B-tree indexes, hash indexes, and bitmap indexes. Each type has its own characteristics and appropriate uses.
    - Typically created based on one or more columns of a table.
    - Faster and more efficient queries but include additional storage costs and update overhead during insert, update, and delete operations.

- **B-Tree Data Structures**
    - A B-Tree consists of nodes, where each node can have multiple keys and multiple pointers to other nodes. Each node has a minimum and maximum number of keys and pointers, maintaining the tree’s balance.
    - Are widely used in databases for indexes, such as primary and secondary key indexes, due to their efficiency and ability to handle large volumes of data.
    - For B-tree indexes, the search time complexity is O(log N), where N is the number of entries in the index. This logarithmic complexity means that as the database grows, the search time increases logarithmically, not linearly. 

- **Example**
    - Creating the table:
        ```sql
        CREATE TABLE people (
            id SERIAL PRIMARY KEY,
            first_name VARCHAR(3),
            last_name VARCHAR(3)
        );
        ```
    - Inserting 1 million records:
        ```sql
        INSERT INTO people (first_name, last_name)
        SELECT 
            substring(md5(random()::text), 0, 3),
            substring(md5(random()::text), 0, 3)
        FROM 
            generate_series(1, 1000000);
        ```
    - Searching only by the index:
        ```sql
        EXPLAIN ANALYZE SELECT id FROM people WHERE id = 100000;
        ```
        | Property           | Value                                       |
        |--------------------|---------------------------------------------|
        | Operation          | Index Only Scan using people_pkey on people |
        | Cost               | 0.42..4.44                                  |
        | Rows               | 1                                           |
        | Width              | 4                                           |
        | Actual Time        | 0.023..0.024                                |
        | Loops              | 1                                           |
        | Index Condition    | (id = 100000)                               |
        | Heap Fetches       | 0                                           |
        | Planning Time      | 0.095 ms                                    |
        | Execution Time     | 0.041 ms                                    | 
    - Searching only by the index, but observing the table details:
        ```sql
        EXPLAIN ANALYZE SELECT first_name FROM people WHERE id = 100000;
        ```
        | Property           | Value                                     |
        |--------------------|-------------------------------------------|
        | Operation          | Index Scan using people_pkey on people    |
        | Cost               | 0.42..8.44                                |
        | Rows               | 1                                         |
        | Width              | 3                                         |
        | Actual Time        | 0.027..0.029                              |
        | Loops              | 1                                         |
        | Index Condition    | (id = 100000)                             |
        | Planning Time      | 0.100 ms                                  |
        | Execution Time     | 0.046 ms                                  |
    
- **Create an Index**
    ```sql
    CREATE INDEX first_name_index ON pessoas(first_name);
    ```

- **Different types of scans**
    - `Table Scan`: Reads the entire table row by row to find the required data
    - `Index Scan`: Reads the index to identify the relevant rows and then retrieves those rows from the table.
    - `Bitmap Index Scan`:  Uses an index to create a bitmap of row locations and then performs a bitmap heap scan to fetch the actual rows.
    - `Index Only Scan`: Retrieves the required data directly from the index if the index contains all the columns needed by the query. **Typically the fastest option** since it avoids fetching rows from the table, reducing I/O operations.

- **Index Cost**
    ```sql
    SELECT pg_size_pretty(pg_relation_size('first_name_index'));
    ```
- **Total Column Size**
    ```sql
    SELECT pg_size_pretty(pg_column_size(first_name)::bigint) AS total_size
    FROM people;
    ```

- **Total Size of All Columns:**
    ```sql
    SELECT pg_size_pretty(SUM(pg_column_size(first_name)::bigint)) AS total_size
    FROM people;
    ```

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-12)
