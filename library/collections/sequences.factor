! Copyright (C) 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: sequences
USING: errors generic kernel math math-internals strings vectors ;

! This file is needed very early in bootstrap.

! Sequences support the following protocol. Concrete examples
! are strings, string buffers, vectors, and arrays. Arrays are
! low level and not bounds-checked; they are in the
! kernel-internals vocabulary, so don't use them unless you have
! a good reason.

GENERIC: empty? ( sequence -- ? )
GENERIC: length ( sequence -- n )
GENERIC: set-length ( n sequence -- )
GENERIC: nth ( n sequence -- obj )
GENERIC: set-nth ( value n sequence -- obj )
GENERIC: thaw ( seq -- mutable-seq )
GENERIC: freeze ( new orig -- new )
GENERIC: reverse ( seq -- seq )
GENERIC: peek ( seq -- elt )
GENERIC: contains? ( elt seq -- ? )

DEFER: append ! remove this when sort is moved from lists to sequences

! Some low-level code used by vectors and string buffers.
IN: kernel-internals

: assert-positive ( fx -- )
    0 fixnum<
    [ "Sequence index must be positive" throw ] when ; inline

: assert-bounds ( fx seq -- )
    over assert-positive
    length fixnum>=
    [ "Sequence index out of bounds" throw ] when ; inline

: bounds-check ( n seq -- fixnum seq )
    >r >fixnum r> 2dup assert-bounds ; inline

: growable-check ( n seq -- fixnum seq )
    >r >fixnum dup assert-positive r> ; inline

GENERIC: underlying
GENERIC: set-underlying
GENERIC: set-capacity
GENERIC: (grow)

: grow ( len seq -- )
    #! If the sequence cannot accomodate len elements, resize it
    #! to exactly len.
    [ underlying (grow) ] keep set-underlying ;

: ensure ( n seq -- )
    #! If n is beyond the sequence's length, increase the length,
    #! growing the underlying storage if necessary, with an
    #! optimistic doubling of its size.
    2dup length fixnum>= [
        >r 1 fixnum+ r>
        2dup underlying length fixnum> [
            over 2 fixnum* over grow
        ] when
        set-capacity
    ] [
        2drop
    ] ifte ;
