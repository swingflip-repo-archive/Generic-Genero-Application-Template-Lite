################################################################################
#APPLICATION TOOLS
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
#
#This is where the applciation tools are located. These include the user
#management tools too.
################################################################################
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

FUNCTION tool_check_password() #Tool to check if a password for a user is correct or not

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
                CALL fgl_winmessage(%"tool.string.Password_Checker",%"tool.string.Status"|| ": " || %"tool.string.Ok", "information") 
                NEXT FIELD password
            ELSE
                CALL fgl_winmessage(%"tool.string.Password_Checker",%"tool.string.Status"|| ": " || %"tool.string.Failed", "information") 
                NEXT FIELD password
            END IF
            
    END INPUT

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "go_back"
            CLOSE WINDOW w
            CALL admin_tools()
        WHEN "logout"
            INITIALIZE g_user TO NULL
            INITIALIZE g_logged_in TO NULL
            DISPLAY "Logged out successfully!"
            CLOSE WINDOW w
            CALL login_screen()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL admin_tools()
    END CASE

END FUNCTION

FUNCTION tool_hash_generator() #Tool to generate a hashed value based off a clear text string

    DEFINE f_plain_string STRING,
           f_salt STRING,
           f_hashed_string STRING,
           f_status STRING
        
    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "tool_hash_generator"
    ELSE
        OPEN WINDOW w WITH FORM "tool_hash_generator"
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

    INPUT f_plain_string FROM plain_string ATTRIBUTE(UNBUFFERED)
        
        BEFORE INPUT
            CALL DIALOG.setActionHidden("accept",1)
            CALL DIALOG.setActionHidden("cancel",1)
            LET f_salt = Security.BCrypt.GenerateSalt(12)

        ON ACTION bt_submit
            ACCEPT INPUT

        ON ACTION bt_go_back
            LET g_instruction = "go_back"
            EXIT INPUT

        ON ACTION CLOSE
            LET g_instruction = "go_back"
            EXIT INPUT
            
        AFTER INPUT
            CALL Security.BCrypt.HashPassword(f_plain_string, f_salt) RETURNING f_hashed_string

            IF Security.BCrypt.CheckPassword(f_plain_string, f_hashed_string) THEN
                LET f_status = %"tool.string.Pass"
            ELSE
                LET f_status = %"tool.string.Failed"
            END IF

            CALL fgl_winmessage("tool.string.Hash_Generator",%"tool.string.Status" || ": " || f_status || "\n" ||
                                %"tool.string.Plain_String" || ": " || f_plain_string || "\n" ||
                                %"tool.string.Hashed_String" || ": " || f_hashed_string || "\n" ||
                                %"tool.string.Salt" || ": " || f_salt, "information") 
            NEXT FIELD plain_string
            
    END INPUT

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "go_back"
            CLOSE WINDOW w
            CALL admin_tools()
        WHEN "logout"
            INITIALIZE g_user TO NULL
            INITIALIZE g_logged_in TO NULL
            DISPLAY "Logged out successfully!"
            CLOSE WINDOW w
            CALL login_screen()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL admin_tools()
    END CASE

END FUNCTION