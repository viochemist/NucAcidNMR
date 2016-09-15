#!/bin/csh

#
# This script takes the extracted FID and splits it in to the reference
# attenuated FID files using the COADD command.  It also applies the
# Rance-Kay de-shuffling to the FIDs so they can be transformed.
#

rm -rf fid
mkdir fid

set bits = (0 0)

foreach ord (`seq ${#bits}`)
  set outName = `printf fid/test%03d.fid $ord`
  set bits[$ord] = 1

  nmrPipe -in test.fid \
  | nmrPipe -fn COADD -cList $bits -axis Y -time \
  | nmrPipe -fn MAC -macro $NMRTXT/bruk_ranceY.M -noRd -noWr \
  -verb -ov -out $outName

  set bits[$ord] = 0
end

#
# This is the script that performs apodization, Fourier transformation,
# baseline correction, etc.  It operates as a standard nmrPipe script
# except for the loop, which allows the same transformations to proceed
# on both the reference and attenuated spectra.
#

set tauValues = ( 2.55  5.1 )    # evolution times for each QJ point
set idxExpmt  = (    1    2 )    # (you don't need to change these
                                 # lines if you use get_jnh.py)

rm -rf ft ft2d
mkdir ft

foreach n ( `seq 1 ${#tauValues}` )
  echo Time t${n} \($tauValues[$n] ms\)...
  set outName  = (`printf ft/test%03d.ft2 $n`)
#  set ucsfName = (`printf ./dnh_t%03d.ucsf $n`)
  set inName   = (`printf fid/test%03d.fid $idxExpmt[$n]`)
  echo "* input  = $inName"
  echo "* output = $outName"

  nmrPipe -in $inName \
  | nmrPipe  -fn POLY -time				\
  | nmrPipe  -fn SP -off 0.45 -end 0.9 -pow 2 -c 0.5	\
  | nmrPipe  -fn ZF -zf 2 -auto				\
  | nmrPipe  -fn FT                                     \
  | nmrPipe  -fn EXT -x1 4ppm -xn 7ppm -sw -verb	\
  | nmrPipe  -fn PS -p0 155.2 -p1 0.0 -di		\
  | nmrPipe  -fn TP                                     \
  | nmrPipe  -fn SP -off 0.5 -end 0.99 -pow 1 -c 0.5	\
  | nmrPipe  -fn ZF -zf 2 -auto				\
  | nmrPipe  -fn FT -neg				\
  | nmrPipe  -fn PS -p0 0 -p1 0 -di			\
  | nmrPipe  -fn POLY -ord 0 -auto			\
  | nmrPipe  -fn CS -ls 5ppm -sw			\
  | nmrPipe  -fn TP                                     \
  | nmrPipe  -fn POLY -auto				\
     -verb -ov -out $outName

  # Optional: Make Sparky-format spectra
  #pipe2ucsf $outName $ucsfName

  sethdr $outName -tau $tauValues[$n]
end

# Backup the 2D spectra (solely for use with IPAP.  ugh.)
#cp -r ft ft2d

# Make the 2D's into a psuedo 3D
series.com ft/test*.ft2
