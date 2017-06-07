################################################################################
#START OF APPLICATION
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
#
#All application intialising is done here then individual window functions are
#called...
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
        m_instruction STRING,
        m_require_app_reload SMALLINT
        
    DEFINE
        m_title STRING,
        m_info RECORD
            deployment_type STRING,
            os_type STRING,
            ip STRING,
            device_name STRING,
            resolution STRING,
            resolution_x STRING,
            resolution_y STRING,
            geo_status STRING,
            geo_lat STRING,
            geo_lon STRING,
            locale STRING
        END RECORD,
        m_username STRING,
        m_password STRING,
        m_remember STRING
    
MAIN
#******************************************************************************#
#Grab deployment data...

    CALL ui.interface.getFrontEndName() RETURNING m_info.deployment_type
    CALL ui.interface.frontCall("standard", "feInfo", "osType", m_info.os_type)
    CALL ui.Interface.frontCall("standard", "feInfo", "ip", m_info.ip)
    CALL ui.Interface.frontCall("standard", "feInfo", "deviceId", m_info.device_name)    
    CALL ui.Interface.frontCall("standard", "feInfo", "screenResolution", m_info.resolution)
    CALL ui.Interface.frontCall("standard", "feInfo", "userPreferredLang", m_info.locale)
    
#******************************************************************************#
#Detect user's locale and set language accordingly depending on available language packs.

    CALL load_localisation("fr",FALSE)
        RETURNING m_require_app_reload

#******************************************************************************#
#Set global application details here...

    LET g_application_title =%"main.string.App_Title"
    LET g_application_version =%"main.string.App_Version"
    LET m_title =  g_application_title || " " || g_application_version
    
#******************************************************************************#

    # RUN "set > /tmp/mobile.env" # Dump the environment for debugging.
    #BREAKPOINT #Uncomment to step through application
    DISPLAY "\nStarting up " || g_application_title || " " || g_application_version || "...\n"

    #Uncomment the below to display device data when running.
    
    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        DISPLAY "--Deployment Data--\n" ||
                "Deployment Type: " || m_info.deployment_type || "\n" ||
                "OS Type: " || m_info.os_type || "\n" ||
                "User Locale: " || m_info.locale || "\n" ||
                "Device IP: " || m_info.ip || "\n" ||
                "Resolution: " || m_info.resolution || "\n" ||
                "-------------------\n"
    ELSE
        DISPLAY "--Deployment Data--\n" ||
                "Deployment Type: " || m_info.deployment_type || "\n" ||
                "OS Type: " || m_info.os_type || "\n" ||
                "User Locale: " || m_info.locale || "\n" ||
                "Device IP: " || m_info.ip || "\n" ||
                "Device ID: " || m_info.device_name || "\n" ||
                "Resolution: " || m_info.resolution || "\n" ||
                "-------------------\n"
    END IF
    
    LET m_string_tokenizer = base.StringTokenizer.create(m_info.resolution,"x")

    WHILE m_string_tokenizer.hasMoreTokens()
        IF m_index = 1
        THEN
            LET m_info.resolution_x = m_string_tokenizer.nextToken() || "px"
        ELSE
            LET m_info.resolution_y = m_string_tokenizer.nextToken() || "px"
        END IF
        LET m_index = m_index + 1
    END WHILE

#******************************************************************************#
# HERE IS WHERE YOU CONFIGURE GOBAL SWITCHES FOR THE APPLICATION
# ADJUST THESE AS YOU SEEM FIT. BELOW IS A LIST OF OPTIONS IN ORDER:
#        g_application_database_ver INTEGER,    #Application Database Version (This is useful to force database additions to pre-existing db instances)
#        g_enable_splash SMALLINT,              #Open splashscreen when opening the application.
#        g_splash_duration INTEGER,            #Splashscreen duration (seconds) g_enable_splash needs to be enabled!
#        g_enable_login SMALLINT                #Boot in to login menu or straight into application (open_application())
#        g_splash_width STRING,                 #Login menu splash width when not in mobile
#        g_splash_height STRING,               #Login menu splash height when not in mobile
#        g_enable_geolocation SMALLINT,        #Toggle to enable geolocation
#        g_enable_mobile_title SMALLINT,       #Toggle application title on mobile
#        g_local_stat_limit INTEGER,            #Number of max local stat records before pruning
#        g_online_ping_URL STRING,              #URL of public site to test internet connectivity (i.e. http://www.google.com) 
#        g_enable_timed_connect SMALLINT,      #Enable timed connectivity checks
#        g_timed_checks_time INTEGER            #Time in seconds before checking connectivity (g_enable_timed_connect has to be enabled)
#        g_date_format STRING                  #Datetime format. i.e.  "%d/%m/%Y %H:%M"
#        g_image_dest STRING                    #Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet)
#        g_ws_end_point STRING,                #The webservice end point. 
#        g_enable_timed_image_upload SMALLINT,  #Enable timed image queue uploads (Could have a performance impact!)
# Here are globals not included in initialize_globals function due to sheer size of the arguement data...
#        g_client_key STRING,                  #Unique Client key for webservice purposes

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
                            TRUE)                               #g_enable_timed_image_upload SMALLINT
        RETURNING m_ok
        
    LET g_client_key = "znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv"      #g_client_key STRING

#******************************************************************************#

    IF m_ok = FALSE
    THEN
         CALL fgl_winmessage(m_title, %"main.string.ERROR_1001", "stop")
         EXIT PROGRAM 1001
    END IF

    IF g_enable_geolocation = TRUE
    THEN
        IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
        THEN
            DISPLAY "****************************************************************************************\n" ||
                    "WARNING: Set up error, track geolocation is enabled and you are not deploying in mobile.\n" ||
                    "****************************************************************************************\n"
        ELSE
            CALL ui.Interface.frontCall("mobile", "getGeolocation", [], [m_info.geo_status, m_info.geo_lat, m_info.geo_lon])
            DISPLAY "--Geolocation Tracking Enabled!--"
            DISPLAY "Geolocation Tracking Status: " || m_info.geo_status
            IF m_info.geo_status = "ok"
            THEN
                DISPLAY "Latitude: " || m_info.geo_lat
                DISPLAY "Longitude: " || m_info.geo_lon
            END IF
            DISPLAY "---------------------------------\n"
        END IF
    END IF

    CALL test_connectivity(m_info.deployment_type)
    CALL capture_local_stats(m_info.*)
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
    
END MAIN

################################################################################

################################################################################
#Individual window/form functions...
################################################################################

FUNCTION run_splash_screen() #Application Splashscreen window function

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "splash_screen"
    ELSE
        OPEN WINDOW w WITH FORM "splash_screen"
    END IF
    
    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "main_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "main"
    END IF
    
    #Initialize window specific variables
  
    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()
    LET m_dom_node1 = m_window.findNode("Image","splash")

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
        END IF
    END IF

    #We need to adjust the image so it appears correctly in GDC,GBC,GMA and GMI

    #Set the login splash size if we are running in GDC
    IF m_info.deployment_type = "GDC"
    THEN
        CALL m_dom_node1.setAttribute("sizePolicy","dynamic")
        CALL m_dom_node1.setAttribute("width",g_splash_width)
        CALL m_dom_node1.setAttribute("height",g_splash_height)
    END IF

    #Set the login screen image to stretch both in GBC
    IF m_info.deployment_type = "GBC" 
    THEN
        CALL m_dom_node1.setAttribute("stretch","both")
    END IF

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

        ON ACTION ACCEPT
            #Do Nothing
        ON ACTION CANCEL
            #Do Nothing
        ON CHANGE username
            LET m_username = downshift(m_username)
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
        
          CALL check_password(m_username,m_password) RETURNING m_ok
          INITIALIZE m_password TO NULL #Clean down the plain text password
          
          IF m_ok = TRUE
          THEN
              LET m_instruction = "connection"
              EXIT INPUT
          ELSE
              CALL fgl_winmessage(" ",%"main.string.Incorrect_Username", "information")
              NEXT FIELD password
          END IF
            
    END INPUT

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "connection_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "connection"
    END IF
    
    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
                IF m_info.deployment_type = "GMA" OR m_info.deployment_type = "GMI"
                THEN
                    LET m_form = m_window.getForm() #Just to be consistent
                    CALL m_form.setElementHidden("bt_photo",0) #Photo uploads exclusive to mobile
                END IF
            ON ACTION CLOSE
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_inter
                LET m_instruction = "bt_inter"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_photo
                LET m_instruction = "bt_photo"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_sync
                CALL upload_image_payload(FALSE)
            ON ACTION bt_admint
                LET m_instruction = "admint"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_logout
                LET m_instruction = "logout"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "admin_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "admin"
    END IF

    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
                    LET m_instruction = "logout"
                    LET TERMINATE = TRUE
                    EXIT MENU      
                END IF
                
            ON ACTION CLOSE
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_dump
                CALL print_debug_global_config()
            ON ACTION bt_create
                LET m_instruction = "bt_create"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_check
                LET m_instruction = "bt_check"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_hash
                LET m_instruction = "bt_hash"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_go_back
                LET m_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
        WHEN "bt_create"
            RUN "fglrun ../toolbin/CreateUser.42r"
        WHEN "bt_check"
            RUN "fglrun ../toolbin/CheckPassword.42r"
        WHEN "bt_hash"
            RUN "fglrun ../toolbin/HashGenerator.42r"
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

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "interact_gdc"
    ELSE
        OPEN WINDOW w WITH FORM "interact"
    END IF

    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
                LET m_instruction = "bt_sign"
                LET TERMINATE = TRUE
                EXIT MENU  
            ON ACTION bt_video
                LET m_instruction = "bt_video"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_maps
                LET m_instruction = "bt_maps"
                LET TERMINATE = TRUE
                EXIT MENU
            ON ACTION bt_go_back
                LET m_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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
#
#
FUNCTION wc_signature_demo() #Webcomponent Demo (Signature) window function (Part of Interactivity Demo)

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "wc_signature"
    ELSE
        OPEN WINDOW w WITH FORM "wc_signature"
    END IF

    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
                LET m_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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
        
    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "wc_google_maps"
    ELSE
        OPEN WINDOW w WITH FORM "wc_google_maps"
    END IF

    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
            LET m_instruction = "go_back"
            EXIT INPUT   

    END INPUT  

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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

    IF m_info.deployment_type = "GDC"
    THEN
        OPEN WINDOW w WITH FORM "wc_video"
    ELSE
        OPEN WINDOW w WITH FORM "wc_video"
    END IF

    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
                LET m_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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
#
#
FUNCTION image_program() #Image Web Service Demo window function

    DEFINE
        f_words STRING,
        f_temp_img_queue DYNAMIC ARRAY OF STRING,
        f_index INTEGER,
        f_queue_count INTEGER,
        f_payload STRING

    OPEN WINDOW w WITH FORM "photo"

    LET TERMINATE = FALSE
    INITIALIZE m_instruction TO NULL
    LET m_window = ui.Window.getCurrent()

    IF m_info.deployment_type <> "GMA" AND m_info.deployment_type <> "GMI"
    THEN
        CALL m_window.setText(m_title)
    ELSE
        IF g_enable_mobile_title = FALSE
        THEN
            CALL m_window.setText("")
        ELSE
            CALL m_window.setText(m_title)
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
                        DISPLAY f_queue_count || %"main.string.Photo_In_Queue" TO status
                    ELSE
                        DISPLAY f_queue_count || %"main.string.Photos_In_Queue" TO status
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
                            CALL load_payload(g_user,"IMAGE",f_payload)
                                RETURNING m_ok
                        END IF
                    END FOR
                    IF reply_yn("Y"," ",%"main.string.Images_Loaded_Successfully")
                    THEN
                        CALL connection_test()
                        IF g_online = "NONE"
                        THEN
                            IF g_enable_timed_image_upload = TRUE AND g_timed_checks_time > 0
                            THEN
                                CALL fgl_winmessage(%"main.string.Warning_Title", %"main.string.You_Are_Offline_Auto_Retry", "information")
                                LET f_queue_count = 0
                                INITIALIZE f_temp_img_queue TO NULL
                                DISPLAY " " TO status 
                            ELSE
                                CALL fgl_winmessage(%"main.string.Warning_Title", %"main.string.You_Are_Offline_Try_Again", "information")
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
                CALL ui.Interface.frontCall("standard", "launchURL", [g_ws_end_point], [])
            ON ACTION bt_go_back
                LET m_instruction = "go_back"
                LET TERMINATE = TRUE
                EXIT MENU                
              
        END MENU
    END WHILE

    CASE m_instruction #Depending on the instruction, we load up new windows/forms within the application whithout unloading.
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

FUNCTION load_localisation(f_locale, f_pre_window) #This auto loads the user's locale language if available. (Must be local to the main.4gl!)
    DEFINE
        f_locale STRING,
        f_pre_window SMALLINT,
        f_localisation_path STRING,
        f_string_buffer base.StringBuffer,
        f_require_reload SMALLINT

    LET f_require_reload = FALSE
    BREAKPOINT
    #Check if we have the locale.42s folder, if not then revert to defaults. 
    #If load_localisation() is called before window then f_pre_window = false else we need to reload current window

    IF os.Path.exists(os.Path.join(base.Application.getProgramDir(), f_locale)) #i.e. en_GB or en_US
    THEN
        LET g_language = f_locale
        LET f_localisation_path = os.Path.join(base.Application.getProgramDir(), g_language)
        CALL base.Application.reloadResources(f_localisation_path)
        LET f_require_reload = TRUE
    ELSE
        LET f_string_buffer = base.StringBuffer.create()
        CALL f_string_buffer.append(f_locale)
        LET f_locale = f_string_buffer.subString(1,2)
        IF os.Path.exists(os.Path.join(base.Application.getProgramDir(), f_locale)) #i.e. en or fr or de
        THEN
            LET g_language = f_locale
            LET f_localisation_path = os.Path.join(base.Application.getProgramDir(), g_language)
            CALL base.Application.reloadResources(f_localisation_path)
            LET f_require_reload = TRUE
        END IF
    END IF

    IF f_pre_window = TRUE
    THEN
        LET f_require_reload = FALSE #Even if we have changed the local language, we don't need to reload window because pre window
    END IF

    RETURN f_require_reload
    
END FUNCTION
#
#
#
#
FUNCTION connection_test() #Test online connectivity, call this whenever opening new window!
    IF g_enable_timed_connect = TRUE
    THEN
        CALL test_connectivity(m_info.deployment_type)
        IF g_online = "NONE" AND m_info.deployment_type = "GMA" OR g_online = "NONE" AND m_info.deployment_type = "GMI"
        THEN
            IF g_enable_mobile_title = FALSE
            THEN
                CALL m_window.setText(%"main.string.Working_Offline")
            ELSE
                CALL m_window.setText(%"main.string.Working_Offline" || m_title)
            END IF
        ELSE
            IF g_enable_mobile_title = FALSE
            THEN
                CALL m_window.setText("")
            ELSE
                CALL m_window.setText(m_title)
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