#!/bin/csh

nmrPipe -in test.fid                                \
#| nmrPipe  -fn POLY -time                           \
#| nmrPipe  -fn SOL                                  \
| nmrPipe  -fn SP -off 0.4 -end 0.95 -pow 2 -c 0.5  \
| nmrPipe  -fn ZF -size 2048                        \
| nmrPipe  -fn FT                                   \
| nmrPipe  -fn EXT -x1 5.6ppm -xn 5.05ppm -sw         \
| nmrPipe  -fn PS -p0 68 -p1 0 -di              \
| nmrPipe  -fn TP                                   \
| nmrPipe  -fn SP -off 0.5 -end 0.98 -pow 1 -c 0.5     \
| nmrPipe  -fn ZF -size 1024                          \
| nmrPipe  -fn FT                              \
#| nmrPipe  -fn EXT -x1 105.5ppm -xn 97ppm -sw         \
| nmrPipe  -fn PS -p0 -92.5 -p1 5.4  -di               \
| nmrPipe  -fn TP                                   \
| nmrPipe  -fn POLY -auto -ord 2                   \
   -ov -verb -out test.ft2
