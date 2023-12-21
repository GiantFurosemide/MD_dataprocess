# select protein HEME OXY
#gmx select  -f MHPC_post_data_000400000_4.trr -s /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/gormacs/for_alpha_dynamic/out_2dh1_homo_100w/step4.1_equilibration.gro  -on index
#gmx trjconv -f MHPC_post_data_000400000_4.trr -s /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/gormacs/for_alpha_dynamic/out_2dh1_homo_100w/step4.1_equilibration.gro  -n index.ndx -o new_traj.trr
#gmx trjcat -f MHPC*.trr -o fixed.trr
gmx trjcat -f MHPC*.trr -o 1801_2000_ns.trr

# 转换pdb
gmx editconf -f input.gro -o output.pdb
gmx trjconv -s input.gro -f input.gro -o output.pdb
echo 0 | gmx trjconv -f {trr} -s {gro_name} -o {outname}
gmx trjcat -f xtc/*.xtc -o merged.xt

#编译topol
gmx grompp -c step4.1_equilibration.gro -f step5_production.mdp -p topol.top -n index.ndx -pp processed.top && mv -v processed.top processed.itp
gmx grompp -c step6.6_equilibration.gro -f step7_production.mdp -p topol.top -n index.ndx -pp processed.top && mv -v processed.top processed.itp
gmx grompp -c replica_1/results/npt/bpt_ab.gro -f mdp/md_prod.mdp -p topol.top -pp processed.top

#可以选择 某些group来输出 center 加 nojump
echo 1 0|gmx trjconv -f merged.xtc -s step4.1_equilibration.gro -pbc nojump -center -o nojump.xtc
#可以选择 某些group来输出 来center 和 align ; 1 1 0 protein protein system
echo 1 1 0|gmx trjconv -f nojump.xtc -s step4.1_equilibration.gro  -center -o nojump_rottrans.xtc -fit rot+trans && rm -v nojump.xtc
#gmx trjconv -f merged.xtc -s step4.1_equilibration.gro -pbc cluster -center -o cluster.xtc
gmx editconf -f input.gro -n atom_indices.ndx -o output.gro
#gmx editconf -f step4.1_equilibration.gro -n protein_heme_oxy.ndx -o protein_heme_oxy.gro

# 取0-20ns的xtc
gmx trjconv -f 2dn1_test.xtc -o 2dn1_test_10.xtc -b 0 -e 20000 -skip 1

# 分为pdb
gmx trjconv -f input.xtc -s input.gro -o output_.pdb -sep

superpose /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/final_out/case_Art_2DN2_100_eqNPT_20230731_20230802/md_post_output/splt_pdbs/2DN2_protein_*.pdb -s -all /Users/muwang/Documents/pdbstructure/2dn1.pdb -s -all -o  out.pdb > ss.log
for i in /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/final_out/case_Art_2DN2_100_eqNPT_20230731_20230802/md_post_output/splt_pdbs/2DN2_protein_*.pdb;do superpose $i -s -all /Users/muwang/Documents/pdbstructure/2dn1.pdb -s -all -o  out.pdb >> ss.log;done

# pymol

select clear_O2 , /C936/APP and not (/C936/APP within 5 of (/C936/A or /C936/B or /C936/C or /C936/D))
create newall, /C936 and not (/C936/APP and not clear_O2 )

##
gmx editconf -f step3_input.pdb -o step3_input.gro 

##
gmx trjcat -f ./*.trr -o ../merged.trr

## atom 
cp -v npt_ab.gro step4.1_equilibration.gro
cp -v step6.6_equilibration.gro step4.1_equilibration.gro
echo 1 q|gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx
#ABL1 deshaw
#echo '[ center ]\n 2459' >> index_sel.ndx
#JNK2
#echo '[ center ]\n 2420' >> index_sel.ndx
#echo '[ center ]\n 6359' >> index_sel.ndx
echo '[ center ]\n 5145' >> index_sel.ndx 
#echo '[ center ]\n 3472' >> index_sel.ndx
echo 0 | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole.xtc -pbc whole
echo 18 0 |gmx trjconv -f whole.xtc -s  step4.1_equilibration.gro -n index_sel.ndx -o atom.xtc -pbc atom  -center
# least squares fit:protein; center:protein
echo 1 1 0|gmx trjconv  -s  step4.1_equilibration.gro -f atom.xtc -fit rot+trans  -center -o atom_rottrans.xtc
rm -rfv atom.xtc


##########################################################################################
## atom pbc ONLY protein 
##########################################################################################
cp -v npt_ab.gro step4.1_equilibration.gro
cp -v step6.6_equilibration.gro step4.1_equilibration.gro
echo 1 q|gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx
echo 1 | gmx trjconv -f step4.1_equilibration.gro -s  step4.1_equilibration.gro -o npt_ab_protein.gro 
MIDDLE_LINE_NUMBER=$(($(cat npt_ab_protein.gro | wc -l)/2))

# initilize the value of CENTER_ATOM_NUMBER
CENTER_ATOM_NUMBER=0
while true; do
    echo "> Please enter a atom ID you want to center with"
    echo "> if you enter -1, i will use the atom ID in the middel of gro file."
    read CENTER_ATOM_NUMBER

    # 使用正则表达式检查输入是否为数字
    if [[ $CENTER_ATOM_NUMBER =~ ^[0-9]+$ ]]; then
        echo "You entered: $CENTER_ATOM_NUMBER"
        break  # 跳出循环，输入有效
    else
        echo "Error: Please enter a valid number."
    fi
done

# 检查CENTER_ATOM_NUMBER的值是否为-1
if [ "$CENTER_ATOM_NUMBER" -eq -1 ]; then
    # 如果是，将MIDDLE_LINE_NUMBER的值赋给CENTER_ATOM_NUMBER
    CENTER_ATOM_NUMBER=$MIDDLE_LINE_NUMBER

    # 输出最终的CENTER_ATOM_NUMBER的值
    echo "Final CENTER_ATOM_NUMBER is: $CENTER_ATOM_NUMBER"
else
    # 如果CENTER_ATOM_NUMBER的值不是-1，直接输出其值
    echo "CENTER_ATOM_NUMBER is not -1，is: $CENTER_ATOM_NUMBER"
fi
echo "[ center ]\n $CENTER_ATOM_NUMBER" >> index_sel.ndx 
echo 1 | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole.xtc -pbc whole
gmx trjconv -f whole.xtc -s  npt_ab_protein.gro -n index_sel.ndx -o atom.xtc -pbc atom  -center
echo 1|gmx trjconv -f atom.xtc -s  npt_ab_protein.gro -o whole_atom_1atomcenter_nojump.xtc -pbc nojump 
rm -rfv whole_atom_1atomcenter.xtc
# least squares fit:protein; center:protein
echo 1 1 1|gmx trjconv  -s  npt_ab_protein.gro -f whole_atom_1atomcenter_nojump.xtc -fit rot+trans  -center -o atom_rottrans.xtc
rm -rfv atom.xtc
rm -rfv whole_atom_1atomcenter_nojump.xtc
rm -rfv whole.xtc
echo "Final CENTER_ATOM_NUMBER is: $CENTER_ATOM_NUMBER"
##########################################################################################
# atom pbc ONLY protein END
##########################################################################################


# whole -> atom -> nojump -> rot+trans 
# FOR ALL ATOMs
cp -v npt_ab.gro step4.1_equilibration.gro
cp -v step6.6_equilibration.gro step4.1_equilibration.gro
echo 1 q|gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx
echo '[ center ]\n 2420' >> index_sel.ndx
# summery
# 1 whole protein 
# no
echo 0| gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole.xtc -pbc whole
# 8 whole protein atom sel 1 center
# yes
echo 19 0|gmx trjconv -f whole.xtc -s  step4.1_equilibration.gro -o whole_atom_1atomcenter.xtc -pbc atom -center -n index_sel.ndx
rm -rfv whole.xtc
# 13 based on #8 nojump
# yes
echo 0|gmx trjconv -f whole_atom_1atomcenter.xtc -s  step4.1_equilibration.gro -o whole_atom_1atomcenter_nojump.xtc -pbc nojump 
rm -rfv whole_atom_1atomcenter.xtc
# least squares fit:protein; center:protein
echo 1 1 0|gmx trjconv  -s  step4.1_equilibration.gro -f whole_atom_1atomcenter_nojump.xtc -fit rot+trans  -center -o allatoms_rottrans.xtc
rm -rfv whole_atom_1atomcenter_nojump.xtc


# whole -> atom -> nojump -> rot+trans 
# FOR protein
cp -v npt_ab.gro step4.1_equilibration.gro
cp -v step6.6_equilibration.gro step4.1_equilibration.gro
echo 1 q|gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx
echo '[ center ]\n 2420' >> index_sel.ndx
# summery
# 1 whole protein 
# no
echo 1| gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole_protein.xtc -pbc whole
# 8 whole protein atom sel 1 center
# yes
echo 19 1|gmx trjconv -f whole_protein.xtc -s  step4.1_equilibration.gro -o whole_protein_atom_1atomcenter.xtc -pbc atom -center -n index_sel.ndx
rm -rfv whole_protein.xtc
# 13 based on #8 nojump
# yes
echo 1|gmx trjconv -f whole_protein_atom_1atomcenter.xtc -s  step4.1_equilibration.gro -o whole_protein_atom_1atomcenter_nojump.xtc -pbc nojump 
rm -rfv whole_protein_atom_1atomcenter.xtc
# least squares fit:protein; center:protein
echo 1 1 1|gmx trjconv  -s  step4.1_equilibration.gro -f whole_protein_atom_1atomcenter_nojump.xtc -fit rot+trans  -center -o protein_rottrans.xtc
rm -rfv whole_protein_atom_1atomcenter_nojump.xtc


# pbc whole
echo 0 | gmx trjconv -f atom_rottrans.xtc -s  step4.1_equilibration.gro -n index_sel.ndx -o atom_rottrans_whole.xtc -pbc whole  
echo 0 | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -n index_sel.ndx -o merge_whole.xtc -pbc whole

# 
gmx grompp -f NVT.mdp -c t1_full_t6.gro -p t1_full_t6_pp.top -o SYS.tpr 
gmx trjconv -f merged.xtc -s SYS.tpr -o PBC_whole_1.xtc -tu ns -dt 10 -pbc whole 


#2420

## atom 
cp -v npt_ab.gro step4.1_equilibration.gro
cp -v step6.6_equilibration.gro step4.1_equilibration.gro
echo 1 q|gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx
echo '[ center ]\n 1' >> index_sel.ndx
echo 18 0 |gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -n index_sel.ndx -o atom.xtc -pbc atom  -center
echo 1 1 0|gmx trjconv  -s  step4.1_equilibration.gro -f atom.xtc -fit rot+trans  -center -o atom_rottrans.xtc
rm -rfv atom.xtc


##
mkdir coor_nc log_txt && mv -v ./*/*.trr coor_nc/ && mv -v ./*/*_log.txt log_txt/

## chimerax
mmaker #52-55/A:37,38,41 to #63:37,38,41
mmaker #3,5:37,38,41 to #63:37,38,41
view #1:37,38,41
show  #52-56/A:37,38,41 target a
show  #1,3,5:37,38,41 target a
show  #1,3,5:97 target a
show  #52-55/D:97 target a
##pymol
alter sel, segi='A'

# chimerax RMSF top25
show #64/A:16,17 target a ; color #64/A:16,17 red target a
show #64/B:46,82,47,49,146,53,50 target a ; color #64/B:46,82,47,49,146,53,50 red target a
show #64/C:48,47,49,50 target a ; color #64/C:48,47,49,50 red target a
show #64/D:47,49,48,44,50,5,45,146,4,43,6 target a ; color #64/D:47,49,48,44,50,5,45,146,4,43,6 red target a

# chimerax delta-RMSF top25
show #64/A:16,17 target a ; color #64/A:16,17 red target a 
show #64/B:46,82,146 target a ; color #64/B:46,82,146 red target a
show #64/C:48,47 target a ; color #64/C:48,47 red target a
show #64/D:5,4,2,6,3,94,9,8,90,95,93,146,145,144,12,91,143,89 target a ; color #64/D:5,4,2,6,3,94,9,8,90,95,93,146,145,144,12,91,143,89 red target a

# chimerax RMSF down25
show #64/A:28,29,32,62,97,98,99,100,101,102,103,104,105,106,107,108 target a;color #64/A:28,29,32,62,97,98,99,100,101,102,103,104,105,106,107,108 orange target a
show #64/B:27,106,107,108,109,110,111,112,113 target a ; color #64/B:27,106,107,108,109,110,111,112,113  orange target a
hide #64/A:28,29,32,62,97,98,99,100,101,102,103,104,105,106,107,108 target a
hide #64/B:27,106,107,108,109,110,111,112,113 target a

# chimerax delta RMSF down25
show #64/A:25,29,41,76,80,81,84,94,97,99,101,102,103,134,138 target a;color #64/A:25,29,41,76,80,81,84,94,97,99,101,102,103,134,138 orange target a
show #64/B:22,23,73 target a;color #64/B:22,23,73 orange target a
show #64/C:9,10,70,76,77,80,82 target a;color #64/C:9,10,70,76,77,80,82 orange target a

# chimerax color 
show #1/A:66,98,101,129,132,62,102,105,65 target a;color #1/A:66,98,101,129,132,62,102,105,65 orange target a

# parallec rrcs
parallel --jobs 8 "python /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/RRCS_hemoglobin.py -f {} -o {.}_rrcs.csv -s protein" ::: ./*.pdb
parallel --jobs 8 "python /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/RRCS_chage.py {}" ::: ./*.pdb

gmx mdmat -f /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/final_out/case_Art_2DN2_100_eqNPT_20230731_20230802_合并/merged1250.xtc  -s /Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/final_out/case_Art_2DN2_100_eqNPT_20230731_20230802_合并/step4.1_equilibration.gro
gmx cluster -f merged1250.xtc -s step4.1_equilibration.gro