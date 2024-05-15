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

--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-09)