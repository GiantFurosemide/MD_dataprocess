#!/bin/bash

WORK_DIR=$PWD

########################################################
################### SCRIPTS PATH #######################
########################################################
# 0. set the path of the defaults scripts directory
SCRIPTS_DIR='/home/muwang/opt/work_scripts/MD_dataprocess'
# 1. cp trr files to one directory
POST_PROCESS=$SCRIPTS_DIR/post_process_mv.sh
# 2. convert .trr to xtc and merge to one xtc
TRR2XTC_MERGE=$SCRIPTS_DIR/trr2xtc.py
# 3. PBC process and align to reference
PBC_PROCESS_ROT_TRANS=$SCRIPTS_DIR/atom_all_atom_pbc.sh
# 4. draw plots based on log files from 512
DRAW_LOG_PLOTS=$SCRIPTS_DIR/draw_log_plots.py
# 5. vmd visualized with vmd script useme.tcl
VMD_VISUAL=$SCRIPTS_DIR/useme_GJZX.tcl
########################################################

########################################################
###################other variables######################
########################################################

# 6. if you want to execute vmd visualization (default is true)
DO_VMD=false

########################################################


echo "Usage:"
echo "1. Go to data directory."
echo "2. cp gro file to current directory."
echo -e "   Make sure its name is: \n\tstep6.1_equilibration.gro or \n\tnpt_ab.gro or \n\tstep4.1_equilibration.gro"
echo "current directory is: $PWD"


### update variables 
# Function to update variables from file
function update_variables() {
    source "$1"
}

# Loop through arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -f)
        file="$2"
        update_variables "$file"
        shift # past argument
        shift # past value
        ;;
        -no_vmd)
        DO_VMD=false
        shift # past argument
        ;;
        *)    # unknown option
        # print 
        shift # past argument
        ;;
    esac
done 
### update variables # END
echo -e "make sure you copy scripts from directory:\n $SCRIPTS_DIR"
echo "we will execute the following scripts: "
echo -e "1. cp trr files to one directory \n> $POST_PROCESS"
echo -e "2. convert .trr to xtc and merge to one xtc \n> $TRR2XTC_MERGE"
echo -e "3. PBC process and align to reference \n> $PBC_PROCESS_ROT_TRANS"
echo -e "4. draw plots based on log files from 512 \n> $DRAW_LOG_PLOTS"
echo -e "5. vmd visualized with vmd script useme.tcl \n> $VMD_VISUAL"


#read -p "Press any key to continue... " -n1 -s 
sleep 5

# 1. cp trr files to one directory
cp -v "$POST_PROCESS" .
echo "executing $(basename $POST_PROCESS) ... "
source $(basename $POST_PROCESS)

# 2. transfer trr to xtc,then merge them to a new xtc file
cd coor_nc
cp -v "$TRR2XTC_MERGE" .
python $(basename $TRR2XTC_MERGE) 
cd $WORK_DIR

# 3 . deal with pbc and align to reference
cp -v "$PBC_PROCESS_ROT_TRANS" .
echo "executing $(basename $PBC_PROCESS_ROT_TRANS) ... "
source $(basename $PBC_PROCESS_ROT_TRANS) < input_atom_id.txt

# 4. draw plots based on log files from 512 (log files has already been copied to directory 'log_txt')
cp -v "$DRAW_LOG_PLOTS" .
python $(basename $DRAW_LOG_PLOTS) -f log_txt 

# 5. vmd visualization: cp useme.tcl to current directory
cp -v "$VMD_VISUAL" .
sed -i "s/GX1/STI/g" $(basename $VMD_VISUAL)
if [ "$DO_VMD" = true ]; then
    
    vmd -e $(basename $VMD_VISUAL)
fi
