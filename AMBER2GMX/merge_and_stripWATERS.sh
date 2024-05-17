
#!/bin/bash


# input files
parm_file="charmm2amber.parm7"
rst7_file="amber.rst7"
# output files
coor_no_water="merge_no_water.nc"
rst7_no_water="amber_no_water.rst7"
parm_no_water="charmm2amber_no_water.parm7"
#vel_all="velocity.nc"
#out_trr="merge_amber.nc"
# then run 


############################################################################################################
# 加载Amber模块 
mkdir coor_nc
mkdir vel_nc
mkdir log_txt
mv md_post_output/*/*_coor.nc coor_nc/
mv md_post_output/*/*_vel.nc vel_nc/
mv md_post_output/*/*_log.txt log_txt/

conda activate AmberTools23

cat > cpptraj000.in <<EOF
parm $parm_file
reference $rst7_file
trajin coor_nc/*.nc
strip :WAT
trajout ${coor_all}
run
quit
EOF
cpptraj -i cpptraj000.in

cat > cpptraj001.in <<EOF
parm $parm_file
trajin $rst7_file
strip :WAT
trajout ${rst7_no_water}
run
quit
EOF
cpptraj -i cpptraj001.in

cat > no_water.parmed <<EOF
loadRestrt ${rst7_no_water}
outparm ${parm_no_water}
run
EOF
parmed -i no_water.parmed

conda deactivate
############################################################################################################