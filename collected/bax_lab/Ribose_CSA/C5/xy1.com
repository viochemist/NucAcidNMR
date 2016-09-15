#!/bin/csh

xyz2pipe -in fid/test%03d.fid -x -verb \
| nmrPipe -fn SP -off 0.37 -pow 2 -end 1.0 -c 1.0  \
| nmrPipe -fn ZF -size 2048 \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 -104.4 -p1 -59.6  -di \
| nmrPipe -fn EXT -x1 6.1ppm -xn 5.2ppm -sw \
| nmrPipe -fn TP \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.93 -c 0.5 \
| nmrPipe -fn ZF -size 256 \
| nmrPipe -fn FT -neg \
| nmrPipe -fn PS -p0 0 -p1 0 -di \
| pipe2xyz -out ft/test%03d.ft1  

