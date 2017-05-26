IMPORT SECURITY

MAIN

    DEFINE pass STRING,
        salt STRING,
        hashed_pass STRING,
        status STRING
    
    DATABASE local_db

    LET salt = Security.BCrypt.GenerateSalt(12)
    PROMPT "Please enter your plain text password below: " FOR pass

    CALL Security.BCrypt.HashPassword(pass, salt) RETURNING hashed_pass

    IF Security.BCrypt.CheckPassword(pass, hashed_pass) THEN
        LET status = "PASS"
    ELSE
        LET status = "FAIL"
    END IF

    DISPLAY "--Password Hash tool-- \n" || "Status: " || status || "\n" ||
                                             "Plain text password: " || pass || "\n" ||
                                             "Salt: " || salt || "\n" ||
                                             "Hashed Pass: " || hashed_pass || "\n" ||
                                             "Make sure you have made a note of these values!!!" || "\n------------------------"
                                             
    CALL fgl_winmessage("Password Hash Tool","Status: " || status || "\n" ||
                                             "Plain text password: " || pass || "\n" ||
                                             "Salt: " || salt || "\n" ||
                                             "Hashed Pass: " || hashed_pass || "\n" ||
                                             "Make sure you have made a note of these values!!!", "information") 
    
END MAIN