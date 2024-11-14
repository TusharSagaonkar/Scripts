CREATE OR REPLACE FUNCTION is_valid_mobile(p_mobile IN VARCHAR2) 
RETURN VARCHAR2 
IS
    -- Regular expression to validate:
    -- 1. +91 followed by 10 digits (e.g., +919029918311)
    -- 2. 91 followed by 10 digits (e.g., 919029918311)
    -- 3. 10 digits starting with 6-9 (e.g., 9029918311)
    v_regex_pattern CONSTANT VARCHAR2(100) := '^(\+91|91)?[6-9][0-9]{9}$';
BEGIN
    -- Check if input matches the pattern
    IF REGEXP_LIKE(p_mobile, v_regex_pattern) THEN
        RETURN 'Y';  -- Valid mobile number
    ELSE
        RETURN 'N';  -- Invalid mobile number
    END IF;
END;
/
