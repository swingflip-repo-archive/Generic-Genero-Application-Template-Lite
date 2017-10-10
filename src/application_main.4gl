################################################################################
#APPLICATION MAIN
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
#
#The main bulk of the application is located here with the demos and tools
#broken in to seperate modules to make things easier to manage...
################################################################################
IMPORT os
IMPORT util
GLOBALS "globals.4gl"

    DEFINE #These are very useful module variables to have defined!
        TERMINATE SMALLINT,
        m_string_tokenizer base.StringTokenizer,
        m_window ui.Window,
        m_form ui.Form,
        m_dom_node1 om.DomNode,
        m_index INTEGER,
        m_ok SMALLINT,
        m_status STRING
        
    DEFINE
        m_username STRING,
        m_password STRING,
        m_remember STRING,
        m_image STRING
    
FUNCTION initialise_app()
    #******************************************************************************#
    #Grab deployment data...
        CALL ui.interface.getFrontEndName() RETURNING global.g_info.deployment_type
        CALL ui.interface.frontCall("standard", "feInfo", "osType", global.g_info.os_type)
        CALL ui.Interface.frontCall("standard", "feInfo", "ip", global.g_info.ip)
        CALL ui.Interface.frontCall("standard", "feInfo", "deviceId", global.g_info.device_name)    
        CALL ui.Interface.frontCall("standard", "feInfo", "screenResolution", global.g_info.resolution)

    #******************************************************************************#
    #Set global application details here...

        LET global.g_application_title =%"main.string.App_Title"
        LET global.g_application_version =%"main.string.App_Version"
        LET global.g_title =  global.g_application_title || " " || global.g_application_version
        
    #******************************************************************************#

        # RUN "set > /tmp/mobile.env" # Dump the environment for debugging.
        #BREAKPOINT #Uncomment to step through application
        DISPLAY "\nStarting up " || global.g_application_title || " " || global.g_application_version || "...\n"

        #Uncomment the below to display device data when running.
        
        IF global.g_info.deployment_type <> "GMA" AND global.g_info.deployment_type <> "GMI"
        THEN
            {DISPLAY "--Deployment Data--\n" ||
                    "Deployment Type: " || global.g_info.deployment_type || "\n" ||
                    "OS Type: " || global.g_info.os_type || "\n" ||
                    "User Locale: " || global.g_info.locale || "\n" ||
                    "Device IP: " || global.g_info.ip || "\n" ||
                    "Resolution: " || global.g_info.resolution || "\n" ||
                    "-------------------\n"}
        ELSE
            {DISPLAY "--Deployment Data--\n" ||
                    "Deployment Type: " || global.g_info.deployment_type || "\n" ||
                    "OS Type: " || global.g_info.os_type || "\n" ||
                    "User Locale: " || global.g_info.locale || "\n" ||
                    "Device IP: " || global.g_info.ip || "\n" ||
                    "Device ID: " || global.g_info.device_name || "\n" ||
                    "Resolution: " || global.g_info.resolution || "\n" ||
                    "-------------------\n"}
        END IF
        
        LET m_string_tokenizer = base.StringTokenizer.create(global.g_info.resolution,"x")

        WHILE m_string_tokenizer.hasMoreTokens()
            IF m_index = 1
            THEN
                LET global.g_info.resolution_x = m_string_tokenizer.nextToken() || "px"
            ELSE
                LET global.g_info.resolution_y = m_string_tokenizer.nextToken() || "px"
            END IF
            LET m_index = m_index + 1
        END WHILE

    #******************************************************************************#
    # HERE IS WHERE YOU CONFIGURE GOBAL SWITCHES FOR THE APPLICATION
    # ADJUST THESE AS YOU SEEM FIT. BELOW IS A LIST OF OPTIONS IN ORDER:
    #        global_config.g_application_database_ver INTEGER,               #Application Database Version (This is useful to force database additions to pre-existing db instances)
    #        global_config.g_enable_splash SMALLINT,                         #Open splashscreen when opening the application.
    #        global_config.g_splash_duration INTEGER,                        #Splashscreen duration (seconds) global_config.g_enable_splash needs to be enabled!
    #        global_config.g_enable_login SMALLINT                           #Boot in to login menu or straight into application (open_application())
    #        global_config.g_splash_width STRING,                            #Login menu splash width when not in mobile
    #        global_config.g_splash_height STRING,                           #Login menu splash height when not in mobile
    #        global_config.g_enable_geolocation SMALLINT,                    #Toggle to enable geolocation
    #        global_config.g_enable_mobile_title SMALLINT,                   #Toggle application title on mobile
    #        global_config.g_local_stat_limit INTEGER,                       #Number of max local stat records before pruning
    #        global.g_online_pinglobal_config.g_URL STRING,                         #URL of public site to test internet connectivity (i.e. http://www.google.com) 
    #        global_config.g_enable_timed_connect SMALLINT,                  #Enable timed connectivity checks
    #        global_config.g_timed_checks_time INTEGER                       #Time in seconds before checking connectivity (global_config.g_enable_timed_connect has to be enabled)
    #        global_config.g_date_format STRING                              #Datetime format. i.e.  "%d/%m/%Y %H:%M"
    #        global_config.g_image_dest STRING                               #Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet)
    #        global_config.g_ws_end_point STRING,                            #The webservice end point. 
    #        global_config.g_enable_timed_image_upload SMALLINT,             #Enable timed image queue uploads (Could have a performance impact!)
    #        global_config.g_local_images_available DYNAMIC ARRAY OF CHAR(2) #Available localisations for images.
    #        global_config.g_default_language STRING,                        #The default language used within the application (i.e. EN)
    # Here are globals not included in initialize_globals function due to sheer size of the arguement data...

       CALL sync_config("GGAT.config",FALSE)
       CALL initialize_globals()
          RETURNING m_ok
          
        IF m_ok = FALSE
        THEN
             CALL fgl_winmessage(global.g_title, %"main.string.ERROR_1001", "stop")
             EXIT PROGRAM 1001
        END IF

        IF global_config.g_enable_geolocation = TRUE
        THEN
            IF global.g_info.deployment_type <> "GMA" AND global.g_info.deployment_type <> "GMI"
            THEN
                DISPLAY "****************************************************************************************\n" ||
                        "WARNING: Set up error, track geolocation is enabled and you are not deploying in mobile.\n" ||
                        "****************************************************************************************\n"
            ELSE
                CALL ui.Interface.frontCall("mobile", "getGeolocation", [], [global.g_info.geo_status, global.g_info.geo_lat, global.g_info.geo_lon])
                DISPLAY "--Geolocation Tracking Enabled!--"
                DISPLAY "Geolocation Tracking Status: " || global.g_info.geo_status
                IF global.g_info.geo_status = "ok"
                THEN
                    DISPLAY "Latitude: " || global.g_info.geo_lat
                    DISPLAY "Longitude: " || global.g_info.geo_lon
                END IF
                DISPLAY "---------------------------------\n"
            END IF
        END IF

        CALL test_connectivity(global.g_info.deployment_type)
        CALL capture_local_stats(global.g_info.*)
            RETURNING m_ok

        CLOSE WINDOW SCREEN #Just incase
        
    #We are now initialised, we now just need to run each individual window functions...

        IF global_config.g_enable_splash = TRUE AND global_config.g_splash_duration > 0
        THEN
            CALL run_splash_screen()
        ELSE
            IF global_config.g_enable_login = TRUE
            THEN
                CALL login_screen() 
            ELSE
                CALL open_application()
            END IF
        END IF
    
END FUNCTION

################################################################################

################################################################################
#Individual window/form functions...
################################################################################

FUNCTION run_splash_screen() #Application Splashscreen window function

    DEFINE
        f_result STRING
        
    IF global.g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "splash_screen"
    ELSE
        OPEN WINDOW w WITH FORM "splash_screen"
    END IF

    INITIALIZE f_result TO NULL
    TRY 
        CALL ui.Interface.frontCall("webcomponent","call",["formonly.splashwc","setLocale",global.g_language_short],[f_result])
    CATCH
        ERROR err_get(status)
        DISPLAY err_get(status)
    END TRY
    
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

        ON TIMER global_config.g_splash_duration
            LET TERMINATE = TRUE
            EXIT MENU

        BEFORE MENU
            CALL DIALOG.setActionHidden("close",1)

        ON ACTION CLOSE
            LET TERMINATE = TRUE
            EXIT MENU
              
        END MENU
    END WHILE

    IF global_config.g_enable_login = TRUE
    THEN
        CLOSE WINDOW w
        CALL login_screen() 
    ELSE
        CLOSE WINDOW w
        CALL open_application()
    END IF

END FUNCTION
#
#
#
#
FUNCTION login_screen() #Local Login window function

    DEFINE
        f_install_type INTEGER,
        f_username STRING,
        f_password STRING,
        f_confirm_password STRING,
        f_user_type STRING,
        f_email STRING,
        f_telephone STRING,
        f_hashed_string STRING
            
        
    CALL check_new_install()
        RETURNING f_install_type

    IF f_install_type == 2
    THEN
        EXIT PROGRAM 9999
    END IF

    IF f_install_type == 1 #Fresh Install... Open new user create before running
    THEN
        IF global.g_info.deployment_type = "GDC"
        THEN
            OPEN WINDOW w WITH FORM "tool_new_install"
        ELSE
            OPEN WINDOW w WITH FORM "tool_new_install"
        END IF

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
        BREAKPOINT
        INPUT f_username, f_password, f_confirm_password, f_user_type, f_email, f_telephone
            FROM username, password, confirm_password, user_type, email, telephone ATTRIBUTE(UNBUFFERED)
            
            BEFORE INPUT
                CALL DIALOG.setActionHidden("accept",1)
                CALL DIALOG.setActionHidden("cancel",1)

            ON CHANGE username
                LET f_username = downshift(f_username)

            ON ACTION bt_submit
                ACCEPT INPUT

            ON ACTION CLOSE
                EXIT INPUT
                
            AFTER INPUT
                #Validate Input
                CALL validate_input_data(f_username, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, "") RETURNING f_username, m_ok, m_status 
                IF m_ok = FALSE
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Bad_Username","stop")
                    NEXT FIELD username
                END IF
                CALL validate_input_data(f_password, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, "") RETURNING f_password, m_ok, m_status 
                IF m_ok = FALSE
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Bad_Password","stop")
                    NEXT FIELD password
                END IF
                CALL validate_input_data(f_confirm_password, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, "") RETURNING f_confirm_password, m_ok, m_status 
                IF m_ok = FALSE
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Bad_Password","stop")
                    NEXT FIELD password
                END IF
                IF f_password != f_confirm_password 
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Mismatch_Password","stop")
                    INITIALIZE f_confirm_password TO NULL
                    NEXT FIELD confirm_password
                END IF
                IF f_user_type IS NULL
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.No_User_Type","stop")
                    NEXT FIELD user_type
                END IF      
                CALL validate_input_data(f_email, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, "EMAIL") RETURNING f_email, m_ok, m_status 
                IF m_ok = FALSE
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Bad_Email","stop")
                    NEXT FIELD email
                END IF
                CALL validate_input_data(f_telephone, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, "") RETURNING f_telephone, m_ok, m_status 
                IF m_ok = FALSE
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Bad_Telephone","stop")
                    NEXT FIELD telephone
                END IF

                SELECT COUNT(*) INTO m_index FROM local_accounts WHERE username = f_username
                IF m_index > 0 
                THEN
                    CALL fgl_winmessage(" ",%"tool.string.Username_Exists","stop")
                    NEXT FIELD username    
                END IF
                LET f_username = f_username.toLowerCase()
                CALL hash_password(f_password) RETURNING m_ok, f_hashed_string
                 
                TRY
                    INSERT INTO local_accounts VALUES(NULL,f_username,f_hashed_string,f_email,f_telephone,NULL,f_user_type)
                CATCH
                    CALL fgl_winmessage("User Create Tool","ERROR: could not create user in the database -" || sqlca.sqlcode,"stop")
                    EXIT PROGRAM 999
                END TRY

                IF f_email IS NULL THEN LET f_email = " " END IF
                IF f_telephone IS NULL THEN LET f_telephone = " " END IF
                                                         
                CALL fgl_winmessage(%"tool.string.Create_User",%"tool.string.Status" || ": " || "OK" || "\n" ||
                                                               %"tool.string.Username" || ": " || f_username || "\n" ||
                                                               %"tool.string.Password" || ": " || f_password || "\n" ||
                                                               %"tool.string.Hashed_Password" || ": " || f_hashed_string || "\n" ||
                                                               %"tool.string.User_Type" || ": " || f_user_type || "\n" ||
                                                               %"tool.string.Email" || ": " || f_email || "\n" ||
                                                               %"tool.string.Telephone" || ": " || f_telephone, "information") 

                LET global.g_instruction = "proceed"
        END INPUT

        CASE global.g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
            WHEN "proceed"
                CLOSE WINDOW w
                CALL login_screen()
            WHEN "go_back"
                CLOSE WINDOW w
                CALL admin_tools()
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
    ELSE
        IF global.g_info.deployment_type = "GDC"
        THEN
            OPEN WINDOW w WITH FORM "main_gdc"
        ELSE
            OPEN WINDOW w WITH FORM "main"
        END IF
        
        #Initialize window specific variables
      
        LET TERMINATE = FALSE
        INITIALIZE global.g_instruction TO NULL
        LET m_window = ui.Window.getCurrent()
        LET m_dom_node1 = m_window.findNode("Image","splash")

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

        #We need to adjust the image so it appears correctly in GDC,GBC,GMA and GMI

        #Set the login splash size if we are running in GDC
        IF global.g_info.deployment_type = "GDC"
        THEN
            CALL m_dom_node1.setAttribute("sizePolicy","dynamic")
            CALL m_dom_node1.setAttribute("width",global_config.g_splash_width)
            CALL m_dom_node1.setAttribute("height",global_config.g_splash_height)
        END IF

        #Set the login screen image to stretch both in GBC
        IF global.g_info.deployment_type = "GBC" 
        THEN
            CALL m_dom_node1.setAttribute("stretch","both")
        END IF

        #Set the login screen image to the corresponding language loaded
        CALL set_localised_image("splash")
            RETURNING m_image
        CALL m_dom_node1.setAttribute("image",m_image)

        INPUT m_username, m_password, m_remember FROM username, password, remember ATTRIBUTE(UNBUFFERED)

            ON TIMER global_config.g_timed_checks_time
                CALL connection_test()
            
            BEFORE INPUT
                CALL connection_test()
                LET m_form = m_window.getForm()
                CALL DIALOG.setActionHidden("accept",1)
                CALL DIALOG.setActionHidden("cancel",1)
                CALL get_local_remember()
                    RETURNING m_ok, m_remember, m_username

            ON CHANGE username
                LET m_username = m_username.toLowerCase()
                CALL refresh_local_remember(m_username, m_remember)
                    RETURNING m_ok

            ON CHANGE remember
                CALL refresh_local_remember(m_username, m_remember)
                    RETURNING m_ok

            ON CHANGE password
                CALL refresh_local_remember(m_username, m_remember)
                    RETURNING m_ok

            ON ACTION bt_login
                ACCEPT INPUT

            ON ACTION CLOSE
                EXIT INPUT
                
            AFTER INPUT
              #Validate Input
              CALL validate_input_data(m_username, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, "") RETURNING m_username, m_ok, m_status 
              IF m_ok = FALSE
              THEN
                  CALL fgl_winmessage(" ",%"main.string.Bad_Username","stop")
                  NEXT FIELD username
              END IF
              CALL validate_input_data(m_password, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, "") RETURNING m_password, m_ok, m_status 
              IF m_ok = FALSE
              THEN
                  CALL fgl_winmessage(" ",%"main.string.Bad_Password","stop")
                  NEXT FIELD password
              END IF
              #Check Password
              CALL check_password(m_username,m_password) RETURNING m_ok
              INITIALIZE m_password TO NULL #Clean down the plain text password
              
              IF m_ok = TRUE
              THEN
                  LET global.g_instruction = "connection"
                  EXIT INPUT
              ELSE
                  CALL fgl_winmessage(" ",%"main.string.Incorrect_Username", "information")
                  NEXT FIELD password
              END IF
                
        END INPUT

        CASE global.g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
            WHEN "connection"
                CLOSE WINDOW w
                CALL open_application()
            OTHERWISE
                CALL ui.Interface.refresh()
                CALL close_app()
        END CASE
    END IF
END FUNCTION
#
#
#
#
FUNCTION open_application() #First Application window function (Demo purposes loads 'connection' form)

    IF global.g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "connection_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "connection"
    END IF
    
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
                CALL update_connection_image("splash")
                
            BEFORE MENU
                CALL connection_test()
                CALL update_connection_image("splash")
                CALL generate_about()
                DISPLAY global.g_application_about TO status
                IF global.g_user_type = "ADMIN"
                THEN
                    LET m_form = m_window.getForm() #Just to be consistent
                    CALL m_form.setElementHidden("bt_admint",0)
                END IF
            ON ACTION CLOSE
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_admint
                LET global.g_instruction = "admint"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_logout
                LET global.g_instruction = "logout"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE global.g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "admint"
            CLOSE WINDOW w
            CALL admin_tools()
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
#
#
#
#
FUNCTION admin_tools() #Rough Development Tools window function (Mainly to showcase an admin only section)

    DEFINE
        f_words STRING

    IF global.g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "admin_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "admin"
    END IF

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
                
            BEFORE MENU
                CALL connection_test()
                LET f_words = %"main.string.Admin_Explanation"
                DISPLAY f_words TO words
                IF global.g_user_type != "ADMIN"
                THEN
                    CALL fgl_winmessage(%"main.string.Error_Title", %"main.string.Bad_Access", "stop")
                    LET global.g_instruction = "logout"
                    LET TERMINATE = TRUE
                    EXIT MENU      
                END IF
                
            ON ACTION CLOSE
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_env_dump
                CALL print_debug_env()
            ON ACTION bt_dump
                CALL print_debug_global_config()
            ON ACTION bt_user_manage
                LET global.g_instruction = "bt_user_manage"
                LET TERMINATE = TRUE
                EXIT MENU                  
            ON ACTION bt_create
                LET global.g_instruction = "bt_create"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_check
                LET global.g_instruction = "bt_check"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_hash
                LET global.g_instruction = "bt_hash"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_go_back
                LET global.g_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
        END MENU
    END WHILE

    CASE global.g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "bt_user_manage"
            CLOSE WINDOW w
            CALL tool_user_management()
        WHEN "bt_create"
            CLOSE WINDOW w
            CALL tool_create_user()
        WHEN "bt_check"
            CLOSE WINDOW w
            CALL tool_check_password()
        WHEN "bt_hash"
            CLOSE WINDOW w
            CALL tool_hash_generator()
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

################################################################################

################################################################################
#Module Functions...
################################################################################

FUNCTION connection_test() #Test online connectivity, call this whenever opening new window!
    IF global_config.g_enable_timed_connect = TRUE
    THEN
        CALL test_connectivity(global.g_info.deployment_type)
        IF global.g_online = "NONE" AND global.g_info.deployment_type = "GMA" OR global.g_online = "NONE" AND global.g_info.deployment_type = "GMI"
        THEN
            IF global_config.g_enable_mobile_title = FALSE
            THEN
                CALL m_window.setText(%"main.string.Working_Offline")
            ELSE
                CALL m_window.setText(%"main.string.Working_Offline" || global.g_title)
            END IF
        ELSE
            IF global_config.g_enable_mobile_title = FALSE
            THEN
                CALL m_window.setText("")
            ELSE
                CALL m_window.setText(global.g_title)
            END IF
        END IF
    END IF
END FUNCTION
#
#
#
#
FUNCTION update_connection_image(f_image) #Used to update connection image within the demo about page

    DEFINE
        f_image STRING
    
    LET m_form = m_window.getForm()
    IF global.g_online = "NONE"
    THEN
        CALL m_form.setElementImage(f_image,"disconnected")
        DISPLAY %"main.string.Services_Disconnected" TO connected
    ELSE
        CALL m_form.setElementImage(f_image,"connected")
        DISPLAY %"main.string.Services_Connected" TO connected
    END IF 
END FUNCTION

################################################################################