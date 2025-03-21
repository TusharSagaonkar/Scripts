CREATE OR REPLACE FUNCTION get_valid_mobile(p_mobile IN VARCHAR2) 
RETURN VARCHAR2 
IS
    -- Regular expression to validate mobile numbers with optional prefixes:
    -- 1. +91XXXXXXXXXX
    -- 2. 91XXXXXXXXXX
    -- 3. 0XXXXXXXXXX
    -- 4. XXXXXXXXXX (10 digits, starts with 6-9)
    v_regex_pattern CONSTANT VARCHAR2(100) := '^(0*|(\+91)?|91)?[6-9][0-9]{9}$';

    -- Pattern to reject numbers where the same digit is repeated 10 or more times
    v_repeated_pattern CONSTANT VARCHAR2(100) := '^(0*|(\+91)?|91)?([0-9])\3{9,}$';

    v_cleaned_mobile VARCHAR2(50);
BEGIN
    -- Step 1: Remove spaces and trim input
    v_cleaned_mobile := TRIM(REPLACE(p_mobile, ' ', ''));

    -- Step 2: Validate format and check for repeated digits
    IF REGEXP_LIKE(v_cleaned_mobile, v_regex_pattern) 
       AND NOT REGEXP_LIKE(v_cleaned_mobile, v_repeated_pattern) THEN
        -- Step 3: Extract the last 10 digits
        RETURN SUBSTR(v_cleaned_mobile, LENGTH(v_cleaned_mobile) - 9, 10);
    ELSE
        RETURN NULL;  -- Return NULL for invalid numbers
    END IF;
END;
/