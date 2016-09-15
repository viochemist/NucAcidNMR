#!/bin/csh -f

set specName    = ft/test%03d.ft2
set simName     = sim/test%03d.ft2
set simDir      = sim
set difName     = dif/test%03d.ft2
set difDir      = dif
set inTabName   = ass.tab
set auxTabName  = axt.tab
set outTabName  = nlin.tab
set errTabName  = err.nlin.tab
set noiseRMS    = 7179162.500000
set specCount   = 2

set aRegSizeX  = 9
set dRegSizeX  = 9
set maxDX      = 0.0
set minXW      = 0.0
set maxXW      = 15.24
set simSizeX   = 1593

set aRegSizeY  = 6
set dRegSizeY  = 6
set maxDY      = 0.0
set minYW      = 0.0
set maxYW      = 9.29
set simSizeY   = 512

set aRegSizeZ  = 2
set dRegSizeZ  = 2
set maxDZ      = 1.0
set minZW      = 0.0
set maxZW      = 4.00
set simSizeZ   = 2


seriesTab -in  $inTabName -list nlin.spec.list \
 -dx  $dRegSizeX -dy  $dRegSizeY \
 -adx $aRegSizeX -ady $aRegSizeY \
 -xzf 64 -yzf 64 -max \
 -out $auxTabName -adVar VOL -verb


cp $auxTabName $outTabName


if (!(-e $simDir)) then
   mkdir $simDir
endif

xyz2pipe -in $specName -verb \
| nmrPipe -fn SET -r 0.0 \
| pipe2xyz -to 0 -out $simName -ov

simSpecND -in $outTabName -list sim.spec.list \
          -mod   GAUSS1D  GAUSS1D  SCALE1D  \
          -w     $simSizeX  $simSizeY  $simSizeZ  \
          -apod None -verb


if (!(-e $difDir)) then
   mkdir $difDir
endif

addNMR -in1 $specName -in2 $simName -out $difName -sub
