CREATE OR REPLACE FUNCTION get_valid_pincode(p_pincode IN VARCHAR2) 
RETURN VARCHAR2 
IS
    -- Indian pincode pattern: exactly 6 digits, first digit between 1-9
    v_regex_pattern CONSTANT VARCHAR2(50) := '^[1-9][0-9]{5}$';

    -- Reject pincodes with all identical digits (e.g., '000000', '777777')
    v_repeated_pattern CONSTANT VARCHAR2(50) := '^([0-9])\1{5}$';

    v_cleaned_pincode VARCHAR2(20);
BEGIN
    -- Step 1: Remove spaces and trim input
    v_cleaned_pincode := TRIM(REPLACE(p_pincode, ' ', ''));

    -- Step 2: Ensure only numeric characters (no alphabets/special characters)
    IF NOT REGEXP_LIKE(v_cleaned_pincode, '^[0-9]+$') THEN
        RETURN NULL;  -- Invalid if non-numeric characters exist
    END IF;

    -- Step 3: Validate pincode format and reject repeated digits
    IF REGEXP_LIKE(v_cleaned_pincode, v_regex_pattern) 
       AND NOT REGEXP_LIKE(v_cleaned_pincode, v_repeated_pattern) THEN
        RETURN v_cleaned_pincode;  -- Return valid 6-digit pincode
    ELSE
        RETURN NULL;  -- Invalid pincode
    END IF;
END;
/