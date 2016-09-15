#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 1480 -dspfvs 20 -grpdly 67.9869232177734  \
  -xN              2048  -yN               440  \
  -xT              1024  -yT               220  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW        13513.514  -ySW         1984.127  \
  -xOBS         750.299  -yOBS          76.038  \
  -xCAR          12.200  -yCAR         154.990  \
  -xLAB              HN  -yLAB             15N  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

