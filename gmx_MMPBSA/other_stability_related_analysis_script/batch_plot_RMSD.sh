
SCRIPT_PLOT_HBOND=plot_RMSD.py
X_LABLE="Time (ns)"
Y_LABLE="RMSD (Å)"
TITLE="RMSD"

#DATA_FILE_HBOND='/home/parric/Downloads/mmPBSA/hbond_test/hbond_analysis/hbond_num.xvg'
#python $SCRIPT_PLOT_HBOND --data_file "$DATA_FILE_HBOND" --xlabel "$X_LABLE" --ylabel "$Y_LABLE" --title "$TITLE"



# get a path array from 'find' command
find $PWD -name "rmsd.xvg" | xargs dirname > rmsd_analysis_list.txt
data_array=($(cat rmsd_analysis_list.txt))

# loop over data_array, process files by calling extract_rows
for data in ${data_array[@]}
do
    DATA_FILE=$data/rmsd.xvg
    python $SCRIPT_PLOT_HBOND --data_file "$DATA_FILE" --xlabel "$X_LABLE" --ylabel "$Y_LABLE" --title "$TITLE"

done