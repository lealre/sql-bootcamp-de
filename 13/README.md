# Day 13 - Partition


## Notes

- **Number of Threads**: Refers to the threads or processes used by a database system to handle operations. This varies by the database system (e.g., SQL Server, MySQL, PostgreSQL).

- **GATHER** in PostgreSQL's execution plan indicates the use of parallel execution. Example
    ```
     Gather  (cost=1000.00..2000.00 rows=100000 width=8)
        Workers Planned: 2
        ->  Parallel Seq Scan on my_table  (cost=0.00..1800.00 rows=50000 width=8)
                Filter: (my_column = 'value')
    ```

- **Main types of partitioning available in PostgreSQL**
    - Range Partitioning: Suitable for continuous ranges, such as dates or numeric ranges.
        ```sql
        CREATE TABLE people (
            id SERIAL PRIMARY KEY,
            first_name VARCHAR(30),
            last_name VARCHAR(30),
            state VARCHAR(30)
        ) PARTITION BY RANGE (id);

        CREATE TABLE people_part1 PARTITION OF people FOR VALUES FROM (MINVALUE) TO (2000001);
        CREATE TABLE people_part2 PARTITION OF people FOR VALUES FROM (2000001) TO (4000001);
        CREATE TABLE people_part3 PARTITION OF people FOR VALUES FROM (4000001) TO (6000001);
        CREATE TABLE people_part4 PARTITION OF people FOR VALUES FROM (6000001) TO (8000001);
        CREATE TABLE people_part5 PARTITION OF people FOR VALUES FROM (8000001) TO (MAXVALUE);
        ```

    - List Partitioning: Ideal for discrete values or categories, like regions or departments.
        ```sql
        CREATE TABLE people (
            id SERIAL,
            first_name VARCHAR(3),
            last_name VARCHAR(3),
            state VARCHAR(3),
            PRIMARY KEY (id, state)
        ) PARTITION BY LIST (state);

        CREATE TABLE people_sp PARTITION OF people FOR VALUES IN ('SP');
        CREATE TABLE people_rj PARTITION OF people FOR VALUES IN ('RJ');
        CREATE TABLE people_mg PARTITION OF people FOR VALUES IN ('MG');
        CREATE TABLE people_es PARTITION OF people FOR VALUES IN ('ES');
        CREATE TABLE people_df PARTITION OF people FOR VALUES IN ('DF');
        ```
    - Hash Partitioning: Useful for evenly distributing data without natural range or list-based criteria.
    - Composite Partitioning: Combines multiple partitioning methods for more complex data models.

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-13)
