#!/bin/csh

#
# originally written by Nick Fitzkee, JBNMR, 2010, Vol(48), 65-70.
#
# This file uses the python script get_jnh.py to determine JNH (or JNH+DNH)
# values from the ratios contained in nlin.tab.
#
# T is d21 (in ms), n is the noise rms. from nmrDraw (from the menu bar click on: Draw/Estimate Noise)
#

./get_jnh.py -T 11.6 -n 7.09279e+6 -i nlin.tab > jnh.dat

