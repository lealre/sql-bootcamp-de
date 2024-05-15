# Day 08 - Stored Procedures


### Notes

- Functions written directly in SQL.

- There is a discussion about whether it is better for the business logic to be written directly inside the database or in the backend development.

- In the case of being inside the database, the backend would directly call the SQL procedure like `session.execute("CALL realizar_transacao(transacao.type, transacao.description, transacao.value, cliente_id)")`

- PostgreSQL has 4 default languages available: **PL/pgSQL** (Chapter 43), **PL/Tcl** (Chapter 44), **PL/Perl** (Chapter 45), and **PL/Python** (Chapter 46)

- **Advantages**
    - Code Reusability: They allow SQL code blocks to be written once and reused in multiple parts of the application.
    - Performance: Because they are compiled and stored in the database, stored procedures can be executed more efficiently than multiple SQL queries sent separately by the application.
    - Security: Stored procedures can help protect the database, as applications only need permission to execute the stored procedure, not to directly access the tables.
    - Data Abstraction: They can be used to hide the complexity of the underlying data model, providing a simplified interface for users or applications.
    - Transaction Control: Stored procedures can include transaction control statements to ensure data integrity during complex operations.

- **Stored Procedures structure**
    - Declare or replace the procedure
    ```sql
    CREATE OR REPLACE PROCEDURE realizar_transacao(
        IN p_type CHAR(1),
        IN p_description VARCHAR(10),
        IN p_value INTEGER,
        IN p_client_id INTEGER
    )
    ```
    
    - Define the language
    ```sql
    LANGUAGE plpgsql
    ```
    
    - Create the body of the procedure, with the logic

    ```sql
    AS $$
    DECLARE
        current_balance INTEGER;
        client_limit INTEGER;
    BEGIN
        -- procedure logic...
    END;
    $$;
    ```

    - Call the procedure
    ```sql
    CALL perform_transaction('d', 'car', 80000, 1);
    ```

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-07)