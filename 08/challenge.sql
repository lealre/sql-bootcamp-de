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

-- Stored procedure to create a transaction
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

-- Insert rows with client_id = 1
    CALL perform_transaction('c','desc', 20000, 1);
    CALL perform_transaction('c','desc', 20000, 1);
    CALL perform_transaction('b','desc', 15000, 1);
    CALL perform_transaction('c','desc', 2000, 1);
    CALL perform_transaction('c','desc', 20000, 1);
    CALL perform_transaction('b','desc', 1000, 1);
    CALL perform_transaction('c','desc', 2000, 1);
    CALL perform_transaction('b','desc', 20000, 1);
    CALL perform_transaction('b','desc', 45621, 1);
    CALL perform_transaction('c','desc', 20000, 1);
    CALL perform_transaction('b','desc', 5000, 1);
    CALL perform_transaction('c','desc', 20000, 1);

-- create procedure
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
        RAISE NOTICE 'ID: %, Type: %, Description: %, Amount: %, Date: %', transaction_record.id, transaction_record.type, transaction_record.description, transaction_record.amount, transaction_record.performed_at;
    END LOOP;
END;
$$;

-- test procedure
CALL view_statement(1)