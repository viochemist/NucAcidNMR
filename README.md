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

 - Bruker pulse, power, and delay naming conventions with the appropriate choice
 of prosol relations
 
 - Compatible with latest patch levels of Topspin 3.2 and above (roughly Avance II and later)
 
 - Internal calculations must be field independent
 
 - All necessary non-conventional pulses, decoupling, etc must be provided
 
 - No additional 'include' files may be used
 
 - Avoid spaces and dashes in any file/directory naming, only use underscore ( _ )
 
Organization within these directories is still to be determined. In general, pulse
sequences should be 90% complete with a simple 'getprosol' command. Whenever this
isn't possible, python or au macros should be provided. 

Setup
-----

In a desired directory (Mac/Linux) with 'git' installed, run:

	git clone https://github.com/viochemist/NucAcidNMR.git

Once installed, collect any updates by running:

	git pull

To contribute, make changes to your local versions and then run:

	git add <changed files>
	git commit -m "Message about changes"
	git push

Always be sure to pull and merge before pushing any changes.  This is a very basic 
workflow for now. Once the library has reached some sort of stable level, a master
and development branch will be formed. For now, I'm just "hunting and gathering".




