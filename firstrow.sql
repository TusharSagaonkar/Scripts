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
    l_row_data SYS.DBMS_SQL.VARCHAR2_TABLE;
BEGIN
    -- Add CSS and basic HTML structure
    l_html_output := l_html_output || '
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { position: sticky; top: 0; background-color: #f2f2f2; }
        input, select { width: 90%; padding: 5px; margin-bottom: 10px; }
    </style></head><body><h2>Excel-Like Advanced Filterable Table</h2><table>';

    -- Open cursor for dynamic SQL query
    OPEN l_cursor FOR p_sql_query;

    -- Fetch column names for the table header dynamically
    FOR col IN 1..100 LOOP
        BEGIN
            -- Get column name dynamically using DBMS_SQL
            EXECUTE IMMEDIATE 'SELECT column_name FROM all_tab_columns WHERE table_name = ''&table_name'' AND column_id = ' || col INTO l_column_names;
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
        
        l_html_output := l_html_output || '<tr>';
        
        -- Process each column and generate HTML for rows
        FOR col_idx IN 1..l_column_count LOOP
            l_column_value := l_row_data(col_idx);
            
            l_html_output := l_html_output || '<td>' || l_column_value || '</td>';
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
END generate_html_with_filtering;