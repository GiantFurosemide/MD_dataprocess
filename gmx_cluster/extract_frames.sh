

####
INPUT_TOP_GRO=step4.1_equilibration.gro
INPUT_TRAJ_XTC=atom_rottrans_all.xtc

##############################################################################################


gmx trjconv -f $INPUT_TOP_GRO -s $INPUT_TOP_GRO -o protein.gro  <<EOF
Protein
EOF

gmx trjconv -f $INPUT_TRAJ_XTC -s $INPUT_TOP_GRO -o atom_rottrans_all_protein.xtc <<EOF
Protein
EOF

INPUT_TOP_GRO=protein.gro 
INPUT_TRAJ_XTC=atom_rottrans_all_protein.xtc
INPUT_TRAJ_XTC_FIT=atom_rottrans_all_protein_fit.xtc
INPUT_TRAJ_XTC_FIT_SKIP=atom_rottrans_all_protein_fit_skip1000.xtc

gmx trjconv -f $INPUT_TRAJ_XTC -s $INPUT_TOP_GRO -fit rot+trans -o $INPUT_TRAJ_XTC_FIT <<EOF
Protein
System
EOF

gmx trjconv -f $INPUT_TRAJ_XTC_FIT -s $INPUT_TOP_GRO -o $INPUT_TRAJ_XTC_FIT_SKIP -skip 1000 << EOF
System
EOF

echo "Use protein only top(.gro): $INPUT_TOP_GRO"
echo "Use protein only traj(.xtc) full traj: $INPUT_TRAJ_XTC_FIT"
echo "Use protein only traj(.xtc) skip 1000: $INPUT_TRAJ_XTC_FIT_SKIP"
