#!/bin/bash

########################################################
################### SCRIPTS PATH #######################
##### uncomment if you want to update new script(s)#####
############ update with ABSOLUTE PATH  ################
########################################################

# 0. set the path of the defaults scripts directory
#SCRIPTS_DIR='/Users/muwang/Documents/work/scripts'
# 1. cp trr files to one directory
#POST_PROCESS=$SCRIPTS_DIR/post_process_mv.sh
# 2. convert .trr to xtc and merge to one xtc
TRR2XTC_MERGE='/home/muwang/opt/work_scripts/MD_dataprocess/trr2xtc_readline_tpr.py'
# 3. PBC process and align to reference
#PBC_PROCESS_ROT_TRANS=$SCRIPTS_DIR/atom_all_pbc_swim.sh
#PBC_PROCESS_ROT_TRANS=$SCRIPTS_DIR/atom_all_atom_pbc_GJZX_ACLY.sh
PBC_PROCESS_ROT_TRANS='/home/muwang/opt/work_scripts/MD_dataprocess/atom_all_atom_pbc_tpr.sh'
# 4. draw plots based on log files from 512
#DRAW_LOG_PLOTS=$SCRIPTS_DIR/draw_log_plots.py
# 5. vmd visualized with vmd script useme.tcl
#VMD_VISUAL=$SCRIPTS_DIR/useme_swimm.tcl
#VMD_VISUAL='/media/muwang/新加卷/muwang/work/traj/GJZX/useme_GJZX.tcl' 
########################################################
###################other variables######################
########################################################

# 6. if you want to execute vmd visualization (default is true)
#DO_VMD=false

########################################################
