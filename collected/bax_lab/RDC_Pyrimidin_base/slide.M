NDSW = 1003;

xSW  = getParm( fdata, NDSW, CUR_XDIM );
ySW  = getParm( fdata, NDSW, CUR_YDIM );

dSize = xSize*ySW/xSW;

xMid  = 1 + dSize/2;
yMid  = 1 + ySize/2;

slope  = (1 - xMid)/(yMid - 1);
offset = -slope*yMid;
shift  = slope*yLoc + offset;

p0     = 0.0;
p1     = -360.0*shift;

(void) phase( rdata, idata, size, p0, p1 );

