IMPORT SECURITY
IMPORT com
IMPORT util
GLOBALS "globals.4gl"
SCHEMA local_db
#
#
#
#
FUNCTION generate_about()

		LET g_application_about = g_application_title || " " || g_application_version || "\n\n" ||
														  %"function.lib.string.Logged_In_As" || g_user || "\n" ||
															%"function.lib.string.User_Type" || g_user_type || "\n" ||
													 	  %"function.lib.string.Logged_In_At" || util.Datetime.format(g_logged_in, g_date_format) || "\n" ||
															%"function.lib.string.Genero_Version" || FGL_GETVERSION() || "\n\n" || 
													 	  %"function.lib.string.About_Explanation" 													
END FUNCTION
#
#
#
#
FUNCTION initialize_globals(f_splash_w,f_splash_h,f_geo,f_mobile_title,f_local_limit,f_online_ping_URL,
														f_enable_timed_connect,f_timed_connect_time,f_date_format,f_image_dest,
														f_enable_timed_image_upload) #Set up global variables
		DEFINE
				f_ok SMALLINT,
				f_splash_w STRING,
				f_splash_h STRING,
				f_geo SMALLINT,
				f_mobile_title SMALLINT,
				f_local_limit INTEGER,
				f_online_ping_URL STRING,
				f_enable_timed_connect SMALLINT,
				f_timed_connect_time INTEGER,
				f_date_format STRING,
				f_image_dest STRING,
				f_enable_timed_image_upload SMALLINT

		LET f_ok = FALSE

		LET g_splash_width = f_splash_w
		LET g_splash_height = f_splash_h
		LET g_enable_geolocation = f_geo
		LET g_enable_mobile_title = f_mobile_title
		LET g_local_stat_limit = f_local_limit
		LET g_online_ping_URL = f_online_ping_URL
		LET g_enable_timed_connect = f_enable_timed_connect
		LET g_timed_checks_time = f_timed_connect_time
		LET g_date_format = f_date_format
		LET g_image_dest = f_image_dest
		LET g_enable_timed_image_upload = f_enable_timed_image_upload
		
		LET f_ok = TRUE
				
		RETURN f_ok
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
						geo_lon STRING
				END RECORD,
				f_concat_geo STRING,
				f_ok SMALLINT,
				f_count INTEGER

		DATABASE local_db
		
		LET f_ok = FALSE
		LET f_concat_geo = f_info.geo_lat || "*" || f_info.geo_lon #* is the delimeter.

		#WHENEVER ERROR CONTINUE
				INSERT INTO local_stat VALUES(NULL, f_info.deployment_type, f_info.os_type, f_info.ip, f_info.device_name, f_info.resolution,  f_concat_geo, CURRENT YEAR TO SECOND)
		#WHENEVER ERROR STOP

		IF sqlca.sqlcode <> 0
		THEN
				CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1002", "stop")
        EXIT PROGRAM 1002
		ELSE
				LET f_ok = TRUE
		END IF

		#We don't want the local stat table getting too big so lets clear down old data as we go along...
		SELECT COUNT(*) INTO f_count FROM local_stat

		IF f_count >= g_local_stat_limit
		THEN
				WHENEVER ERROR CONTINUE
						DELETE FROM local_stat WHERE l_s_index = (SELECT MIN(l_s_index) FROM local_stat)
				WHENEVER ERROR STOP

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
		DEFINE f_pass STRING,
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
						LET g_user = f_user
						LET g_user_type = f_user_type
						LET g_logged_in = CURRENT YEAR TO SECOND
							
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

		DATABASE local_db

		LET f_ok = FALSE

		SELECT remember, username INTO f_remember, f_username FROM local_remember WHERE 1 = 1

		IF f_remember IS NOT NULL
		THEN
				LET f_ok = TRUE
		ELSE
				CALL fgl_winmessage(%"function.lib.string.Fatal_Error", %"function.lib.string.ERROR_1004", "stop")
        EXIT PROGRAM 1004
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

		DATABASE local_db

		LET f_ok = FALSE
		WHENEVER ERROR CONTINUE
				UPDATE local_remember SET remember = f_remember, username = f_username, last_modified = CURRENT YEAR TO SECOND WHERE 1 = 1
		WHENEVER ERROR STOP

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
						LET f_req = com.HttpRequest.Create(g_online_ping_URL)
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

		LET g_online = f_connectivity
END FUNCTION
#
#
#
#
FUNCTION timed_upload_queue_data()

		DEFINE
				f_count INTEGER
				
		IF g_enable_timed_image_upload = TRUE AND g_online = TRUE
		THEN
				SELECT COUNT(*) INTO f_count FROM payload_queue WHERE payload_type = 'IMAGE'
				IF f_count = 0
				THEN
						CALL upload_image_payload(TRUE)
								MESSAGE %"function.lib.string.Uploaded" || g_OK_uploads || %"function.lib.string.Images_OK" || g_FAILED_uploads || %"function.lib.string.Images_Failed"
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

		DATABASE local_db

		LET f_ok = FALSE

		CALL get_payload_destination(f_type)
				RETURNING f_destination

		WHENEVER ERROR CONTINUE
			INSERT INTO payload_queue VALUES(NULL,f_user,CURRENT YEAR TO SECOND,NULL,f_destination,f_type,f_payload)
		WHENEVER ERROR STOP

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
						RETURN g_image_dest
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

		DATABASE local_db

		PREPARE s1
				FROM "SELECT * FROM payload_queue WHERE payload_type = 'IMAGE'"
		DECLARE c1 CURSOR FOR s1

		SELECT COUNT(*) INTO f_count FROM payload_queue WHERE payload_type = 'IMAGE'

		IF f_count = 0
		THEN
				IF f_silent = FALSE
				THEN
						CALL fgl_winmessage(%"Image Upload", %"function.lib.string.No_Images_To_Upload", "information")
				END IF
		ELSE
				CALL ws_funcs_check_service(g_client_key)
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
						LET g_OK_uploads = 0
						LET g_FAILED_uploads = 0
						LET f_index = 1
						FOREACH c1 INTO f_queue_rec.*
								#DISPLAY f_queue_rec.*
								CALL ws_funcs_process_image(g_client_key,f_queue_rec.requested_by,f_queue_rec.requested_date,f_queue_rec.payload)
										RETURNING f_soapstatus, f_soapresponse
								IF f_soapresponse = "OK"
								THEN
										LET f_audit_rec[f_index].p_q_index = f_queue_rec.p_q_index
										LET f_audit_rec[f_index].satatus = "OK"
										LET f_index = f_index + 1
										LET g_OK_uploads = g_OK_uploads + 1
										DELETE FROM payload_queue WHERE p_q_index = f_queue_rec.p_q_index
								ELSE
										LET f_audit_rec[f_index].p_q_index = f_queue_rec.p_q_index
										LET f_audit_rec[f_index].satatus = "FAIL"
										LET f_index = f_index + 1
										LET g_FAILED_uploads = g_FAILED_uploads + 1
								END IF
						END FOREACH
						FOR f_index = 1 TO f_audit_rec.getLength()
								#DISPLAY "Image: " || f_audit_rec[f_index].p_q_index || " STATUS: " || f_audit_rec[f_index].satatus
						END FOR
						IF f_silent = FALSE
						THEN
								CALL fgl_winmessage(%"function.lib.string.Image_Upload", %"function.lib.string.Uploaded" || g_OK_uploads || %"function.lib.string.Images_OK" || g_FAILED_uploads || %"function.lib.string.Images_Failed", "information")
						END IF
				END IF
		END IF
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