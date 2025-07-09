BEGIN
  FOR rec IN (SELECT * FROM apex_user_list) LOOP
    APEX_UTIL.EDIT_USER(
      p_user_name     => rec.username,
      p_change_password_on_first_use => 'Y' -- Set to 'Y' to force password change
    );
  END LOOP;
END;
/
