
if (yLoc != 1)   
   {
    exit( 0 );
   };

if (!(zLoc % 2))
   {
    exit( 0 );
   };

float planeR[size*2*specnum], planeI[size*2*specnum];
float ccc[size], scc[size], csc[size], ssc[size];
float ccs[size], scs[size], css[size], sss[size];

(void) dReadB( inUnit, planeR, wordLen*size*specnum*2 );
(void) dReadB( inUnit, planeI, wordLen*size*specnum*2 );

offset = 0;

for( i = 1; i <= specnum; i += 2 )
   {
    (void) vvCopyOff( ccc, planeR, size, 0, offset );
    (void) vvCopyOff( scc, planeR, size, 0, offset+size );
    (void) vvCopyOff( css, planeR, size, 0, offset+2*size );
    (void) vvCopyOff( sss, planeR, size, 0, offset+3*size );

    (void) vvCopyOff( ccs, planeI, size, 0, offset );
    (void) vvCopyOff( scs, planeI, size, 0, offset+size );
    (void) vvCopyOff( csc, planeI, size, 0, offset+2*size );
    (void) vvCopyOff( ssc, planeI, size, 0, offset+3*size );

    (void) vNeg( csc, size );
    (void) vNeg( ssc, size );

    (void) vvCopyOff( planeR, ccc, size, offset,        0 );
    (void) vvCopyOff( planeR, scc, size, offset+size,   0 );
    (void) vvCopyOff( planeR, csc, size, offset+2*size, 0 );
    (void) vvCopyOff( planeR, ssc, size, offset+3*size, 0 );

    (void) vvCopyOff( planeI, ccs, size, offset,        0 );
    (void) vvCopyOff( planeI, scs, size, offset+size,   0 );
    (void) vvCopyOff( planeI, css, size, offset+2*size, 0 );
    (void) vvCopyOff( planeI, sss, size, offset+3*size, 0 );

    offset += 4*size;
   }

(void) dWrite( outUnit, planeR, wordLen*size*specnum*2 );
(void) dWrite( outUnit, planeI, wordLen*size*specnum*2 );
