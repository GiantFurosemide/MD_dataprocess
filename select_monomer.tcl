# select ligands by resname and create representation for all ligands
set r_name "AAR"
set all_ligands [atomselect top "resname $r_name"]

set frame_resid [$all_ligands get resid]
set frame_resid [lsort -unique $frame_resid]

foreach resid $frame_resid  {
mol representation VDW
mol selection "resname $r_name and resid $resid and not hydrogen"
mol addrep top
}

