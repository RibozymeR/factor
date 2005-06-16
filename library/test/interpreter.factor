IN: temporary
USING: unparser ;
USE: vectors
USE: interpreter
USE: test
USE: namespaces
USE: stdio
USE: prettyprint
USE: math
USE: math-internals
USE: lists
USE: kernel
USE: sequences

: done-cf? ( -- ? ) meta-cf get not ;
: done? ( -- ? ) done-cf? meta-r get length 0 = and ;

: interpret ( quot -- )
    #! The quotation is called with each word as its executed.
    done? [ drop ] [ [ next swap call ] keep interpret ] ifte ;

: run ( -- ) [ do ] interpret ;

: test-interpreter
    init-interpreter meta-cf set run meta-d get ;

[ { 1 2 3 } ] [
    [ 1 2 3 ] test-interpreter
] unit-test

[ { "Yo" 2 } ] [
    [ 2 >r "Yo" r> ] test-interpreter
] unit-test

[ { 2 } ] [
    [ t [ 2 ] [ "hi" ] ifte ] test-interpreter
] unit-test

[ { "hi" } ] [
    [ f [ 2 ] [ "hi" ] ifte ] test-interpreter
] unit-test

[ { 4 } ] [
    [ 2 2 fixnum+ ] test-interpreter
] unit-test

[ { "Hey" "there" } ] [
    [ [[ "Hey" "there" ]] uncons ] test-interpreter
] unit-test

[ { t } ] [
    [ "XYZ" "XYZ" = ] test-interpreter
] unit-test

[ { f } ] [
    [ "XYZ" "XuZ" = ] test-interpreter
] unit-test

[ { #{ 1 1.5 }# { } #{ 1 1.5 }# { } } ] [
    [ #{ 1 1.5 }# { } 2dup ] test-interpreter
] unit-test

[ { 4 } ] [
    [ 2 2 + ] test-interpreter
] unit-test

[ { } ] [
    [ 3 "x" set ] test-interpreter
] unit-test

[ { 3 } ] [
    [ 3 "x" set "x" get ] test-interpreter
] unit-test

[ { } ] [
    [ 2 2 + . ] test-interpreter
] unit-test

[ { "hi\n" } ] [
    [ [ "hi" print ] with-string ] test-interpreter
] unit-test

[ { "4\n" } ] [
    [ [ 2 2 + unparse print ] with-string ] test-interpreter
] unit-test

[ { "4" } ] [
    [ [ 0 2 2 + prettyprint* drop ] with-string ] test-interpreter
] unit-test

[ { "4\n" } ] [
    [ [ 2 2 + . ] with-string ] test-interpreter
] unit-test
