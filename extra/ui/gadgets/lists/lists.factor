! Copyright (C) 2006, 2009 Slava Pestov.
! See https://factorcode.org/license.txt for BSD license.
USING: accessors fonts kernel locals math math.order
math.rectangles math.vectors models namespaces opengl sequences
ui.commands ui.gadgets ui.gadgets.labels ui.gadgets.packs
ui.gadgets.presentations ui.gadgets.scrollers
ui.gadgets.viewports ui.gestures ui.render ui.theme ;
IN: ui.gadgets.lists

TUPLE: list < pack index presenter color hook ;

: list-theme ( list -- list )
    selection-color >>color ; inline

: <list> ( hook presenter model -- gadget )
    list new
        { 0 1 } >>orientation
        1 >>fill
        0 >>index
        swap >>model
        swap >>presenter
        swap >>hook
        list-theme ;

: calc-bounded-index ( n list -- m )
    control-value length 1 - min 0 max ;

: bound-index ( list -- )
    dup index>> over calc-bounded-index >>index drop ;

: list-presentation-hook ( list -- quot )
    hook>> [ [ list? ] find-parent ] prepend ;

: <list-presentation> ( hook elt presenter -- gadget )
    [ call( elt -- obj ) ] [ drop ] 2bi
    [ >label monospace-font >>font ] dip
    <presentation>
    swap >>hook ; inline

: <list-items> ( list -- seq )
    [ list-presentation-hook ]
    [ presenter>> ]
    [ control-value ]
    tri [
        [ 2dup ] dip swap <list-presentation>
    ] map 2nip ;

M: list model-changed
    nip
    dup clear-gadget
    dup <list-items> add-gadgets
    bound-index ;

: selected-rect ( list -- rect )
    dup index>> swap children>> ?nth ;

M: list draw-gadget*
    origin get [
        dup color>> gl-color
        selected-rect [
            rect-bounds gl-fill-rect
        ] when*
    ] with-translation ;

M: list focusable-child* drop t ;

: list-value ( list -- object )
    dup index>> swap control-value ?nth ;

: scroll>selected ( list -- )
    ! We change the rectangle's width to zero to avoid
    ! scrolling right.
    [ selected-rect rect-bounds { 0 1 } v* <rect> ] keep
    scroll>rect ;

: list-empty? ( list -- ? ) control-value empty? ;

: select-index ( n list -- )
    dup list-empty? [
        2drop
    ] [
        [ control-value length rem ] [ index<< ] [ ] tri
        [ relayout-1 ] [ scroll>selected ] bi
    ] if ;

: select-previous ( list -- )
    [ index>> 1 - ] keep select-index ;

: select-next ( list -- )
    [ index>> 1 + ] keep select-index ;

: invoke-value-action ( list -- )
    dup list-empty? [
        dup hook>> call( list -- )
    ] [
        [ index>> ] keep nth-gadget invoke-secondary
    ] if ;

:: select-gadget ( gadget list -- )
    gadget list children>> index
    [ list select-index ] when* ;

: clamp-loc ( point max -- point )
    { 0 0 } swap vclamp ;

: select-at ( point list -- )
    [ dim>> clamp-loc ] keep
    [ pick-up ] keep
    select-gadget ;

: list-page ( list vec -- )
    [ dup selected-rect rect-bounds 2 v/n v+ over visible-dim ] dip
    v* v+ swap select-at ;

: list-page-up ( list -- ) { 0 -1 } list-page ;

: list-page-down ( list -- ) { 0 1 } list-page ;

list "keyboard-navigation" "Lists can be navigated from the keyboard." {
    { T{ button-down } request-focus }
    { T{ key-down f f "UP" } select-previous }
    { T{ key-down f f "DOWN" } select-next }
    { T{ key-down f f "PAGE_UP" } list-page-up }
    { T{ key-down f f "PAGE_DOWN" } list-page-down }
    { T{ key-down f f "RET" } invoke-value-action }
} define-command-map
