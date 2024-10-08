
# cp data for mmpbsa calculation to cwd


data_array=(
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY15_0001_10w_20240925_194802/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY15_0002_10w_20240925_443321/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY15_0003_10w_20240925_558899/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY15_0004_10w_20240925_135815/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY15_0005_10w_20240925_135815/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY16_0001_10w_20240926_194802/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY16_0002_10w_20240926_194802/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY16_0003_10w_20240926_194802/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY16_0004_10w_20240926_194802/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY16_0005_10w_20240926_194802/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY19_0001_10w_20240926_443321/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY19_0002_10w_20240926_558899/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY19_0003_10w_20240926_135815/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY19_0004_10w_20240926_135815/'
'/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY19_0005_10w_20240926_135815/'

)


function cp_files_to_cwd {
    # make a directory bu using the basename of the first argument
    mkdir -v $(basename $1)
    # copy files to current working directory
    cp -v $1/md_post_output/production.mdp $(basename $1)/
    cp -v $1/md_post_output/step4.1_equilibration.gro $(basename $1)/
    cp -v $1/md_post_output/step4.1_equilibration.tpr $(basename $1)/
    cp -v $1/md_post_output/topol.top $(basename $1)/
    cp -v $1/md_post_output/atom_rottrans_all.xtc $(basename $1)/
}



# loop over data_array,cp files to current working directory
for data in ${data_array[@]}
do
    cp_files_to_cwd $data
done
