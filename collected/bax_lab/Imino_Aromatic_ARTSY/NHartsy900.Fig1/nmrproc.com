#!/bin/csh

#
# originally written by Nick Fitzkee, see JBNMR, 2010, Vol(48), 65-70.
#
# This is the script that performs apodization, Fourier transformation,
# baseline correction, etc.  It operates as a standard nmrPipe script
# except for the loop, which allows the same transformations to proceed
# on both the reference and attenuated spectra.
#

set tauValues = ( 5.05 10.1 )    # evolution times for each QJ point
set idxExpmt  = (    1    2 )    # (you don't need to change these
                                 # lines if you use get_jnh.py)

rm -rf ft ft2d
mkdir ft

foreach n ( `seq 1 ${#tauValues}` )
  echo Time t${n} \($tauValues[$n] ms\)...
  set outName  = (`printf ft/test%03d.ft2 $n`)
  set inName   = (`printf fid/test%03d.fid $idxExpmt[$n]`)
  echo "* input  = $inName"
  echo "* output = $outName"

  nmrPipe -in $inName \
  | nmrPipe  -fn SP -off 0.4 -end 0.98 -pow 2 -c 0.5    \
  | nmrPipe  -fn ZF -size 4096                          \
  | nmrPipe  -fn FT                                     \
  | nmrPipe  -fn EXT -x1 15.5ppm -xn 9ppm -sw -verb       \
  | nmrPipe  -fn PS -p0 -124.3 -p1 14 -di               \
  | nmrPipe  -fn TP                                     \
  | nmrPipe  -fn SP -off 0.4 -end 0.98 -pow 1 -c 0.5    \
  | nmrPipe  -fn ZF -size 1024                          \
  | nmrPipe  -fn FT                                     \
  | nmrPipe  -fn PS -p0 90 -p1 0 -di                \
  | nmrPipe  -fn TP                                     \
  | nmrPipe  -fn POLY -auto -ord 2                      \
     -verb -ov -out $outName

  sethdr $outName -tau $tauValues[$n]
end

# Backup the 2D spectra (solely for use with IPAP.  ugh.)
cp -r ft ft2d

# Make the 2D's into a psuedo 3D
series.com ft/test*.ft2
