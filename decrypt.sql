CREATE OR REPLACE FUNCTION decrypt(p_string RAW)  
RETURN VARCHAR2 AS  
    v_key RAW(16) := UTL_RAW.cast_to_raw('1234567890999899'); -- 16-byte AES key  
    v_iv  RAW(16) := UTL_RAW.cast_to_raw('abcdefghijklmnop'); -- Same IV as encryption  
    v_decrypted_raw RAW(2000);  
    v_decrypted_string VARCHAR2(2000);  
BEGIN  
    v_decrypted_raw := DBMS_CRYPTO.decrypt(  
        src => p_string,  
        typ => DBMS_CRYPTO.ENCRYPT_AES128 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,  
        key => v_key,  
        iv  => v_iv  
    );  

    v_decrypted_string := UTL_RAW.cast_to_varchar2(v_decrypted_raw);  

    RETURN v_decrypted_string;  
END;  
/