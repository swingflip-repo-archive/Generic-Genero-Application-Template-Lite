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
        m_string_buffer base.StringBuffer,
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
        m_image STRING,
        m_local_images_available DYNAMIC ARRAY OF CHAR(2)
    
FUNCTION initialise_app()

    #******************************************************************************#
    #Grab deployment data...
        CALL ui.interface.getFrontEndName() RETURNING g_info.deployment_type
        CALL ui.interface.frontCall("standard", "feInfo", "osType", g_info.os_type)
        CALL ui.Interface.frontCall("standard", "feInfo", "ip", g_info.ip)
        CALL ui.Interface.frontCall("standard", "feInfo", "deviceId", g_info.device_name)    
        CALL ui.Interface.frontCall("standard", "feInfo", "screenResolution", g_info.resolution)

    #******************************************************************************#
    #Set global application details here...

        LET g_application_title =%"main.string.App_Title"
        LET g_application_version =%"main.string.App_Version"
        LET g_title =  g_application_title || " " || g_application_version
        
    #******************************************************************************#

        # RUN "set > /tmp/mobile.env" # Dump the environment for debugging.
        #BREAKPOINT #Uncomment to step through application
        DISPLAY "\nStarting up " || g_application_title || " " || g_application_version || "...\n"

        #Uncomment the below to display device data when running.
        
        IF g_info.deployment_type <> "GMA" AND g_info.deployment_type <> "GMI"
        THEN
            {DISPLAY "--Deployment Data--\n" ||
                    "Deployment Type: " || g_info.deployment_type || "\n" ||
                    "OS Type: " || g_info.os_type || "\n" ||
                    "User Locale: " || g_info.locale || "\n" ||
                    "Device IP: " || g_info.ip || "\n" ||
                    "Resolution: " || g_info.resolution || "\n" ||
                    "-------------------\n"}
        ELSE
            {DISPLAY "--Deployment Data--\n" ||
                    "Deployment Type: " || g_info.deployment_type || "\n" ||
                    "OS Type: " || g_info.os_type || "\n" ||
                    "User Locale: " || g_info.locale || "\n" ||
                    "Device IP: " || g_info.ip || "\n" ||
                    "Device ID: " || g_info.device_name || "\n" ||
                    "Resolution: " || g_info.resolution || "\n" ||
                    "-------------------\n"}
        END IF
        
        LET m_string_tokenizer = base.StringTokenizer.create(g_info.resolution,"x")

        WHILE m_string_tokenizer.hasMoreTokens()
            IF m_index = 1
            THEN
                LET g_info.resolution_x = m_string_tokenizer.nextToken() || "px"
            ELSE
                LET g_info.resolution_y = m_string_tokenizer.nextToken() || "px"
            END IF
            LET m_index = m_index + 1
        END WHILE

    #******************************************************************************#
    # HERE IS WHERE YOU CONFIGURE GOBAL SWITCHES FOR THE APPLICATION
    # ADJUST THESE AS YOU SEEM FIT. BELOW IS A LIST OF OPTIONS IN ORDER:
    #        g_application_database_ver INTEGER,               #Application Database Version (This is useful to force database additions to pre-existing db instances)
    #        g_enable_splash SMALLINT,                         #Open splashscreen when opening the application.
    #        g_splash_duration INTEGER,                        #Splashscreen duration (seconds) g_enable_splash needs to be enabled!
    #        g_enable_login SMALLINT                           #Boot in to login menu or straight into application (open_application())
    #        g_splash_width STRING,                            #Login menu splash width when not in mobile
    #        g_splash_height STRING,                           #Login menu splash height when not in mobile
    #        g_enable_geolocation SMALLINT,                    #Toggle to enable geolocation
    #        g_enable_mobile_title SMALLINT,                   #Toggle application title on mobile
    #        g_local_stat_limit INTEGER,                       #Number of max local stat records before pruning
    #        g_online_ping_URL STRING,                         #URL of public site to test internet connectivity (i.e. http://www.google.com) 
    #        g_enable_timed_connect SMALLINT,                  #Enable timed connectivity checks
    #        g_timed_checks_time INTEGER                       #Time in seconds before checking connectivity (g_enable_timed_connect has to be enabled)
    #        g_date_format STRING                              #Datetime format. i.e.  "%d/%m/%Y %H:%M"
    #        g_image_dest STRING                               #Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet)
    #        g_ws_end_point STRING,                            #The webservice end point. 
    #        g_enable_timed_image_upload SMALLINT,             #Enable timed image queue uploads (Could have a performance impact!)
    #        g_local_images_available DYNAMIC ARRAY OF CHAR(2) #Available localisations for images.
    #        g_default_language STRING,                        #The default language used within the application (i.e. EN)
    # Here are globals not included in initialize_globals function due to sheer size of the arguement data...
    #        g_client_key STRING,                              #Unique Client key for webservice purposes

        #List the localisations availble for images and wc here so we can change the images depending on locale...
        LET m_local_images_available[1] = "EN"
        LET m_local_images_available[2] = "FR"
        
        CALL initialize_globals(1,                                  #g_application_database_ver INTEGER
                                TRUE,                               #g_enable_splash SMALLINT
                                5,                                  #g_splash_duration INTEGER
                                TRUE,                               #g_enable_login SMALLINT
                                "500px",                            #g_splash_width STRING
                                "281px",                            #g_splash_height STRING
                                FALSE,                              #g_enable_geolocation SMALLINT
                                FALSE,                              #g_enable_mobile_title SMALLINT
                                100,                                #g_local_stat_limit INTEGER
                                "http://www.google.com",            #g_online_ping_URL STRING
                                TRUE,                               #g_enable_timed_connect SMALLINT
                                10,                                 #g_timed_checks_time INTEGER
                                "%d/%m/%Y %H:%M",                   #g_date_format STRING
                                "webserver1",                       #g_image_dest STRING  
                                "http://www.ryanhamlin.co.uk/ws",   #g_ws_end_point STRING
                                TRUE,                               #g_enable_timed_image_upload SMALLINT
                                "EN",                               #g_default_language CHAR(2)
                                m_local_images_available)           #g_local_images_available DYNAMIC ARRAY OF CHAR(2)
            RETURNING m_ok
            
        LET g_client_key = "znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv"      #g_client_key STRING

    #******************************************************************************#

        IF m_ok = FALSE
        THEN
             CALL fgl_winmessage(g_title, %"main.string.ERROR_1001", "stop")
             EXIT PROGRAM 1001
        END IF

        IF g_enable_geolocation = TRUE
        THEN
            IF g_info.deployment_type <> "GMA" AND g_info.deployment_type <> "GMI"
            THEN
                DISPLAY "****************************************************************************************\n" ||
                        "WARNING: Set up error, track geolocation is enabled and you are not deploying in mobile.\n" ||
                        "****************************************************************************************\n"
            ELSE
                CALL ui.Interface.frontCall("mobile", "getGeolocation", [], [g_info.geo_status, g_info.geo_lat, g_info.geo_lon])
                DISPLAY "--Geolocation Tracking Enabled!--"
                DISPLAY "Geolocation Tracking Status: " || g_info.geo_status
                IF g_info.geo_status = "ok"
                THEN
                    DISPLAY "Latitude: " || g_info.geo_lat
                    DISPLAY "Longitude: " || g_info.geo_lon
                END IF
                DISPLAY "---------------------------------\n"
            END IF
        END IF

        CALL test_connectivity(g_info.deployment_type)
        CALL capture_local_stats(g_info.*)
            RETURNING m_ok

        CLOSE WINDOW SCREEN #Just incase
        
    #We are now initialised, we now just need to run each individual window functions...

        IF g_enable_splash = TRUE AND g_splash_duration > 0
        THEN
            CALL run_splash_screen()
        ELSE
            IF g_enable_login = TRUE
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
        
    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "splash_screen"
    ELSE
        OPEN WINDOW w WITH FORM "splash_screen"
    END IF

    INITIALIZE f_result TO NULL
    TRY 
      CALL ui.Interface.frontCall("webcomponent","call",["formonly.splashwc","setLocale",g_language_short],[f_result])
    CATCH
      ERROR err_get(status)
      DISPLAY err_get(status)
    END TRY
    
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

        ON TIMER 10
            LET TERMINATE = TRUE
            EXIT MENU

        BEFORE MENU
            CALL DIALOG.setActionHidden("close",1)

        ON ACTION CLOSE
            LET TERMINATE = TRUE
            EXIT MENU
              
        END MENU
    END WHILE

    IF g_enable_login = TRUE
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

    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "main_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "main"
    END IF
    
    #Initialize window specific variables
  
    LET TERMINATE = FALSE
    INITIALIZE g_instruction TO NULL
    LET m_window = ui.Window.getCurrent()
    LET m_dom_node1 = m_window.findNode("Image","splash")

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

    #We need to adjust the image so it appears correctly in GDC,GBC,GMA and GMI

    #Set the login splash size if we are running in GDC
    IF g_info.deployment_type = "GDC"
    THEN
        CALL m_dom_node1.setAttribute("sizePolicy","dynamic")
        CALL m_dom_node1.setAttribute("width",g_splash_width)
        CALL m_dom_node1.setAttribute("height",g_splash_height)
    END IF

    #Set the login screen image to stretch both in GBC
    IF g_info.deployment_type = "GBC" 
    THEN
        CALL m_dom_node1.setAttribute("stretch","both")
    END IF

    #Set the login screen image to the corresponding language loaded
    CALL set_localised_image("splash")
        RETURNING m_image
    CALL m_dom_node1.setAttribute("image",m_image)

    INPUT m_username, m_password, m_remember FROM username, password, remember ATTRIBUTE(UNBUFFERED)

        ON TIMER g_timed_checks_time
            CALL connection_test()
            CALL timed_upload_queue_data()
        
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
              LET g_instruction = "connection"
              EXIT INPUT
          ELSE
              CALL fgl_winmessage(" ",%"main.string.Incorrect_Username", "information")
              NEXT FIELD password
          END IF
            
    END INPUT

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "connection"
            CLOSE WINDOW w
            CALL open_application()
        OTHERWISE
            CALL ui.Interface.refresh()
            CALL close_app()
    END CASE
END FUNCTION
#
#
#
#
FUNCTION open_application() #First Application window function (Demo purposes loads 'connection' form)

    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "connection_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "connection"
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
                CALL update_connection_image("splash")
                
            BEFORE MENU
                CALL connection_test()
                CALL update_connection_image("splash")
                CALL generate_about()
                DISPLAY g_application_about TO status
                IF g_user_type = "ADMIN"
                THEN
                    LET m_form = m_window.getForm() #Just to be consistent
                    CALL m_form.setElementHidden("bt_admint",0)
                END IF
                IF g_info.deployment_type = "GMA" OR g_info.deployment_type = "GMI"
                THEN
                    LET m_form = m_window.getForm() #Just to be consistent
                    CALL m_form.setElementHidden("bt_photo",0) #Photo uploads exclusive to mobile
                END IF
            ON ACTION CLOSE
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_inter
                LET g_instruction = "bt_inter"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_photo
                LET g_instruction = "bt_photo"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_sync
                CALL upload_image_payload(FALSE)
            ON ACTION bt_admint
                LET g_instruction = "admint"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_logout
                LET g_instruction = "logout"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "bt_inter"
            CLOSE WINDOW w
            CALL interact_demo()
        WHEN "bt_photo"
            CLOSE WINDOW w
            CALL image_program()
        WHEN "admint"
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

    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "admin_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "admin"
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
                LET f_words = %"main.string.Admin_Explanation"
                DISPLAY f_words TO words
                IF g_user_type != "ADMIN"
                THEN
                    CALL fgl_winmessage(%"main.string.Error_Title", %"main.string.Bad_Access", "stop")
                    LET g_instruction = "logout"
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
            ON ACTION bt_create
                LET g_instruction = "bt_create"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_check
                LET g_instruction = "bt_check"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_hash
                LET g_instruction = "bt_hash"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_go_back
                LET g_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "bt_create"
            CLOSE WINDOW w
            CALL create_user()
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
#
#
FUNCTION interact_demo() #Interactivity Demo window function

    DEFINE
        f_words STRING

    IF g_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "interact_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "interact"
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
                LET f_words = %"main.string.Interact_Explanation"
                DISPLAY f_words TO words

            ON ACTION bt_sign
                LET g_instruction = "bt_sign"
                LET TERMINATE = TRUE
                EXIT MENU  
            ON ACTION bt_video
                LET g_instruction = "bt_video"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_maps
                LET g_instruction = "bt_maps"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_go_back
                LET g_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE g_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "bt_sign"
            CLOSE WINDOW w
            CALL wc_signature_demo()
        WHEN "bt_maps"
            CLOSE WINDOW w
            CALL wc_maps_demo()
        WHEN "bt_video"
            CLOSE WINDOW w
            CALL wc_video_demo()
        WHEN "go_back"
            CLOSE WINDOW w
            CALL open_application()
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

################################################################################

################################################################################
#Module Functions...
################################################################################

FUNCTION connection_test() #Test online connectivity, call this whenever opening new window!
    IF g_enable_timed_connect = TRUE
    THEN
        CALL test_connectivity(g_info.deployment_type)
        IF g_online = "NONE" AND g_info.deployment_type = "GMA" OR g_online = "NONE" AND g_info.deployment_type = "GMI"
        THEN
            IF g_enable_mobile_title = FALSE
            THEN
                CALL m_window.setText(%"main.string.Working_Offline")
            ELSE
                CALL m_window.setText(%"main.string.Working_Offline" || g_title)
            END IF
        ELSE
            IF g_enable_mobile_title = FALSE
            THEN
                CALL m_window.setText("")
            ELSE
                CALL m_window.setText(g_title)
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
    IF g_online = "NONE"
    THEN
        CALL m_form.setElementImage(f_image,"disconnected")
        DISPLAY %"main.string.Services_Disconnected" TO connected
    ELSE
        CALL m_form.setElementImage(f_image,"connected")
        DISPLAY %"main.string.Services_Connected" TO connected
    END IF 
END FUNCTION

################################################################################