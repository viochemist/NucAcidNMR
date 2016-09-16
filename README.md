# NucAcidNMR
Pulse sequence development for Nucleic Acid NMR experiments

Objectives
----------

1) To build a thorough library of nucleic acid pulse sequences

2) To optimize all sequences for quick and easy setup by any user

Conventions
-----------

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
  - Header - references, initialled/dated change list, any special setup instructions
  - Safety checks - after "1 ze" and before the experiment starts, check validity of crucial parameters

	```
	1 ze
	
	  if "d1 < 0.5" {
	    2u
	    print "error: D1 too short"
	    goto HaltAcqu
	  }
	  ...
	
	2 d11
	  ...
	  < experiment code >
	  ...
	
	  go=2 ...
	  d11 do:f# ...
	  d11 mc ...
	  d11 BLKGRAD
	  
	HaltAcqu, d11
	exit
	```
      
  - Sequence - comment blocks of code (Hx -> HyCz, INEPT, CS Encode, etc.)
  - Footer - all parameters listed (ie. ;p10 : describe), any special processing instructions
 
Organization within these directories is still to be determined. In general, pulse
sequences should be 90% complete with a simple 'getprosol' command. Whenever this
isn't possible, python or au macros should be provided. 

Setup
-----

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




