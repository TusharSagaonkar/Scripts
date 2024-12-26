DECLARE
    v_sql    CLOB;
BEGIN
    -- Step 1: Generate the dynamic SQL to include column names as the first row
    SELECT 
        'SELECT ' || LISTAGG('''' || COLUMN_NAME || '''', ', ') 
                    WITHIN GROUP (ORDER BY COLUMN_ID) || 
        ' FROM DUAL UNION ALL SELECT ' || LISTAGG(COLUMN_NAME, ', ') 
                                         WITHIN GROUP (ORDER BY COLUMN_ID) || 
        ' FROM MY_TABLE'
    INTO v_sql
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'MY_TABLE';

    -- Step 2: Execute the dynamic query
    EXECUTE IMMEDIATE v_sql;
END;