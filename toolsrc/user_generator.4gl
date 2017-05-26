IMPORT SECURITY

MAIN

    DEFINE user STRING,
        pass STRING,
        salt STRING,
        hashed_pass STRING,
        email STRING,
        telephone STRING,
        user_type CHAR(5),
        status STRING,
        m_ok SMALLINT,
        f_buff base.StringBuffer
    
    DATABASE local_db

    PROMPT "Please enter the new username: " FOR user
    LET user = downshift(user)
    PROMPT "Please enter your plain text password: " FOR pass

    CALL hash_password(pass) RETURNING m_ok, hashed_pass

    PROMPT "Please enter user type: (i.e. ADMIN, USER1, USER2) " FOR user_type

    LET f_buff = base.StringBuffer.create()
    CALL f_buff.append(user_type)
    CALL f_buff.toUpperCase()
    LET user_type = f_buff.toString()
    
    PROMPT "Please enter an email (optional): " FOR email
    PROMPT "Please enter a telephone (optional): " FOR telephone

    #WHENEVER ERROR CONTINUE
        INSERT INTO local_accounts VALUES(NULL,user,hashed_pass,email,telephone,NULL,user_type)
    #WHENEVER ERROR STOP
    
    IF sqlca.sqlcode <> 0
    THEN
        CALL fgl_winmessage("User Create Tool","ERROR: could not create user in the database","stop")
        EXIT PROGRAM 999
    ELSE
        IF email IS NULL THEN LET email = " " END IF
        IF telephone IS NULL THEN LET telephone = " " END IF
        
        DISPLAY "--User Create tool-- \n" || "Status: " || "OK" || "\n" ||
                                                 "Username: " || user || "\n" ||
                                                 "Plain text password: " || pass || "\n" ||
                                                 "Hashed Pass: " || hashed_pass || "\n" ||
                                                 "User Type: " || user_type || "\n" ||
                                                 "Email: " || email || "\n" ||
                                                 "Telephone: " || telephone || "\n" ||
                                                 "Make sure you have made a note of these values!!!" || "\n------------------------"
                                                 
        CALL fgl_winmessage("User Create tool","Status: " || "OK" || "\n" ||
                                                 "Username: " || user || "\n" ||
                                                 "Plain text password: " || pass || "\n" ||
                                                 "Hashed Pass: " || hashed_pass || "\n" ||
                                                 "User Type: " || user_type || "\n" ||
                                                 "Email: " || email || "\n" ||
                                                 "Telephone: " || telephone || "\n" ||
                                                 "Make sure you have made a note of these values!!!", "information") 
    END IF
    
END MAIN