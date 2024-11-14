CREATE OR REPLACE FUNCTION is_valid_mobile(p_mobile IN VARCHAR2) 
RETURN VARCHAR2 
IS
    -- Regex pattern to validate the mentioned formats:
    -- 1. +91XXXXXXXXXX
    -- 2. 91XXXXXXXXXX
    -- 3. 0XXXXXXXXXX (with one or more leading zeros)
    -- 4. XXXXXXXXXX (10 digits starting with 6-9)
    v_regex_pattern CONSTANT VARCHAR2(100) := '^(0*|(\+91)?|91)?[6-9][0-9]{9}$';
    v_trimmed_mobile VARCHAR2(50);
BEGIN
    -- Remove leading and trailing spaces
    v_trimmed_mobile := TRIM(p_mobile);

    -- Check if the trimmed input matches the pattern
    IF REGEXP_LIKE(v_trimmed_mobile, v_regex_pattern) THEN
        RETURN 'Y';  -- Valid mobile number
    ELSE
        RETURN 'N';  -- Invalid mobile number
    END IF;
END;
/
