WORK_DIR=$PWD

echo "Go to data directory."
echo "cp gro file to current directory."
echo "Make sure its name is \n\tstep6.1_equilibration.gro or \n\tnpt_ab.gro or \n\tstep4.1_equilibration.gro"
echo "current directory is: $PWD"
SCRIPTS_DIR='/Users/muwang/Documents/work/scripts'
echo "make sure the scripts directory is: $SCRIPTS_DIR"

read -p "Press any key to continue... " -n1 -s 

# cp trr files to one directory
cp -v "$SCRIPTS_DIR/post_process_mv.sh" .
echo "executing post_process_mv.sh ... "
source post_process_mv.sh

# transfer trr to xtc,then merge them to a new xtc file
cp -v "$SCRIPTS_DIR/trr2xtc.py" .
python trr2xtc.py
cd $WORK_DIR

# deal with pbc and align to reference
cp -v "$SCRIPTS_DIR/atom_only_pbc.sh" .
echo "executing atom_only_pbc.sh ... "
source atom_only_pbc.sh

cp -v "$SCRIPTS_DIR/draw_log_plots.py" .
python draw_log_plots.py -f log_txt 