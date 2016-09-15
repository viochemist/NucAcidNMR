#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 1672 -dspfvs 20 -grpdly 67.9892272949219  \
  -xN              1024  -yN              2400  \
  -xT               512  -yT              1200  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW        11961.722  -ySW         8333.333  \
  -xOBS         747.195  -yOBS         187.900  \
  -xCAR           4.773  -yCAR         101.549  \
  -xLAB              H5  -yLAB              C5  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

