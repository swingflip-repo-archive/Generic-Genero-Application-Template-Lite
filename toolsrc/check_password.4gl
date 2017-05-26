IMPORT SECURITY

MAIN

    DEFINE user STRING,
        pass STRING,
        salt STRING,
        hashed_pass STRING,
        email STRING,
        telephone STRING,
        status STRING,
        m_ok SMALLINT
    
    DATABASE local_db

    PROMPT "Please enter the new username: " FOR user
    PROMPT "Please enter your plain text password: " FOR pass

    CALL check_password(user,pass) RETURNING m_ok

    LET pass = " "
    
    IF m_ok = TRUE
    THEN
        CALL fgl_winmessage("User Password Check","Status: " || "OK", "information") 
    ELSE
        CALL fgl_winmessage("User Password Check","Status: " || "FAILED", "information") 
    END IF
END MAIN