; 13C-1H CH2_TROSY-NOESY optimized for Nucleic Acids

#include "bits.nt"

;hsqcref.gk
;JB 18 0ctober 2001

;p1 = 90 deg (10us) 1H pulse @pl1
;p3 = 90 deg 13C pulse @pl3
;p6 = 180 deg reburp 2-bands (65-70ppm and 38-43ppm)
;cpd2 = WURST-4 adiabatic pulses in a p5m4 composite decoupling sequence (76-89ppm)
;cpd4 = GARP wide band


"d2=1/143"
"d3=d2/4-p22-5u-p3"
"d7=d2/16"		;1/(16JCH)
"d4=d7-p22-5u"		;Delay pour S3E
"d26=p3-p1"
"d13=d2*0.17-p22"	;Delay1 pour CH2-S3CT
"d14=d2*0.115-p23"	;Delay2 pour CH2-S3CT
"d16=0.35m-p24"
"d17=0.35m-p25"   
"d11=50m"
"d12=1m"

"d0=3u"
"d20=2u"

1 ze
  1m RESET
2     2m do:C1 do:C2
      d11
      d12
3     d12
4     d12
      d12
5     d12
6     d12 do:C1 do:C2
7     1m LOCK_ON
      d1
      1m LOCK_OFF
      10u pl1:H
      10u fq1:C1
      10u pl3:C1
;********  INEPT  *****
     (p1 ph0):H
     5u
     p22:gp21
     d3
     (d26 p1*2 ph0):H (p3*2 ph0):C1
     5u
     p22:gp21
     d3 pl3:C1
     (p1 ph11):H
     10u pl29:N
     p20:gp0		;need huge gradient
     300u pl3:C1
;***** S3E *****
     (p3 ph17):C1
     5u
     p22:gp20
     d4
     (p3*2 ph0):C1 (d26 p1*2 ph0):H
     5u
     p22:gp20
     d4 pl5:C2  
     (p3 ph19):C1
;****** 13C evolution + encoding *****
     3u cpd2:C2
     d0
     3u do:C2
     p26:gp26*EA       ;coherence encoding gradient 0.5m @ -50% on z
     100u
     100u pl6:C1
     (p6:sp6 ph6):C1
     9u 
     p27:gp27*EA       ;coherence encoding gradient 0.5m @ 50% on z
     200u pl3:C1
;****** CH2-S3CT transfer back ****** 
       (p3 ph9):C1 (d26 p1 ph0):H
       2u
       p22:gp22
       d13
       (d26 p1*2 ph0):H (p3*2 ph7):C1
       2u
       p22:gp22
       d13
       (p1 ph1):H (p3 ph8):C1
       2u
       p23:gp23
       d14
       (d26 p1*2 ph0):H (p3*2 ph7):C1
       2u
       p23:gp23
       d14
       (d26 p1 ph0):H (p3 ph7):C1
       4u
       p24:gp24       ;coherence decoding gradient 100u 50%
       d16
       (p1*2 ph0):H
       2u
       p25:gp25       ;coherence decoding gradient  ~151.5u -50%
       d17 pl31:C1
;****** NOESY ******
       d20
       (p1 ph20):H
       4u
       p21:gp1
       3u fq1:C1
       d9 pl31:C1     ;NOE mixing time
       (p1 ph0):H
       go=2 ph31 cpd4:C1
       1m do:C1 do:N
       1m LOCK_ON
       d11 wr #0 if #0 zd

d12*0.25 ip9
d12*0.25 ip9
d12*0.5  igrad EA
lo to 3 times 2
d12*0.5 
d12*0.5 id0
lo to 4 times l3 ;NLOOP
d12*0.5 rd0
d12*0.5 ip20
lo to 5 times 2
d12*0.5 id20
d12*0.25 ip31
d12*0.25 ip31
lo to 6 times l4
 
d12

1m RESET
1m LOCK_ON
exit


ph0=0
ph1=1
ph11=3
ph6=0 0 1 1
ph7=0
ph8=1
ph9=0
ph17=(8)3 7 
ph19=0
ph20=0
ph31=0 2 2 0
