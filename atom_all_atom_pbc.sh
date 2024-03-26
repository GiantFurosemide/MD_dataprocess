echo -e "##################################################"
echo -e " start executing atom_all_atom_pbc.sh"
echo -e "##################################################"


gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx << EOF
1
q
EOF

# todo: need to pick atom for making index file

echo System | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole_all.xtc -pbc whole
echo center System | gmx trjconv -f whole_all.xtc -s step4.1_equilibration.gro -n index_sel.ndx -o atom_all.xtc -pbc atom  -center
echo C-alpha C-alpha System | gmx trjconv  -s step4.1_equilibration.gro -f atom_all.xtc -fit rot+trans  -center -o atom_rottrans_all.xtc

rm -rfv whole_all.xtc
rm -rfv atom_all.xtc

echo -e "##################################################"
echo -e " atom_all_atom_pbc.sh executed successfully!"
echo -e "##################################################"