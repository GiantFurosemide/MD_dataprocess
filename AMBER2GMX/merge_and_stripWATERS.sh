
#!/bin/bash


# input files
parm_file="charmm2amber.parm7"
rst7_file="amber.rst7"
# output files
coor_all="merge.nc"
#vel_all="velocity.nc"
#out_trr="merge_amber.nc"
# then run 


############################################################################################################
# 加载Amber模块 
mkdir coor_nc
mkdir vel_nc
mkdir log_txt
mv ./*/*_coor.nc coor_nc/
mv ./*/*_vel.nc vel_nc/
mv ./*/*_log.txt log_txt/

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


conda deactivate
############################################################################################################