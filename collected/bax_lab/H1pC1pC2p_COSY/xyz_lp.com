#!/bin/csh

xyz2pipe -in fid/test%03d.fid -x -verb \
| nmrPipe -fn SP -off 0.37 -pow 2 -end 1.0 -c 0.5  \
| nmrPipe -fn ZF -size 2048 \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 255.8 -p1 50  -di \
| nmrPipe -fn EXT -x1 6ppm -xn 5ppm -sw \
| nmrPipe -fn TP \
| nmrPipe -fn SP -off 0.5 -pow 1 -end 0.95 -c 0.5 \
| nmrPipe -fn ZF -size 64 \
| nmrPipe -fn FT -neg \
| nmrPipe -fn PS -p0 -90.0 -p1 0  -di \
| nmrPipe -fn CS -ls 5ppm \
| pipe2xyz -out ft/test%03d.ft1  

xyz2pipe -in ft/test%03d.ft1 -z -verb \
| nmrPipe -fn LP -ps0-0 \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 1.0 -c 0.5   \
| nmrPipe -fn ZF -size 256 \
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 0 -p1 0 -di \
| nmrPipe -fn CS -ls 2ppm \
| nmrPipe -fn TP \
| pipe2xyz -out ft/test%03d.ft2 

xyz2pipe -in ft/test%03d.ft2 -x -verb \
| nmrPipe -fn HT \
| nmrPipe -fn FT -neg -inv \
| nmrPipe -fn ZF -size 64 -inv \
| nmrPipe -fn SP -hdr -inv \
| nmrPipe -fn LP -ps0-0 -ord 8 \
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.95 -c 0.5 \
| nmrPipe -fn ZF -size 128 \
| nmrPipe -fn FT -neg -di \
| pipe2xyz -out ft/test%03d.ft3 

