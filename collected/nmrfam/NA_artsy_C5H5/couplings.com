#!/bin/csh

#
# originally written by Nick Fitzkee, JBNMR, 2010, Vol(48), 65-70.
#
# This file uses the python script get_jch.py to determine JNH (or JNH+DNH)
# values from the ratios contained in nlin.tab.
#
# T is d27 (in ms), n is the noise rms. from nmrDraw (from the menu bar click on: Draw/Estimate Noise)
#
# -i option will ignore unassigned peaks
#

#./get_jch.py -T 5.7 -n 763817 nlin.tab > jdC5H5.dat
./get_jch.py -T 5.7 -n 763817 nlin.tab > jdC5H5.dat


