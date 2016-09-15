#!/bin/csh

xyz2pipe -in ./fid/test%03d.fid -x -verb \
| nmrPipe -fn EXT  -x1 1pts -xn 256pts -sw  \
| nmrPipe -fn SP -off 0.5 -pow 1 -end 0.98 -c 0.5  \
| nmrPipe -fn ZF -auto \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 231.5 -p1 -53  -di \
| nmrPipe -fn TP \
| nmrPipe -fn SP -off 0.5 -pow 1 -end 0.90  \
| nmrPipe -fn ZF -auto\
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 8.3 -p1 174.6 -di\
| nmrPipe -fn TP\
| nmrPipe -fn POLY -auto \
| nmrPipe -fn EXT -x1 6ppm -xn 9ppm -sw \
| pipe2xyz -out ./ft/test%03d.ft2 

xyz2pipe -in ./ft/test%03d.ft2 -z -verb \
| nmrPipe -fn SP -off 0.37 -pow 1 -end 0.98 \
| nmrPipe -fn ZF -size 512 \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 -85.7 -p1 184.6 -di\
| pipe2xyz -out ./ft/test%03d.ft3 -z

xyz2pipe -in ./ft/test%03d.ft3 -x -verb \
| nmrPipe -fn TP \
| nmrPipe -fn HT \
| nmrPipe -fn FT -auto -inv\
| nmrPipe -fn ZF -auto -inv\
| nmrPipe -fn SP -off 0.5 -pow 1 -end 0.90 -inv\
| nmrPipe -fn LP -ps0-0 -pred 33 -ord 6 \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.98  \
| nmrPipe -fn ZF -auto \
| nmrPipe -fn FT -di \
| nmrPipe -fn TP \
| pipe2xyz -out ./ft/test%03d.ft3 -x -verb 

xyz2pipe -in ./ft/test%03d.ft3 -z -verb \
| pipe2xyz -out ./ft/testy%03d.ft3 -y
