IMPORT os
IMPORT util
IMPORT SECURITY
GLOBALS "globals.4gl"

    DEFINE #These are very useful module variables to have defined!
        TERMINATE SMALLINT,
        m_string_buffer base.StringBuffer,
        m_string_tokenizer base.StringTokenizer,
        m_window ui.Window,
        m_form ui.Form,
        m_dom_node1 om.DomNode,
        m_index INTEGER,
        m_ok SMALLINT

FUNCTION tool_check_password() #Webcomponent Demo (Signature) window function (Part of Interactivity Demo)

    DEFINE f_username STRING,
        f_password STRING
        
    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "tool_check_password"
    ELSE
        OPEN WINDOW w WITH FORM "tool_check_password"
    END IF

    LET TERMINATE = FALSE
    INITIALIZE g_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF g_info.deployment_type <> "GMA" AND g_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(g_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(g_title)
        END IF
    END IF

    INPUT f_username, f_password FROM username, password ATTRIBUTE(UNBUFFERED)
        
        BEFORE INPUT
            CALL DIALOG.setActionHidden("accept",1)
            CALL DIALOG.setActionHidden("cancel",1)

        ON CHANGE username
            LET f_username = downshift(f_username)

        ON ACTION bt_submit
            ACCEPT INPUT

        ON ACTION bt_go_back
            LET g_instruction = "go_back"
            EXIT INPUT

        ON ACTION CLOSE
            LET g_instruction = "go_back"
            EXIT INPUT
            
        AFTER INPUT
          CALL check_password(f_username,f_password) RETURNING m_ok
          INITIALIZE f_password TO NULL #Clean down the plain text password
          
          IF m_ok = TRUE
          THEN
              CALL fgl_winmessage("User Password Check","Status: " || "OK", "information") 
              NEXT FIELD password
          ELSE
              CALL fgl_winmessage("User Password Check","Status: " || "FAILED", "information") 
              NEXT FIELD password
          END IF
            
    END INPUT

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "go_back"
            CLOSE WINDOW w
            CALL interact_demo()
        WHEN "logout"
            INITIALIZE g_user TO NULL
            INITIALIZE g_logged_in TO NULL
            DISPLAY "Logged out successfully!"
            CLOSE WINDOW w
            CALL admin_tools()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL close_app()
    END CASE

END FUNCTION