# Day 07 - DDL/DML Statements

The objective was see the commands `CREATE`, `INSERT`, `UPDATE`, `DROP` and `DELETE`.

## Notes

- **Create a table**
    ```sql
    CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY NOT NULL,
    limit  INTEGER NOT NULL,
    balance  INTEGER NOT NULL
    );
    ```
    - `IF NOT EXISTS`: optional clause that ensures the table is only created if it does not already exist in the database, preventing errors if the table already exists.
    - `clients`: name of the table.
    - Each column is defined with a name, a data type, and optionally other constraints, such as defining a primary key (`PRIMARY KEY`) and the requirement of not being null (`NOT NULL`).

- **UUID**: Universally Unique Identifier
    - 128-bit number used to uniquely identify something without having to coordinate with a central authority.
    ```sql
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

    CREATE TABLE IF NOT EXISTS clients (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        limit INTEGER NOT NULL,
        balance INTEGER NOT NULL
    );
    ```

- **Inserting values on the table**
    ```sql
    INSERT INTO clients (limit, balance)
    VALUES
        (10000, 0),
        (80000, 0),
        (1000000, 0),
        (10000000, 0),
        (500000, 0);
    ```
    - In the `INSERT INTO` clause, the name of the table is specified (clients in this case), followed by the list of columns in parentheses, if necessary.
    - Each row of values corresponds to a new record to be inserted into the table, with the values in the same order as the columns were listed.

- **Update table value**
    ```sql
    UPDATE clients
    SET balance = 500
    WHERE id IN (1, 2, 3);
    ```

- **Delete a row from table**
    ```sql
    DELETE FROM clients
    WHERE id = 6;
    ```

- **Drop a table**
    ```sql
    DROP TABLE IF EXISTS clients;
    ```

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-07)
    