CREATE OR REPLACE FUNCTION Encrypt(input_string IN VARCHAR2) RETURN RAW IS
    v_ccn_raw      RAW(128) := UTL_RAW.cast_to_raw(input_string);
    v_key          RAW(16) := UTL_RAW.cast_to_raw('1234567890abcdef'); -- 16-byte key
    v_iv           RAW(16) := UTL_RAW.cast_to_raw('abcdefghijklmnop'); -- 16-byte IV
    v_encrypted_raw RAW(2048);
BEGIN
    v_encrypted_raw := DBMS_CRYPTO.encrypt(
        src => v_ccn_raw,
        typ => DBMS_CRYPTO.ENCRYPT_AES128 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => v_key,
        iv  => v_iv
    );
    RETURN v_encrypted_raw;
END;
/