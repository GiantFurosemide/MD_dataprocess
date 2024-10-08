#!/bin/bash
# usage: bash gmx_rms.sh IN_TRAJ_XTC IN_TPR


IN_TRAJ_XTC=$1
IN_TPR=$2

#IN_TRAJ_XTC=hbond_test/atom_rottrans_all.xtc
#IN_TPR=hbond_test/step4.1_equilibration.tpr

OUT_RMSD_DIR=$(dirname $IN_TRAJ_XTC)/rmsd_analysis
mkdir -p $OUT_RMSD_DIR
OUT_RMSD_XVG=$OUT_RMSD_DIR/rmsd.xvg

gmx rms -s $IN_TPR -f $IN_TRAJ_XTC -o $OUT_RMSD_XVG -tu ns <<EOF
Protein-H
Protein-H
EOF