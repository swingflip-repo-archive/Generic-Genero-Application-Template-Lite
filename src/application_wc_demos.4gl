################################################################################
#APPLICATION WEBCOMPONENT DEMOS
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
#
#This is where all the genero webcomponent demo window functions  are located...
#
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

FUNCTION wc_signature_demo() #Webcomponent Demo (Signature) window function (Part of Interactivity Demo)

    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "wc_signature"
    ELSE
        OPEN WINDOW w WITH FORM "wc_signature"
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

    LET TERMINATE = FALSE

    WHILE TERMINATE = FALSE
        MENU
        
            ON TIMER g_timed_checks_time
                CALL connection_test()
                CALL timed_upload_queue_data()
                
            BEFORE MENU
                CALL connection_test()
              
            ON ACTION bt_go_back
                LET g_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "go_back"
            CLOSE WINDOW w
            CALL interact_demo()
        WHEN "logout"
            INITIALIZE g_user TO NULL
            INITIALIZE g_logged_in TO NULL
            DISPLAY "Logged out successfully!"
            CLOSE WINDOW w
            CALL login_screen()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL close_app()
    END CASE

END FUNCTION
#
#
FUNCTION wc_maps_demo() #Webcomponent Demo (Signature) window function (Part of Interactivity Demo)

    DEFINE
        f_latlng_record RECORD
            lat FLOAT,
            lng FLOAT
        END RECORD,
        f_result STRING,
        f_obj util.JSONObject,
        f_dummy STRING
        
    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "wc_google_maps"
    ELSE
        OPEN WINDOW w WITH FORM "wc_google_maps"
    END IF

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
    
LABEL go_back_wc_maps_demo: 

    INPUT f_dummy, f_latlng_record.lat, f_latlng_record.lng FROM wc_gm, lat, lng ATTRIBUTES(UNBUFFERED)

        #ON TIMER can cause some grief when running in an INPUT in terms of field validation. Disabled for now.
        #ON TIMER g_timed_checks_time
           #CALL connection_test()
            #CALL timed_upload_queue_data()

        BEFORE INPUT
            CALL DIALOG.setActionHidden("accept",1)
            CALL DIALOG.setActionHidden("cancel",1)
            CALL DIALOG.setActionHidden("mapclicked",1)

        ON ACTION ACCEPT
            #Do Nothing
        ON ACTION CANCEL
            #Do Nothing
        ON ACTION bt_go
            INITIALIZE f_result TO NULL
            TRY 
              CALL ui.Interface.frontCall("webcomponent","call",["formonly.wc_gm","goToLocation",util.JSON.stringify(f_latlng_record)],[f_result])
            CATCH
              ERROR err_get(status)
              DISPLAY err_get(status)
            END TRY
        ON ACTION mapclicked
            INITIALIZE f_result TO NULL
            TRY 
              CALL ui.Interface.frontCall("webcomponent","call",["formonly.wc_gm","returnlatlng","run"],[f_result])
            CATCH
              ERROR err_get(status)
              DISPLAY err_get(status)
            END TRY
            IF f_result IS NOT NULL
            THEN
                LET f_obj = util.JSONObject.parse(f_result)
                CALL f_obj.toFGL(f_latlng_record)
                CALL ui.Interface.refresh() #Just incase...
            END IF
        ON ACTION bt_go_back
            LET g_instruction = "go_back"
            EXIT INPUT   

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
            CALL login_screen()
        OTHERWISE
            GOTO go_back_wc_maps_demo
    END CASE

END FUNCTION
#
#
FUNCTION wc_video_demo() #Webcomponent Demo (Signature) window function (Part of Interactivity Demo)

    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "wc_video"
    ELSE
        OPEN WINDOW w WITH FORM "wc_video"
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

    LET TERMINATE = FALSE

    WHILE TERMINATE = FALSE
        MENU
        
            ON TIMER g_timed_checks_time
                CALL connection_test()
                CALL timed_upload_queue_data()
                
            BEFORE MENU
                CALL connection_test()
              
            ON ACTION bt_go_back
                LET g_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "go_back"
            CLOSE WINDOW w
            CALL interact_demo()
        WHEN "logout"
            INITIALIZE g_user TO NULL
            INITIALIZE g_logged_in TO NULL
            DISPLAY "Logged out successfully!"
            CLOSE WINDOW w
            CALL login_screen()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL close_app()
    END CASE

END FUNCTION