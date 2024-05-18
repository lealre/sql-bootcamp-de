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

-- insert random values values

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

-- create procedure
CREATE OR REPLACE PROCEDURE view_statement(
    IN p_client_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance INTEGER;
    transaction_record RECORD;
    counter INTEGER := 0;
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
CALL view_statement(2)