GMX_HBOND_SCRIPT='gmx_hbond.sh'

# get a path array from 'find' command
find $PWD -name "step4.1_equilibration.tpr" | xargs dirname > traj_xtc_list.txt
data_array=($(cat traj_xtc_list.txt))

# loop over data_array, process files by calling extract_rows
for data in ${data_array[@]}
do
    IN_TRAJ_XTC=$data/atom_rottrans_all.xtc
    IN_TPR=$data/step4.1_equilibration.tpr
    bash $GMX_HBOND_SCRIPT $IN_TRAJ_XTC $IN_TPR
done

