! :folding=indent:collapseFolds=1:

! $Id$
!
! Copyright (C) 2004 Slava Pestov.
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 
! 1. Redistributions of source code must retain the above copyright notice,
!    this list of conditions and the following disclaimer.
! 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
! 
! THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
! INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
! FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
! DEVELOPERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
! SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
! PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
! OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
! WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
! OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
! ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

! Bootstrapping trick; see doc/bootstrap.txt.
IN: !syntax
USE: syntax

USE: errors
USE: hashtables
USE: kernel
USE: lists
USE: math
USE: namespaces
USE: parser
USE: strings
USE: words
USE: vectors
USE: unparser

: parsing ( -- )
    #! Mark the most recently defined word to execute at parse
    #! time, rather than run time. The word can use 'scan' to
    #! read ahead in the input stream.
    word t "parsing" set-word-property ; parsing

: inline ( -- )
    #! Mark the last word to be inlined.
    word  t "inline" set-word-property ; parsing

! The variable "in-definition" is set inside a : ... ;.
! ( and #! then add "stack-effect" and "documentation"
! properties to the current word if it is set.

! Constants
: t t parsed ; parsing
: f f parsed ; parsing

! Lists
: [ f ; parsing
: ] reverse parsed ; parsing

: | ( syntax: | cdr ] )
    #! See the word 'parsed'. We push a special sentinel, and
    #! 'parsed' acts accordingly.
    "|" ; parsing

! Vectors
: { f ; parsing
: } reverse list>vector parsed ; parsing

! Hashtables
: {{ f ; parsing
: }} alist>hash parsed ; parsing

! Do not execute parsing word
: POSTPONE: ( -- ) scan-word parsed ; parsing

: :
    #! Begin a word definition. Word name follows.
    CREATE [ define-compound ] [ ] "in-definition" on ; parsing

: ;
    #! End a word definition.
    "in-definition" off reverse swap call ; parsing

! Symbols
: SYMBOL:
    #! A symbol is a word that pushes itself when executed.
    CREATE define-symbol ; parsing

: \
    #! Parsed as a piece of code that pushes a word on the stack
    #! \ foo ==> [ foo ] car
    scan-word unit parsed  \ car parsed ; parsing

! Vocabularies
: DEFER:
    #! Create a word with no definition. Used for mutually
    #! recursive words.
    CREATE drop ; parsing
: FORGET: scan-word forget ; parsing

: USE:
    #! Add vocabulary to search path.
    scan "use" cons@ ; parsing
: IN:
    #! Set vocabulary for new definitions.
    scan dup "use" cons@ "in" set ; parsing

! Char literal
: CHAR: ( -- ) next-word-ch parse-ch parsed ; parsing

! String literal
: parse-string ( -- )
    next-ch dup CHAR: " = [
        drop
    ] [
        parse-ch , parse-string
    ] ifte ;

: "
    #! Note the ugly hack to carry the new value of 'pos' from
    #! the make-string scope up to the original scope.
    [ parse-string "col" get ] make-string
    swap "col" set parsed ; parsing

: #{
    #! Complex literal - #{ real imaginary #}
    scan str>number scan str>number rect> "}" expect parsed ;
    parsing

! Comments
: (
    #! Stack comment.
    ")" until parsed-stack-effect ; parsing

: !
    #! EOL comment.
    until-eol drop ; parsing

: #!
    #! Documentation comment.
    until-eol parsed-documentation ; parsing

! Reading numbers in other bases

: BASE: ( base -- )
    #! Read a number in a specific base.
    scan swap base> parsed ;

: HEX: 16 BASE: ; parsing
: DEC: 10 BASE: ; parsing
: OCT: 8 BASE: ; parsing
: BIN: 2 BASE: ; parsing
