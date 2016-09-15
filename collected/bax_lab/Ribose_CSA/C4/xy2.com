#!/bin/csh

xyz2pipe -in ft/test%03d.ft1 -z -verb \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.93 -c 0.5 \
| nmrPipe -fn ZF -zf 4 \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 5.8 -p1 -11.6 -di \
| nmrPipe -fn TP \
| pipe2xyz -out ft/test%03d_noLP.ft2 

