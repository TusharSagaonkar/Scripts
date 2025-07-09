DECLARE
  v_workspace_id NUMBER;
BEGIN
  -- Set workspace context
  SELECT workspace_id
    INTO v_workspace_id
    FROM apex_workspaces
   WHERE workspace = 'YOUR_WORKSPACE_NAME'; -- Replace this

  APEX_UTIL.SET_SECURITY_GROUP_ID(v_workspace_id);

  -- Loop through your user list
  FOR rec IN (SELECT username FROM apex_user_list) LOOP
    APEX_UTIL.EDIT_USER(
      p_user_name                    => rec.username,
      p_change_password_on_first_use => 'Y'
    );
  END LOOP;
END;