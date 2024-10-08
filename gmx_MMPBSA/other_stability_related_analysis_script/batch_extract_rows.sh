
function extract_rows {
    IN_DAT=$1  # /path/to/FINAL_RESULTS_MMPBSA.dat'
    OUT_DAT=$(dirname $IN_DAT)/$(basename $IN_DAT .dat)_extracted.dat
    printf "IN_DAT: $IN_DAT\nOUT_DAT: $OUT_DAT\n"
    printf "extract rows 29 32 31 47 51 67 71 87 91 107 111 113 130 134 151 155 172 176 193\n"
    printf "processing....\n"
    python extract_rows.py -i $IN_DAT -o $OUT_DAT -r 29 32 31 47 51 67 71 87 91 107 111 113 130 134 151 155 172 176 193 
    printf "done\n"
}


# build a list of files to be processed

#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY15_0001_10w_20240925_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY15_0002_10w_20240925_443321/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY15_0003_10w_20240925_558899/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY15_0004_10w_20240925_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY15_0005_10w_20240925_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY16_0001_10w_20240926_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY16_0002_10w_20240926_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY16_0003_10w_20240926_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY16_0004_10w_20240926_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY16_0005_10w_20240926_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY19_0001_10w_20240926_443321/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY19_0002_10w_20240926_558899/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY19_0003_10w_20240926_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY19_0004_10w_20240926_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_1/Grain_LY19_0005_10w_20240926_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0006_10w_20240929_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0007_10w_20240929_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0008_10w_20240926_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0009_10w_20240930_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0011_10w/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0012_10w/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0013_10w/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0014_10w/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY15_0015_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY16_0006_10w_20240930_194802_re1/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY16_0007_10w_20240930_194802_1/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY16_0008_10w_20240930_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY16_0009_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY16_0010_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY16_0011_10w_20240930_194802/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY19_0006_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY19_0007_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY19_0008_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
#'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_2/Grain_LY19_0009_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
data_array=(
'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_3/Grain_LY16_0015_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_3/Grain_LY19_0014_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_3/Grain_LY16_0013_10w_20240930_194802/FINAL_RESULTS_MMPBSA.dat'
'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_3/Grain_LY16_0014_10w_20240930_135815/FINAL_RESULTS_MMPBSA.dat'
'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_3/Grain_LY16_0012_10w_20240930_194802/FINAL_RESULTS_MMPBSA.dat'
'/media/muwang/Extreme_SSD/work/traj/Grain/mmPBSA/round_3/Grain_LY15_0010_10w_20240930_194802/FINAL_RESULTS_MMPBSA.dat'

)


# loop over data_array, process files by calling extract_rows
for data in ${data_array[@]}
do
    extract_rows $data
done
