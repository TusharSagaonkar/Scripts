CREATE OR REPLACE PROCEDURE generate_html_table(p_sql_query IN VARCHAR2) 
IS
    -- Declare variables for handling dynamic SQL and result set
    l_cursor    SYS_REFCURSOR;
    l_column_count  NUMBER;
    l_column_name  VARCHAR2(255);
    l_html_output VARCHAR2(32767) := '<!DOCTYPE html><html><head><title>Excel-Like Table</title><style>';
    l_row_data   VARCHAR2(4000);
    l_column_data VARCHAR2(4000);
BEGIN
    -- Add CSS to the output
    l_html_output := l_html_output || '
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { position: sticky; top: 0; background-color: #f2f2f2; }
        input, select { width: 90%; padding: 5px; margin-bottom: 10px; }
    </style></head><body><h2>Excel-Like Advanced Filterable Table</h2><table>';

    -- Open the cursor for the dynamic SQL query
    OPEN l_cursor FOR p_sql_query;

    -- Get the number of columns in the result set
    FOR i IN 1..10 LOOP
        BEGIN
            -- Try to get the column name
            EXECUTE IMMEDIATE 'SELECT column_name FROM all_tab_columns WHERE table_name = (SELECT table_name FROM user_tables) AND ROWNUM = ' || i INTO l_column_name;
            EXIT;  -- Exit the loop if successful
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT; -- Exit if no more columns
        END;
    END LOOP;

    -- Loop through the result set and generate HTML rows
    LOOP
        FETCH l_cursor INTO l_row_data;
        EXIT WHEN l_cursor%NOTFOUND;

        -- Process each row data here
        l_html_output := l_html_output || '<tr>';

        -- Fetch column names dynamically for the headers
        FOR col IN 1..l_column_count LOOP
            -- Construct dynamic column data for each row
            l_column_data := l_row_data(col);
            l_html_output := l_html_output || '<td>' || l_column_data || '</td>';
        END LOOP;
        l_html_output := l_html_output || '</tr>';
    END LOOP;

    -- Close the cursor
    CLOSE l_cursor;

    -- Close the HTML table structure
    l_html_output := l_html_output || '</table></body></html>';

    -- Print the HTML output (you can send this as a response in a web-based application)
    DBMS_OUTPUT.PUT_LINE(l_html_output);
END;
/