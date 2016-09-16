# NucAcidNMR
#### *Pulse sequence development for Nucleic Acid NMR experiments*



## Objectives

1. To build a thorough library of nucleic acid pulse sequences
2. To optimize all sequences for quick and easy setup by any user

## Conventions

The library will be divided into two categories, initially. The *collected* 
directory will contain pulse sequences found from any NMR lab. These can be
both Varian/Agilent or Bruker sequences. The *optimized* directory will contain
those sequences that have been optimized for Bruker spectrometers and made to 
conform to the following conventions:

- Bruker pulse, power, and delay naming conventions with the appropriate choice of prosol relations
- Compatible with latest patch levels of Topspin 3.2 and above (roughly Avance II and later)
- Internal calculations must be field independent
- All necessary non-conventional pulses, decoupling, etc must be provided
- No additional 'include' files may be used
- Avoid spaces and dashes in any file/directory naming, only use underscore ( _ )
- All sequences should be well documented
  - Header - references, class/type info, initialled/dated change list, any special setup instructions
  - Safety checks - after "1 ze" and before the experiment starts, check validity of crucial parameters
  - Sequence - comment blocks of code (Hx -> HyCz, INEPT, CS Encode, etc.)
  - Footer - all parameters listed (ie. ;p10 : describe), any special processing instructions
 
Organization within these directories is still to be determined. In general, pulse
sequences should be 90% complete with a simple 'getprosol' command. Whenever this
isn't possible, python or au macros should be provided. 

### Example Code

```
;na_example
;avance-version (16/01/01)             ; I believe this is year/month/day ... not sure if important
;Example experiment code to highlight several conventions
;
;$CLASS=HighRes
;$DIM=2D
;$TYPE=NucleicAcids
;$SUBTYPE=Assignment
;$SUBTYPEB=Backbone
;$COMMENT=Class, Dim, Type, Subtype should be specified for easy experiment selection
;
; == SETUP ==
; While not a real experiment, please describe briefly any special instructions here
;
; == CHANGELIST ==
; Written by ALH, 15 Sept 2016
; -- 16 Sept 2016 / ALH - Added safety check

prosol relations=<triple_na>

#include <Avance.incl>
#include <Grad.incl>
#include <Delay.incl>

;### Pulses ###
"p2=p1*2"
"p4=p3*2"
"p22=p21*2"

;### Delays ###
"d11=30m"
"d12=20u"
"d13=2u"

;### Misc ###
aqseq 312
"acqt0=-p1*2/3.1415"		; set acqt0 for optimal phasing in direct dim
;baseopt_echo			; use if sequence ends with echo

/*******************************/
/* BEGIN ACTUAL PULSE SEQUENCE */
/*******************************/

1 ze
/***** PARAMETER CHECK *****/

  if "d1 < 0.5" {
    2u
    print "error: D1 too short"
    goto HaltAcqu
  }

/***** START EXPERIMENT *****/
2 d11
  d1

  ...
  < experiment code >
  ...

/***** ACQUISITION *****/

  go=2 ...
  d11 do:f# ...
  d11 mc ...
  d11 BLKGRAD
  
HaltAcqu, d11
exit

ph0=0			; Ideally, ph0 through ph3 should be X, Y, -X, -Y
ph1=1
ph2=2
ph3=3

ph4=0 2 2 0		; First phase cycle
ph31=0 0 2 2

;###################
;    Definitions
;-------------------

; ... Powers ...
;pl0    : 1H - No power
;pl1    : 1H - High power level
;pl2    : 13C - High power level
;pl3    : 15N - High power level
;pl14   : 13C - CPD low-power decoupling level

; ... Pulses ...
;p1     : 1H - hard 90 degree @ PL1 (used to find 1H shape powers)
;p2     : 1H - hard 180 degree @ PL1
;p3     : 13C - hard 90 degree @ PL2 
;p4     : 13C - hard 180 degree @ PL2
;p21    : 15N - hard 90 degree @ PL3
;p22    : 15N - hard 180 degree @ PL3
;p16    : Gradient  [1 ms]

; ... Shapes ...
;sp1    : 1H - H2O selective pulse
;spnam1 : Sinc1.1000

; ... Decoupling ...
;cpd2   : 13C - Decoupling according to sequence defined by cpdprg2
;pcpd2  : 13C - 90 degree pulse for decoupling sequence
;cpdprg2: 13C - garp4.p61 @ PL14

; ... Delays ...
;d0     : Incremented delay (2D)
;d1     : Interscan recovery delay
;d11    : Disk I/O delay [30ms]
;d12    : Short delay    [10us]
;d13    : Shorter delay  [2us]
;d16    : Gradient recovery delay  [200us]

; ... Constants ...
;cnst4  : J(CH) ~ 200 Hz

;  ... Miscellaneous ...
;ds     : >= 16
;ns     : 2*n
;inf1   : t1 increment
;zgoptns: 'LABEL_CN'

;FnMODE : States-TPPI in F1

; ... Gradients ...
;for z-only gradients:
;gpz1: 11%
;gpz2:  7%

;use gradient files:   
;gpnam1: SMSQ10.100
;gpnam2: SMSQ10.100


	;preprocessor-flags-start
;LABEL_CN: for C-13 and N-15 labeled samples start experiment with
;        option -DLABEL_CN (eda: ZGOPTNS)
	;preprocessor-flags-end

;Processing

;PHC0(F1): 90
;PHC1(F1): -180
;FCOR(F1): 1

```

## Setup

In a desired directory (Mac/Linux) with 'git' installed, run:

	git clone git@github.com:viochemist/NucAcidNMR.git

Set your name and e-mail with:

	git config --global user.name = "My Name"
	git config --global user.email = name@something.com
	
Once installed, collect any updates by running:

	git pull

To contribute, run ssh-keygen and/or send me your .ssh/id_rsa.pub so that I can
generate a key. Then, after you make changes to your local versions, run:

	git add <changed files>
	git commit -m "Message about changes"
	git push

Always be sure to pull and merge before pushing any changes.  This is a very basic 
workflow for now. Once the library has reached some sort of stable level, a master
and development branch will be formed. For now, I'm just "hunting and gathering".




