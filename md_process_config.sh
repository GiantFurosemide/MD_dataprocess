#!/bin/bash

########################################################
################### SCRIPTS PATH #######################
### input -1 if you don't want to update new script(s)##
############ update with ABSOLUTE PATH  ################
########################################################

# 0. set the path of the defaults scripts directory
SCRIPTS_DIR='/Users/muwang/Documents/work/scripts'
# 1. cp trr files to one directory
POST_PROCESS=$SCRIPTS_DIR/post_process_mv.sh
# 2. convert .trr to xtc and merge to one xtc
TRR2XTC_MERGE=$SCRIPTS_DIR/trr2xtc_custom.py
# 3. PBC process and align to reference
PBC_PROCESS_ROT_TRANS=$SCRIPTS_DIR/atom_all_pbc_swim.sh
# 4. draw plots based on log files from 512
DRAW_LOG_PLOTS=$SCRIPTS_DIR/draw_log_plots.py
# 5. vmd visualized with vmd script useme.tcl
VMD_VISUAL=$SCRIPTS_DIR/useme.tcl

########################################################
###################other variables######################
########################################################

# 6. if you want to execute vmd visualization (default is true)
DO_VMD=true

########################################################