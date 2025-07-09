DECLARE
  v_workspace_id NUMBER;
  v_user_id      NUMBER;
BEGIN
  -- Step 1: Set workspace context
  SELECT workspace_id
    INTO v_workspace_id
    FROM apex_workspaces
   WHERE workspace = 'YOUR_WORKSPACE_NAME'; -- 🔁 Replace with your actual workspace name

  APEX_UTIL.SET_SECURITY_GROUP_ID(v_workspace_id);

  -- Step 2: Loop through each user in your list
  FOR rec IN (SELECT username FROM apex_user_list) LOOP
    BEGIN
      -- Get the internal APEX user ID
      SELECT user_id INTO v_user_id
      FROM apex_workspace_apex_users
      WHERE user_name = rec.username;

      -- Call the full EDIT_USER procedure
      APEX_UTIL.EDIT_USER(
        p_user_id                      => v_user_id,
        p_user_name                    => rec.username,
        p_first_name                   => NULL,
        p_last_name                    => NULL,
        p_web_password                 => NULL,
        p_new_password                 => NULL,
        p_email_address                => NULL,
        p_start_date                   => NULL,
        p_end_date                     => NULL,
        p_employee_id                  => NULL,
        p_allow_access_to_schemas      => NULL,
        p_person_type                  => NULL,
        p_default_schema               => NULL,
        p_group_ids                    => NULL,
        p_developer_roles              => NULL,
        p_description                  => NULL,
        p_account_expiry               => NULL,
        p_account_locked               => 'N',
        p_failed_access_attempts       => 0,
        p_change_password_on_first_use => 'Y',
        p_first_password_use_occurred  => 'N'
      );
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('User not found: ' || rec.username);
    END;
  END LOOP;
END;