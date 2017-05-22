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




