! :folding=none:collapseFolds=1:

! $Id$
!
! Copyright (C) 2004, 2005 Slava Pestov.
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

IN: alien
DEFER: alien
DEFER: dll

USE: alien
USE: assembler
USE: compiler
USE: errors
USE: files
USE: generic
USE: io-internals
USE: kernel
USE: kernel-internals
USE: lists
USE: math
USE: math-internals
USE: parser
USE: profiler
USE: random
USE: strings
USE: unparser
USE: vectors
USE: words

[
    [ execute                " word -- "                          f ]
    [ call                   [ [ general-list ] [ ] ] ]
    [ ifte                   [ [ object general-list general-list ] [ ] ] ]
    [ cons                   [ [ object object ] [ cons ] ] ]
    [ <vector>               [ [ integer ] [ vector ] ] ]
    [ vector-nth             [ [ integer vector ] [ object ] ] ]
    [ set-vector-nth         [ [ object integer vector ] [ ] ] ]
    [ str-nth                [ [ integer string ] [ integer ] ] ]
    [ str-compare            [ [ string string ] [ integer ] ] ]
    [ str=                   [ [ string string ] [ boolean ] ] ]
    [ index-of*              [ [ integer string text ] [ integer ] ] ]
    [ substring              [ [ integer integer string ] [ string ] ] ]
    [ str-reverse            [ [ string ] [ string ] ] ]
    [ <sbuf>                 [ [ integer ] [ sbuf ] ] ]
    [ sbuf-length            [ [ sbuf ] [ integer ] ] ]
    [ set-sbuf-length        [ [ integer sbuf ] [ ] ] ]
    [ sbuf-nth               [ [ integer sbuf ] [ integer ] ] ]
    [ set-sbuf-nth           [ [ integer integer sbuf ] [ ] ] ]
    [ sbuf-append            [ [ text sbuf ] [ ] ] ]
    [ sbuf>str               [ [ sbuf ] [ string ] ] ]
    [ sbuf-reverse           [ [ sbuf ] [ ] ] ]
    [ sbuf-clone             [ [ sbuf ] [ sbuf ] ] ]
    [ sbuf=                  [ [ sbuf sbuf ] [ boolean ] ] ]
    [ sbuf-hashcode          [ [ sbuf ] [ fixnum ] ] ]
    [ arithmetic-type        [ [ object object ] [ object object fixnum ] ] ]
    [ >fixnum                [ [ number ] [ fixnum ] ] ]
    [ >bignum                [ [ number ] [ bignum ] ] ]
    [ >float                 [ [ number ] [ float ] ] ]
    [ (fraction>)            [ [ integer integer ] [ rational ] ] ]
    [ str>float              [ [ string ] [ float ] ] ]
    [ (unparse-float)        [ [ float ] [ string ] ] ]
    [ (rect>)                [ [ real real ] [ number ] ] ]
    [ fixnum=                [ [ fixnum fixnum ] [ boolean ] ] ]
    [ fixnum+                [ [ fixnum fixnum ] [ integer ] ] ]
    [ fixnum-                [ [ fixnum fixnum ] [ integer ] ] ]
    [ fixnum*                [ [ fixnum fixnum ] [ integer ] ] ]
    [ fixnum/i               [ [ fixnum fixnum ] [ integer ] ] ]
    [ fixnum/f               [ [ fixnum fixnum ] [ integer ] ] ]
    [ fixnum-mod             [ [ fixnum fixnum ] [ fixnum ] ] ]
    [ fixnum/mod             [ [ fixnum fixnum ] [ integer fixnum ] ] ]
    [ fixnum-bitand          [ [ fixnum fixnum ] [ fixnum ] ] ]
    [ fixnum-bitor           [ [ fixnum fixnum ] [ fixnum ] ] ]
    [ fixnum-bitxor          [ [ fixnum fixnum ] [ fixnum ] ] ]
    [ fixnum-bitnot          [ [ fixnum ] [ fixnum ] ] ]
    [ fixnum-shift           [ [ fixnum fixnum ] [ fixnum ] ] ]
    [ fixnum<                [ [ fixnum fixnum ] [ boolean ] ] ]
    [ fixnum<=               [ [ fixnum fixnum ] [ boolean ] ] ]
    [ fixnum>                [ [ fixnum fixnum ] [ boolean ] ] ]
    [ fixnum>=               [ [ fixnum fixnum ] [ boolean ] ] ]
    [ bignum=                [ [ bignum bignum ] [ boolean ] ] ]
    [ bignum+                [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum-                [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum*                [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum/i               [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum/f               [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum-mod             [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum/mod             [ [ bignum bignum ] [ bignum bignum ] ] ]
    [ bignum-bitand          [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum-bitor           [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum-bitxor          [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum-bitnot          [ [ bignum ] [ bignum ] ] ]
    [ bignum-shift           [ [ bignum bignum ] [ bignum ] ] ]
    [ bignum<                [ [ bignum bignum ] [ boolean ] ] ]
    [ bignum<=               [ [ bignum bignum ] [ boolean ] ] ]
    [ bignum>                [ [ bignum bignum ] [ boolean ] ] ]
    [ bignum>=               [ [ bignum bignum ] [ boolean ] ] ]
    [ float=                 [ [ bignum bignum ] [ boolean ] ] ]
    [ float+                 [ [ float float ] [ float ] ] ]
    [ float-                 [ [ float float ] [ float ] ] ]
    [ float*                 [ [ float float ] [ float ] ] ]
    [ float/f                [ [ float float ] [ float ] ] ]
    [ float<                 [ [ float float ] [ boolean ] ] ]
    [ float<=                [ [ float float ] [ boolean ] ] ]
    [ float>                 [ [ float float ] [ boolean ] ] ]
    [ float>=                [ [ float float ] [ boolean ] ] ]
    [ facos                  [ [ real ] [ float ] ] ]
    [ fasin                  [ [ real ] [ float ] ] ]
    [ fatan                  [ [ real ] [ float ] ] ]
    [ fatan2                 [ [ real real ] [ float ] ] ]
    [ fcos                   [ [ real ] [ float ] ] ]
    [ fexp                   [ [ real ] [ float ] ] ]
    [ fcosh                  [ [ real ] [ float ] ] ]
    [ flog                   [ [ real ] [ float ] ] ]
    [ fpow                   [ [ real real ] [ float ] ] ]
    [ fsin                   [ [ real ] [ float ] ] ]
    [ fsinh                  [ [ real ] [ float ] ] ]
    [ fsqrt                  [ [ real ] [ float ] ] ]
    [ <word>                 [ [ ] [ word ] ] ]
    [ update-xt              [ [ word ] [ ] ] ]
    [ drop                   [ [ object ] [ ] ] ]
    [ dup                    [ [ object ] [ object object ] ] ]
    [ swap                   [ [ object object ] [ object object ] ] ]
    [ over                   [ [ object object ] [ object object object ] ] ]
    [ pick                   [ [ object object object ] [ object object object object ] ] ]
    [ >r                     [ [ object ] [ ] ] ]
    [ r>                     [ [ ] [ object ] ] ]
    [ eq?                    [ [ object object ] [ boolean ] ] ]
    [ getenv                 [ [ fixnum ] [ object ] ] ]
    [ setenv                 [ [ object fixnum ] [ ] ] ]
    [ open-file              [ [ string object object ] [ port ] ] ]
    [ stat                   [ [ string ] [ cons ] ] ]
    [ (directory)            [ [ string ] [ general-list ] ] ]
    [ garbage-collection     [ [ ] [ ] ] ]
    [ save-image             [ [ string ] [ ] ] ]
    [ datastack              " -- ds "          ]
    [ callstack              " -- cs "          ]
    [ set-datastack          " ds -- "          ]
    [ set-callstack          " cs -- "          ]
    [ exit*                  [ [ integer ] [ ] ] ]
    [ client-socket          [ [ string integer ] [ port port ] ] ]
    [ server-socket          [ [ integer ] [ port ] ] ]
    [ close-port             [ [ port ] ] ]
    [ add-accept-io-task     [ [ port general-list ] [ ] ] ]
    [ accept-fd              [ [ port ] [ string integer port port ] ] ]
    [ can-read-line?         [ [ port ] [ boolean ] ] ]
    [ add-read-line-io-task  [ [ port general-list ] [ ] ] ]
    [ read-line-fd-8         [ [ port ] [ sbuf ] ] ]
    [ can-read-count?        [ [ integer port ] [ boolean ] ] ]
    [ add-read-count-io-task [ [ integer port general-list ] [ ] ] ]
    [ read-count-fd-8        [ [ integer port ] [ sbuf ] ] ]
    [ can-write?             [ [ integer port ] [ boolean ] ] ]
    [ add-write-io-task      [ [ port general-list ] [ ] ] ]
    [ write-fd-8             [ [ text port ] [ ] ] ]
    [ add-copy-io-task       [ [ port port general-list ] [ ] ] ]
    [ pending-io-error       [ [ ] [ ] ] ]
    [ next-io-task           [ [ ] [ general-list ] ] ]
    [ room                   [ [ ] [ integer integer integer integer ] ] ]
    [ os-env                 [ [ string ] [ object ] ] ]
    [ millis                 [ [ ] [ integer ] ] ]
    [ init-random            [ [ ] [ ] ] ]
    [ (random-int)           [ [ ] [ integer ] ] ]
    [ type                   [ [ object ] [ fixnum ] ] ]
    [ call-profiling         [ [ integer ] [ ] ] ]
    [ allot-profiling        [ [ integer ] [ ] ] ]
    [ cwd                    [ [ ] [ string ] ] ]
    [ cd                     [ [ string ] [ ] ] ]
    [ compiled-offset        [ [ ] [ integer ] ] ]
    [ set-compiled-offset    [ [ integer ] [ ] ] ]
    [ literal-top            [ [ ] [ integer ] ] ]
    [ set-literal-top        [ [ integer ] [ ] ] ]
    [ address                [ [ object ] [ integer ] ] ]
    [ dlopen                 [ [ string ] [ dll ] ] ]
    [ dlsym                  [ [ string object ] [ integer ] ] ]
    [ dlclose                [ [ dll ] [ ] ] ]
    [ <alien>                [ [ integer ] [ alien ] ] ]
    [ <local-alien>          [ [ integer ] [ alien ] ] ]
    [ alien-cell             [ [ alien integer ] [ integer ] ] ]
    [ set-alien-cell         [ [ integer alien integer ] [ ] ] ]
    [ alien-4                [ [ alien integer ] [ integer ] ] ]
    [ set-alien-4            [ [ integer alien integer ] [ ] ] ]
    [ alien-2                [ [ alien integer ] [ fixnum ] ] ]
    [ set-alien-2            [ [ integer alien integer ] [ ] ] ]
    [ alien-1                [ [ alien integer ] [ fixnum ] ] ]
    [ set-alien-1            [ [ integer alien integer ] [ ] ] ]
    [ heap-stats             [ [ ] [ general-list ] ] ]
    [ throw                  [ [ object ] [ ] ] ]
    [ string>memory          [ [ string integer ] [ ] ] ]
    [ memory>string          [ [ integer integer ] [ string ] ] ]
    [ local-alien?           [ [ alien ] [ object ] ] ]
    [ alien-address          [ [ alien ] [ integer ] ] ]
    ! Note: a correct type spec for these would have [ X ] as
    ! input, not [ object ]. However, we rely on the inferencer
    ! to handle these specially, since they are also optimized
    ! out in some cases, etc.
    [ >cons                  [ [ object ] [ cons ] ] ]
    [ >vector                [ [ object ] [ vector ] ] ]
    [ >string                [ [ object ] [ string ] ] ]
    [ >word                  [ [ word ] [ word ] ] ]
    [ slot                   [ [ object fixnum ] [ object ] ] ]
    [ set-slot               [ [ object object fixnum ] [ ] ] ]
    [ integer-slot           [ [ object fixnum ] [ integer ] ] ]
    [ set-integer-slot       [ [ integer object fixnum ] [ ] ] ]
    [ grow-array             [ [ integer array ] [ integer ] ] ]
] [
    2unlist dup string? [
        "stack-effect" set-word-property
    ] [
        "infer-effect" set-word-property
    ] ifte
] each
