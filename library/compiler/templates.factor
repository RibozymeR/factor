! Copyright (C) 2006 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
IN: compiler
USING: arrays generic hashtables inference io kernel math
namespaces prettyprint sequences vectors words ;

SYMBOL: free-vregs

! A data stack location.
TUPLE: ds-loc n ;

! A call stack location.
TUPLE: cs-loc n ;

UNION: loc ds-loc cs-loc ;

TUPLE: phantom-stack height ;

C: phantom-stack ( -- stack )
    0 over set-phantom-stack-height
    V{ } clone over set-delegate ;

GENERIC: finalize-height ( n stack -- )

GENERIC: <loc> ( n stack -- loc )

: (loc)
    #! Utility for methods on <loc>
    phantom-stack-height - ;

: (finalize-height) ( stack word -- )
    #! We consolidate multiple stack height changes until the
    #! last moment, and we emit the final height changing
    #! instruction here.
    swap [
        phantom-stack-height
        dup zero? [ 2drop ] [ swap execute ] if
        0
    ] keep set-phantom-stack-height ; inline

TUPLE: phantom-datastack ;

C: phantom-datastack
    [ >r <phantom-stack> r> set-delegate ] keep ;

M: phantom-datastack <loc> (loc) <ds-loc> ;

M: phantom-datastack finalize-height
    \ %inc-d (finalize-height) ;

TUPLE: phantom-callstack ;

C: phantom-callstack
    [ >r <phantom-stack> r> set-delegate ] keep ;

M: phantom-callstack <loc> (loc) <cs-loc> ;

M: phantom-callstack finalize-height
    \ %inc-r (finalize-height) ;

: phantom-locs ( n phantom -- locs )
    #! A sequence of n ds-locs or cs-locs indexing the stack.
    swap reverse-slice [ swap <loc> ] map-with ;

: phantom-locs* ( phantom -- locs )
    dup length swap phantom-locs ;

: adjust-phantom ( n phantom -- )
    #! Change stack heiht.
    [ phantom-stack-height + ] keep set-phantom-stack-height ;

GENERIC: cut-phantom ( n phantom -- seq )

M: phantom-stack cut-phantom ( n phantom -- seq )
    [ delegate cut* swap ] keep set-delegate ;

SYMBOL: phantom-d
SYMBOL: phantom-r

: phantoms ( -- phantom phantom ) phantom-d get phantom-r get ;

: init-templates ( -- )
    <phantom-datastack> phantom-d set
    <phantom-callstack> phantom-r set ;

: finalize-heights ( -- )
    phantoms [ finalize-height ] 2apply ;

: alloc-reg ( -- n ) free-vregs get pop ;

: stack>vreg ( vreg# loc -- operand )
    >r <vreg> dup r> %peek ;

: stack>new-vreg ( loc -- vreg )
    alloc-reg swap stack>vreg ;

: vreg>stack ( value loc -- )
    over loc? [
        2drop
    ] [
        over [ %replace ] [ 2drop ] if
    ] if ;

: vregs>stack ( phantom -- )
    [
        dup phantom-locs* [ vreg>stack ] 2each 0
    ] keep set-length ;

: (live-locs) ( seq -- seq )
    dup phantom-locs* [ 2array ] 2map
    [ first2 over loc? >r = not r> and ] subset
    [ first ] map ;

: live-locs ( phantom phantom -- hash )
    [ (live-locs) ] 2apply append prune
    [ dup stack>new-vreg ] map>hash ;

: lazy-store ( value loc -- )
    over loc? [
        2dup = [
            2drop
        ] [
            >r \ live-locs get hash r> vreg>stack 
        ] if
    ] [
        2drop
    ] if ;

: flush-locs ( phantom phantom -- )
    2dup live-locs \ live-locs set
    [ dup phantom-locs* [ lazy-store ] 2each ] 2apply ;

: finalize-contents ( -- )
    phantoms 2dup flush-locs [ vregs>stack ] 2apply ;

: end-basic-block ( -- )
    finalize-contents finalize-heights ;

: used-vregs ( -- seq )
    phantoms append [ vreg? ] subset [ vreg-n ] map ;

: compute-free-vregs ( -- )
    used-vregs vregs length reverse diff
    >vector free-vregs set ;

: requested-vregs ( template -- n )
    0 [ [ 1+ ] unless ] reduce ;

: template-vreg# ( template template -- n )
    [ requested-vregs ] 2apply + ;

: alloc-regs ( template -- template )
    [ [ alloc-reg ] unless* ] map ;

: alloc-reg# ( n -- regs )
    free-vregs [ cut ] change ;

: additional-vregs# ( seq seq -- n )
    2array phantoms 2array [ [ length ] map ] 2apply v-
    0 [ 0 max + ] reduce ;

: free-vregs* ( -- n )
    free-vregs get length
    phantoms [ [ loc? ] subset length ] 2apply + - ;

: ensure-vregs ( n -- )
    compute-free-vregs free-vregs* <=
    [ finalize-contents compute-free-vregs ] unless ;

: lazy-load ( value loc -- value )
    over loc?
    [ dupd = [ drop f ] [ stack>new-vreg ] if ] [ drop ] if ;

: phantom-vregs ( values template -- )
    [ >r f lazy-load r> second set ] 2each ;

: stack>vregs ( phantom template -- values )
    [
        [ first ] map alloc-regs
        dup length rot phantom-locs
        [ stack>vreg ] 2map
    ] 2keep length neg swap adjust-phantom ;

: compatible-values? ( value template -- ? )
    {
        { [ over loc? ] [ 2drop t ] }
        { [ dup not ] [ 2drop t ] }
        { [ over not ] [ 2drop f ] }
        { [ dup integer? ] [ swap vreg-n = ] }
    } cond ;

: template-match? ( template phantom -- ? )
    [ reverse-slice ] 2apply
    t [ swap first compatible-values? and ] 2reduce ;

: split-template ( template phantom -- slow fast )
    over length over length <=
    [ drop { } swap ] [ length swap cut* ] if ;

: match-template ( template -- slow fast )
    phantom-d get 2dup template-match?
    [ split-template ] [ drop { } ] if ;

: fast-input ( template -- )
    phantom-d get
    over length neg over adjust-phantom
    over length swap cut-phantom
    swap phantom-vregs ;

: phantom-append ( seq stack -- )
    over length over adjust-phantom swap nappend ;

: (template-outputs) ( seq stack -- )
    phantoms swapd phantom-append phantom-append ;

SYMBOL: +input
SYMBOL: +output
SYMBOL: +scratch
SYMBOL: +clobber

: fix-spec ( spec -- spec )
    H{
        { +input { } }
        { +output { } }
        { +scratch { } }
        { +clobber { } }
    } swap hash-union ;

: adjust-free-vregs ( seq -- ) free-vregs [ diff ] change ;

: output-vregs ( -- seq seq )
    +output +clobber [ get [ get ] map ] 2apply ;

: outputs-clash? ( -- ? )
    output-vregs append phantoms append
    [ swap member? ] contains-with? ;

: slow-input ( template -- )
    dup empty? [ finalize-contents ] unless
    outputs-clash? [ finalize-contents ] when
    phantom-d get swap [ stack>vregs ] keep phantom-vregs ;

: input-vregs ( -- seq )
    +input +scratch [ get [ second get vreg-n ] map ] 2apply
    append ;

: template-inputs ( -- )
    +input get dup { } additional-vregs# ensure-vregs
    match-template fast-input
    used-vregs adjust-free-vregs
    slow-input
    input-vregs adjust-free-vregs ;

: template-outputs ( -- )
    +output get [ get ] map { } (template-outputs) ;

: with-template ( quot spec -- )
    fix-spec [ template-inputs call template-outputs ] bind
    compute-free-vregs ; inline

: operand ( var -- op ) get v>operand ; inline
