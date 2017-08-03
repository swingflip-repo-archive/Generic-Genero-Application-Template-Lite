GLOBALS

    DEFINE
    
################################################################################
# CONFIG GLOBALS
################################################################################

        global_config RECORD
            g_application_database_ver INTEGER,               #Application Database Version (This is useful to force database additions to pre-existing db instances) 
            g_client_key STRING,                              #Unique Client key for webservice purposes
            g_image_dest STRING,                              #Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet, because you should be able to fglWSDL this is pretty redundant)
            g_ws_end_point STRING,                            #The webservice end point. 
            g_splash_width STRING,                            #Login menu splash width when not in mobile
            g_splash_height STRING,                           #Login menu splash height when not in mobile
            g_enable_geolocation SMALLINT,                    #Toggle to enable geolocation
            g_enable_mobile_title SMALLINT,                   #Toggle application title on mobile
            g_timed_checks_time INTEGER,                      #Time in seconds before running auto checks, uploads or refreshes (0 disables this globally)
            g_enable_timed_connect SMALLINT,                  #Enable timed connectivity checks
            g_enable_timed_image_upload SMALLINT,             #Enable timed image queue uploads (Could have a performance impact!)
            g_enable_splash SMALLINT,                         #Open splashscreen when opening the application.
            g_splash_duration SMALLINT,                       #Splashscreen duration (seconds) g_enable_splash needs to be enabled!
            g_enable_login SMALLINT,                          #Boot in to login menu or straight into application (open_application())
            g_local_stat_limit INTEGER,                       #Number of max local stat records before pruning
            g_online_ping_URL STRING,                         #URL of public site to test internet connectivity (i.e. http://www.google.com) 
            g_date_format STRING,                             #Datetime format. i.e.  "%d/%m/%Y %H:%M"
            g_default_language STRING,                        #The default language used within the application (i.e. EN)
            g_local_images_available DYNAMIC ARRAY OF CHAR(2) #Available localisations for images.
      END RECORD,

################################################################################
# GLOBALS (These should be replaced with PUBLIC and PRIVATE variables!)
################################################################################

      global RECORD
            g_application_title STRING,            #Application Title
            g_application_version STRING,          #Application Version
            g_application_about STRING,            #Application About Blurb
            g_title STRING,                        #Concatenated application title string
            g_online STRING,                       #BOOLEAN to determine if the application is online or offline
            g_user STRING,                         #Username of the user currently logged in
            g_user_type STRING,                    #User type currently logged in
            g_logged_in DATETIME YEAR TO SECOND,   #When the current user logged in to the system
            g_OK_uploads INTEGER,                  #Number of successful uploads just carried out
            g_FAILED_uploads INTEGER,              #Number of failed uploads just carried out
            g_language STRING,                     #Current user's selected language
            g_language_short STRING,               #The two character language code i.e. en instead of en_GB
            g_instruction STRING,                  #This is used to swap between windows and forms
            g_info RECORD                          #Used to store information regarding client deployment
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
            END RECORD
        END RECORD
    
END GLOBALS