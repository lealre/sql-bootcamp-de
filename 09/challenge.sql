-- Creation of the product table
CREATE TABLE product (
    prod_code INT PRIMARY KEY,
    description VARCHAR(50) UNIQUE,
    available_quantity INT NOT NULL DEFAULT 0
);

-- Insertion of products
INSERT INTO product VALUES (1, 'Basic', 10);
INSERT INTO product VALUES (2, 'Data', 5);
INSERT INTO product VALUES (3, 'Summer', 15);

-- Creation of the sales_record table
CREATE TABLE sales_record (
    sale_code SERIAL PRIMARY KEY,
    prod_code INT,
    quantity_sold INT,
    FOREIGN KEY (prod_code) REFERENCES product(prod_code) ON DELETE CASCADE
);


-- Create trigger
CREATE OR REPLACE FUNCTION assert_stock()
RETURNS TRIGGER AS $$
DECLARE
    current_quantity INTEGER;
BEGIN
    -- get current quantity available
    SELECT available_quantity INTO current_quantity
    FROM product
    WHERE prod_code = NEW.prod_code;
    
    -- Veritfy if transaction is possible
    IF NEW.quantity_sold > current_quantity THEN
        RAISE EXCEPTION 'No stock available';
    ELSE
        UPDATE product SET available_quantity = current_quantity - NEW.quantity_sold
        WHERE prod_code = NEW.prod_code;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_assert_stock
BEFORE INSERT ON sales_record
FOR EACH ROW
EXECUTE FUNCTION assert_stock();

-- Test trigger
INSERT INTO sales_record (prod_code, quantity_sold) VALUES (1, 12);