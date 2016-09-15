#!/bin/csh

xyz2pipe -in fid/test%03d.fid -x -verb \
| nmrPipe -fn SOL \
| nmrPipe -fn SP -off 0.37 -pow 2 -end 1.0 -c 1.0  \
| nmrPipe -fn ZF -auto \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 -75.8 -p1 -19 -di \
| nmrPipe -fn EXT -x1 6.5ppm -xn 4.8ppm -sw \
| nmrPipe -fn TP \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.93 -c 0.5 \
| nmrPipe -fn ZF -zf 4 \
| nmrPipe -fn FT -neg \
| nmrPipe -fn PS -p0 -90 -p1 0 -di \
| pipe2xyz -out ft/test%03d.ft1  

