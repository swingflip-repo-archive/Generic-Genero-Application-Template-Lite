# ------------------------------------------------------------------------------
# Database creation script for SQLite
#
# Note: This script is a helper script to create an empty database schema
#       Adapt it to fit your needs
# ------------------------------------------------------------------------------

MAIN
    DATABASE local_db

    CALL db_drop_tables() #THIS WIPES ALL EXISTING DATA! COMMENT OUT IF YOU WANT THE DATA
    CALL db_create_tables()
		CALL db_create_defaults()
END MAIN

{
  db_create_tables

  Create all tables in database.
}
FUNCTION db_create_tables()
    WHENEVER ERROR CONTINUE

    EXECUTE IMMEDIATE "CREATE TABLE local_stat (
        l_s_index INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        deployment_type VARCHAR(255) NOT NULL,
				os_type VARCHAR(255) NOT NULL,
				ip VARCHAR(255),
				device_name VARCHAR(255),
				resolution VARCHAR(255),
				geo_location VARCHAR(255),
				last_load DATETIME NOT NULL
				);"

    EXECUTE IMMEDIATE "CREATE TABLE local_accounts (
        l_u_index INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username VARCHAR(255) NOT NULL,
				password VARCHAR(255) NOT NULL,
				email VARCHAR(255),
				phone INTEGER,
				last_login DATETIME,
				user_type VARCHAR(5),
				CONSTRAINT l_u_unique UNIQUE (username)
				);"

		EXECUTE IMMEDIATE "CREATE TABLE local_remember (
				l_r_index INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
				username VARCHAR(255),
				remember SMALLINT NOT NULL,
				last_modified DATETIME
				);"

		EXECUTE IMMEDIATE "CREATE TABLE payload_queue (
				p_q_index INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
				requested_by VARCHAR(255) NOT NULL,
				requested_date DATETIME NOT NULL,
				last_attempted DATETIME,
				destination VARCHAR(255) NOT NULL,
				payload_type VARCHAR(64) NOT NULL,
				payload BLOB NOT NULL
				);"

    WHENEVER ERROR STOP
END FUNCTION

{
  db_create_defaults

  Create default values which should be existent in every new deployment
}
FUNCTION db_create_defaults()
    WHENEVER ERROR CONTINUE

				EXECUTE IMMEDIATE "DELETE FROM local_remember WHERE 1 = 1"
				EXECUTE IMMEDIATE "INSERT INTO local_remember VALUES(NULL,NULL,0,NULL)"
		
		WHENEVER ERROR STOP
END FUNCTION

{
  db_drop_tables

  Drop all tables from database.
}
FUNCTION db_drop_tables()
    WHENEVER ERROR CONTINUE

    #EXECUTE IMMEDIATE "DROP TABLE local_stat"
    #EXECUTE IMMEDIATE "DROP TABLE local_accounts"
		#EXECUTE IMMEDIATE "DROP TABLE local_remember"
		EXECUTE IMMEDIATE "DROP TABLE payload_queue"
		
    WHENEVER ERROR STOP
END FUNCTION


