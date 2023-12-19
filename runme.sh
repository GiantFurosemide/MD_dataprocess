#step1_pdbreader.pdb
#topol.top
#toppar

# seperate into protein and lig 
# 不需要重置top gmx pdb2gmx -f step1_pdbreader_protein.pdb -o step1_pdbreader_processed_protein.gro -ter
# gmx editconf -f step1_pdbreader.pdb -o step1_pdbreader.gro -bt cubic -box 210
# 注意 -box 单位是nm 所以210-> 21
gmx editconf -f step1_pdbreader.pdb -o step1_pdbreader_newbox210.gro -bt cubic -box 21.85
gmx editconf -f step1_pdbreader.pdb -o step1_pdbreader_newbox98.gro -bt cubic -box 10.5
# add water
# 	the “-water spce” in pdb2gmx is optional, please use spc216.gro for all three-points water models, tip4p.gro for four-points water models
# 	and tip5p for five-points water models
gmx solvate -cp step1_pdbreader_newbox210.gro -cs spc216.gro -p topol.top -o step1_pdbreader_newbox210_solv.gro
gmx solvate -cp step1_pdbreader_newbox98.gro -cs spc216.gro -p topol.top -o step1_pdbreader_newbox98_solv.gro