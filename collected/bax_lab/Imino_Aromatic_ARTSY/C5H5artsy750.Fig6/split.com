#!/bin/csh

#
# originally written by Nick Fitzkee, JBNMR, 2010, Vol(48), 65-70.
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
