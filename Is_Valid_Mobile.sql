CREATE OR REPLACE FUNCTION is_valid_mobile(p_mobile IN VARCHAR2) 
RETURN VARCHAR2 
IS
    -- Regular expression to validate the following valid formats:
    -- 1. +91XXXXXXXXXX  (e.g., +919029918311)
    -- 2. 91XXXXXXXXXX   (e.g., 919029918311)
    -- 3. 0XXXXXXXXXX    (e.g., 09029918311, 009029918311)
    -- 4. XXXXXXXXXX     (e.g., 9029918311) - 10 digits, starting with 6-9
    -- 5. Spaces between digits should be ignored (e.g., '98 20 37 46 83' -> '9820374683')
    v_regex_pattern CONSTANT VARCHAR2(100) := '^(0*|(\+91)?|91)?[6-9][0-9]{9}$';

    -- Regular expression to reject mobile numbers where the same digit is repeated 10 or more times:
    -- Examples of invalid numbers:
    -- 1. '0000000000', '9999999999', '8888888888' (same digit repeated 10 times)
    -- 2. '917777777777', '06666666666' (same digit repeated 10+ times, even with prefix)
    v_repeated_pattern CONSTANT VARCHAR2(100) := '^(0*|(\+91)?|91)?([0-9])\3{9,}$';

    v_cleaned_mobile VARCHAR2(50);
BEGIN
    -- Step 1: Remove spaces within the mobile number
    v_cleaned_mobile := TRIM(REPLACE(p_mobile, ' ', ''));

    -- Step 2: Validate the cleaned mobile number
    IF REGEXP_LIKE(v_cleaned_mobile, v_regex_pattern) 
       AND NOT REGEXP_LIKE(v_cleaned_mobile, v_repeated_pattern) THEN
        RETURN 'Y';  -- Valid mobile number
    ELSE
        RETURN 'N';  -- Invalid mobile number
    END IF;
END;
/