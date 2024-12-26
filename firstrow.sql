DECLARE
    v_html_output VARCHAR2(4000); -- To hold the generated HTML output
    v_data_output VARCHAR2(4000); -- To hold the table data
    v_column_names VARCHAR2(4000); -- To hold the column names
BEGIN
    -- Initialize the HTML output with the form opening tag
    v_html_output := '<form action="your_action_url" method="POST">'; -- Change "your_action_url" as needed

    -- Step 1: Loop through the columns of the table and generate the HTML inputs
    FOR rec IN (
        SELECT COLUMN_NAME
        FROM USER_TAB_COLUMNS
        WHERE TABLE_NAME = 'MY_TABLE' -- Replace with your table name (uppercase)
        ORDER BY COLUMN_ID
    ) LOOP
        -- Concatenate HTML for each column with label and input element
        v_html_output := v_html_output || 
                         '<label for="' || rec.COLUMN_NAME || '">' || rec.COLUMN_NAME || ':</label>' ||
                         '<input type="text" id="' || rec.COLUMN_NAME || '" name="' || rec.COLUMN_NAME || '" placeholder="' || rec.COLUMN_NAME || '" /><br>';
    END LOOP;

    -- Step 2: Add a submit button and close the form
    v_html_output := v_html_output || 
                     '<input type="submit" value="Submit" />' || 
                     '</form>';

    -- Step 3: Fetch the table data and generate a table below the form
    v_data_output := '<h3>Table Data:</h3><table border="1"><tr>';
    
    -- Step 3a: Generate column headers for the table
    FOR rec IN (
        SELECT COLUMN_NAME
        FROM USER_TAB_COLUMNS
        WHERE TABLE_NAME = 'MY_TABLE' -- Replace with your table name (uppercase)
        ORDER BY COLUMN_ID
    ) LOOP
        v_data_output := v_data_output || 
                         '<th>' || rec.COLUMN_NAME || '</th>';
    END LOOP;

    v_data_output := v_data_output || '</tr>';

    -- Step 3b: Fetch and display the table data
    FOR rec IN (
        SELECT * FROM MY_TABLE -- Replace with your table name (uppercase)
    ) LOOP
        v_data_output := v_data_output || '<tr>';
        
        FOR col IN 1..(SELECT COUNT(*) FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'MY_TABLE') LOOP
            v_data_output := v_data_output || 
                             '<td>' || 
                             (CASE
                                WHEN col = 1 THEN rec.COLUMN1 -- Adjust column names as needed
                                WHEN col = 2 THEN rec.COLUMN2 -- Adjust column names as needed
                                ELSE ''
                             END) ||
                             '</td>';
        END LOOP;
        
        v_data_output := v_data_output || '</tr>';
    END LOOP;

    v_data_output := v_data_output || '</table>';

    -- Step 4: Output the generated HTML (form + table data)
    DBMS_OUTPUT.PUT_LINE(v_html_output);
    DBMS_OUTPUT.PUT_LINE(v_data_output);
END;