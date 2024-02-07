#!/bin/bash


# input files
parm_file="charmm2amber.parm7"
rst7_file="amber.rst7"
# output files
coor_all="merge.nc"
vel_all="velocity.nc"
out_trr="merge_amber.nc"
# then run 


############################################################################################################
# 加载Amber模块 
conda activate AmberTools23

cat > cpptraj000.in <<EOF
parm $parm_file
reference $rst7_file
trajin coor_nc/*.nc
trajout ${coor_all}
run
quit
EOF
cpptraj -i cpptraj000.in

cat > cpptraj001.in <<EOF
parm $parm_file
reference $rst7_file
trajin vel_nc/*.nc
trajout ${vel_all}
run
quit
EOF
cpptraj -i cpptraj001.in

cat > cpptraj002.in <<EOF
parm $parm_file
reference $rst7_file
trajin ${coor_all} mdvel ${vel_all}
trajout ${out_trr}
run
quit
EOF
cpptraj -i cpptraj002.in

conda deactivate
############################################################################################################