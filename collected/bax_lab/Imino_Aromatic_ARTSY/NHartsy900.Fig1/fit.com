#!/bin/csh

#
# originally written by Nick Fitzkee, see JBNMR, 2010, Vol(48), 65-70.
#
# This file uses the assignments in test_ass.tab to determine the peak
# intensities in the reference spectrum.  The output is nlin.tab, which
# is generated using seriesTab, and which contains an additional column
# Z_A1 containing the intensity ratio of the second and first spectra.
#
# seriesTab does not allow the peak to shift, but it does perform a 
# basic Fourier fitting to interpolate intensities between the digitized
# spectral coordinates.
#
# Note that without the -nofit argument, autoFit would also attempt to
# perform a full spectrum fit, which would extract linewidths and heights
# for each peak.  This is not optimal here, because in unfavorable 
# situations the height that is fit may not accurately represent the
# height of the spectrum, especially when overlap occurs.
#

autoFit.tcl -series -dX 0.0 -dY 0.0 -inTab test_ass.tab \
            -specName ft/test%03d.ft2 -nofit

