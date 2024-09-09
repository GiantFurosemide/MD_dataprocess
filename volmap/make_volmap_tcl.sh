atom_selection='resname STI and not hydrogen'
dx_name=ABL1r3_0003

# 1. generate dx file by in VMD
echo  volmap density [atomselect top \"$atom_selection\"] -res 1.0 -weight mass -allframes -combine avg -o ${dx_name}_volmap_out.dx > volmap.tcl

# 2. run this command in VMD console
echo "run this command in VMD console:"
echo "> source volmap.tcl"