#!/bin/csh

bruk2pipe -in ./ser -bad 0.0 -noaswap -DMX -decim 24 -dspfvs 12  \
  -xN              1024  -yN                26  -zN                54  \
  -xT               512  -yT                13  -zT                27  \
  -xMODE            DQD  -yMODE  Echo-AntiEcho  -zMODE    States-TPPI  \
  -xSW         7507.508  -ySW         1111.111  -zSW         1111.111  \
  -xOBS         800.131  -yOBS         201.210  -zOBS         201.210  \
  -xCAR          5.8433  -yCAR         92.6085  -zCAR         76.0915  \
  -xLAB              1H  -yLAB             13C  -zLAB             13C  \
  -ndim               3  -aq2D          States                         \
  -out ./fid/test%03d.fid -verb -ov

sleep 5
