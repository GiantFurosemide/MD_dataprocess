echo -e "##################################################"
echo -e " start executing post_process_mv.sh"
echo -e "##################################################"


# make coor_nc in $PWD, not cp just mv
MY_OUT_DIR=$PWD
mkdir -p '../wangmu_check'
mkdir -p ${MY_OUT_DIR}
mkdir -p ${MY_OUT_DIR}/coor_nc
mkdir -p ${MY_OUT_DIR}/log_txt
mv -v ./*/*.trr ${MY_OUT_DIR}/coor_nc 
mv -v ./*/*log.txt ${MY_OUT_DIR}/log_txt
echo '\n > Done!'
#cd coor_nc

echo -e "##################################################"
echo -e " post_process_mv.sh executed successfully!"
echo -e "##################################################"