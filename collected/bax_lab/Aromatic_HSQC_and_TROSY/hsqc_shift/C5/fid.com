#!/bin/csh

bruk2pipe -in ./ser -bad 0.0 -noaswap -DMX -decim 24 -dspfvs 12 -grpdly 0  \
  -xN              1024  -yN               400  \
  -xT               512  -yT               200  \
  -xMODE            DQD  -yMODE  Echo-AntiEcho  \
  -xSW         8012.821  -ySW         2325.581  \
  -xOBS         800.130  -yOBS         201.211  \
  -xCAR           5.391  -yCAR         100.247  \
  -xLAB              1H  -yLAB             13C  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

