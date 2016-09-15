#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 928 -dspfvs 20 -grpdly 67.9839782714844  \
  -xN              2048  -yN               800  \
  -xT              1024  -yT               400  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW        21551.724  -ySW         2380.952  \
  -xOBS         900.281  -yOBS          91.238  \
  -xCAR          12.200  -yCAR         152.998  \
  -xLAB              HN  -yLAB             15N  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

