#Below is a list of global variables. The global variables in the top section are mainly used
#to configure the application. These variables are configured and are set near the start of main
#and via the initialize_globals function. To configure the application just ammend the arguments being
#passed into the initialize_globals function, if you need to add just extend the initialize_globals function
#within the top of function_lib

GLOBALS

################################################################################
# CONFIG GLOBALS
################################################################################

		DEFINE
		#Application Information
				g_application_title STRING,						#Application Title
				g_application_version STRING,					#Application Version
				g_application_about STRING,						#Application About Blurb
				g_application_database_ver INTEGER,		#Application Database Version (This is useful to force database additions to pre-existing db instances) 

		#Webservice variables
				g_client_key STRING,									#Unique Client key for webservice purposes
				g_image_dest STRING,									#Webserver destination for image payloads. i.e. "Webservice_1" (Not used as of yet, because you should be able to fglWSDL this is pretty redundant)

		#Application Image variables
				g_splash_width STRING, 								#Login menu splash width when not in mobile
				g_splash_height STRING, 							#Login menu splash height when not in mobile

		#Application on/off toggles
				g_enable_geolocation SMALLINT,				#Toggle to enable geolocation
				g_enable_mobile_title SMALLINT,				#Toggle application title on mobile

		#Timed event toggles and variables
				g_timed_checks_time INTEGER,					#Time in seconds before running auto checks, uploads or refreshes (0 disables this globally)
				g_enable_timed_connect SMALLINT,			#Enable timed connectivity checks
				g_enable_timed_image_upload SMALLINT,	#Enable timed image queue uploads (Could have a performance impact!)

		#General application variables
				g_enable_login SMALLINT,							#Boot in to login menu or straight into application (open_application())
				g_local_stat_limit INTEGER,						#Number of max local stat records before pruning
				g_online_ping_URL STRING,							#URL of public site to test internet connectivity (i.e. http://www.google.com) 
				g_date_format STRING									#Datetime format. i.e.  "%d/%m/%Y %H:%M"

################################################################################
				
		#Global variables used within the application,
		#These variables contain useful data used during runtime, these variables aren't used for app configuration...
		DEFINE
				g_online STRING,											#BOOLEAN to determine if the application is online or offline
				g_user STRING,												#Username of the user currently logged in
				g_user_type STRING,										#User type currently logged in
				g_logged_in DATETIME YEAR TO SECOND,	#When the current user logged in to the system
				g_OK_uploads INTEGER,									#Number of successful uploads just carried out
				g_FAILED_uploads INTEGER							#Number of failed uploads just carried out
		
END GLOBALS