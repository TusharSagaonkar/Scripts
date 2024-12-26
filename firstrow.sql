CREATE OR REPLACE PROCEDURE generate_html_with_filtering(
    p_sql_query IN VARCHAR2, 
    p_html OUT VARCHAR2
) 
IS
    l_cursor SYS_REFCURSOR;
    l_column_names VARCHAR2(4000);
    l_html_output VARCHAR2(32767) := '<!DOCTYPE html><html><head><title>Excel-Like Filterable Table</title><style>';
    l_column_count NUMBER;
    l_column_value VARCHAR2(4000);
    l_row_data VARCHAR2(4000);
    l_view_name VARCHAR2(30);
    l_temp_sql VARCHAR2(4000);
    l_first_row BOOLEAN := TRUE;
BEGIN
    -- Generate a unique temporary view name (e.g., TEMP_VIEW_<timestamp>)
    l_view_name := 'TEMP_VIEW_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');

    -- Create the temporary view based on the provided SQL query
    l_temp_sql := 'CREATE GLOBAL TEMPORARY VIEW ' || l_view_name || ' AS ' || p_sql_query;
    EXECUTE IMMEDIATE l_temp_sql;

    -- Add CSS and basic HTML structure for the table
    l_html_output := l_html_output || '
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { position: sticky; top: 0; background-color: #f2f2f2; }
        input, select { width: 90%; padding: 5px; margin-bottom: 10px; }
    </style></head><body><h2>Excel-Like Advanced Filterable Table</h2><table id="excelTable">';

    -- Open cursor for dynamic SQL query on the temporary view
    OPEN l_cursor FOR 'SELECT * FROM ' || l_view_name;

    -- Fetch column names for the table header dynamically
    FOR col IN 1..100 LOOP
        BEGIN
            -- Get column name dynamically using DBMS_SQL
            EXECUTE IMMEDIATE 'SELECT column_name FROM all_tab_columns WHERE table_name = ''' || UPPER(l_view_name) || ''' AND column_id = ' || col INTO l_column_names;
            l_column_count := col;

            -- Add each column header and filter input
            l_html_output := l_html_output || '<th>' || l_column_names || '<br>
                <select class="filter-type">
                    <option value="contains">Contains</option>
                    <option value="startsWith">Starts With</option>
                    <option value="endsWith">Ends With</option>
                    <option value="equals">Equals</option>
                    <option value="notEquals">Does Not Equal</option>
                    <option value="greaterThan">Greater Than</option>
                    <option value="lessThan">Less Than</option>
                </select>
                <input type="text" class="filter-input" placeholder="Search ' || l_column_names || '"></th>';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

    -- Add the table body (rows) dynamically
    LOOP
        FETCH l_cursor INTO l_row_data;
        EXIT WHEN l_cursor%NOTFOUND;
        
        IF l_first_row THEN
            l_html_output := l_html_output || '<tbody>';
            l_first_row := FALSE;
        END IF;
        
        l_html_output := l_html_output || '<tr>';
        
        -- Process each column and generate HTML for rows
        FOR col_idx IN 1..l_column_count LOOP
            -- Fetch the value dynamically for each column
            EXECUTE IMMEDIATE 'SELECT ' || l_column_names || ' FROM ' || l_view_name INTO l_column_value;
            
            l_html_output := l_html_output || '<td>' || NVL(l_column_value, 'NULL') || '</td>';
        END LOOP;
        
        l_html_output := l_html_output || '</tr>';
    END LOOP;

    -- Close the cursor
    CLOSE l_cursor;

    -- Close the HTML table and body
    l_html_output := l_html_output || '</tbody></table>';

    -- Add JavaScript for filtering logic
    l_html_output := l_html_output || '
    <script>
        const table = document.getElementById("excelTable");
        const inputs = table.querySelectorAll(".filter-input");
        const selects = table.querySelectorAll(".filter-type");

        // Attach event listeners to all inputs and selects
        inputs.forEach((input, index) => {
            input.addEventListener("keyup", () => applyFilters());
            selects[index].addEventListener("change", () => applyFilters());
        });

        function applyFilters() {
            const rows = table.querySelectorAll("tbody tr");

            rows.forEach(row => {
                let isVisible = true;

                // Check all filters
                inputs.forEach((input, colIndex) => {
                    const filterValue = input.value.toLowerCase();
                    const filterType = selects[colIndex].value;
                    const cell = row.cells[colIndex];
                    const cellText = cell ? (cell.textContent || cell.innerText).toLowerCase() : "";

                    if (filterValue) {
                        const cellValue = isNaN(cellText) ? cellText : parseFloat(cellText);
                        const inputValue = isNaN(filterValue) ? filterValue : parseFloat(filterValue);

                        if (filterType === "contains" && !cellText.includes(filterValue)) {
                            isVisible = false;
                        } else if (filterType === "startsWith" && !cellText.startsWith(filterValue)) {
                            isVisible = false;
                        } else if (filterType === "endsWith" && !cellText.endsWith(filterValue)) {
                            isVisible = false;
                        } else if (filterType === "equals" && cellValue != inputValue) {
                            isVisible = false;
                        } else if (filterType === "notEquals" && cellValue == inputValue) {
                            isVisible = false;
                        } else if (filterType === "greaterThan" && cellValue <= inputValue) {
                            isVisible = false;
                        } else if (filterType === "lessThan" && cellValue >= inputValue) {
                            isVisible = false;
                        }
                    }
                });

                // Set row visibility
                row.style.display = isVisible ? "" : "none";
            });
        }
    </script>';

    -- Return the generated HTML as output
    p_html := l_html_output;

    -- Drop the temporary view after successful HTML generation
    EXECUTE IMMEDIATE 'DROP VIEW ' || l_view_name;

EXCEPTION
    WHEN OTHERS THEN
        -- In case of any error, make sure the temporary view is dropped
        EXECUTE IMMEDIATE 'DROP VIEW ' || l_view_name;
        RAISE;
END generate_html_with_filtering;