# 1. cp_filter.sh

Description: cp .tpr, .xtc file to current work directory for next step MMPBSA calculation
input: an array of /path/to/512/data/processed. for example, '/media/muwang/My_Book/muwang/work/traj/Grain/Grain_LY15_0001_10w_20240925_194802/', in 'md_post_output' 
output: -

# 2. main.sh
Description: run batch MM-PBSA/GBSA calculation and prcocess logging. cp MMPBSA_calculation.sh to each data path and execute.

# 3. MMPBSA_calculation.sh
Description: script to calculate MM-PBSA/GBSA by gmx-PBSA ( a packege based on amber MMPBSA.py for gromacs format trajectory and topology file )
more information: https://valdes-tresanco-ms.github.io/gmx_MMPBSA/dev/

input:
	MMPBSA_IN_FILE=mmpbsa.in
	COMPLEX_TPR=step4.1_equilibration.tpr
	COMPLEX_XTC=atom_rottrans_all.xtc
	COMPLEX_INDEX=index.ndx
	RECPTEOR_LIGAND_INDEX='19 20'   // index start from 0
	COMPLEX_TOP=topol.top
	MMPBSA_OUT_DAT=FINAL_RESULTS_MMPBSA.dat
	MMPBSA_OUT_CSV=FINAL_RESULTS_MMPBSA.csv
	( update atoms selection phrase in function generate_index_operation)

output:
	FINAL_RESULTS_MMPBSA.dat // output of MMPBSA.py, average energy items of 'complex' 'protein' 'ligand' 'DeltaTOTAL'
	FINAL_RESULTS_MMPBSA.csv // energy items for each frames

# 4. other_stability_related_analysis_script/
Description: scripts for batch calculation/visualization of RMSD/hbond, and extract deltaTOTAL from FINAL_RESULTS_MMPBSA.dat