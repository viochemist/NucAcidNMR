#!/bin/csh

#
# zero fill exact multiple of sw ratio (in this case, 16)
# EXT range should be adjusted to with of diagonal signals

# 1 126 null p0 168 zft -alt
# 127 253 rev p0 0  zft -alt +225 FTY

xyz2pipe -in ./fid/test%03d.fid -x -verb \
| nmrPipe -fn EXT -x1 1pts -xn 256pts -sw\
| nmrPipe -fn SP -off 0.5 -pow 2 -end 0.98 -c 0.5  \
| nmrPipe -fn ZF -auto\
| nmrPipe -fn FT -auto \
| nmrPipe -fn PS -p0 99 -p1 0  -di \
| nmrPipe -fn TP \
| nmrPipe -fn SP -off 0.37 -pow 1 -end 0.98 -c 0.5 \
| nmrPipe -fn ZF -auto \
| nmrPipe -fn FT -auto\
| nmrPipe -fn PS -p0 -45.4 -p1 183.5 -di \
| nmrPipe -fn REV \
| nmrPipe -fn POLY -auto -ord 2 \
| nmrPipe -fn TP\
| pipe2xyz -out ./ft/test%03d.ft2 


xyz2pipe -in ./ft/test%03d.ft2 -z -verb \
| nmrPipe -fn PS -p0 -3.5 -p1 0  \
| nmrPipe -fn LP -ps0-0 -pred 6 -ord 4 \
| nmrPipe -fn SP -off 0.4 -end 0.98 -pow 2 -c 0.5 \
| nmrPipe -fn ZF -size 32 \
| nmrPipe -fn FT -alt -di\
| nmrPipe -fn TP \
| nmrPipe -fn HT \
| nmrPipe -fn FT -inv \
| nmrPipe -fn MAC -macro slide.M \
| nmrPipe -fn FT -di \
| nmrPipe -fn MAC -macro shape.M -noRd -noWr -all \
| nmrPipe -fn EXT -x1 6Pts -xn 12Pts \
| pipe2xyz -out ./stack/test%03d.ft3 -z

xyz2pipe -in ./stack/test%03d.ft3 -z -verb \
| nmrPipe -fn SP \
| nmrPipe -fn MAC -macro sum.M -noRd -noWr -all \
| pipe2xyz -out ft/test%03d.dat -z

#| nmrPipe -fn LP -ps0-0 -pred 6 -ord 4 \
#| nmrPipe -fn SP -off 0.4 -pow 1 -end 0.99 -c 0.5 \
#| nmrPipe -fn ZF -auto \
#| nmrPipe -fn FT -auto \
#| nmrPipe -fn PS -p0 -11.8 -p1 188.4 -di\
#| nmrPipe -fn REV \
#| nmrPipe -fn TP\
