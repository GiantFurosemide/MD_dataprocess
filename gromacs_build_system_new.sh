# clean input structure
grep -v HETATM 2hhb_prepared.pdb > 2hhb_prepared_tmp.pdb
grep -v CONECT 2hhb_prepared_tmp.pdb > 2hhb_prepared_clean.pdb
grep MISSING input/1fjs.pdb

# Generating a topology
gmx pdb2gmx -f 2hhb_prepared.pdb -o 2hhb_prepared.gro -water tip3p -ff "charmm27"
#Select the Force Field:
#From '/usr/local/gromacs/share/gromacs/top':
# 1: AMBER03 protein, nucleic AMBER94 (Duan et al., J. Comp. Chem. 24, 1999-2012, 2003)
# 2: AMBER94 force field (Cornell et al., JACS 117, 5179-5197, 1995)
# 3: AMBER96 protein, nucleic AMBER94 (Kollman et al., Acc. Chem. Res. 29, 461-469, 1996)
# 4: AMBER99 protein, nucleic AMBER94 (Wang et al., J. Comp. Chem. 21, 1049-1074, 2000)
# 5: AMBER99SB protein, nucleic AMBER94 (Hornak et al., Proteins 65, 712-725, 2006)
# 6: AMBER99SB-ILDN protein, nucleic AMBER94 (Lindorff-Larsen et al., Proteins 78, 1950-58, 2010)
# 7: AMBERGS force field (Garcia & Sanbonmatsu, PNAS 99, 2782-2787, 2002)
# 8: CHARMM27 all-atom force field (CHARM22 plus CMAP for proteins)
# 9: GROMOS96 43a1 force field
#10: GROMOS96 43a2 force field (improved alkane dihedrals)
#11: GROMOS96 45a3 force field (Schuler JCC 2001 22 1205)
#12: GROMOS96 53a5 force field (JCC 2004 vol 25 pag 1656)
#13: GROMOS96 53a6 force field (JCC 2004 vol 25 pag 1656)
#14: GROMOS96 54a7 force field (Eur. Biophys. J. (2011), 40,, 843-856, DOI: 10.1007/s00249-011-0700-9)
#15: OPLS-AA/L all-atom force field (2001 aminoacid dihedrals)
gmx editconf -f 1fjs_processed.gro -o 1fjs_newbox.gro -c -d 1.0 -bt dodecahedron
gmx solvate -cp 1fjs_newbox.gro -cs spc216.gro -o 1fjs_solv.gro -p topol.top

# an empty ions.mdp is ok
touch ions.mdp
gmx grompp -f ions.mdp -c 1fjs_solv.gro -p topol.top -o ions.tpr
printf "SOL\n" | gmx genion -s ions.tpr -o 1fjs_solv_ions.gro -conc 0.15 -p topol.top -pname NA -nname CL -neutral
gmx grompp -f input/emin-charmm.mdp -c 1fjs_solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em
printf "Potential\n0\n" | gmx energy -f em.edr -o potential.xvg -xvg none
#!printf "Potential\n0\n" | gmx energy -f em.edr -o potential.xvg

# Equilibration run - temperature
gmx grompp -f input/nvt-charmm.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
gmx mdrun -ntmpi 1 -v -deffnm nvt
