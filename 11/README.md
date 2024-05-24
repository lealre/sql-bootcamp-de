# Day 11 - Query Order

## Notes
- When executing a query in a client-server database system like PostgreSQL, several steps are involved in sending the request to the server and receiving the result on the client side.
    ```mermaid
    flowchart TD
        input[Client-Side Input]
        parse[Query Parsing]
        optimize[Query Optimization]
        execute[Query Execution]
        auth[Authorization & Authentication]
        plan[Query Planning]
        retrieve[Data Retrieval]
        process[Result Processing]
        transmit[Result Transmission]
        clientProcess[Client-Side Processing]
        display[Display to User]

        input --> parse
        parse --> optimize
        optimize --> execute
        execute --> auth
        auth --> plan
        plan --> retrieve
        retrieve --> process
        process --> transmit
        transmit --> clientProcess
        clientProcess --> display
    ```
- **Query Order**
    -  A typical order of query execution in PostgreSQL can be summarized as follows:
        ```mermaid
        graph TD
            fromclause["FROM clause: Identifying tables/views"]
            whereclause["WHERE clause: Applying conditions"]
            groupby["GROUP BY clause: Grouping rows"]
            having["HAVING clause: Applying filters"]
            selectclause["SELECT clause: Processing selected columns"]
            distinctall["DISTINCT/ALL clause: Removing duplicates"]
            orderby["ORDER BY clause: Sorting result set"]
            limitoffset["LIMIT and OFFSET clauses: Limiting and offsetting rows"]
            finalresult["Final Result: Returning processed result set"]

            fromclause --> whereclause
            whereclause --> groupby
            groupby --> having
            having --> selectclause
            selectclause --> distinctall
            distinctall --> orderby
            orderby --> limitoffset
            limitoffset --> finalresult
        ```
    - The optimizer may reorder the steps of query execution to minimize resource usage, such as reducing disk I/O or avoiding unnecessary calculations.
--------------
[Class Repository](https://github.com/lvgalvao/data-engineering-roadmap/tree/main/Bootcamp%20-%20SQL%20e%20Analytics/Aula-10)
