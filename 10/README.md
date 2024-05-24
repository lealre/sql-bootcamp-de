# Day 10 - ACID Transactions

## Notes

- **Transaction**
    - Every transaction starts with a `BEGIN`.
    - Every transaction is completed with a `COMMIT` (in memory).
    - If a transaction fails, it requires a `ROLLBACK`.

- **ACID**
    - *Atomicity*: Ensures that a transaction is treated as a single unit, which either completes in its entirety or does not occur at all.
    - *Consistency*: Ensures that a transaction brings the database from one valid state to another, maintaining the database invariants.
    - *Isolation*: Ensures that concurrently executing transactions do not affect each other.
    - *Durability*: Ensures that once a transaction has been committed, it will remain so, even in the event of a system failure.

- **Transaction Isolation**
    - [PostgeSQL documentation](https://www.postgresql.org/docs/current/transaction-iso.html)

    1. *Read Uncommitted*: allows a transaction to see uncommitted changes made by other transactions. It can lead to dirty reads, where a transaction reads data that may later be rolled back.

    2. *Read Committed*: default isolation level in PostgreSQL. A transaction can only see changes that were committed before it began. It cannot see uncommitted changes from other transactions.
        ```sql
        -- Set isolation level to Read Committed (default)
        BEGIN;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
        -- Your SQL operations here
        COMMIT;
        ```
    
    3. *Repeatable Read*: transaction will see a consistent snapshot of the database as it was at the start of the transaction. Even if other transactions commit changes during its execution, it will not see those changes.
        ```sql
        -- Set isolation level to Repeatable Read
        BEGIN;
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        -- Your SQL operations here
        COMMIT;
        ```

    4. *Serializable*: highest isolation level. Transactions are executed in a way that ensures that the outcome is the same as if the transactions were executed serially, one after another.
        ```sql
        -- Set isolation level to Serializable
        BEGIN;
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        -- Your SQL operations here
        COMMIT;
        ```



        | Isolation Level  | Dirty Read                  | Nonrepeatable Read | Phantom Read               | Serialization Anomaly |
        |------------------|-----------------------------|--------------------|----------------------------|-----------------------|
        | Read uncommitted | Allowed, but not in PG      | Possible           | Possible                   | Possible              |
        | Read committed   | Not possible                | Possible           | Possible                   | Possible              |
        | Repeatable read  | Not possible                | Not possible       | Allowed, but not in PG     | Possible              |
        | Serializable     | Not possible                | Not possible       | Not possible               | Not possible          |

    - **CAP theorem**
        -  The acronym "CAP" stands for Consistency, Availability, and Partition tolerance. According to the CAP theorem, a distributed database can only guarantee two out of the following three properties simultaneously.
        - [IBM Link](https://www.ibm.com/topics/cap-theorem)

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-10)