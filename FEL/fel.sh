#!/bin/bash

# GROMACS PCA and Gibbs free energy calculation script
# Ensure the required files (merged_fit.xtc, step4.1_equilibration.gro, topol.tpr£¬xpm2txt.py) are in the same directory.

# Step 1: Generate covariance matrix and eigenvectors
gmx covar -s step4.1_equilibration.gro -f merged_fit.xtc -o eigenvalues.xvg -v eigenvectors.trr -xpma covapic.xpm << EOF

# Step 2: Project onto the first principal component
gmx anaeig -s topol.tpr -f merged_fit.xtc -v eigenvectors.trr -first 1 -proj pc1.xvg

# Step 3: Project onto the second principal component
gmx anaeig -s topol.tpr -f merged_fit.xtc -v eigenvectors.trr -first 2 -last 2 -proj pc2.xvg

# Step 4: Extract PC2 values and combine PC1 and PC2 into a single input file for SHAM
awk '{print $2}' pc2.xvg > pc2_values.txt
paste pc1.xvg pc2_values.txt > gsham_input.xvg

# Step 5: Perform SHAM analysis to calculate Gibbs free energy
gmx sham -f gsham_input.xvg -ls FES.xpm

# Step 6: Convert the FES.xpm to a readable text file
python2.7 xpm2txt.py -f FES.xpm -o free-energy-landscape.txt

echo "Analysis complete. Check free-energy-landscape.txt for results."