
echo 0 | gmx trjconv -f merged.xtc -s  step6.6_equilibration.gro -o whole.xtc -pbc whole
gmx trjconv -f whole.xtc -s  step6.6_equilibration.gro -n index_sel.ndx -o atom.xtc -pbc atom  -center
echo 1 1 0 | gmx trjconv  -s  step6.6_equilibration.gro -f atom.xtc -fit rot+trans  -center -o atom_rottrans.xtc