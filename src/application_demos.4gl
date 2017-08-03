################################################################################
#APPLICATION DEMOS
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
#
#This is where all the genero demo window functions are located...
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
        
FUNCTION image_program() #Image Web Service Demo window function

    DEFINE
        f_words STRING,
        f_temp_img_queue DYNAMIC ARRAY OF STRING,
        f_index INTEGER,
        f_queue_count INTEGER,
        f_payload STRING

    OPEN WINDOW w WITH FORM "photo"

    LET TERMINATE = FALSE
    INITIALIZE global.g_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF global.g_info.deployment_type <> "GMA" AND global.g_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(global.g_title)
    ELSE
        IF global_config.g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(global.g_title)
        END IF
    END IF

    LET TERMINATE = FALSE

    WHILE TERMINATE = FALSE
        MENU
        
            ON TIMER global_config.g_timed_checks_time
                CALL connection_test()
                CALL timed_upload_queue_data()
                
            BEFORE MENU
                CALL connection_test()
                LET f_words = %"main.string.Photo_Explanation"
                DISPLAY f_words TO words
                LET f_queue_count = 0
                INITIALIZE f_temp_img_queue TO NULL
                
            ON ACTION CLOSE
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_takep
                IF f_temp_img_queue.getLength() = 0
                THEN
                    LET f_index = 1
                END IF
                CALL ui.Interface.frontCall("mobile","takePhoto",[],[f_temp_img_queue[f_index]])
                DISPLAY f_temp_img_queue[f_index]
                IF f_temp_img_queue[f_index] IS NOT NULL
                THEN
                    LET f_queue_count = f_queue_count + 1
                    IF f_queue_count = 1
                    THEN
                        DISPLAY f_queue_count || %"main.string.Photo_In_Temporary_Queue" TO status
                    ELSE
                        DISPLAY f_queue_count || %"main.string.Photos_In_Temporary_Queue" TO status
                    END IF
                    LET f_index = f_index + 1
                ELSE
                    #DISPLAY "Action cancelled by user"
                    IF f_temp_img_queue.getLength() = 1
                    THEN
                        INITIALIZE f_temp_img_queue TO NULL
                    END IF
                END IF
            ON ACTION bt_choosep
                IF f_temp_img_queue.getLength() = 0
                THEN
                    LET f_index = 1
                END IF
                CALL ui.Interface.frontCall("mobile","choosePhoto",[],[f_temp_img_queue[f_index]])
                DISPLAY f_temp_img_queue[f_index]
                IF f_temp_img_queue[f_index] IS NOT NULL
                THEN
                    LET f_queue_count = f_queue_count + 1
                    IF f_queue_count = 1
                    THEN
                        DISPLAY f_queue_count || %"main.string.Photo_In_Temporary_Queue" TO status
                    ELSE
                        DISPLAY f_queue_count || %"main.string.Photos_In_Temporary_Queue" TO status
                    END IF
                    LET f_index = f_index + 1
                ELSE
                    #DISPLAY "Action cancelled by user"
                    IF f_temp_img_queue.getLength() = 1
                    THEN
                        INITIALIZE f_temp_img_queue TO NULL
                    END IF
                END IF
            ON ACTION bt_cancel
                IF f_temp_img_queue.getLength() = 0
                THEN
                    CALL fgl_winmessage(%"main.string.Image_Upload", %"main.string.No_Images_To_Cancel", "information")
                ELSE
                    IF reply_yn("N"," ",%"main.string.Are_You_Sure_To_Cancel")
                    THEN
                        LET f_queue_count = 0
                        INITIALIZE f_temp_img_queue TO NULL
                        DISPLAY " " TO status
                        MESSAGE %"main.string.Cleared_Image_Queue"
                    END IF
                END IF
            ON ACTION bt_confirm
                IF f_temp_img_queue.getLength() = 0
                THEN
                    CALL fgl_winmessage(%"main.string.Image_Upload", %"main.string.No_Temp_Images_To_Upload", "information")
                ELSE
                    FOR f_index = 1 TO f_temp_img_queue.getLength()
                        IF f_temp_img_queue[f_index] IS NOT NULL
                        THEN
                            DISPLAY "Grabbing image: " || f_temp_img_queue[f_index]
                            CALL fgl_getfile(f_temp_img_queue[f_index],"imageupload_" || f_index)
                            DISPLAY "Encoding image into Base64 ready for transport..."
                            LET f_payload = util.Strings.base64Encode("imageupload_" || f_index)
                            DISPLAY "Loading payload into local delivery queue..."
                            CALL load_payload(global.g_user,"IMAGE",f_payload)
                                RETURNING m_ok
                        END IF
                    END FOR
                    IF reply_yn("Y"," ",%"main.string.Images_Loaded_Successfully")
                    THEN
                        CALL connection_test()
                        IF global.g_online = "NONE"
                        THEN
                            IF global_config.g_enable_timed_image_upload = TRUE AND global_config.g_timed_checks_time > 0
                            THEN
                                CALL fgl_winmessage(%"main.string.Warning_title", %"main.string.You_Are_Offline_Auto_Retry", "information")
                                LET f_queue_count = 0
                                INITIALIZE f_temp_img_queue TO NULL
                                DISPLAY " " TO status 
                            ELSE
                                CALL fgl_winmessage(%"main.string.Warning_title", %"main.string.You_Are_Offline_Try_Again", "information")
                                LET f_queue_count = 0
                                INITIALIZE f_temp_img_queue TO NULL
                                DISPLAY " " TO status
                            END IF
                        ELSE
                            CALL upload_image_payload(FALSE)
                            LET f_queue_count = 0
                            INITIALIZE f_temp_img_queue TO NULL
                            DISPLAY " " TO status
                        END IF
                    ELSE
                        MESSAGE %"main.string.Images_Loaded_In_Queue"
                        LET f_queue_count = 0
                        INITIALIZE f_temp_img_queue TO NULL
                        DISPLAY " " TO status
                    END IF
                END IF
            ON ACTION bt_viewpho
                CALL ui.Interface.frontCall("standard", "launchURL", [global_config.g_ws_end_point], [])
            ON ACTION bt_go_back
                LET global.g_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE global.g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "go_back"
            CLOSE WINDOW w
            CALL open_application()
        WHEN "logout"
            INITIALIZE global.g_user TO NULL
            INITIALIZE global.g_logged_in TO NULL
            DISPLAY "Logged out successfully!"
            CLOSE WINDOW w
            CALL login_screen()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL close_app()
    END CASE

END FUNCTION