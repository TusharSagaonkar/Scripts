DECLARE
    v_html_output VARCHAR2(4000); -- To hold the generated HTML output
    v_column_names VARCHAR2(4000); -- To store the column names as text
BEGIN
    -- Step 1: Get the column names from the table and format them for HTML input fields
    FOR rec IN (
        SELECT COLUMN_NAME
        FROM USER_TAB_COLUMNS
        WHERE TABLE_NAME = 'MY_TABLE' -- Replace with your table name (uppercase)
        ORDER BY COLUMN_ID
    ) LOOP
        -- Concatenate HTML input field with placeholder as column name
        v_html_output := v_html_output || 
                         '<label for="' || rec.COLUMN_NAME || '">' || rec.COLUMN_NAME || ':</label>' ||
                         '<input type="text" id="' || rec.COLUMN_NAME || '" name="' || rec.COLUMN_NAME || '" placeholder="' || rec.COLUMN_NAME || '" />' ||
                         '<br>';
    END LOOP;

    -- Step 2: Output the generated HTML
    DBMS_OUTPUT.PUT_LINE(v_html_output);
END;