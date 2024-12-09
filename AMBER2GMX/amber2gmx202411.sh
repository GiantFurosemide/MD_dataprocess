#!/bin/bash

# conver parm rst7 nc of amber to gro top and trr(not aligned) xtc(aligned)



# input files
parm_file="step3_input.parm7"
rst7_file="step4.1_equilibration.rst7"
nc_file='step5_*.nc'
protein_last_residue=127
# output files
coor_all="merge.nc"
coor_all_gmx="merge.trr"
#vel_all="velocity.nc"
#out_trr="merge_amber.nc"
out_gro_gmx="gmx.gro"
out_top_gmx="topol.top"
# aligned_traj='atom_rottrans_all.xtc'
# then run 


############################################################################################################
# 加载Amber模块 
conda activate AmberTools23

cat > cpptraj000.in <<EOF
parm $parm_file
reference $rst7_file
trajin ${nc_file}
autoimage :1-${protein_last_residue} origin 

trajout ${coor_all}
trajout ${coor_all_gmx}
run
quit
EOF
cpptraj -i cpptraj000.in

cat > convertAMBERtop2GMXtop.py <<EOF
import parmed as pmd
#加载 Amber 格式的文件
amber = pmd.load_file('${parm_file}', '${rst7_file}')

# 保存为 Gromacs 格式的文件
amber.save('${out_gro_gmx}', overwrite=True)
amber.save('${out_top_gmx}', format='gromacs', overwrite=True)

EOF
python convertAMBERtop2GMXtop.py 


cat > gmx_aligned_traj.sh <<EOF
cp ${out_gro_gmx} step4.1_equilibration.gro
echo C-alpha System | gmx trjconv  -s step4.1_equilibration.gro -f ${coor_all_gmx} -fit rot+trans -o atom_rottrans_all.xtc
EOF
source gmx_aligned_traj.sh




conda deactivate
#######################################