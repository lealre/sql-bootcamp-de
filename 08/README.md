# Day 08 - Stored Procedures


## Challenge

Create a stored procedure `'view_statement'` to provide a detailed view of a client's bank statement, including their current balance and information on the last 10 transactions. This operation takes the client's ID as input and returns a message with the client's current balance and a list of the last 10 transactions, including the transaction ID, transaction type (deposit or withdrawal), a brief description, the transaction amount, and the date it was conducted.

1. Create and insert values in tables.
    ```sql
    -- Create tables
    CREATE TABLE IF NOT EXISTS clients (
        id SERIAL PRIMARY KEY NOT NULL,
        credit_limit INTEGER NOT NULL,
        balance INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS transactions (
        id SERIAL PRIMARY KEY NOT NULL,
        type CHAR(1) NOT NULL,
        description VARCHAR(10) NOT NULL,
        amount INTEGER NOT NULL,
        client_id INTEGER NOT NULL,
        performed_at TIMESTAMP NOT NULL DEFAULT NOW()
    );

    -- Insert clients info
    INSERT INTO clients (credit_limit, balance)
    VALUES
        (10000, 0),
        (80000, 0),
        (1000000, 0),
        (10000000, 0),
        (500000, 0);

    -- Insert 20 rows with client_id = 1
    INSERT INTO transactions (type, description, amount, client_id, performed_at)
    VALUES
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 1, NOW() - (RANDOM() * INTERVAL '365 days'));

    -- Insert 20 rows with client_id = 2
    INSERT INTO transactions (type, description, amount, client_id, performed_at)
    VALUES
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('d', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days')),
        ('c', 'any', (RANDOM() * 10000)::INTEGER, 2, NOW() - (RANDOM() * INTERVAL '365 days'));
    ```

3. Create proceure
    ```sql
    CREATE OR REPLACE PROCEDURE view_statement(
    IN p_client_id INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        current_balance INTEGER;
        transaction_record RECORD;
    BEGIN
        -- Get the current balance of the client
        SELECT balance INTO current_balance
        FROM clients
        WHERE id = p_client_id;

        -- Return the current balance of the client
        RAISE NOTICE 'Current balance of the client: %', current_balance;

        -- Return the last 10 transactions of the client
        RAISE NOTICE 'Last 10 transactions of the client:';
        FOR transaction_record IN
            SELECT *
            FROM transactions
            WHERE client_id = p_client_id
            ORDER BY performed_at DESC
            LIMIT 10
        LOOP
            counter := counter + 1;
            RAISE NOTICE 'ID: %, Type: %, Description: %, Amount: %, Date: %', transaction_record.id, transaction_record.type, transaction_record.description, transaction_record.amount, transaction_record.performed_at;
            EXIT WHEN counter >= 10;
        END LOOP;
    END;
    $$;
    ```

4. Call procedure
    ```sql
    CALL view_statement(2)
    ```
    ```
    NOTICE:  Current balance of the client: 0
    NOTICE:  Last 10 transactions of the client:
    NOTICE:  ID: 36, Type: c, Description: any, Amount: 1091, Date: 2024-05-11 00:45:04.517331
    NOTICE:  ID: 34, Type: c, Description: any, Amount: 2951, Date: 2024-04-24 15:35:10.783397
    NOTICE:  ID: 39, Type: d, Description: any, Amount: 5462, Date: 2024-04-15 08:58:19.821193
    NOTICE:  ID: 23, Type: d, Description: any, Amount: 4654, Date: 2024-02-12 15:17:24.660285
    NOTICE:  ID: 30, Type: c, Description: any, Amount: 2334, Date: 2024-02-09 17:31:33.918556
    NOTICE:  ID: 27, Type: d, Description: any, Amount: 1796, Date: 2024-01-20 07:46:45.405118
    NOTICE:  ID: 26, Type: c, Description: any, Amount: 1520, Date: 2023-12-08 09:19:04.186051
    NOTICE:  ID: 33, Type: d, Description: any, Amount: 4882, Date: 2023-12-03 01:05:07.396912
    NOTICE:  ID: 38, Type: c, Description: any, Amount: 4187, Date: 2023-11-20 19:51:30.38053
    NOTICE:  ID: 37, Type: d, Description: any, Amount: 845, Date: 2023-10-27 20:38:15.961209
    ```


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
- **Stored Procedure example**
    - Given the client and transactions tables below, we cannot allow transactions that cause the client's balance to fall below the credit. We agree that type = `'d'` is an operation that will debit from the client (purchase) and type = `'c'` will credit the client (sale).
    ```sql
    -- Create tables
    CREATE TABLE IF NOT EXISTS clients (
        id SERIAL PRIMARY KEY NOT NULL,
        credit_limit INTEGER NOT NULL,
        balance INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS transactions (
        id SERIAL PRIMARY KEY NOT NULL,
        type CHAR(1) NOT NULL,
        description VARCHAR(10) NOT NULL,
        amount INTEGER NOT NULL,
        client_id INTEGER NOT NULL,
        performed_at TIMESTAMP NOT NULL DEFAULT NOW()
    );
    ```

    - Therefore, we created the procedure below.
    ```sql
    CREATE OR REPLACE PROCEDURE perform_transaction(
        IN p_type CHAR(1),
        IN p_description VARCHAR(10),
        IN p_amount INTEGER,
        IN p_client_id INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        current_balance INTEGER;
        client_limit INTEGER;
    BEGIN
        -- Get the current balance and limit of the client
        SELECT balance, credit_limit INTO current_balance, client_limit
        FROM clients
        WHERE id = p_client_id;
        
        -- Check if the transaction is valid based on the balance and limit
        IF p_type = 'd' AND current_balance - p_amount < -client_limit THEN
            RAISE EXCEPTION 'Insufficient balance to perform the transaction';
        END IF;
        
        -- Check if the transaction is valid based on the balance and limit
        IF p_type = 'd' AND current_balance - p_amount < -client_limit THEN
            RAISE EXCEPTION 'Insufficient balance to perform the transaction';
        END IF;
        
        -- Update the client's balance
        UPDATE clients
        SET balance = balance + CASE WHEN p_type = 'd' THEN -p_amount ELSE p_amount END
        WHERE id = p_client_id;
        
        -- Insert a new transaction
        INSERT INTO transactions (type, description, amount, client_id)
        VALUES (p_type, p_description, p_amount, p_client_id);
    END;
    $$;
    ```

    - Given the values inserted by the table below, we tested the procedure.
    ```sql
    INSERT INTO clients (credit_limit, balance)
    VALUES
        (10000, 0),
        (80000, 0),
        (1000000, 0),
        (10000000, 0),
        (500000, 0);
    ```
    | id | credit_limit | balance |
    |----|--------------|---------|
    |  1 |        10000 |       0 |
    |  2 |        80000 |       0 |
    |  3 |      1000000 |       0 |
    |  4 |     10000000 |       0 |
    |  5 |       500000 |       0 |

    - Using the client with `id` = 1, we test with a debit transaction (`'d'`) in the amount of 20000.
    ```sql
    CALL perform_transaction('d','buy', 20000, 1)
    ```
    ```
    ERROR:  Insufficient balance to perform the transaction
    CONTEXT:  PL/pgSQL function perform_transaction(character,character varying,integer,integer) line 18 at RAISE 

    SQL state: P0001
    ```

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-07)