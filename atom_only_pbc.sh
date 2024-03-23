##########################################################################################
## atom pbc ONLY protein 
##########################################################################################

echo -e "##################################################"
echo -e " start executing atom_only_pbc.sh"
echo -e "##################################################"

cp -v npt_ab.gro step4.1_equilibration.gro
cp -v step6.6_equilibration.gro step4.1_equilibration.gro

gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx << EOF
1
q
EOF

echo 1 | gmx trjconv -f step4.1_equilibration.gro -s  step4.1_equilibration.gro -o npt_ab_protein.gro 
MIDDLE_LINE_NUMBER=$(($(cat npt_ab_protein.gro | wc -l)/2))

# initilize the value of CENTER_ATOM_NUMBER
CENTER_ATOM_NUMBER=0
while true; do
    echo "> Please enter a atom ID you want to center with"
    echo "> if you enter -1, i will use the atom ID in the middle of gro file."
    read CENTER_ATOM_NUMBER

    # 使用正则表达式检查输入是否为数字
    if [[ $CENTER_ATOM_NUMBER =~ ^[0-9]+$ ]]; then
        echo "You entered: $CENTER_ATOM_NUMBER"
        break  # 跳出循环，输入有效
    elif [[ "$CENTER_ATOM_NUMBER" -eq -1 ]]; then
        echo "You entered: $CENTER_ATOM_NUMBER"
        break
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
    echo "CENTER_ATOM_NUMBER is not -1, is: $CENTER_ATOM_NUMBER"
fi
echo "[ center ]" >> index_sel.ndx 
echo "$CENTER_ATOM_NUMBER" >> index_sel.ndx 
echo 1 | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole.xtc -pbc whole
gmx trjconv -f whole.xtc -s  npt_ab_protein.gro -n index_sel.ndx -o atom.xtc -pbc atom  -center
echo 1|gmx trjconv -f atom.xtc -s  npt_ab_protein.gro -o whole_atom_1atomcenter_nojump.xtc -pbc nojump 
rm -rfv whole_atom_1atomcenter.xtc
# least squares fit:protein; center:protein
echo 1 1 1|gmx trjconv  -s  npt_ab_protein.gro -f whole_atom_1atomcenter_nojump.xtc -fit rot+trans  -center -o atom_rottrans_nojump.xtc
echo 1 1 1|gmx trjconv  -s  npt_ab_protein.gro -f atom.xtc -fit rot+trans  -center -o atom_rottrans.xtc

#rm -rfv whole.xtc
#rm -rfv atom.xtc
rm -rfv whole_atom_1atomcenter_nojump.xtc
echo "\n\n\n#################################"
echo "Final CENTER_ATOM_NUMBER is: $CENTER_ATOM_NUMBER"
echo "#################################"

echo -e "##################################################"
echo -e " atom_only_pbc.sh executed successfully!"
echo -e "##################################################"
##########################################################################################
# atom pbc ONLY protein END
##########################################################################################
