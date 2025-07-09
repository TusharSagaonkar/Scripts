BEGIN
  FOR rec IN (SELECT * FROM apex_user_list) LOOP
    APEX_UTIL.CREATE_USER(
      p_user_name     => rec.username,
      p_web_password  => rec.password,
      p_first_name    => rec.fullname,        -- Full name stored here
      p_developer_privs => NULL,              -- Reader only
      p_default_schema => 'YOUR_SCHEMA',      -- 🔁 Replace with your schema
      p_change_password_on_first_use => 'N'
    );
  END LOOP;
END;