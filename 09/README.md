# Day 09 - Triggers 

## Notes
- **Definition**: Triggers are stored procedures that are automatically executed or fired when specific events occur on a table or view. They are executed in response to events such as `INSERT`, `UPDATE`, or `DELETE`.

- **Why we use Triggers in projects**
    - Task automation: To perform automatic actions that are necessary after modifications in the database, such as maintaining logs or updating related tables.
    - Data integrity: Ensuring data consistency and validation by applying business rules directly in the database.

- **Trigger Logic**:
    ```sql
    CREATE TRIGGER trigger_name
    AFTER INSERT OR UPDATE OR DELETE ON table_name
    FOR EACH ROW
    BEGIN
        -- Trigger logic here
    END;

- **Trigger example**:
    - Table `employee` → Stores employee data, including ID, name, salary, and hire date
    - Table `employee_audit` → Stores the history of employee salary changes, including the old salary, the new salary, and the date of the modification
        ```sql
        -- Creation of the Employee table
        CREATE TABLE employee (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100),
            salary DECIMAL(10, 2),
            hire_date DATE
        );

        -- Creation of the Employee_Audit table
        CREATE TABLE employee_audit (
            id INT,
            old_salary DECIMAL(10, 2),
            new_salary DECIMAL(10, 2),
            salary_modification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (id) REFERENCES employee(id)
        );

        -- Insertion of data into the Employee table
        INSERT INTO employee (name, salary, hire_date) VALUES ('Maria', 5000.00, '2021-06-01');
        INSERT INTO employee (name, salary, hire_date) VALUES ('João', 4500.00, '2021-07-15');
        INSERT INTO employee (name, salary, hire_date) VALUES ('Ana', 4000.00, '2022-01-10');
        INSERT INTO employee (name, salary, hire_date) VALUES ('Pedro', 5500.00, '2022-03-20');
        INSERT INTO employee (name, salary, hire_date) VALUES ('Lucas', 4700.00, '2022-05-25');
        ```

    - The trigger `trg_salary_modified` will be fired after an update to the salary in the `employee` table. It will record the details of the modification in the `employee_audit` table.
        ```sql
        -- Creation of the Trigger for salary change auditing
        CREATE OR REPLACE FUNCTION register_salary_audit() RETURNS TRIGGER AS $$
        BEGIN
            INSERT INTO employee_audit (id, old_salary, new_salary)
            VALUES (OLD.id, OLD.salary, NEW.salary);
            RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER trg_salary_modified
        AFTER UPDATE OF salary ON employee
        FOR EACH ROW
        EXECUTE FUNCTION register_salary_audit();
        ```
    - Update an employee's salary
        ```sql
        -- Update Ana's salary
        UPDATE employee SET salary = 4300.00 WHERE name = 'Ana';    
        ```
    - After performing the update, we can check the employee_audit table to ensure that the salary change was recorded.
        ```sql
        -- Query the employee_audit table to verify the changes
        SELECT * 
        FROM employee_audit 
        WHERE id = (
                SELECT id 
                FROM employee 
                WHERE name = 'Ana'
        );
        ```

    | id | old_salary | new_salary | salary_modification_date      |
    |----|------------|------------|-------------------------------|
    | 3  | 4000.00    | 4300.00    | "2024-05-19 12:09:37.014934"   |




--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-09)