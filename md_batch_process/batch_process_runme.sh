usage="# usage: 
# 1.copy:
#    batch_process_runme.sh*
#    input_atom_id.txt*
#    input_gro_path.txt*
#    md_process_config.sh*
#    md_process_custom.sh*
# to current directory
# 2. modify the data_array to the path of your data
# 3. modeify the input_atom_id.txt to your atom id. gro file path
# 4. run this script"

echo -e $usage
sleep 8


data_array=(
#'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/Dynamo_JAK2JH2r1_0001_10w_20240914_443321/md_post_output'
#'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/Dynamo_JAK2JH2r1_0008_10w_20240914_443321/md_post_output'
#'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/Dynamo_JAK2JH2r1_0012_10w_20240914_443321/md_post_output'
#'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/Dynamo_JAK2JH2r1_0013_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0011_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0003_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0009_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0010_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0002_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0012_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0013_10w_20240914_443321/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0014_10w_20240913/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0015_10w_20240913/md_post_output'
'/media/muwang/Extreme_SSD/work/traj/dynamo/JAK2JH2r1/downloading/Dynamo_JAK2JH2r1_0016_10w_20240912_135814/md_post_output'
)

my_root_path=$PWD

for item in "${data_array[@]}"
do
	cp -v "${my_root_path}/md_process_custom.sh" $item
	cp -v "${my_root_path}/md_process_config.sh" $item
	cp -v "${my_root_path}/input_atom_id.txt" $item
	#cp -v "${my_root_path}/input_gro_path.txt" $item
	cp -v "${my_root_path}/input_gro_path.txt" "${my_root_path}/input_gro_path.txt.tmp"

	tmp_dir_name=$(dirname ${item})
	echo $tmp_dir_name
	sed -i "s|MY_DIR|${tmp_dir_name}|g" "${my_root_path}/input_gro_path.txt.tmp"
	mv -v "${my_root_path}/input_gro_path.txt.tmp" ${item}/input_gro_path.txt
	cd $item
	source md_process_custom.sh -f md_process_config.sh
	cd $my_root_path

done
