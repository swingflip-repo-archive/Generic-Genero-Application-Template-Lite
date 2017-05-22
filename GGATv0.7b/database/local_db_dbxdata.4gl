{<CODEFILE Path="local_db.code" Hash="1B2M2Y8AsgTpgAmY7PhCfg==" />}
#+ DB schema - Data Management (local_db)

--------------------------------------------------------------------------------
--This code is generated with the template dbapp4.0
--Warning: Enter your changes within a <BLOCK> or <POINT> section, otherwise they will be lost.
{<POINT Name="user.comments">} {</POINT>}

--------------------------------------------------------------------------------
--Importing modules
IMPORT FGL libdbappCore
IMPORT FGL libdbappSql

IMPORT FGL local_db_dbxconstraints
{<POINT Name="import">} {</POINT>}

--------------------------------------------------------------------------------
--Database schema
SCHEMA local_db

--------------------------------------------------------------------------------
--Functions

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_selectRowByKey">}
#+ Select a row identified by the primary key in the "payload_queue" table
#+
#+ @param p_key - Primary Key
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER, LIKE payload_queue.*
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_NOTFOUND, RECORD LIKE payload_queue.*
PUBLIC FUNCTION local_db_dbxdata_payload_queue_primary_key_payload_queue_selectRowByKey(p_key, p_lock)
    DEFINE p_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE l_data RECORD LIKE payload_queue.*
    DEFINE l_supportLock BOOLEAN
    DEFINE errNo INTEGER
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_selectRowByKey.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    -- SQLite does not support the FOR UPDATE close in SELECT syntax
    LET l_supportLock = (UPSHIFT(fgl_db_driver_type()) != "SQT")
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_selectRowByKey.init">} {</POINT>}
    TRY
        IF p_lock AND l_supportLock THEN
            SELECT * INTO l_data.* FROM payload_queue
                WHERE payload_queue.p_q_index = p_key.payload_queue_p_q_index
            FOR UPDATE
        ELSE
            SELECT * INTO l_data.* FROM payload_queue
                WHERE payload_queue.p_q_index = p_key.payload_queue_p_q_index
        END IF
        IF SQLCA.SQLCODE == NOTFOUND THEN
            LET errNo = ERROR_NOTFOUND
        END IF
    CATCH
        INITIALIZE l_data.* TO NULL
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_selectRowByKey.afterSelect">} {</POINT>}
    RETURN errNo, l_data.*
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_selectRowByKey

{<BLOCK Name="fct.payload_queue_insertRowByKey">}
#+ Insert a row in the "payload_queue" table and return the primary key created
#+
#+ @param p_data - a row data LIKE payload_queue.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, payload_queue.p_q_index
PRIVATE FUNCTION local_db_dbxdata_payload_queue_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE payload_queue.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.payload_queue_insertRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.payload_queue_insertRowByKey.init">} {</POINT>}
        CALL local_db_dbxconstraints.local_db_dbxconstraints_payload_queue_checkTableConstraints(FALSE, p_data.*) RETURNING errNo, errMsg
        {<POINT Name="fct.payload_queue_insertRowByKey.beforeInsert">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            TRY
                INSERT INTO payload_queue VALUES (p_data.*)
            CATCH
                LET errNo = ERROR_FAILURE
            END TRY
            {<POINT Name="fct.payload_queue_insertRowByKey.afterInsert">} {</POINT>}
        END IF
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg, p_data.p_q_index
END FUNCTION
{</BLOCK>} --fct.payload_queue_insertRowByKey

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_insertRowByKey">}
#+ Insert a row in the "payload_queue" table and return the table keys
#+
#+ @param p_data - a row data LIKE payload_queue.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, payload_queue.p_q_index
PUBLIC FUNCTION local_db_dbxdata_payload_queue_primary_key_payload_queue_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE payload_queue.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_insertRowByKey.define">} {</POINT>}
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_insertRowByKey.init">} {</POINT>}

    CALL local_db_dbxdata_payload_queue_insertRowByKey(p_data.*) RETURNING errNo, errMsg, p_data.p_q_index
    RETURN errNo, errMsg, p_data.p_q_index
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_insertRowByKey

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_updateRowByKey">}
#+ Update a row identified by the primary key in the "payload_queue" table
#+
#+ @param p_dataT0 - a row data LIKE payload_queue.*
#+ @param p_dataT1 - a row data LIKE payload_queue.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE, error message
PUBLIC FUNCTION local_db_dbxdata_payload_queue_primary_key_payload_queue_updateRowByKey(p_dataT0, p_dataT1)
    DEFINE p_dataT0 RECORD LIKE payload_queue.*
    DEFINE p_dataT1 RECORD LIKE payload_queue.*
    DEFINE l_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_updateRowByKey.define">} {</POINT>}
    LET l_key.payload_queue_p_q_index = p_dataT0.p_q_index
    INITIALIZE errMsg TO NULL
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_updateRowByKey.init">} {</POINT>}
        TRY
            LET errNo = local_db_dbxdata_payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
            {<POINT Name="fct.payload_queue_primary_key_payload_queue_updateRowByKey.afterSelect">} {</POINT>}
            IF errNo == ERROR_SUCCESS THEN
                CALL local_db_dbxconstraints.local_db_dbxconstraints_payload_queue_checkTableConstraints(TRUE, p_dataT1.*) RETURNING errNo, errMsg
                {<POINT Name="fct.payload_queue_primary_key_payload_queue_updateRowByKey.beforeUpdate">} {</POINT>}
                IF errNo == ERROR_SUCCESS THEN
                    UPDATE payload_queue
                        SET payload_queue.* = p_dataT1.*
                        WHERE payload_queue.p_q_index = l_key.payload_queue_p_q_index
                END IF
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_updateRowByKey.afterUpdate">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_updateRowByKey

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKey">}
#+ Delete a row identified by the primary key in the "payload_queue" table
#+
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_payload_queue_primary_key_payload_queue_deleteRowByKey(p_key)
    DEFINE p_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKey.init">} {</POINT>}
        TRY
            DELETE FROM payload_queue
                WHERE payload_queue.p_q_index = p_key.payload_queue_p_q_index
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKey.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_deleteRowByKey

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess">}
#+ Delete a row identified by the primary key in the "payload_queue" table if the concurrent access is success
#+
#+ @param p_dataT0 - a row data LIKE payload_queue.*
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess(p_dataT0)
    DEFINE p_dataT0 RECORD LIKE payload_queue.*
    DEFINE l_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.payload_queue_p_q_index = p_dataT0.p_q_index
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess.init">} {</POINT>}
        LET errNo = local_db_dbxdata_payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = local_db_dbxdata_payload_queue_primary_key_payload_queue_deleteRowByKey(l_key.*)
        END IF
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_deleteRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess">}
#+ Check if a row identified by the primary key in the "payload_queue" table has been modified or deleted
#+
#+ @param p_dataT0 - a row data LIKE payload_queue.*
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE
PUBLIC FUNCTION local_db_dbxdata_payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess(p_dataT0, p_lock)
    DEFINE p_dataT0 RECORD LIKE payload_queue.*
    DEFINE l_dataT2 RECORD LIKE payload_queue.*
    DEFINE l_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE errNo INTEGER
    DEFINE errDiff INTEGER
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.payload_queue_p_q_index = p_dataT0.p_q_index
    INITIALIZE l_dataT2.* TO NULL
    LET errDiff = FALSE
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess.init">} {</POINT>}
    CALL local_db_dbxdata_payload_queue_primary_key_payload_queue_selectRowByKey(l_key.*, p_lock) RETURNING errNo, l_dataT2.*
    CASE errNo
        WHEN ERROR_SUCCESS
            LET errDiff = (p_dataT0.* != l_dataT2.*)
            {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
            IF NOT errDiff THEN
                LET errNo = ERROR_SUCCESS
            ELSE
                LET errNo = ERROR_CONCURRENT_ACCESS_FAILURE
            END IF
        WHEN ERROR_NOTFOUND
            LET errNo = ERROR_CONCURRENT_ACCESS_NOTFOUND
    END CASE
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess.afterCheck">} {</POINT>}
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_checkRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.payload_queue_setDefaultValuesFromDBSchema">}
#+ Set data with the default values coming from the DB schema
#+
PUBLIC FUNCTION local_db_dbxdata_payload_queue_setDefaultValuesFromDBSchema()
    DEFINE l_data RECORD LIKE payload_queue.*
    {<POINT Name="fct.payload_queue_setDefaultValuesFromDBSchema.define">} {</POINT>}

    INITIALIZE l_data.* TO NULL
    {<POINT Name="fct.payload_queue_setDefaultValuesFromDBSchema.init">} {</POINT>}
    RETURN l_data.*
END FUNCTION
{</BLOCK>} --fct.payload_queue_setDefaultValuesFromDBSchema

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_selectRowByKey">}
#+ Select a row identified by the primary key in the "local_stat" table
#+
#+ @param p_key - Primary Key
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER, LIKE local_stat.*
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_NOTFOUND, RECORD LIKE local_stat.*
PUBLIC FUNCTION local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_selectRowByKey(p_key, p_lock)
    DEFINE p_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE l_data RECORD LIKE local_stat.*
    DEFINE l_supportLock BOOLEAN
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_selectRowByKey.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    -- SQLite does not support the FOR UPDATE close in SELECT syntax
    LET l_supportLock = (UPSHIFT(fgl_db_driver_type()) != "SQT")
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_selectRowByKey.init">} {</POINT>}
    TRY
        IF p_lock AND l_supportLock THEN
            SELECT * INTO l_data.* FROM local_stat
                WHERE local_stat.l_s_index = p_key.local_stat_l_s_index
            FOR UPDATE
        ELSE
            SELECT * INTO l_data.* FROM local_stat
                WHERE local_stat.l_s_index = p_key.local_stat_l_s_index
        END IF
        IF SQLCA.SQLCODE == NOTFOUND THEN
            LET errNo = ERROR_NOTFOUND
        END IF
    CATCH
        INITIALIZE l_data.* TO NULL
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_selectRowByKey.afterSelect">} {</POINT>}
    RETURN errNo, l_data.*
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_selectRowByKey

{<BLOCK Name="fct.local_stat_insertRowByKey">}
#+ Insert a row in the "local_stat" table and return the primary key created
#+
#+ @param p_data - a row data LIKE local_stat.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_stat.l_s_index
PRIVATE FUNCTION local_db_dbxdata_local_stat_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_stat.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_stat_insertRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_stat_insertRowByKey.init">} {</POINT>}
        CALL local_db_dbxconstraints.local_db_dbxconstraints_local_stat_checkTableConstraints(FALSE, p_data.*) RETURNING errNo, errMsg
        {<POINT Name="fct.local_stat_insertRowByKey.beforeInsert">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            TRY
                INSERT INTO local_stat VALUES (p_data.*)
            CATCH
                LET errNo = ERROR_FAILURE
            END TRY
            {<POINT Name="fct.local_stat_insertRowByKey.afterInsert">} {</POINT>}
        END IF
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg, p_data.l_s_index
END FUNCTION
{</BLOCK>} --fct.local_stat_insertRowByKey

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_insertRowByKey">}
#+ Insert a row in the "local_stat" table and return the table keys
#+
#+ @param p_data - a row data LIKE local_stat.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_stat.l_s_index
PUBLIC FUNCTION local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_stat.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_insertRowByKey.define">} {</POINT>}
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_insertRowByKey.init">} {</POINT>}

    CALL local_db_dbxdata_local_stat_insertRowByKey(p_data.*) RETURNING errNo, errMsg, p_data.l_s_index
    RETURN errNo, errMsg, p_data.l_s_index
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_insertRowByKey

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey">}
#+ Update a row identified by the primary key in the "local_stat" table
#+
#+ @param p_dataT0 - a row data LIKE local_stat.*
#+ @param p_dataT1 - a row data LIKE local_stat.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE, error message
PUBLIC FUNCTION local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_updateRowByKey(p_dataT0, p_dataT1)
    DEFINE p_dataT0 RECORD LIKE local_stat.*
    DEFINE p_dataT1 RECORD LIKE local_stat.*
    DEFINE l_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey.define">} {</POINT>}
    LET l_key.local_stat_l_s_index = p_dataT0.l_s_index
    INITIALIZE errMsg TO NULL
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey.init">} {</POINT>}
        TRY
            LET errNo = local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
            {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey.afterSelect">} {</POINT>}
            IF errNo == ERROR_SUCCESS THEN
                CALL local_db_dbxconstraints.local_db_dbxconstraints_local_stat_checkTableConstraints(TRUE, p_dataT1.*) RETURNING errNo, errMsg
                {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey.beforeUpdate">} {</POINT>}
                IF errNo == ERROR_SUCCESS THEN
                    UPDATE local_stat
                        SET local_stat.* = p_dataT1.*
                        WHERE local_stat.l_s_index = l_key.local_stat_l_s_index
                END IF
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey.afterUpdate">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_updateRowByKey

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey">}
#+ Delete a row identified by the primary key in the "local_stat" table
#+
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey(p_key)
    DEFINE p_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey.init">} {</POINT>}
        TRY
            DELETE FROM local_stat
                WHERE local_stat.l_s_index = p_key.local_stat_l_s_index
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess">}
#+ Delete a row identified by the primary key in the "local_stat" table if the concurrent access is success
#+
#+ @param p_dataT0 - a row data LIKE local_stat.*
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess(p_dataT0)
    DEFINE p_dataT0 RECORD LIKE local_stat.*
    DEFINE l_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_stat_l_s_index = p_dataT0.l_s_index
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess.init">} {</POINT>}
        LET errNo = local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_deleteRowByKey(l_key.*)
        END IF
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_deleteRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess">}
#+ Check if a row identified by the primary key in the "local_stat" table has been modified or deleted
#+
#+ @param p_dataT0 - a row data LIKE local_stat.*
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE
PUBLIC FUNCTION local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess(p_dataT0, p_lock)
    DEFINE p_dataT0 RECORD LIKE local_stat.*
    DEFINE l_dataT2 RECORD LIKE local_stat.*
    DEFINE l_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE errNo INTEGER
    DEFINE errDiff INTEGER
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_stat_l_s_index = p_dataT0.l_s_index
    INITIALIZE l_dataT2.* TO NULL
    LET errDiff = FALSE
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess.init">} {</POINT>}
    CALL local_db_dbxdata_local_stat_sqlite_autoindex_local_stat_1_selectRowByKey(l_key.*, p_lock) RETURNING errNo, l_dataT2.*
    CASE errNo
        WHEN ERROR_SUCCESS
            LET errDiff = (p_dataT0.* != l_dataT2.*)
            {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
            IF NOT errDiff THEN
                LET errNo = ERROR_SUCCESS
            ELSE
                LET errNo = ERROR_CONCURRENT_ACCESS_FAILURE
            END IF
        WHEN ERROR_NOTFOUND
            LET errNo = ERROR_CONCURRENT_ACCESS_NOTFOUND
    END CASE
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess.afterCheck">} {</POINT>}
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_checkRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_stat_setDefaultValuesFromDBSchema">}
#+ Set data with the default values coming from the DB schema
#+
PUBLIC FUNCTION local_db_dbxdata_local_stat_setDefaultValuesFromDBSchema()
    DEFINE l_data RECORD LIKE local_stat.*
    {<POINT Name="fct.local_stat_setDefaultValuesFromDBSchema.define">} {</POINT>}

    INITIALIZE l_data.* TO NULL
    {<POINT Name="fct.local_stat_setDefaultValuesFromDBSchema.init">} {</POINT>}
    RETURN l_data.*
END FUNCTION
{</BLOCK>} --fct.local_stat_setDefaultValuesFromDBSchema

{<BLOCK Name="fct.local_remember_primary_key_local_remember_selectRowByKey">}
#+ Select a row identified by the primary key in the "local_remember" table
#+
#+ @param p_key - Primary Key
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER, LIKE local_remember.*
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_NOTFOUND, RECORD LIKE local_remember.*
PUBLIC FUNCTION local_db_dbxdata_local_remember_primary_key_local_remember_selectRowByKey(p_key, p_lock)
    DEFINE p_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE l_data RECORD LIKE local_remember.*
    DEFINE l_supportLock BOOLEAN
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_remember_primary_key_local_remember_selectRowByKey.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    -- SQLite does not support the FOR UPDATE close in SELECT syntax
    LET l_supportLock = (UPSHIFT(fgl_db_driver_type()) != "SQT")
    {<POINT Name="fct.local_remember_primary_key_local_remember_selectRowByKey.init">} {</POINT>}
    TRY
        IF p_lock AND l_supportLock THEN
            SELECT * INTO l_data.* FROM local_remember
                WHERE local_remember.l_r_index = p_key.local_remember_l_r_index
            FOR UPDATE
        ELSE
            SELECT * INTO l_data.* FROM local_remember
                WHERE local_remember.l_r_index = p_key.local_remember_l_r_index
        END IF
        IF SQLCA.SQLCODE == NOTFOUND THEN
            LET errNo = ERROR_NOTFOUND
        END IF
    CATCH
        INITIALIZE l_data.* TO NULL
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_remember_primary_key_local_remember_selectRowByKey.afterSelect">} {</POINT>}
    RETURN errNo, l_data.*
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_selectRowByKey

{<BLOCK Name="fct.local_remember_insertRowByKey">}
#+ Insert a row in the "local_remember" table and return the primary key created
#+
#+ @param p_data - a row data LIKE local_remember.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_remember.l_r_index
PRIVATE FUNCTION local_db_dbxdata_local_remember_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_remember.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_remember_insertRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_remember_insertRowByKey.init">} {</POINT>}
        CALL local_db_dbxconstraints.local_db_dbxconstraints_local_remember_checkTableConstraints(FALSE, p_data.*) RETURNING errNo, errMsg
        {<POINT Name="fct.local_remember_insertRowByKey.beforeInsert">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            TRY
                INSERT INTO local_remember VALUES (p_data.*)
            CATCH
                LET errNo = ERROR_FAILURE
            END TRY
            {<POINT Name="fct.local_remember_insertRowByKey.afterInsert">} {</POINT>}
        END IF
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg, p_data.l_r_index
END FUNCTION
{</BLOCK>} --fct.local_remember_insertRowByKey

{<BLOCK Name="fct.local_remember_primary_key_local_remember_insertRowByKey">}
#+ Insert a row in the "local_remember" table and return the table keys
#+
#+ @param p_data - a row data LIKE local_remember.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_remember.l_r_index
PUBLIC FUNCTION local_db_dbxdata_local_remember_primary_key_local_remember_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_remember.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_remember_primary_key_local_remember_insertRowByKey.define">} {</POINT>}
    {<POINT Name="fct.local_remember_primary_key_local_remember_insertRowByKey.init">} {</POINT>}

    CALL local_db_dbxdata_local_remember_insertRowByKey(p_data.*) RETURNING errNo, errMsg, p_data.l_r_index
    RETURN errNo, errMsg, p_data.l_r_index
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_insertRowByKey

{<BLOCK Name="fct.local_remember_primary_key_local_remember_updateRowByKey">}
#+ Update a row identified by the primary key in the "local_remember" table
#+
#+ @param p_dataT0 - a row data LIKE local_remember.*
#+ @param p_dataT1 - a row data LIKE local_remember.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE, error message
PUBLIC FUNCTION local_db_dbxdata_local_remember_primary_key_local_remember_updateRowByKey(p_dataT0, p_dataT1)
    DEFINE p_dataT0 RECORD LIKE local_remember.*
    DEFINE p_dataT1 RECORD LIKE local_remember.*
    DEFINE l_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_remember_primary_key_local_remember_updateRowByKey.define">} {</POINT>}
    LET l_key.local_remember_l_r_index = p_dataT0.l_r_index
    INITIALIZE errMsg TO NULL
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_remember_primary_key_local_remember_updateRowByKey.init">} {</POINT>}
        TRY
            LET errNo = local_db_dbxdata_local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
            {<POINT Name="fct.local_remember_primary_key_local_remember_updateRowByKey.afterSelect">} {</POINT>}
            IF errNo == ERROR_SUCCESS THEN
                CALL local_db_dbxconstraints.local_db_dbxconstraints_local_remember_checkTableConstraints(TRUE, p_dataT1.*) RETURNING errNo, errMsg
                {<POINT Name="fct.local_remember_primary_key_local_remember_updateRowByKey.beforeUpdate">} {</POINT>}
                IF errNo == ERROR_SUCCESS THEN
                    UPDATE local_remember
                        SET local_remember.* = p_dataT1.*
                        WHERE local_remember.l_r_index = l_key.local_remember_l_r_index
                END IF
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_remember_primary_key_local_remember_updateRowByKey.afterUpdate">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_updateRowByKey

{<BLOCK Name="fct.local_remember_primary_key_local_remember_deleteRowByKey">}
#+ Delete a row identified by the primary key in the "local_remember" table
#+
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_remember_primary_key_local_remember_deleteRowByKey(p_key)
    DEFINE p_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKey.init">} {</POINT>}
        TRY
            DELETE FROM local_remember
                WHERE local_remember.l_r_index = p_key.local_remember_l_r_index
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKey.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_deleteRowByKey

{<BLOCK Name="fct.local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess">}
#+ Delete a row identified by the primary key in the "local_remember" table if the concurrent access is success
#+
#+ @param p_dataT0 - a row data LIKE local_remember.*
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess(p_dataT0)
    DEFINE p_dataT0 RECORD LIKE local_remember.*
    DEFINE l_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_remember_l_r_index = p_dataT0.l_r_index
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess.init">} {</POINT>}
        LET errNo = local_db_dbxdata_local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
        {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = local_db_dbxdata_local_remember_primary_key_local_remember_deleteRowByKey(l_key.*)
        END IF
        {<POINT Name="fct.local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_deleteRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess">}
#+ Check if a row identified by the primary key in the "local_remember" table has been modified or deleted
#+
#+ @param p_dataT0 - a row data LIKE local_remember.*
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE
PUBLIC FUNCTION local_db_dbxdata_local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess(p_dataT0, p_lock)
    DEFINE p_dataT0 RECORD LIKE local_remember.*
    DEFINE l_dataT2 RECORD LIKE local_remember.*
    DEFINE l_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE errNo INTEGER
    DEFINE errDiff INTEGER
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_remember_l_r_index = p_dataT0.l_r_index
    INITIALIZE l_dataT2.* TO NULL
    LET errDiff = FALSE
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess.init">} {</POINT>}
    CALL local_db_dbxdata_local_remember_primary_key_local_remember_selectRowByKey(l_key.*, p_lock) RETURNING errNo, l_dataT2.*
    CASE errNo
        WHEN ERROR_SUCCESS
            LET errDiff = (p_dataT0.* != l_dataT2.*)
            {<POINT Name="fct.local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
            IF NOT errDiff THEN
                LET errNo = ERROR_SUCCESS
            ELSE
                LET errNo = ERROR_CONCURRENT_ACCESS_FAILURE
            END IF
        WHEN ERROR_NOTFOUND
            LET errNo = ERROR_CONCURRENT_ACCESS_NOTFOUND
    END CASE
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess.afterCheck">} {</POINT>}
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_checkRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_remember_setDefaultValuesFromDBSchema">}
#+ Set data with the default values coming from the DB schema
#+
PUBLIC FUNCTION local_db_dbxdata_local_remember_setDefaultValuesFromDBSchema()
    DEFINE l_data RECORD LIKE local_remember.*
    {<POINT Name="fct.local_remember_setDefaultValuesFromDBSchema.define">} {</POINT>}

    INITIALIZE l_data.* TO NULL
    {<POINT Name="fct.local_remember_setDefaultValuesFromDBSchema.init">} {</POINT>}
    RETURN l_data.*
END FUNCTION
{</BLOCK>} --fct.local_remember_setDefaultValuesFromDBSchema

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_selectRowByKey">}
#+ Select a row identified by the primary key in the "local_accounts" table
#+
#+ @param p_key - Primary Key
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER, LIKE local_accounts.*
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_NOTFOUND, RECORD LIKE local_accounts.*
PUBLIC FUNCTION local_db_dbxdata_local_accounts_primary_key_local_accounts_selectRowByKey(p_key, p_lock)
    DEFINE p_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE l_data RECORD LIKE local_accounts.*
    DEFINE l_supportLock BOOLEAN
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_selectRowByKey.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    -- SQLite does not support the FOR UPDATE close in SELECT syntax
    LET l_supportLock = (UPSHIFT(fgl_db_driver_type()) != "SQT")
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_selectRowByKey.init">} {</POINT>}
    TRY
        IF p_lock AND l_supportLock THEN
            SELECT * INTO l_data.* FROM local_accounts
                WHERE local_accounts.l_u_index = p_key.local_accounts_l_u_index
            FOR UPDATE
        ELSE
            SELECT * INTO l_data.* FROM local_accounts
                WHERE local_accounts.l_u_index = p_key.local_accounts_l_u_index
        END IF
        IF SQLCA.SQLCODE == NOTFOUND THEN
            LET errNo = ERROR_NOTFOUND
        END IF
    CATCH
        INITIALIZE l_data.* TO NULL
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_selectRowByKey.afterSelect">} {</POINT>}
    RETURN errNo, l_data.*
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_selectRowByKey

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey">}
#+ Select a row identified by the primary key in the "local_accounts" table
#+
#+ @param p_key - Primary Key
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER, LIKE local_accounts.*
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_NOTFOUND, RECORD LIKE local_accounts.*
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey(p_key, p_lock)
    DEFINE p_key
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE l_data RECORD LIKE local_accounts.*
    DEFINE l_supportLock BOOLEAN
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    -- SQLite does not support the FOR UPDATE close in SELECT syntax
    LET l_supportLock = (UPSHIFT(fgl_db_driver_type()) != "SQT")
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey.init">} {</POINT>}
    TRY
        IF p_lock AND l_supportLock THEN
            SELECT * INTO l_data.* FROM local_accounts
                WHERE local_accounts.username = p_key.local_accounts_username
            FOR UPDATE
        ELSE
            SELECT * INTO l_data.* FROM local_accounts
                WHERE local_accounts.username = p_key.local_accounts_username
        END IF
        IF SQLCA.SQLCODE == NOTFOUND THEN
            LET errNo = ERROR_NOTFOUND
        END IF
    CATCH
        INITIALIZE l_data.* TO NULL
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey.afterSelect">} {</POINT>}
    RETURN errNo, l_data.*
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey

{<BLOCK Name="fct.local_accounts_insertRowByKey">}
#+ Insert a row in the "local_accounts" table and return the primary key created
#+
#+ @param p_data - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER, STRING, INTEGER, VARCHAR(255)
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_accounts.l_u_index, local_accounts.username
PRIVATE FUNCTION local_db_dbxdata_local_accounts_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_accounts.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_accounts_insertRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_accounts_insertRowByKey.init">} {</POINT>}
        CALL local_db_dbxconstraints.local_db_dbxconstraints_local_accounts_checkTableConstraints(FALSE, p_data.*) RETURNING errNo, errMsg
        {<POINT Name="fct.local_accounts_insertRowByKey.beforeInsert">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            TRY
                INSERT INTO local_accounts VALUES (p_data.*)
            CATCH
                LET errNo = ERROR_FAILURE
            END TRY
            {<POINT Name="fct.local_accounts_insertRowByKey.afterInsert">} {</POINT>}
        END IF
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg, p_data.l_u_index, p_data.username
END FUNCTION
{</BLOCK>} --fct.local_accounts_insertRowByKey

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_insertRowByKey">}
#+ Insert a row in the "local_accounts" table and return the table keys
#+
#+ @param p_data - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER, STRING, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_accounts.l_u_index
PUBLIC FUNCTION local_db_dbxdata_local_accounts_primary_key_local_accounts_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_accounts.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_insertRowByKey.define">} {</POINT>}
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_insertRowByKey.init">} {</POINT>}

    CALL local_db_dbxdata_local_accounts_insertRowByKey(p_data.*) RETURNING errNo, errMsg, p_data.l_u_index, p_data.username
    RETURN errNo, errMsg, p_data.l_u_index
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_insertRowByKey

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_insertRowByKey">}
#+ Insert a row in the "local_accounts" table and return the table keys
#+
#+ @param p_data - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER, STRING, VARCHAR(255)
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message, local_accounts.username
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_insertRowByKey(p_data)
    DEFINE p_data RECORD LIKE local_accounts.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_insertRowByKey.define">} {</POINT>}
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_insertRowByKey.init">} {</POINT>}

    CALL local_db_dbxdata_local_accounts_insertRowByKey(p_data.*) RETURNING errNo, errMsg, p_data.l_u_index, p_data.username
    RETURN errNo, errMsg, p_data.username
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_insertRowByKey

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_updateRowByKey">}
#+ Update a row identified by the primary key in the "local_accounts" table
#+
#+ @param p_dataT0 - a row data LIKE local_accounts.*
#+ @param p_dataT1 - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE, error message
PUBLIC FUNCTION local_db_dbxdata_local_accounts_primary_key_local_accounts_updateRowByKey(p_dataT0, p_dataT1)
    DEFINE p_dataT0 RECORD LIKE local_accounts.*
    DEFINE p_dataT1 RECORD LIKE local_accounts.*
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_updateRowByKey.define">} {</POINT>}
    LET l_key.local_accounts_l_u_index = p_dataT0.l_u_index
    INITIALIZE errMsg TO NULL
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_updateRowByKey.init">} {</POINT>}
        TRY
            LET errNo = local_db_dbxdata_local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
            {<POINT Name="fct.local_accounts_primary_key_local_accounts_updateRowByKey.afterSelect">} {</POINT>}
            IF errNo == ERROR_SUCCESS THEN
                CALL local_db_dbxconstraints.local_db_dbxconstraints_local_accounts_checkTableConstraints(TRUE, p_dataT1.*) RETURNING errNo, errMsg
                {<POINT Name="fct.local_accounts_primary_key_local_accounts_updateRowByKey.beforeUpdate">} {</POINT>}
                IF errNo == ERROR_SUCCESS THEN
                    UPDATE local_accounts
                        SET local_accounts.* = p_dataT1.*
                        WHERE local_accounts.l_u_index = l_key.local_accounts_l_u_index
                END IF
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_updateRowByKey.afterUpdate">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_updateRowByKey

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey">}
#+ Update a row identified by the primary key in the "local_accounts" table
#+
#+ @param p_dataT0 - a row data LIKE local_accounts.*
#+ @param p_dataT1 - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE, error message
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey(p_dataT0, p_dataT1)
    DEFINE p_dataT0 RECORD LIKE local_accounts.*
    DEFINE p_dataT1 RECORD LIKE local_accounts.*
    DEFINE l_key
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey.define">} {</POINT>}
    LET l_key.local_accounts_username = p_dataT0.username
    INITIALIZE errMsg TO NULL
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey.init">} {</POINT>}
        TRY
            LET errNo = local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
            {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey.afterSelect">} {</POINT>}
            IF errNo == ERROR_SUCCESS THEN
                CALL local_db_dbxconstraints.local_db_dbxconstraints_local_accounts_checkTableConstraints(TRUE, p_dataT1.*) RETURNING errNo, errMsg
                {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey.beforeUpdate">} {</POINT>}
                IF errNo == ERROR_SUCCESS THEN
                    UPDATE local_accounts
                        SET local_accounts.* = p_dataT1.*
                        WHERE local_accounts.username = l_key.local_accounts_username
                END IF
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey.afterUpdate">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_updateRowByKey

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKey">}
#+ Delete a row identified by the primary key in the "local_accounts" table
#+
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_accounts_primary_key_local_accounts_deleteRowByKey(p_key)
    DEFINE p_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKey.define">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKey.init">} {</POINT>}
        TRY
            DELETE FROM local_accounts
                WHERE local_accounts.l_u_index = p_key.local_accounts_l_u_index
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKey.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_deleteRowByKey

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKey">}
#+ Delete a row identified by the unique key in the "local_accounts" table
#+
#+ @param p_key - Secondary Key
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKey(p_key)
    DEFINE p_key
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE errNo INTEGER
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKey.define">} {</POINT>}
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKey.init">} {</POINT>}

    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        --we assume Primary Key and Secondary Key do not change
        CALL local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_getPK(p_key.*)
            RETURNING errNo, l_key.*
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = local_db_dbxdata_local_accounts_primary_key_local_accounts_deleteRowByKey(l_key.*)
        END IF
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKey

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess">}
#+ Delete a row identified by the primary key in the "local_accounts" table if the concurrent access is success
#+
#+ @param p_dataT0 - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess(p_dataT0)
    DEFINE p_dataT0 RECORD LIKE local_accounts.*
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_accounts_l_u_index = p_dataT0.l_u_index
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess.init">} {</POINT>}
        LET errNo = local_db_dbxdata_local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = local_db_dbxdata_local_accounts_primary_key_local_accounts_deleteRowByKey(l_key.*)
        END IF
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_deleteRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess">}
#+ Delete a row identified by the primary key in the "local_accounts" table if the concurrent access is success
#+
#+ @param p_dataT0 - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE|ERROR_DELETE_CASCADE_ROW_USED
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess(p_dataT0)
    DEFINE p_dataT0 RECORD LIKE local_accounts.*
    DEFINE l_key
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE errNo INTEGER
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_accounts_username = p_dataT0.username
    LET errNo = libdbapp_begin_work()
    IF errNo == ERROR_SUCCESS THEN
        {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess.init">} {</POINT>}
        LET errNo = local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess(p_dataT0.*, TRUE)
        {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKey(l_key.*)
        END IF
        {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess.afterDelete">} {</POINT>}
        IF errNo == ERROR_SUCCESS THEN
            LET errNo = libdbapp_commit_work()
        ELSE
            CALL libdbapp_rollback_work()
        END IF
    END IF
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_deleteRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess">}
#+ Check if a row identified by the primary key in the "local_accounts" table has been modified or deleted
#+
#+ @param p_dataT0 - a row data LIKE local_accounts.*
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE
PUBLIC FUNCTION local_db_dbxdata_local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess(p_dataT0, p_lock)
    DEFINE p_dataT0 RECORD LIKE local_accounts.*
    DEFINE l_dataT2 RECORD LIKE local_accounts.*
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE errNo INTEGER
    DEFINE errDiff INTEGER
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_accounts_l_u_index = p_dataT0.l_u_index
    INITIALIZE l_dataT2.* TO NULL
    LET errDiff = FALSE
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess.init">} {</POINT>}
    CALL local_db_dbxdata_local_accounts_primary_key_local_accounts_selectRowByKey(l_key.*, p_lock) RETURNING errNo, l_dataT2.*
    CASE errNo
        WHEN ERROR_SUCCESS
            LET errDiff = (p_dataT0.* != l_dataT2.*)
            {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
            IF NOT errDiff THEN
                LET errNo = ERROR_SUCCESS
            ELSE
                LET errNo = ERROR_CONCURRENT_ACCESS_FAILURE
            END IF
        WHEN ERROR_NOTFOUND
            LET errNo = ERROR_CONCURRENT_ACCESS_NOTFOUND
    END CASE
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess.afterCheck">} {</POINT>}
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_checkRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess">}
#+ Check if a row identified by the primary key in the "local_accounts" table has been modified or deleted
#+
#+ @param p_dataT0 - a row data LIKE local_accounts.*
#+ @param p_lock - Indicate if a lock is used in order to prevent several users editing the same rows at the same time
#+
#+ @returnType INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_CONCURRENT_ACCESS_NOTFOUND|ERROR_CONCURRENT_ACCESS_FAILURE
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess(p_dataT0, p_lock)
    DEFINE p_dataT0 RECORD LIKE local_accounts.*
    DEFINE l_dataT2 RECORD LIKE local_accounts.*
    DEFINE l_key
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE p_lock BOOLEAN
    DEFINE errNo INTEGER
    DEFINE errDiff INTEGER
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess.define">} {</POINT>}

    LET l_key.local_accounts_username = p_dataT0.username
    INITIALIZE l_dataT2.* TO NULL
    LET errDiff = FALSE
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess.init">} {</POINT>}
    CALL local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_selectRowByKey(l_key.*, p_lock) RETURNING errNo, l_dataT2.*
    CASE errNo
        WHEN ERROR_SUCCESS
            LET errDiff = (p_dataT0.* != l_dataT2.*)
            {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess.afterSelect">} {</POINT>}
            IF NOT errDiff THEN
                LET errNo = ERROR_SUCCESS
            ELSE
                LET errNo = ERROR_CONCURRENT_ACCESS_FAILURE
            END IF
        WHEN ERROR_NOTFOUND
            LET errNo = ERROR_CONCURRENT_ACCESS_NOTFOUND
    END CASE
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess.afterCheck">} {</POINT>}
    RETURN errNo
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_checkRowByKeyWithConcurrentAccess

{<BLOCK Name="fct.local_accounts_setDefaultValuesFromDBSchema">}
#+ Set data with the default values coming from the DB schema
#+
PUBLIC FUNCTION local_db_dbxdata_local_accounts_setDefaultValuesFromDBSchema()
    DEFINE l_data RECORD LIKE local_accounts.*
    {<POINT Name="fct.local_accounts_setDefaultValuesFromDBSchema.define">} {</POINT>}

    INITIALIZE l_data.* TO NULL
    {<POINT Name="fct.local_accounts_setDefaultValuesFromDBSchema.init">} {</POINT>}
    RETURN l_data.*
END FUNCTION
{</BLOCK>} --fct.local_accounts_setDefaultValuesFromDBSchema

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_getPK">}
#+ Get the primary key for the "local_accounts" table
#+
#+ @param p_key - Secondary Key
#+
#+ @returnType INTEGER, INTEGER
#+ @return     ERROR_SUCCESS|ERROR_FAILURE|ERROR_NOTFOUND, local_accounts.l_u_index
PUBLIC FUNCTION local_db_dbxdata_local_accounts_sqlite_autoindex_local_accounts_1_getPK(p_key)
    DEFINE p_key
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE errNo INTEGER
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_getPK.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    LET l_where = "WHERE local_accounts.username = ? "
    LET l_sqlQuery = "SELECT l_u_index FROM local_accounts ", l_where
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_getPK.init">} {</POINT>}
    TRY
        PREPARE cur_local_accounts_sqlite_autoindex_local_accounts_1_getPK FROM l_sqlQuery
        EXECUTE cur_local_accounts_sqlite_autoindex_local_accounts_1_getPK USING p_key.* INTO l_key.*
        IF SQLCA.SQLCODE == NOTFOUND THEN
            LET errNo = ERROR_NOTFOUND
        END IF
        FREE cur_local_accounts_sqlite_autoindex_local_accounts_1_getPK
    CATCH
        INITIALIZE l_key.* TO NULL
        LET errNo = ERROR_FAILURE
    END TRY
    RETURN errNo, l_key.*
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_getPK

--------------------------------------------------------------------------------
--Add user functions
{<POINT Name="user.functions">} {</POINT>}
