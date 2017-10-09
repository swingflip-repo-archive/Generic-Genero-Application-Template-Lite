IMPORT SECURITY
IMPORT com
IMPORT util
IMPORT os
#IMPORT JAVA java.util.regex.Pattern
#IMPORT JAVA java.util.regex.Matcher
GLOBALS "globals.4gl"
SCHEMA local_db
#
#
#
#
FUNCTION generate_about()

    IF global_config.g_enable_login = TRUE
    THEN
        LET global.g_application_about = global.g_application_title || " " || global.g_application_version || "\n\n" ||
                                  %"function.lib.string.Logged_In_As" || global.g_user || "\n" ||
                                  %"function.lib.string.User_Type" || global.g_user_type || "\n" ||
                                  %"function.lib.string.Logged_In_At" || util.Datetime.format(global.g_logged_in, global_config.g_date_format) || "\n" ||
                                  %"function.lib.string.Genero_Version" || FGL_GETVERSION() || "\n\n" || 
                                  %"function.lib.string.About_Explanation"   
    ELSE
        LET global.g_application_about = global.g_application_title || " " || global.g_application_version || "\n\n" ||
                                  %"function.lib.string.Genero_Version" || FGL_GETVERSION() || "\n\n" || 
                                  %"function.lib.string.About_Explanation"     
    END IF
END FUNCTION
#
#
#
#
FUNCTION sync_config(f_config_name,f_debug)

    DEFINE 
        f_config_name STRING,
        f_configpath STRING,
        f_config_configname STRING,
        f_msg STRING,
        f_debug SMALLINT

    LET f_configpath = os.path.join(os.path.pwd(), f_config_name)
    LET f_config_configname = os.path.join("..","config")
    LET f_config_configname = os.path.join(base.Application.getProgramDir(),f_config_configname)
        
    IF NOT os.path.exists(f_configpath) #Check working directory for GGAT.config
    THEN
        LET f_msg = "Config file missing, "
        IF NOT os.path.exists(os.path.join(base.Application.getProgramDir(),f_config_name)) #Check app directory for GGAT.config
        THEN
            IF NOT os.path.exists(os.path.join(f_config_configname,f_config_name)) # Check app/../config for GGAT.config
            THEN
                #If you get to this point you have done something drastically wrong...
                DISPLAY "FATAL ERROR: You don't have a config file set up!"
                EXIT PROGRAM 9999
            ELSE
                IF os.path.copy(os.path.join(f_config_configname,f_config_name), f_configpath)
                THEN
                    LET f_msg = f_msg.append("Copied config")
                ELSE
                    LET f_msg = f_msg.append("Config copy failed! ")
                END IF
            END IF
        ELSE
            IF os.path.copy(os.path.join(base.Application.getProgramDir(),f_config_name), f_configpath)
            THEN
                LET f_msg = f_msg.append("Copied config")
            ELSE
                LET f_msg = f_msg.append("Config copy failed! ")
            END IF
        END IF
    ELSE
        LET f_msg = "config exists, checking for master config for resync... "
        IF os.path.exists(os.path.join(f_config_configname,f_config_name)) # Check app/../config for GGAT.config
        THEN
            IF os.path.copy(os.path.join(f_config_configname,f_config_name), f_configpath)
            THEN
                LET f_msg = f_msg.append("Re-synced the config OK")
            ELSE
                LET f_msg = f_msg.append("Config re-sync failed! ")
            END IF
        ELSE
            LET f_msg = f_msg.append(" In production deployment. Contiuning as normal.")
        END IF
    END IF
  
    IF f_debug = TRUE
    THEN
        DISPLAY f_msg
    END IF
    
END FUNCTION
#
#
#
#
FUNCTION initialize_globals() #Set up global variables

    DEFINE
        f_channel base.Channel,
        f_string_line STRING

    LET f_channel = base.Channel.create()
    TRY
        CALL f_channel.openFile(os.path.join(os.path.pwd(),"GGAT.config"),"r")
    CATCH
        RETURN FALSE
    END TRY
    WHILE NOT f_channel.isEof()
        LET f_string_line = f_string_line.append( f_channel.readLine() ) 
    END WHILE
    CALL f_channel.close() 
  
    CALL util.JSON.parse( f_string_line, global_config)

    RETURN TRUE
    
END FUNCTION
#
#
#
#
FUNCTION print_debug_global_config()
    DEFINE
        f_msg STRING

    #FYI, these aren't ALL of the globals. I have only dumped what I believe could be of use...
    LET f_msg = %"function.lib.string.Config_Dump_Text" ||
                # Current Session Global Variable Values #
                "global.g_online = " || global.g_online || "\n" ||
                "global.g_user = " || global.g_user || "\n" ||
                "global.g_user_type = " || global.g_user_type || "\n" ||
                "global.g_logged_in = " || global.g_logged_in || "\n" ||
                "global.g_language = " || global.g_language || "\n" ||
                "global.g_language_short = " || global.g_language_short || "\n" ||
                # Application Global Variable Values #
                "global_config.g_default_language = " || global_config.g_default_language || "\n" ||
                "global_config.g_application_database_ver = " || global_config.g_application_database_ver || "\n" ||
                "global_config.g_enable_splash = " || global_config.g_enable_splash || "\n" ||
                "global_config.g_splash_duration = " || global_config.g_splash_duration || "\n" ||
                "global_config.g_enable_login = " || global_config.g_enable_login || "\n" ||
                "global_config.g_splash_width = " || global_config.g_splash_width || "\n" ||
                "global_config.g_splash_height = " || global_config.g_splash_height || "\n" ||
                "global_config.g_enable_geolocation = " || global_config.g_enable_geolocation || "\n" ||
                "global_config.g_enable_mobile_title = " || global_config.g_enable_mobile_title || "\n" ||
                "global_config.g_local_stat_limit = " || global_config.g_local_stat_limit || "\n" ||
                "global_config.g_online_pinglobal_config.g_URL = " || global_config.g_online_ping_URL || "\n" ||
                "global_config.g_enable_timed_connect = " || global_config.g_enable_timed_connect || "\n" ||
                "global_config.g_timed_checks_time = " || global_config.g_timed_checks_time || "\n" ||
                "global_config.g_date_format = " || global_config.g_date_format || "\n" ||
                "global_config.g_image_dest = " || global_config.g_image_dest || "\n" ||
                "global_config.g_enable_timed_image_upload = " || global_config.g_enable_timed_image_upload
    DISPLAY f_msg 
    CALL fgl_winmessage(%"function.lib.string.global_dump",f_msg, "information")
END FUNCTION
#
#
#
#
FUNCTION print_debug_env()
    DEFINE
        f_msg STRING,
        f_fe_typ STRING,
        f_fe_ver STRING,
        f_cli_os STRING,
        f_cli_osver STRING,
        f_ip STRING,
        f_device_name STRING,
        f_cli_res STRING

    LET f_fe_typ = ui.interface.getFrontEndName()
    LET f_fe_ver = ui.interface.getFrontEndVersion()

    CALL ui.interface.frontCall("standard", "feInfo", "osType", f_cli_os)
    CALL ui.interface.frontCall("standard", "feInfo", "osVersion", f_cli_osver)
    CALL ui.Interface.frontCall("standard", "feInfo", "ip", f_ip)
    CALL ui.Interface.frontCall("standard", "feInfo", "deviceId",f_device_name)    
    CALL ui.Interface.frontCall("standard", "feInfo", "screenResolution", f_cli_res)
    IF f_device_name IS NULL THEN LET f_device_name = "N/A" END IF

    LET f_msg = %"function.lib.string.Env_Dump_Text" ||
                "DVM VER= " || fgl_getVersion() || "\n" ||
                "FGLPROFILE = " || NVL(fgl_getEnv("FGLPROFILE"),"NULL") || "\n" ||
                "FGLIMAGEPATH = " || NVL(fgl_getEnv("FGLIMAGEPATH"),"NULL") || "\n" ||
                "FGLRESOURCEPATH = " || NVL(fgl_getEnv("FGLRESOURCEPATH"),"NULL") || "\n" ||
                "FRONT END NAME = " || f_fe_typ || "\n" ||
                "FRONT END VER= " || f_fe_ver || "\n" ||
                "OSTYPE = " || f_cli_os || "\n" ||
                "OSVERSION = " || f_cli_osver || "\n" ||
                "IP = " || f_ip || "\n" ||
                "DEVICEID = " || f_device_name || "\n" ||
                "RESOLUTION = " || f_cli_res
                
    DISPLAY f_msg 
    CALL fgl_winmessage(%"function.lib.string.Env_Dump",f_msg, "information")
END FUNCTION
#
#
#
#
FUNCTION capture_local_stats(f_info)
    DEFINE
        f_info RECORD
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
        f_concat_geo STRING,
        f_ok SMALLINT,
        f_count INTEGER

    CALL openDB("local_db.db",FALSE)
    
    LET f_ok = FALSE
    LET f_concat_geo = f_info.geo_lat || "*" || f_info.geo_lon #* is the delimeter.
    TRY
        INSERT INTO local_stat VALUES(NULL, f_info.deployment_type, f_info.os_type, f_info.ip, f_info.device_name, f_info.resolution,  f_concat_geo, CURRENT YEAR TO SECOND)
    CATCH
        DISPLAY STATUS || " " || SQLERRMESSAGE
    END TRY

    IF sqlca.sqlcode <> 0
    THEN
        CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1002", "stop")
        EXIT PROGRAM 1002
    ELSE
        LET f_ok = TRUE
    END IF

    #We don't want the local stat table getting too big so lets clear down old data as we go along...
    SELECT COUNT(*) INTO f_count FROM local_stat

    IF f_count >= global_config.g_local_stat_limit
    THEN
        TRY
            DELETE FROM local_stat WHERE l_s_index = (SELECT MIN(l_s_index) FROM local_stat)
        CATCH
            DISPLAY STATUS || " " || SQLERRMESSAGE
        END TRY

        IF sqlca.sqlcode <> 0
        THEN
            CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1003", "stop")
            EXIT PROGRAM 1003
        END IF
    END IF
    
    RETURN f_ok
END FUNCTION
#
#
#
#
FUNCTION hash_password(f_pass)
    DEFINE
        f_pass STRING,
        salt STRING,
        hashed_pass STRING,
        f_ok SMALLINT
    
    LET f_ok = FALSE

    LET salt = Security.BCrypt.GenerateSalt(12)

    CALL Security.BCrypt.HashPassword(f_pass, salt) RETURNING hashed_pass

    IF Security.BCrypt.CheckPassword(f_pass, hashed_pass) THEN
        LET f_ok = TRUE
    ELSE
        LET f_ok = FALSE
    END IF

    RETURN f_ok, hashed_pass
END FUNCTION
#
#
#
#
FUNCTION check_password(f_user,f_pass)
    DEFINE f_user STRING,
        f_pass STRING,
        hashed_pass STRING,
        f_user_type STRING,
        f_ok SMALLINT

    LET f_ok = FALSE

    SELECT password,user_type INTO hashed_pass,f_user_type FROM local_accounts WHERE username = f_user

    IF hashed_pass IS NULL
    THEN
        LET f_ok = FALSE
    ELSE
        IF Security.BCrypt.CheckPassword(f_pass, hashed_pass) THEN
            LET f_ok = TRUE
            LET global.g_user = f_user
            LET global.g_user_type = f_user_type
            LET global.g_logged_in = CURRENT YEAR TO SECOND
              
        ELSE
            LET f_ok = FALSE
        END IF
    END IF

    RETURN f_ok
END FUNCTION
#
#
#
#
FUNCTION get_local_remember()

    DEFINE
        f_remember SMALLINT,
        f_username LIKE local_accounts.username,
        f_ok SMALLINT

    CALL openDB("local_db.db",FALSE)

    LET f_ok = FALSE

    SELECT remember, username INTO f_remember, f_username FROM local_remember WHERE 1  = 1

    IF f_remember IS NOT NULL
    THEN
        LET f_ok = TRUE
    ELSE
        CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1004", "stop")
        EXIT PROGRAM 1004
    END IF

    IF f_remember = FALSE
    THEN
        LET f_username = ""
    END IF

    RETURN f_ok, f_remember, f_username
    
END FUNCTION
#
#
#
#
FUNCTION refresh_local_remember(f_username,f_remember)

    DEFINE
        f_remember SMALLINT,
        f_username LIKE local_accounts.username,
        f_ok SMALLINT

    CALL openDB("local_db.db",FALSE)

    LET f_ok = FALSE
    TRY
        UPDATE local_remember SET remember = f_remember, username = f_username, last_modified = CURRENT YEAR TO SECOND WHERE 1 = 1
    CATCH
        DISPLAY STATUS || " " || SQLERRMESSAGE
    END TRY

    IF sqlca.sqlcode <> 0
    THEN
        CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1005", "stop")
        EXIT PROGRAM 1005
    ELSE
        LET f_ok = TRUE
    END IF

    RETURN f_ok
    
END FUNCTION
#
#
#
#
FUNCTION test_connectivity(f_deployment_type)

    DEFINE
        f_deployment_type STRING,
        f_connectivity STRING,
        f_req com.HttpRequest,
        f_resp com.HttpResponse,
        f_resp_code INTEGER

    IF f_deployment_type = "GMA" OR f_deployment_type = "GMI"
    THEN
        CALL ui.Interface.frontCall("mobile", "connectivity", [], [f_connectivity])
    ELSE
        TRY
            LET f_req = com.HttpRequest.Create(global_config.g_online_ping_URL)
            CALL f_req.setHeader("PingHeader","High Priority")
            CALL f_req.doRequest()
            LET f_resp = f_req.getResponse()
            LET f_resp_code = f_resp.getStatusCode()
            IF f_resp.getStatusCode() != 200 THEN
                #DISPLAY "HTTP Error (" || f_resp.getStatusCode() || ") " || f_resp.getStatusDescription()
                LET f_connectivity = "NONE"
                MESSAGE %"function.lib.string.Working_Offline"
            ELSE
                #HTTP Code of 200 means we have some level of internet connection so lets set the the f_connectivity to "WIFI" like a mobile WIFI connection
                LET f_connectivity = "WIFI"
                MESSAGE ""
                #DISPLAY "HTTP Response is : " || f_resp.getTextResponse()
            END IF
        CATCH
            #DISPLAY "ERROR :" || STATUS || " (" || SQLCA.SQLERRM || ")"
            LET f_connectivity = "NONE"
            MESSAGE %"function.lib.string.Working_Offline"
        END TRY
    END IF

    LET global.g_online = f_connectivity
END FUNCTION
#
#
#
#
FUNCTION timed_upload_queue_data()

    DEFINE
        f_count INTEGER

    IF global_config.g_enable_timed_image_upload = TRUE AND global.g_online != "NONE"
    THEN
        SELECT COUNT(*) INTO f_count FROM payload_queue WHERE payload_type = 'IMAGE'
        IF f_count != 0
        THEN
            DISPLAY "Uploading images..."
            CALL upload_image_payload(TRUE)
            #MESSAGE %"function.lib.string.Uploaded" || global.g_OK_uploads || %"function.lib.string.Images_OK" || global.g_FAILED_uploads || %"function.lib.string.Images_Failed"
            MESSAGE SFMT(%"function.lib.string.Uploaded",global.g_OK_uploads,global.g_FAILED_uploads)
        END IF
    END IF
    

END FUNCTION
#
#
#
#
FUNCTION load_payload(f_user,f_type,f_payload)

    DEFINE
        f_user STRING,
        f_type STRING,
        f_payload STRING,
        f_destination STRING,
        f_ok SMALLINT

    CALL openDB("local_db.db",FALSE)

    LET f_ok = FALSE

    CALL get_payload_destination(f_type)
        RETURNING f_destination

    TRY
      INSERT INTO payload_queue VALUES(NULL,f_user,CURRENT YEAR TO SECOND,NULL,f_destination,f_type,f_payload)
    CATCH
        DISPLAY STATUS || " " || SQLERRMESSAGE
    END TRY

    IF sqlca.sqlcode <> 0
    THEN
        CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1006", "stop")
        EXIT PROGRAM 1006
    ELSE
        LET f_ok = TRUE
    END IF

    RETURN f_ok
END FUNCTION
#
#
#
#
FUNCTION get_payload_destination(f_type) 
    #I left this function in, incase you wanted to write your own WS clients in genero but if you use fglWSDL then 
    #you don't really need this here. But seeing as I already coded it in, I might as well keep it in!

    DEFINE
        f_type STRING

    CASE f_type
        WHEN "IMAGE"
            RETURN global_config.g_image_dest
        OTHERWISE
            RETURN "ERROR" #This will never happen.
    END CASE
    
END FUNCTION
#
#
#
#
FUNCTION upload_image_payload(f_silent)

    DEFINE
        f_soapstatus INTEGER,
        f_soapresponse STRING,
        f_queue_rec RECORD
            p_q_index LIKE payload_queue.p_q_index,
            requested_by LIKE payload_queue.requested_by,
            requested_date LIKE payload_queue.requested_date,
            last_attempted LIKE payload_queue.last_attempted,
            destination LIKE payload_queue.destination,
            payload_type LIKE payload_queue.payload_type,
            payload STRING #BDL doesn't support BLOB so we need to define it as STRING not BYTE
        END RECORD,
        f_audit_rec DYNAMIC ARRAY OF RECORD
            p_q_index LIKE payload_queue.p_q_index,
            satatus CHAR(5)
        END RECORD,
        f_index INTEGER,
        f_silent SMALLINT,
        f_count INTEGER

    CALL openDB("local_db.db",FALSE)

    PREPARE s1
        FROM "SELECT * FROM payload_queue WHERE payload_type = 'IMAGE'"
    DECLARE c1 CURSOR FOR s1

    SELECT COUNT(*) INTO f_count FROM payload_queue WHERE payload_type = 'IMAGE'

    IF f_count = 0
    THEN
        IF f_silent = FALSE
        THEN
            CALL fgl_winmessage(%"function.lib.string.Image_Upload", %"function.lib.string.No_Images_To_Upload", "information")
        END IF
    ELSE
        CALL ws_funcs_check_service(global_config.g_client_key)
            RETURNING f_soapstatus, f_soapresponse

        IF f_soapresponse <> "OK"
        THEN
            IF f_silent = FALSE
            THEN
                CALL fgl_winmessage(%"function.lib.string.Warning_Title", %"function.lib.string.Unable_To_Communicate", "information")
            END IF
        END IF

        IF f_soapresponse = "OK"
        THEN
            LET global.g_OK_uploads = 0
            LET global.g_FAILED_uploads = 0
            LET f_index = 1
            FOREACH c1 INTO f_queue_rec.*
                #DISPLAY f_queue_rec.*
                CALL ws_funcs_process_image(global_config.g_client_key,f_queue_rec.requested_by,f_queue_rec.requested_date,f_queue_rec.payload)
                    RETURNING f_soapstatus, f_soapresponse
                IF f_soapresponse = "OK"
                THEN
                    LET f_audit_rec[f_index].p_q_index = f_queue_rec.p_q_index
                    LET f_audit_rec[f_index].satatus = "OK"
                    LET f_index = f_index + 1
                    LET global.g_OK_uploads = global.g_OK_uploads + 1
                    DELETE FROM payload_queue WHERE p_q_index = f_queue_rec.p_q_index
                ELSE
                    LET f_audit_rec[f_index].p_q_index = f_queue_rec.p_q_index
                    LET f_audit_rec[f_index].satatus = "FAIL"
                    LET f_index = f_index + 1
                    LET global.g_FAILED_uploads = global.g_FAILED_uploads + 1
                END IF
            END FOREACH
            FOR f_index = 1 TO f_audit_rec.getLength()
                #DISPLAY "Image: " || f_audit_rec[f_index].p_q_index || " STATUS: " || f_audit_rec[f_index].satatus
            END FOR
            IF f_silent = FALSE
            THEN
                #CALL fgl_winmessage(%"function.lib.string.Image_Upload", %"function.lib.string.Uploaded" || global.g_OK_uploads || %"function.lib.string.Images_OK" || global.g_FAILED_uploads || %"function.lib.string.Images_Failed", "information")
                CALL fgl_winmessage(%"function.lib.string.Image_Upload", SFMT(%"function.lib.string.Uploaded",global.g_OK_uploads,global.g_FAILED_uploads), "information" )
            END IF
        END IF
    END IF
END FUNCTION
#
#
#
#
FUNCTION set_localised_image(f_image)

    DEFINE
        f_image STRING

    IF global_config.g_default_language.toUpperCase() = global.g_language_short.toUpperCase()
    THEN
        RETURN f_image #Default language being used. Return default image
    ELSE
        IF global_config.g_local_images_available.search("",global.g_language_short.toUpperCase())
        THEN
            RETURN f_image || "_" || global.g_language_short.toLowerCase() #Localisation found. Return localised image
        END IF
    END IF
    
    RETURN f_image #We should never reach this point but just incase...
    
END FUNCTION

FUNCTION check_new_install()

    DEFINE
        f_count INTEGER

    #0-USERFOUND,#1-NEWINSTALL,#2-DBERROR

    CALL openDB("local_db.db",FALSE)
    
    TRY
        SELECT COUNT(*) INTO f_count FROM local_accounts
    CATCH
        DISPLAY STATUS || " " || SQLERRMESSAGE
        CALL fgl_winmessage("ERROR", STATUS || " " || SQLERRMESSAGE, "stop")
        RETURN 2
    END TRY

    IF f_count == 0 
    THEN
        RETURN 1
    ELSE
        RETURN 0
    END IF
    
END FUNCTION
#
#
#
#
FUNCTION validate_input_data(f_input,f_nulls,f_special_characters,f_safe_special_characters,f_numerals,f_letters,f_spaces,f_special_data_type)

    DEFINE
        f_input STRING,
        f_nulls SMALLINT,
        f_special_characters SMALLINT,
        f_safe_special_characters SMALLINT,
        f_numerals SMALLINT,
        f_letters SMALLINT,
        f_spaces SMALLINT,
        f_special_data_type STRING
        
    IF f_nulls = FALSE AND f_input IS NULL
    THEN
        RETURN f_input, FALSE, "BAD_NULLS"
    END IF

    IF f_special_data_type IS NULL
    THEN
        IF f_special_characters = FALSE AND fgl_regex(f_input,"\~\#\$\%\^\&\*\(\)\+\"\{\}\|\<\>\?\-\=\[\]\/")
        THEN
            RETURN f_input, FALSE, "BAD_CHARS"
        END IF

        IF f_safe_special_characters = FALSE AND fgl_regex(f_input,"\@\_\,\.\!\'\:\;")
        THEN
            RETURN f_input, FALSE, "BAD_CHARS_2"
        END IF

        IF f_numerals = FALSE AND fgl_regex(f_input,"0123456789")
        THEN
            RETURN f_input, FALSE, "BAD_NUMERALS"
        END IF

        IF f_letters = FALSE AND fgl_regex(f_input,"abcdefghijklmnopqrstuvwxyz") #This should include foriegn letters too at some point.
        THEN
            RETURN f_input, FALSE, "BAD_LETTERS"
        END IF

        IF f_spaces = FALSE AND fgl_regex(f_input," ")
        THEN
            RETURN f_input, FALSE, "BAD_SPACES"
        END IF
    END IF 
    
    IF f_special_data_type = "EMAIL" AND f_input MATCHES "*@*.*" = FALSE
    THEN
        RETURN f_input, FALSE, "BAD_EMAIL"
    ELSE    
        #Can't use this as JAVA is not supported in GMI...
        {IF fgl_regex(f_input,"\S+@\S+\.\S+") = FALSE #A simple email regex to make sure it's somewhat valid
        THEN
            RETURN f_input, FALSE, "BAD_EMAIL"
        END IF}
    END IF

    IF f_special_data_type = "URL"
    THEN
        LET f_input = util.Strings.urlEncode(f_input) #Encode the data so it's safe and computer friendly
    END IF   

    RETURN f_input, TRUE, "OK"
    
END FUNCTION
#
#
#
#
# This is the easiest way to regex input data however because JAVA is not currently supported by GMI,
# we have to use a FGL work around. Hopefully we will get a native FGL regex in the future...
{FUNCTION contains_characters(f_string,f_characters) #Returns TRUE or FALSE if string starts, ends or contains f_characters

    DEFINE
        f_string STRING,
        f_characters STRING,
        f_parameter STRING,
        f_pattern Pattern,
        f_matcher Matcher,
        f_ok SMALLINT

    LET f_ok = FALSE

    LET f_parameter = "[" || f_characters || "]" 
    LET f_pattern = Pattern.compile(f_parameter)
    LET f_matcher = f_pattern.matcher(f_string)

    IF f_matcher.matches()
    THEN
        LET f_ok = TRUE
    END IF

    RETURN f_ok
    
END FUNCTION}
#
#
#
#
FUNCTION fgl_regex(f_string,f_characters) #Not 100% correct but you get the idea...

    DEFINE
        f_string STRING,
        f_characters STRING,
        f_integer INTEGER,
        f_integer2 INTEGER
        
    LET f_string = f_string.toUpperCase()
    LET f_characters = f_characters.toUpperCase()
    FOR f_integer = 1 TO f_string.getLength()
        FOR f_integer2 = 1 TO f_characters.getLength()
            IF f_characters.getCharAt( f_integer2 ) = f_string.getCharAt( f_integer )
            THEN
                RETURN TRUE 
            END IF
        END FOR
    END FOR
    
    RETURN FALSE
    
END FUNCTION
#
#
#
#
FUNCTION reply_yn(f_default,f_title,f_question)

    DEFINE
         f_default STRING,
         f_title STRING,
         f_question STRING,
         f_answer STRING
   
     IF f_default MATCHES "[Yy]*"
     THEN
         LET f_default = "yes"
     ELSE
         LET f_default = "no"
     END IF

     LET f_answer = FGL_WINQUESTION(f_title,f_question,f_default, "yes|no","question",0)
     CALL ui.Interface.Refresh()
     RETURN f_answer = "yes"

END FUNCTION # reply_yn
#
#
#
#
FUNCTION close_app()
    DISPLAY "Application exited successfully!"
    EXIT PROGRAM 1
END FUNCTION