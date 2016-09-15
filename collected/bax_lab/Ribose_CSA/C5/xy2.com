#!/bin/csh

xyz2pipe -in ft/test%03d.ft1 -z -verb \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.93 -c 0.5 \
| nmrPipe -fn ZF -size 256 \
| nmrPipe -fn FT -neg \
| nmrPipe -fn PS -p0 -0.2 -p1 0 -di \
| nmrPipe -fn TP \
| pipe2xyz -out ft/test%03d.ft2 

