DECLARE
  v_workspace_id NUMBER;
BEGIN
  -- Step 1: Set workspace context
  SELECT workspace_id
    INTO v_workspace_id
    FROM apex_workspaces
   WHERE workspace = 'YOUR_WORKSPACE_NAME';  -- 🔁 Replace with your workspace name

  APEX_UTIL.SET_SECURITY_GROUP_ID(v_workspace_id);

  -- Step 2: Force password change for each user
  FOR rec IN (SELECT username FROM apex_user_list) LOOP
    APEX_UTIL.EDIT_USER(
      p_user_name                     => rec.username,
      p_web_password                  => NULL,          -- Keep current password
      p_first_name                    => NULL,
      p_last_name                     => NULL,
      p_email_address                 => NULL,
      p_description                   => NULL,
      p_account_locked                => NULL,
      p_account_expiry               => NULL,
      p_failed_access_attempts       => NULL,
      p_change_password_on_first_use => 'Y',
      p_attribute_01                 => NULL,
      p_attribute_02                 => NULL,
      p_attribute_03                 => NULL,
      p_attribute_04                 => NULL,
      p_attribute_05                 => NULL,
      p_attribute_06                 => NULL,
      p_attribute_07                 => NULL,
      p_attribute_08                 => NULL,
      p_attribute_09                 => NULL,
      p_attribute_10                 => NULL
    );
  END LOOP;
END;