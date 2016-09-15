/***/
/* bruk_ranceY2.M: Rance-mode gradient shuffling for Y-Axis. (Bruker)
/***/

/* Process only every pair of complex rows, one real, one imag: */

if (!(sliceCode % 2))
   {
    exit( 0 );
   };

float sumR[size], sumI[size], difR[size], difI[size];

(void) dReadB( inUnit, rdata, wordLen*size );
(void) dReadB( inUnit, idata, wordLen*size );
(void) dReadB( inUnit, difR,  wordLen*size );
(void) dReadB( inUnit, difI,  wordLen*size );

(void) vvCopy( sumR, rdata, size );
(void) vvCopy( sumI, idata, size );

(void) vvSub( sumR, difR, size );
(void) vvSub( sumI, difI, size );
(void) vvAdd( difR, rdata, size );
(void) vvAdd( difI, idata, size );

(void) dWrite( outUnit, sumR, wordLen*size );
(void) dWrite( outUnit, sumI, wordLen*size );
(void) dWrite( outUnit, difR, wordLen*size );
(void) dWrite( outUnit, difI, wordLen*size );

