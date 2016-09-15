#!/bin/sh
# The next line restarts using nmrWish \
exec nmrWish "$0" -- "$@"

set auto_path "[split $env(TCLPATH) :] $auto_path"
set ARGV      [concat $argv0 $argv]
set ARGC      [llength $ARGV]

set assName        ass_750.tab
set inName         test.tab
set outName        ass.tab

# offsets added to chemical shift assignments:
set cor_X	-0.01
set cor_Y	0.0

set xTolPPM     0.03
set yTolPPM     0.15

#
# Help text:

   if {[flagLoc $ARGV -HELP] || [flagLoc $ARGV -help]} \
      {
       puts "Project assignments from one peak table to another:"
       puts "  -ass assName    Assigned peak table input."
       puts "  -in  inName     Unassigned peak table input."
       puts "  -out outName    Assigned peak table output."
       puts "  -cor_x  cor_X   X_PPM offset correction (ppm)."
       puts "  -cor_y  cor_Y   X_PPM offset correction (ppm)."
       puts "  -xTol   xMax    Maximum X_PPM difference for match."
       puts "  -yTol   yMax    Maximum Y_PPM difference for match."
       exit
      }

getArgD $ARGV -in     inName
getArgD $ARGV -ass    assName
getArgD $ARGV -out    outName

getArgD $ARGV -sx     sX
getArgD $ARGV -sy     sY

getArgD $ARGV -xTol  xTolPPM
getArgD $ARGV -yTol  yTolPPM

set indexList ""
set assList ""

gdbInit
gdbCreate dBase -name ASS

set assTab [gdbRead table -in $assName -name ass  -verb]
set pkTab  [gdbRead table -in $inName  -name peak -verb]

set entryI  [gdbFirst $assTab]

while {$entryI} \
   {
    set ass [gdbGet $entryI ASS]

    if {"$ass" == "None" || "$ass" == "(Null)" || "$ass" == "?"} \
       {
        set entryI [gdbNext $entryI]
	continue
       }

#
# Find the peak entry nearest to the given X and Y position.

    set xPPM [expr [gdbGet $entryI X_PPM] + $cor_X]
    set yPPM [expr [gdbGet $entryI Y_PPM] + $cor_Y]

    set cond  "near( X_PPM, $xPPM, $xTolPPM ) && near( Y_PPM, $yPPM, $yTolPPM )"

    set eList [gdbSelect -from $pkTab -M -inPlace -cond $cond]
    set count [llength $eList]

    if {$count < 1} \
       {
        puts "Residue $ass: No match!"
       } \
    elseif {$count == 1} \
       {
#        puts "Matched to residue $ass"

        foreach entryJ $eList \
           {
            set index [gdbGet $entryJ INDEX]

            if {[lsearch $indexList $index] < 0} \
               {
                gdbSet $entryJ ASS $ass
                set ready($index) $ass
                lappend indexList $index
                lappend assList $ready($index)
               } \
            else \
               {
                puts "Matched to $ass but overlaps with previously matched $ready($index)"
               }
           }
       } \
    else \
       {
        puts "Residue $ass: Ambiguous, matched $count times."
       }

    set entryI [gdbNext $entryI]
   }

gdbWrite $pkTab $outName

set newList [lsort -r $indexList]
puts "\nList of succesful (unique) assignments: \n $newList"
puts "\nTotal succesful (unique) assignments: [llength $assList]"
puts "\nList of assignments: \n $assList"

exit

