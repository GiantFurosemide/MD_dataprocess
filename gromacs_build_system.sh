grep -v HOH 1aki.pdb > 1AKI_clean.pdb
gmx pdb2gmx -f 1AKI_clean.pdb -o 1AKI_processed.gro -water spce
# choose 8 || 8: CHARMM27 all-atom force field (CHARM22 plus CMAP for proteins)
!gmx pdb2gmx -f 1fjs_protein.pdb -o 1fjs_processed.gro -water tip3p -ff "charmm27"
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
!gmx editconf -f 1fjs_processed.gro -o 1fjs_newbox.gro -c -d 1.0 -bt dodecahedron
!gmx solvate -cp 1fjs_newbox.gro -cs spc216.gro -o 1fjs_solv.gro -p topol.top