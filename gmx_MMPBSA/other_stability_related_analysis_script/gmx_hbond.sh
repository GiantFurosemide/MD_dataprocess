#!/bin/bash
# usage: bash gmx_hbond.sh IN_TRAJ_XTC IN_TPR


IN_TRAJ_XTC=$1
IN_TPR=$2
##Index file that contains selected groups', acceptors', donors' and
##           hydrogens' indices and hydrogen bond pairs between or within
##           selected groups.
#OUT_HBOND_DIR=$(dirname $IN_TRAJ_XTC)/hbond_legacy_analysis
#mkdir -p $OUT_HBOND_DIR
#OUT_INDEX=$OUT_HBOND_DIR/hbond.ndx
## Number of hydrogen bonds as a function of time.
#OUT_FILE=$OUT_HBOND_DIR/hbond_num.xvg
## Distance distribution of all hydrogen bonds.
#OUT_DIST=$OUT_HBOND_DIR/hbond_dist.xvg
## Number of donors and acceptors analyzed for each frame.
#OUT_DAN=$OUT_HBOND_DIR/hbond_dan.xvg
## life time of hbond
#OUT_LIFE=$OUT_HBOND_DIR/hbond_life.xvg
#
## if gmx = 2024 or later, use hbond-legacy
#gmx hbond-legacy -f $IN_TRAJ_XTC -s $IN_TPR -num $OUT_FILE -dist $OUT_DIST  -life $OUT_LIFE <<EOF
#Protein
#Protein
#EOF


# hbond
OUT_HBOND_DIR=$(dirname $IN_TRAJ_XTC)/hbond_analysis
mkdir -p $OUT_HBOND_DIR
OUT_INDEX=$OUT_HBOND_DIR/hbond.ndx
# Number of hydrogen bonds as a function of time.
OUT_FILE=$OUT_HBOND_DIR/hbond_num.xvg
# Distance distribution of all hydrogen bonds.
OUT_DIST=$OUT_HBOND_DIR/hbond_dist.xvg
# Number of donors and acceptors analyzed for each frame.
OUT_DAN=$OUT_HBOND_DIR/hbond_dan.xvg
# life time of hbond
OUT_LIFE=$OUT_HBOND_DIR/hbond_life.xvg

gmx hbond -f $IN_TRAJ_XTC -s $IN_TPR -o $OUT_INDEX -num $OUT_FILE -dist $OUT_DIST -dan $OUT_DAN <<EOF
Protein
Protein
EOF