!/bin/csh

bruk2pipe -in ./ser -bad 0.0 -noaswap -DMX -decim 24 -dspfvs 12        \
  -xN              1024  -yN               244  -zN               110  \
  -xT               512  -yT               122  -zT                55  \
  -xMODE            DQD  -yMODE        Complex  -zMODE        Complex  \
  -xSW         8012.821  -ySW         2212.389  -zSW         1100.110  \
  -xOBS         800.129  -yOBS         201.202  -zOBS         800.129  \
  -xCAR           3.900  -yCAR              56  -zCAR           3.900  \
  -xLAB           H-acq  -yLAB             13C  -zLAB           H-ind  \
  -ndim               3  -aq2D          States                         \
| nmrPipe -fn MAC -macro macroRanceY.M -noRd -noWr \
| nmrPipe -fn MAC -macro macroMIX8.M   -noRd -noWr \
| pipe2xyz -out ./fid/test%03d.fid -verb -ov
