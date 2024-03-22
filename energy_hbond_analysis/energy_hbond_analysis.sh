cd /media/wangmu/新加卷/muwang/work/traj/folding/chignolin

traj_trr='/media/wangmu/新加卷/muwang/work/traj/dynamo/folding/chignolin/process/coor_nc/36240.trr'
aligned_xtc='/media/wangmu/新加卷/muwang/work/traj/dynamo/folding/chignolin/process/atom_rottrans.xtc'
top_tpr='/media/wangmu/新加卷/muwang/work/traj/dynamo/folding/chignolin/md_0_1.tpr' 

echo 'Protein' | gmx traj -f $traj_trr  -s $top_tpr -ov veloc.xvg 
echo 'Protein' | gmx traj -f $traj_trr  -s $top_tpr -ekt ektrans.xvg
echo 'Protein' | gmx traj -f $traj_trr  -s $top_tpr -ekr ekrot.xvg
echo 'Protein' 'Protein' | gmx rms  -f $aligned_xtc  -s $top_tpr -o rmsd.xvg
echo 'Protein' | gmx gyrate -f $aligned_xtc  -s $top_tpr -o gyrate.xvg


function mv_comment(){
	_temp=${1}.tmp
	mv -v $1 $_temp
	grep -v '#' $_temp > $1
	echo -e "Done processing: ${1}"
}

mv_comment veloc.xvg 
nv_comment ektrans.xvg
nv_comment ekrot.xvg
nv_comment rmsd.xvg
nv_comment gyrate.xvg


# rerun
echo Protein | gmx convert-tpr -s  md_0_1.tpr -o md_0_1-convert.tpr
gmx mdrun -s md_0_1-convert.tpr -rerun 36240.trr -e md_0_1-convert.edr

# energy
gmx energy -f md_0_1-convert.edr -s md_0_1-convert.tpr -o energy.xvg
echo Potential | gmx energy -f md_0_1-convert.edr  -o energy.xvg
echo $(seq 1 12) | gmx energy -f md_0_1-convert.edr  -o all.xvg

# hbond
#ptions to specify output files:

#-o      [<.ndx>]           (hbond.ndx)
#          Index file that contains selected groups', acceptors', donors' and
#          hydrogens' indices and hydrogen bond pairs between or within
#          selected groups.
#-num    [<.xvg>]           (hbnum.xvg)      (Opt.)
#          Number of hydrogen bonds as a function of time.
#-dist   [<.xvg>]           (hbdist.xvg)     (Opt.)
#          Distance distribution of all hydrogen bonds.
#-ang    [<.xvg>]           (hbang.xvg)      (Opt.)
#          Angle distribution of all hydrogen bonds.
#-dan    [<.xvg>]           (hbdan.xvg)      (Opt.)
#          Number of donors and acceptors analyzed for each frame.

# hbond statistic
gmx hbond -s md_0_1-convert.tpr -f process/atom_rottrans.xtc  \
	-o hbond.ndx \
	-num hbond_num.xvg  \
	-dist hbdist.xvg \
	-ang hbang.xvg \
	-dan hbdan.xvg <<EOF
	Protein
	protein
EOF

# hbond for each frame
gmx hbond -s md_0_1-convert.tpr -f process/atom_rottrans.xtc  \
	-o hbond_1_ns.ndx \
	-num hbond_num_1_ns.xvg  \
	-tu ns \
	-b 1 \
	-e 1 <<EOF
	Protein
	Protein
EOF

function save_hbond_info_frame(){

	gmx hbond -s md_0_1-convert.tpr -f process/atom_rottrans.xtc  \
	-o hbond_${1}_ns.ndx \
	-num hbond_num_${1}_ns.xvg  \
	-tu ns \
	-b ${1} \
	-e ${1} <<EOF
	Protein
	Protein
EOF

}

# extract all 
mkdir hbond_for_frame
for i in $(seq 1 36240);
do
	save_hbond_info_frame $i;
	mv hbond_${i}_ns.ndx hbond_for_frame;
	mv hbond_num_${i}_ns.xvg hbond_for_frame;
done;

