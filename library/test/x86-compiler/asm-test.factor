IN: scratchpad
USE: compiler

0 EAX I>R
0 ECX I>R

0 EAX [I]>R
0 ECX [I]>R

0 EAX I>[R]
0 ECX I>[R]

EAX 0 R>[I]
ECX 0 R>[I]

EAX EAX [R]>R
EAX ECX [R]>R
ECX EAX [R]>R
ECX ECX [R]>R

EAX EAX R>[R]
EAX ECX R>[R]
ECX EAX R>[R]
ECX ECX R>[R]

4 0 I+[I]
0 4 I+[I]

4 EAX R+I
4 ECX R+I
65535 EAX R+I
65535 ECX R+I

4 EAX R-I
4 ECX R-I
65535 EAX R-I
65535 ECX R-I
