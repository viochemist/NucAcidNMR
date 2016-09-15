#!/bin/csh

bruk2pipe -in ./ser -bad 0.0 -noaswap -DMX -decim 24 -dspfvs 12 -grpdly 0  \
  -xN              1024  -yN               300  \
  -xT               512  -yT               150  \
  -xMODE            DQD  -yMODE  Echo-AntiEcho  \
  -xSW         8012.821  -ySW         1694.915  \
  -xOBS         800.132  -yOBS         201.220  \
  -xCAR           7.766  -yCAR         140.255  \
  -xLAB              1H  -yLAB             13C  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

