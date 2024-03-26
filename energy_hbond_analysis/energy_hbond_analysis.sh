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
	echo -e "Done processing: ${2}"
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

#############################
# deal with all 106 us data #
#############################

echo Protein | gmx convert-tpr -s  md_0_1.tpr -o md_0_1-convert.tpr
gmx mdrun -s md_0_1-convert.tpr -rerun coor_nc/all_protein.trr -e md_0_1-convert.edr
echo $(seq 1 12) | gmx energy -f md_0_1-convert.edr  -o all_protein_energy.xvg

mkdir truncation_trj
function extract_frames(){
	# extract_frames time1 time2 in ns
	gmx trjconv \
	-s md_0_1-convert.tpr \
	-f coor_nc/all_protein.trr  \
	-tu ns \
	-b $1 \
	-e $2  \
	-o truncation_trj/all_protein_frame_${1}_${2}.trr <<EOF
	Protein
EOF
}

extract_frames 1 36591
extract_frames 36608 74015
extract_frames 74032 80191
extract_frames 80208 106032

gmx trjcat -f truncation_trj/*.trr -o all_protein_truncated.trr
#truncation_trj/all_protein_frame_1_36591.trr*
#truncation_trj/all_protein_frame_36608_74015.trr*
#truncation_trj/all_protein_frame_74032_80191.trr*
#truncation_trj/all_protein_frame_80208_106032.trr*
gmx mdrun -s md_0_1-convert.tpr -rerun all_protein_truncated.trr -e md_0_1-convert.edr -gpu_id 1
echo $(seq 1 12) | gmx energy -f md_0_1-convert.edr  -o all_protein_energy_truncated.xvg

########################
# energy for all atoms
########################

# tutorial of "energy group":https://www.alexkchew.com/tutorials/using-energy-groups-in-gromacs

gmx dump -s md_0_1-convert.tpr -om md_0_1-convert.mdp

# 166 atom 
atom_id=1
gmx make_ndx -f md_0_1.tpr -o energy_group_index.ndx << INPUT
a ${atom_id}
name 17 sel_atom_energy
q
INPUT



function mdp_add_energy_groups () 

{ 

    input_mdp_file_="$1";

    output_mdp_file_="$2";

    energy_groups_="$3";

    cp -r "${input_mdp_file_}" "${output_mdp_file_}";

    echo "" >> "${output_mdp_file_}";

    echo "; ENERGY GROUPS " >> "${output_mdp_file_}";

    echo "energygrps          = ${energy_groups_}" >> "${output_mdp_file_}";

    echo "----- mdp_add_energy_groups -----";

    echo "--> Created ${output_mdp_file_} from ${input_mdp_file_}";

    echo "--> Added energy groups: ${energy_groups_}"

}

mdp_add_energy_groups "md_0_1-convert.mdp" "md_0_1-convert_energy_group.mdp" "sel_atom_energy"

#gmx grompp -f md_0_1-convert_energy_group_change.mdp -c md_0_1-convert.tpr  -o md_0_1-convert_energy_group.tpr -n energy_group_index.ndx -maxwarn 5 -p processed.top
gmx grompp -f md_0_1-convert_energy_group_change.mdp -c md_0_1.tpr  -o md_0_1_energy_group.tpr -n energy_group_index.ndx -maxwarn 20 -p processed.top

echo Protein | gmx convert-tpr -s  md_0_1_energy_group.tpr -o md_0_1_energy_group-protein.tpr
gmx mdrun -s md_0_1_energy_group-protein.tpr -rerun all_protein_truncated.trr -e md_0_1_energy_group-protein.edr

echo $(seq 1 24) | gmx energy -f md_0_1_energy_group-protein.edr -o md_0_1_energy_group-protein.xvg


###########################
# then loop over all atoms
###########################
# 166 atom 

mkdir all_atom_energy
cd all_atom_energy
cp ../md_0_1.tpr .
cp ../processed.top .
cp ../md_0_1-convert_energy_group_change.mdp .

echo "energy log" > runme.log
for i in  $(seq 1 166);
do
atom_id=$i
gmx make_ndx -f md_0_1.tpr -o energy_group_index_atom_${atom_id}.ndx << INPUT
a ${atom_id}
name 17 sel_atom_energy
q
INPUT

gmx grompp -f md_0_1-convert_energy_group_change.mdp -c md_0_1.tpr  -o md_0_1_energy_group_atom_${atom_id}.tpr -n  energy_group_index_atom_${atom_id}.ndx -maxwarn 20 -p processed.top
echo Protein | gmx convert-tpr -s  md_0_1_energy_group_atom_${atom_id}.tpr -o md_0_1_energy_group_atom_${atom_id}-protein.tpr
gmx mdrun -s md_0_1_energy_group_atom_${atom_id}-protein.tpr -rerun ../all_protein_truncated.trr -e md_0_1_energy_group_atom_${atom_id}-protein.edr
echo $(seq 1 24) | gmx energy -f md_0_1_energy_group_atom_${atom_id}-protein.edr -o md_0_1_energy_group_atom_${atom_id}-protein.xvg

echo md_0_1_energy_group_atom_${atom_id}-protein.xvg >> runme.log
done;

mkdir atom_energy_chignolin
mv md_0_1_energy_group_atom_*-protein.xvg atom_energy_chignolin