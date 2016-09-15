NDSW   = 1003;
NDAPOD = 1002;

if (sliceCode == CODE_ARGS)
   {
    exit( 0 );
   };

if (sliceCode == CODE_INIT)
   {
    (void) setParm( fdata, NDSIZE, 1, CUR_XDIM );
    (void) setParm( fdata, NDAPOD, 1, CUR_XDIM );
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

float src[xSize*ySize], buff[xSize], dest[ySize];

(void) dReadB( inUnit, src, wordLen*xSize*ySize );

xOff = 0;

for( iy = 0; iy < ySize; iy++ )
   {
    (void) vvCopyOff( buff, src, xSize, 0, xOff );

    dest[iy] = vSum( buff, xSize );

    xOff += xSize;
   }

(void) dWriteB( outUnit, dest, wordLen*ySize );
