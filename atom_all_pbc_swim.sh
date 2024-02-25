gmx make_ndx -f step4.1_equilibration.gro -o index_sel.ndx << EOF
1
q
EOF

echo "[ center ]" >> index_sel.ndx 
echo "2246" >> index_sel.ndx 

echo 0 | gmx trjconv -f merged.xtc -s  step4.1_equilibration.gro -o whole_all.xtc -pbc whole
echo 21 0 | gmx trjconv -f whole_all.xtc -s step4.1_equilibration.gro -n index_sel.ndx -o atom_all.xtc -pbc atom  -center
echo 3 3 0| gmx trjconv  -s step4.1_equilibration.gro -f atom_all.xtc -fit rot+trans  -center -o atom_rottrans_all.xtc

rm -rfv whole_all.xtc
rm -rfv atom_all.xtc