#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 1848 -dspfvs 20 -grpdly 67.9869537353516  \
  -xN              1024  -yN               600  \
  -xT               512  -yT               300  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW        10822.511  -ySW         2000.000  \
  -xOBS         600.433  -yOBS         150.993  \
  -xCAR           4.773  -yCAR         101.630  \
  -xLAB              H6  -yLAB              C5  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

