#!/bin/csh

bruk2pipe -in ./ser -bad 0.0 -noaswap -DMX -decim 24 -dspfvs 12 -grpdly 0  \
  -xN              1024  -yN               160  \
  -xT               512  -yT                80  \
  -xMODE            DQD  -yMODE  Echo-AntiEcho  \
  -xSW         8012.821  -ySW          765.697  \
  -xOBS         800.132  -yOBS         201.222  \
  -xCAR           7.104  -yCAR         153.782  \
  -xLAB              1H  -yLAB             13C  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

