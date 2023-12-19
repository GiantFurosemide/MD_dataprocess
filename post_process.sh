
# make coor_nc log.txt in ../out_wangmu

MY_OUT_DIR='../out_wangmu'
mkdir -p '../wangmu_check'
mkdir -p ${MY_OUT_DIR}
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
cp -v ./*/*.trr ${MY_OUT_DIR}/coor_nc && cp -v ./*/*log.txt ${MY_OUT_DIR}/log_txt
echo '\n > Done!'

# make ONLY log.txt in ../out_wangmu

MY_OUT_DIR='../out_wangmu'
mkdir -p '../wangmu_check'
mkdir -p ${MY_OUT_DIR}
mkdir -p ${MY_OUT_DIR}/log_txt
cp -v ./*/*log.txt ${MY_OUT_DIR}/log_txt
echo "\n > Done! cp log.txt"


# make coor_nc in customized dir
MY_OUT_DIR='/ogfs/users/sldebug2/white_6W8I_BC2P_20231201'
mkdir -p '../wangmu_check'
mkdir -p ${MY_OUT_DIR}
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
cp -v ./*/*.trr ${MY_OUT_DIR}/coor_nc && cp -v ./*/*log.txt ${MY_OUT_DIR}/log_txt
echo '\n > Done!"'

# make coor_nc in $PWD
MY_OUT_DIR=$PWD
mkdir -p '../wangmu_check'
mkdir -p ${MY_OUT_DIR}
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
cp -v ./*/*.trr ${MY_OUT_DIR}/coor_nc && cp -v ./*/*log.txt ${MY_OUT_DIR}/log_txt
echo '\n > Done!'


# make coor_nc in $PWD, not cp just mv
MY_OUT_DIR=$PWD
mkdir -p '../wangmu_check'
mkdir -p ${MY_OUT_DIR}
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
mv -v ./*/*.trr ${MY_OUT_DIR}/coor_nc && mv -v ./*/*log.txt ${MY_OUT_DIR}/log_txt
echo '\n > Done!'
cd coor_nc
trr2xtc_cp2here
cd ..




mkdir coor_nc log_txt vel_nc
MY_OUT_DIR=/public/users/home/sldebug/sl/case_ASN439LYS_20230531_npt_20230911_2140/md_post_output
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
cp -v ./*/*_coor.nc ${MY_OUT_DIR}/coor_nc && cp -v ./*/*log.txt ${MY_OUT_DIR}/log_txt && cp -v ./*/*_vel.nc ${MY_OUT_DIR}/vel_nc


# make coor_nc in current directory
mkdir coor_nc log_txt
MY_OUT_DIR=$PWD
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
cp -v ./*/*.trr ${MY_OUT_DIR}/coor_nc && cp -v ./*/*log.txt ${MY_OUT_DIR}/log_txt

