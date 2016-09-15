#!/bin/csh

xyz2pipe -in ft/test%03d.ft1 -z -verb \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.93 -c 0.5 \
| nmrPipe -fn ZF -zf 4 \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 2.8 -p1 0 -di \
| nmrPipe -fn CS -ls 2.7615ppm -sw \
| nmrPipe -fn TP \
| pipe2xyz -out ft/test%03d_noLP.ft2 



