#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 1480 -dspfvs 20 -grpdly 67.9869232177734  \
  -xN              2048  -yN               512  \
  -xT              1024  -yT               256  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW        13513.514  -ySW         4464.286  \
  -xOBS         750.294  -yOBS         188.688  \
  -xCAR           4.676  -yCAR         147.618  \
  -xLAB              1H  -yLAB             13C  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

