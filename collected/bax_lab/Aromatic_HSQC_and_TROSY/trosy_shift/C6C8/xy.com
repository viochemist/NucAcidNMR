#!/bin/csh

nmrPipe -in test.fid                                \
#| nmrPipe  -fn POLY -time                           \
#| nmrPipe  -fn SOL                                  \
| nmrPipe  -fn SP -off 0.4 -end 0.95 -pow 2 -c 0.5  \
| nmrPipe  -fn ZF -size 2048                        \
| nmrPipe  -fn FT                                   \
| nmrPipe  -fn EXT -x1 8.3ppm -xn 6.8ppm -sw         \
| nmrPipe  -fn PS -p0 71.8 -p1 0 -di              \
| nmrPipe  -fn TP                                   \
| nmrPipe  -fn SP -off 0.5 -end 0.98 -pow 1 -c 0.5     \
| nmrPipe  -fn ZF -size 1024                          \
| nmrPipe  -fn FT                              \
#| nmrPipe  -fn EXT -x1 144.2ppm -xn 135ppm -sw         \
| nmrPipe  -fn CS -ls 0.8ppm -sw         \
| nmrPipe  -fn PS -p0 -90.2 -p1 0.6  -di               \
| nmrPipe  -fn TP                                   \
| nmrPipe  -fn POLY -auto -ord 2                   \
   -ov -verb -out test.ft2
