
SCRIPT_PLOT_HBOND=plot_hbond_number.py
X_LABLE="Time (ps)"
Y_LABLE="Hbonds"
TITLE="Number of hydrogen bonds"

DATA_FILE_HBOND='/home/parric/Downloads/mmPBSA/hbond_test/hbond_analysis/hbond_num.xvg'
python $SCRIPT_PLOT_HBOND --data_file "$DATA_FILE_HBOND" --xlabel "$X_LABLE" --ylabel "$Y_LABLE" --title "$TITLE"



# get a path array from 'find' command
find $PWD -name "hbond_num.xvg" | xargs dirname > hbond_analysis_list.txt
data_array=($(cat hbond_analysis_list.txt))

# loop over data_array, process files by calling extract_rows
for data in ${data_array[@]}
do
    DATA_FILE_HBOND=$data/hbond_num.xvg
    python $SCRIPT_PLOT_HBOND --data_file "$DATA_FILE_HBOND" --xlabel "$X_LABLE" --ylabel "$Y_LABLE" --title "$TITLE"

done