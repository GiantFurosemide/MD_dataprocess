### 1. cp data for mmpbsa calculation to cwd
#source cp_filter.sh
#
### 2. check xtc files to determain the number of frames
#echo "start" > xtc_check.log
#for i in Grain*; do
#    echo $i
#    gmx check -f $i/atom_rottrans_all.xtc 1>> xtc_check.log 2>> xtc_check.log
#done
## 1-1480 frames in  xtc_check.log

my_roor_log=$(pwd)/main.log
my_roor_dir=$(pwd)

# log function with timestamp
function my_log {
    echo "[$(date)] $1" >> $my_roor_log
}


echo "start" > $my_roor_log
for i in Grain*; do
    echo $i
    cp -v  MMPBSA_calculation.sh $i
    cd $i
    
    my_log "start, $i"
    source MMPBSA_calculation.sh
    my_log "end, $i"
    
    cd $my_roor_dir
    my_log "back to  $my_roor_dir"
done