#!/bin/csh

#
# originally written by Nick Fitzkee, JBNMR, 2010, Vol(48), 65-70.
#
# This file uses the python script get_jnh.py to determine JNH (or JNH+DNH)
# values from the ratios contained in nlin.tab.
#


./get_jnh.py -T 5.1 -n 133225 nlin.tab > jdC5H5.dat


