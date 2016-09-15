#!/bin/csh

bruk2pipe -in ./ser -bad 0.0 -noaswap -DMX -decim 24 -dspfvs 12  \
  -xN              1024  -yN                78  -zN                58  \
  -xT               512  -yT                39  -zT                29  \
  -xMODE            DQD  -yMODE  Echo-AntiEcho  -zMODE        Complex  \
  -xSW         8012.821  -ySW         1111.111  -zSW         1111.111  \
  -xOBS         800.130  -yOBS         201.208  -zOBS         201.208  \
  -xCAR         4.75466  -yCAR          93.050  -zCAR          70.960  \
  -xLAB              1H  -yLAB             13C  -zLAB             13C  \
  -ndim               3  -aq2D          States                         \
  -out ./fid/test%03d.fid -verb -ov

sleep 5
