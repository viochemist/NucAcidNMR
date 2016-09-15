NDSW   = 1003;
NDAPOD = 1002;

if (sliceCode == CODE_ARGS)
   {
    exit( 0 );
   };

if (sliceCode == CODE_INIT)
   {
    xT  = getParm( fdata, NDAPOD, CUR_XDIM );
    yT  = getParm( fdata, NDAPOD, CUR_YDIM );

    xSW = getParm( fdata, NDSW, CUR_XDIM );
    ySW = getParm( fdata, NDSW, CUR_YDIM );

    dCount = integer((xSW/ySW) + 0.5);
    dSize  = integer((xSize/dCount) + 0.5);

    (void) printf( "Reshape: dCount %.1f dSize %.1f\n", dCount, dSize );
 
    (void) setParm( fdata, NDSW,   ySW*dCount,   CUR_YDIM );

    (void) setParm( fdata, NDSIZE, dSize,        CUR_XDIM );
    (void) setParm( fdata, NDSIZE, ySize*dCount, CUR_YDIM );

    (void) setParm( fdata, NDAPOD, xT/dCount,    CUR_XDIM );
    (void) setParm( fdata, NDAPOD, yT*dCount,    CUR_YDIM );
   };

if (sliceCode < 1)
   {
    exit( 0 ); 
   };

/***/
/* Process each 2D plane:
/***/

if (sliceCode % ySize)
   {
    exit( 0 );
   };

float src[xSize*ySize], dest[dSize*ySize*dCount];

(void) dReadB( inUnit, src, wordLen*xSize*ySize );

xOff = 0;
yOff = 0;

for( i = 1; i <= dCount; i++ )
   {
    thisXOff = xOff;

    for( iy = 0; iy < ySize; iy++ )
       {
        (void) vvCopyOff( dest, src, dSize, yOff, thisXOff );

        thisXOff += xSize;
        yOff     += dSize;        
       }

    xOff += dSize;
   }

(void) dWriteB( outUnit, dest, wordLen*dSize*ySize*dCount );
