DECLARE
    l_user_id                       NUMBER;
    l_workspace                     VARCHAR2(255);
    l_user_name                     VARCHAR2(100);
    l_first_name                    VARCHAR2(255);
    l_last_name                     VARCHAR2(255);
    l_web_password                  VARCHAR2(255);
    l_email_address                 VARCHAR2(240);
    l_start_date                    DATE;
    l_end_date                      DATE;
    l_employee_id                   NUMBER(15,0);
    l_allow_access_to_schemas       VARCHAR2(4000);
    l_person_type                   VARCHAR2(1);
    l_default_schema                VARCHAR2(30);
    l_groups                        VARCHAR2(1000);
    l_developer_role                VARCHAR2(60);
    l_description                   VARCHAR2(240);
    l_account_expiry                DATE;
    l_account_locked                VARCHAR2(1);
    l_failed_access_attempts        NUMBER;
    l_first_password_use_occurred   VARCHAR2(1);

    v_workspace_id                  NUMBER;
BEGIN
    -- Get workspace ID and set APEX context
    SELECT workspace_id
      INTO v_workspace_id
      FROM apex_workspaces
     WHERE workspace = 'YOUR_WORKSPACE_NAME'; -- 🔁 Replace with your workspace name

    APEX_UTIL.SET_SECURITY_GROUP_ID(v_workspace_id);

    -- Loop through each user in apex_user_list
    FOR rec IN (SELECT username FROM apex_user_list) LOOP
        BEGIN
            -- Get internal APEX user ID
            l_user_id := APEX_UTIL.GET_USER_ID(rec.username);

            -- Fetch current user details
            APEX_UTIL.FETCH_USER(
                p_user_id                       => l_user_id,
                p_workspace                     => l_workspace,
                p_user_name                     => l_user_name,
                p_first_name                    => l_first_name,
                p_last_name                     => l_last_name,
                p_web_password                  => l_web_password,
                p_email_address                 => l_email_address,
                p_start_date                    => l_start_date,
                p_end_date                      => l_end_date,
                p_employee_id                   => l_employee_id,
                p_allow_access_to_schemas       => l_allow_access_to_schemas,
                p_person_type                   => l_person_type,
                p_default_schema                => l_default_schema,
                p_groups                        => l_groups,
                p_developer_role                => l_developer_role,
                p_description                   => l_description,
                p_account_expiry                => l_account_expiry,
                p_account_locked                => l_account_locked,
                p_failed_access_attempts        => l_failed_access_attempts,
                p_change_password_on_first_use  => l_change_password_on_first_use,
                p_first_password_use_occurred   => l_first_password_use_occurred
            );

            -- Edit user and force password change
            APEX_UTIL.EDIT_USER (
                p_user_id                       => l_user_id,
                p_user_name                     => l_user_name,
                p_first_name                    => l_first_name,
                p_last_name                     => l_last_name,
                p_web_password                  => l_web_password,
                p_new_password                  => l_web_password,
                p_email_address                 => l_email_address,
                p_start_date                    => l_start_date,
                p_end_date                      => l_end_date,
                p_employee_id                   => l_employee_id,
                p_allow_access_to_schemas       => l_allow_access_to_schemas,
                p_person_type                   => l_person_type,
                p_default_schema                => l_default_schema,
                p_group_ids                     => l_groups,
                p_developer_roles               => l_developer_role,
                p_description                   => l_description,
                p_account_expiry                => l_account_expiry,
                p_account_locked                => l_account_locked,
                p_failed_access_attempts        => l_failed_access_attempts,
                p_change_password_on_first_use  => 'Y',  -- 👈 Force it
                p_first_password_use_occurred   => 'N'
            );
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Failed for user: ' || rec.username || ' - ' || SQLERRM);
        END;
    END LOOP;
END;