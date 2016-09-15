#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 1232 -dspfvs 20 -grpdly 67.9882507324219  \
  -xN              2048  -yN              1024  \
  -xT              1024  -yT               512  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW        16233.766  -ySW         5263.158  \
  -xOBS         900.274  -yOBS         226.405  \
  -xCAR           4.773  -yCAR         145.907  \
  -xLAB              1H  -yLAB             13C  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov


