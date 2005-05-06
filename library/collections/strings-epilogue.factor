! Copyright (C) 2004, 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: strings
USING: generic kernel lists math namespaces sequences strings ;

: sbuf-append ( ch/str sbuf -- )
    over string? [ swap nappend ] [ push ] ifte ;

: cat2 ( "a" "b" -- "ab" )
    swap
    80 <sbuf>
    [ sbuf-append ] keep
    [ sbuf-append ] keep
    >string ;

: cat3 ( "a" "b" "c" -- "abc" )
    >r >r >r 80 <sbuf>
    r> over sbuf-append
    r> over sbuf-append
    r> over sbuf-append >string ;

: fill ( count char -- string ) <repeated> >string ;

: pad ( string count char -- string )
    >r over length - dup 0 <= [
        r> 2drop
    ] [
        r> fill swap append
    ] ifte ;

: split-next ( index string split -- next )
    3dup index-of* dup -1 = [
        >r drop string-tail , r> ( end of string )
    ] [
        swap length dupd + >r swap substring , r>
    ] ifte ;

: (split) ( index string split -- )
    2dup >r >r split-next dup -1 = [
        drop r> drop r> drop
    ] [
        r> r> (split)
    ] ifte ;

: split ( string split -- list )
    #! Split the string at each occurrence of split, and push a
    #! list of the pieces.
    [ 0 -rot (split) ] make-list ;

: split-n-advance substring , >r tuck + swap r> ;
: split-n-finish nip dup length swap substring , ;

: (split-n) ( start n str -- )
    3dup >r dupd + r> 2dup length < [
        split-n-advance (split-n)
    ] [
        split-n-finish 3drop
    ] ifte ;

: split-n ( n str -- list )
    #! Split a string into n-character chunks.
    [ 0 -rot (split-n) ] make-list ;

: ch>string ( ch -- str ) 1 <sbuf> [ push ] keep >string ;

: >sbuf ( seq -- sbuf ) 0 <sbuf> [ swap nappend ] keep ;

M: object >string >sbuf >string ;

M: string thaw >sbuf ;
M: string freeze drop >string ;

M: sbuf clone ( sbuf -- sbuf )
    [ length <sbuf> dup ] keep nappend ;
