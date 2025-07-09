BEGIN
  FOR rec IN (SELECT username FROM apex_user_list) LOOP
    APEX_UTIL.SET_USER_ATTRIBUTE(
      p_user_name => rec.username,
      p_attribute_name => 'CHANGE_PASSWORD_ON_FIRST_USE',
      p_attribute_value => 'Y'
    );
  END LOOP;
END;