#!/bin/csh

nmrPipe -in test.fid                                \
#| nmrPipe  -fn POLY -time                           \
#| nmrPipe  -fn SOL                                  \
| nmrPipe  -fn SP -off 0.4 -end 0.95 -pow 2 -c 0.5  \
| nmrPipe  -fn ZF -size 2048                        \
| nmrPipe  -fn FT                                   \
| nmrPipe  -fn EXT -x1 8.5ppm -xn 6.0ppm -sw         \
| nmrPipe  -fn PS -p0 69.1 -p1 0 -di              \
| nmrPipe  -fn TP                                   \
| nmrPipe  -fn SP -off 0.40 -end 0.98 -pow 1 -c 0.5     \
| nmrPipe  -fn ZF -size 512                          \
| nmrPipe  -fn FT                              \
#| nmrPipe  -fn EXT -x1 155.5ppm -xn 152ppm -sw         \
| nmrPipe  -fn PS -p0 -85.7 -p1 0.2  -di               \
| nmrPipe  -fn TP                                   \
| nmrPipe  -fn POLY -auto -ord 2                   \
   -ov -verb -out test.ft2
