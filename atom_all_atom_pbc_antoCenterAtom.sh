##########################################################################################
## atom pbc ONLY protein 
##########################################################################################
#cp -v npt_ab.gro step4.1_equilibration.gro
#cp -v step6.6_equilibration.gro step4.1_equilibration.gro
#echo 1 q|gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx
gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx 
echo 1 | gmx trjconv -f step4.1_equilibration.gro -s  step4.1_equilibration.gro -o npt_ab_protein.gro 
MIDDLE_LINE_NUMBER=$(($(cat npt_ab_protein.gro | wc -l)/2))

# initilize the value of CENTER_ATOM_NUMBER
# Define the input file
input_file="npt_ab_protein.gro"
# Call the Python script and capture the output
center_atom_id=$(python Find_protein_center_atom_ID_v1.py)
# Output the center atom ID
echo "Center atom ID: $center_atom_id"
# Further processing can be added here if needed
echo "[ center ]" >> index_sel.ndx 
echo "$center_atom_id" >> index_sel.ndx 

echo 0 | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole.xtc -pbc whole -n index_sel.ndx 
echo 17 0 | gmx trjconv -f whole.xtc -s  npt_ab_protein.gro -n index_sel.ndx -o atom.xtc -pbc atom  -center
#echo 0|gmx trjconv -f atom.xtc -s  step4.1_equilibration.gro -o whole_atom_1atomcenter_nojump.xtc -pbc nojump 
#rm -rfv whole_atom_1atomcenter.xtc
# least squares fit:protein; center:protein
echo 1 1 0 | gmx trjconv  -s  step4.1_equilibration.gro -f atom.xtc -fit rot+trans  -center -o atom_rottrans.xtc -n index_sel.ndx
#echo 17 | gmx trjconv -f step4.1_equilibration.gro -s  step4.1_equilibration.gro -o npt_ab_protein_UNL.gro -n index_sel.ndx
#rm -rfv whole.xtc
#rm -rfv atom.xtc
#rm -rfv whole_atom_1atomcenter_nojump.xtc
echo "\n\n\n#################################"
echo "Final CENTER_ATOM_NUMBER is: $CENTER_ATOM_NUMBER"
echo "#################################"
##########################################################################################
# atom pbc ONLY protein END
##########################################################################################