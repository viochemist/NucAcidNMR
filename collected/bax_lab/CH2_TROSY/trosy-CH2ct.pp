; 13C-1H CH2_TROSY CT, optimized for protein side chains

#include "bits.nt"


;p1 = 90 deg (10us) 1H pulse @pl1
;p3 = 90 deg 13C pulse @pl3
;p6 = 180 deg 13Ca-13Cb shape pulse (reburp profile)
;p7 = 180 deg 13C' shape pulse (sine-bell shape)
;p5 = 180 deg 15C pulse @pl5

"d2=1/135"
"d3=d2/4-p22-5u-p3"
"d7=d2/16"		;1/(16JCH)
"d4=d7-p24-5u"		;Delay pour S3E
"d26=p3-p1"
"d25=(p7-p5)*0.5"
"d13=d2*0.17-p22"	;Delay1 pour CH2-S3CT
"d14=d2*0.115-p23"	;Delay2 pour CH2-S3CT
"d16=0.5m-p24"
"d17=0.5m-p25"   
"d11=50m"
"d12=1m"

"d0=5u"
"d5=14m"		;13C Constant Time
"d9=d5-d0-p7-p26-300u-p6*0.5"
"d10=d5-p7-5u-p6*0.5"

1 ze
  1m RESET
2     2m
      d11
      d12
3     d12
4     d12
      d12
5     d12
6     d12
7     1m LOCK_ON
      d1
      1m LOCK_OFF
      10u pl1:H
      10u pl3:C1
;********  INEPT  *****
     (p1 ph0):H
     5u
     p22:gp2
     d3
     (d26 p1*2 ph0):H (p3*2 ph0):C1
     5u
     p22:gp2
     d3 pl3:C1
     (p1 ph11):H
     10u pl5:N
     p20:gp0		;need huge gradient
     250u pl3:C1
;***** S3E *****
     (p3 ph17):C1
     5u
     p24:gp0
     d4
     (p3*2 ph18):C1 (d26 p1*2 ph0):H
     5u
     p24:gp0
     d4
     (p3 ph19):C1
;****** 13C CT-evolution + encoding *****
     d0 pl6:C2
     (p7:sp7 ph0):C2 (d25 p5 ph0):N
     d9
     p26:gp26*EA	 ;coherence encoding gradient
     300u pl6:C1
     (p6:sp6 ph0):C1
     d10 pl6:C2
     (p7:sp7 ph0):C2 (d25 p5 ph0):N
     5u pl3:C1
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
       (d26 p1*2 ph0):H (p3*2 ph0):C1
       2u
       p23:gp23
       d14
       (d26 p1 ph0):H (p3 ph7):C1
       4u
       p24:gp24       ;coherence decoding gradient
       d16
       (p1*2 ph0):H
       2u
       p25:gp25       ;coherence decoding gradient
       d17
       (2u ph0)
       go=2 ph31
       1m
       1m LOCK_ON
       d11 wr #0 if #0 zd
d12*0.25 ip9
d12*0.25 ip9
d12*0.5  igrad EA
lo to 3 times 2
d12*0.5 rp19
d12*0.25 id0
d12*0.25 dd10
lo to 4 times l3 ;NLOOP
d12
d12
1m RESET
1m LOCK_ON
exit


ph0=0
ph1=1
ph11=3
ph7=0
ph8=1
ph9=0
ph17=(8)5 1 
ph18=0
ph19=0
ph31=0 2 
