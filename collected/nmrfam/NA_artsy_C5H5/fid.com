#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 2666.66666666667 -dspfvs 20 -grpdly 67.9861755371094  \
  -xN              1024  -yN              1024  \
  -xT               512  -yT               512  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW         7500.000  -ySW         3125.000  \
  -xOBS         750.294  -yOBS         188.679  \
  -xCAR           4.724  -yCAR         102.680  \
  -xLAB              1H  -yLAB             13C  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

