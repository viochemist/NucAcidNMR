#!/usr/bin/python2

#
# title:   get_jnh.py
# summary: Measure analytical JNH values from ratios in axt.tab
# author:  Nicholas Fitzkee (nfitzkee@nih.gov)
# date:    June 28, 2010
#

# Change this if you want to adjust the default time for dephasing and noise
MAX_TIME  = 4.5e-3  # T in s
DEF_NOISE = 1.0

import sys, math

def usage():
    print 'usage: get_jnh.py [-n <noise>] [-T <time>] <axt.tab>'
    sys.exit()

def help():
    print 'usage: get_jnh.py [-n <noise>] [-T <time>] <axt.tab>'

    print """
    This script extracts JNH values from the axt.tab file created by
    seriesTab using the analytical formulas provided in equations 2
    and 3.  It takes the following arguments:

    -T | --bigT  <time>   The total dephasing delay T in ms.

    -n | --noise <noise>  The spectral noise, determined by NMRDraw

    -i | --ignore         Ignore unassigned peaks (ASS=None)

    At the very least, you'll want to specify the noise, otherwise the
    uncertainties will be off.  However, if you adjust the T delay, you
    can specify that, too.

    Output is four columns: The inferred residue number (table index
    is used otherwise), the coupling, the uncertainty, and the assignment.
    """
    sys.exit()

def getResNum(ass):
    """getResNum(ass) - get a residue number from an assignment string"""
    ass = ass.split('-')[0]  # for sparky peaks

    start = None
    end = None

    for i in xrange(len(ass)):
        if ass[i] in '0123456789':
            start = i
            break

    for i in xrange(len(ass)-1, -1, -1):
        if ass[i] in '0123456789':
            end = i
            break
    
    if start == None or end == None: return None
    
    # for 'alternate' assignments (lowercase), e.g. 'A212bHN'
    # stupid hack is to just add a factor of 1,000
    
    offset = 0
    if end+1 < len(ass):
        c = ass[end+1]
        if c == c.lower():
            offset = 1000*(1+ord(c)-ord('a'))
            
    try:
        return int(ass[start:end+1]) + offset
    except:
        return None

def isInt(val):
    """isInt(v) - is a string coaxable to int"""
    try:
        int(val)
    except:
        return 0

    return 1

def listFind(needle, haystack):
    """listFind(n, h) - return the index of needle in haystack"""
    for idx in xrange(len(haystack)):
        if haystack[idx] == needle:
            return idx

    return -1

def getColumns(tabf):
    """getColumns(f) - return indices of desired columns in a tab file"""
    assID = 'ASS'
    hgtID = 'HEIGHT'
    idxID = 'INDEX'
    
    f = open(tabf)
    lines = f.readlines()
    f.close()

    vline = None

    for l in lines:
        l = l.strip().upper()
        if not l or l[0] == '#': continue
        toks = l.split()

        if toks[0] == 'VARS':
            vline = toks[1:]

        if vline != None: break

    idxIdx = listFind(idxID, vline)
    idxAss = listFind(assID, vline)
    idxHgt = listFind(hgtID, vline)
    idxRat = -1
    
    for dim in 'XYZA':
        idxRat = listFind('%s_A1' % dim, vline)
        if idxRat >= 0: break

    if idxIdx < 0 or idxAss < 0 or idxHgt < 0 or idxRat < 0:
        print 'Error: not all columns found in %s.' % tabf
        sys.exit(1)

    return idxIdx, idxAss, idxHgt, idxRat

# Main Function #############################################################

def main(tabf, bigT, noise, ignore, out=sys.stdout):
    idxIndex, idxAssign, idxHeight, idxRatio = getColumns(tabf)
    
    closeOut = 0
    if type(out) == type(''):
        out = open(out)
        closeOut = 1
    w = out.write
    
    f = open(tabf)
    lines = f.readlines()
    f.close()

    result = []

    for l in lines:
        l = l.strip()

        if l and l[0] != '#':
            toks = l.split()
            if not isInt(toks[0]): continue
            
            res    = getResNum(toks[idxAssign])

            if res == None:
                if ignore: continue
                res = int(toks[idxIndex])
            
            fnoise = noise / abs(float(toks[idxHeight]))
            ratio  = float(toks[idxRatio])

            #jnh = -2.0/math.pi/bigT*math.acos(0.5*ratio)
            jnh = 2.0/math.pi/bigT*math.acos(0.5*ratio)

            err_ratio = (1.0 + ratio*ratio)/(4.0 - ratio*ratio)
            err = 2.0*fnoise/math.pi/bigT*math.sqrt(err_ratio)

            result.append((res, jnh, err, toks[idxAssign]))

    result.sort()

    if out != None:
        for res, jnh, err, ass in result:
            print '%4i %13.5e %13.5e %s' % (res, jnh, err, ass)

    return result

    
if __name__ == '__main__':
    import getopt

    sopt = 'T:n:hi'
    lopt = ['bigT=', 'noise=', 'help', '--ignore']
    
    try:
        opts, args = getopt.getopt(sys.argv[1:], sopt, lopt)
    except getopt.error:
        usage()

    bigT   = MAX_TIME
    noise  = DEF_NOISE
    ignore = 0

    for o, v in opts:
        if o in ('-h', '--help'):
            help()
        elif o in ('-T', '--bigT'):
            bigT = float(v)/1000.0
        elif o in ('-n', '--noise'):
            noise = abs(float(v))
        elif o in ('-i', '--ignore'):
            ignore = 1
        else:
            usage()

    if not len(args): usage()

    main(args[0], bigT, noise, ignore)
