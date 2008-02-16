! Copyright (C) 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: arrays continuations db io kernel math namespaces
quotations sequences db.postgresql.ffi alien alien.c-types
db.types ;
IN: db.postgresql.lib

: postgresql-result-error-message ( res -- str/f )
    dup zero? [
        drop f
    ] [
        PQresultErrorMessage [ CHAR: \n = ] right-trim
    ] if ;

: postgres-result-error ( res -- )
    postgresql-result-error-message [ throw ] when* ;

: postgresql-error-message ( -- str )
    db get db-handle PQerrorMessage [ CHAR: \n = ] right-trim ;

: postgresql-error ( res -- res )
    dup [ postgresql-error-message throw ] unless ;

: postgresql-result-ok? ( n -- ? )
    PQresultStatus
    PGRES_COMMAND_OK PGRES_TUPLES_OK 2array member? ;

: connect-postgres ( host port pgopts pgtty db user pass -- conn )
    PQsetdbLogin
    dup PQstatus zero? [ postgresql-error-message throw ] unless ;

: do-postgresql-statement ( statement -- res )
    db get db-handle swap statement-sql PQexec dup postgresql-result-ok? [
        dup postgresql-result-error-message swap PQclear throw
    ] unless ;

: do-postgresql-bound-statement ( statement -- res )
    >r db get db-handle r>
    [ statement-sql ] keep
    [ statement-params length f ] keep
    statement-params
    [ first number>string* malloc-char-string ] map >c-void*-array
    f f 0 PQexecParams
    dup postgresql-result-ok? [
        dup postgresql-result-error-message swap PQclear throw
    ] unless ;
