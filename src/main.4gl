################################################################################
#START OF APPLICATION
#Written by Ryan Hamlin - 2017. (Ryan@ryanhamlin.co.uk)
#
#This is the application launcher. We need to detect locale seperately from the
#main application otherwise we will automatically load the default localisation
#strings for main.4gl. If we loaded directly into the application, main.4gl will
#always use the default (en) version of the strings. This is an oversight on Genero's
#behalf that hopefully won't be an issue in the future...
################################################################################
IMPORT os
IMPORT util
GLOBALS "globals.4gl"
        
        
    DEFINE
        m_require_app_reload SMALLINT
    
MAIN
#******************************************************************************# 
    #Detect user's locale and set language accordingly depending on available language packs.
    CALL ui.Interface.frontCall("standard", "feInfo", "userPreferredLang", g_info.locale)

    LET g_language = g_info.locale
    
    CALL load_localisation(g_info.locale,FALSE)
        RETURNING m_require_app_reload #Not needed yet, but will useful when we can change strings runtime properly.

    CALL initialise_app()
    
END MAIN

FUNCTION load_localisation(f_locale, f_pre_window) #This auto loads the user's locale language if available. (Must be local to the main.4gl!)
    DEFINE
        f_locale STRING,
        f_pre_window SMALLINT,
        f_localisation_path STRING,
        f_string_buffer base.StringBuffer,
        f_require_reload SMALLINT
        
    LET f_require_reload = FALSE
    #Check if we have the locale.42s folder, if not then revert to defaults. 
    #If load_localisation() is called before window then f_pre_window = false else we need to reload current window

    LET f_string_buffer = base.StringBuffer.create()
    CALL f_string_buffer.append(f_locale)
    LET g_language_short = f_string_buffer.subString(1,2)

    IF os.Path.exists(os.Path.join(base.Application.getProgramDir(), f_locale)) #i.e. en_GB or en_US
    THEN
        LET g_language = f_locale
        LET f_localisation_path = os.Path.join(base.Application.getProgramDir(), g_language)
        CALL base.Application.reloadResources(f_localisation_path)
        LET f_require_reload = TRUE
    ELSE
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