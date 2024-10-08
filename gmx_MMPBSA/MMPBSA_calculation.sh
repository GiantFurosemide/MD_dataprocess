




## 3. make index file
# make index operation file  (group 1-18, 19-36, 37-54, 1-36 is 0 18 19 20 start from 0)
# 1-36 as 'recepter'
# 37-54 as 'ligand'
function generate_index_operation {
    cat > index_operation.txt << EOF
ri 1-18 
ri 19-36 
ri 37-54
ri 1-36   
q

EOF
}

# make index file
function gro_make_index {
    echo -e "gmx make_ndx -f $1 -o index.ndx"
    gmx make_ndx -f $1 -o index.ndx < index_operation.txt
}

# make index file
function tpr_make_index {
    echo -e "gmx make_ndx -f $1 -o index.ndx"
    gmx make_ndx -f $1 -o index.ndx  < index_operation.txt 
}


## 4. convert gro to pdb
# convert gro to pdb
function gro2pdb {
    echo -e "gmx editconf -f $1 -o $(basename $1 .gro).pdb"
    gmx editconf -f $1 -o $(basename $1 .gro).pdb
}

function tpr2pdb {
    echo -e "gmx editconf -f $1 -o $(basename $1 .tpr).pdb"
    gmx editconf -f $1 -o $(basename $1 .tpr).pdb
}

## 5. prepare mmpbsa.in 
function prepare_mmpbsa_in {
cat > mmpbsa.in << EOF
#Sample input file for GB calculation
#This input file is meant to show only that gmx_MMPBSA works. Although, we tried to use the input files as recommended in the
#Amber manual, some parameters have been changed to perform more expensive calculations in a reasonable amount of time. Feel free to change the parameters
#according to what is better for your system.

&general
sys_name="Stability",
startframe=1,
endframe=1480,
interval=10,
keep_files=0,
/
&gb
igb=2, saltcon=0.150,
/
&pb
istrng=0.150,
/

EOF
}


############################################################################################################
# main

MMPBSA_IN_FILE=mmpbsa.in
COMPLEX_TPR=step4.1_equilibration.tpr
COMPLEX_XTC=atom_rottrans_all.xtc
COMPLEX_INDEX=index.ndx
RECPTEOR_LIGAND_INDEX='19 20'
COMPLEX_TOP=topol.top

MMPBSA_OUT_DAT=FINAL_RESULTS_MMPBSA.dat
MMPBSA_OUT_CSV=FINAL_RESULTS_MMPBSA.csv

generate_index_operation
tpr_make_index  $COMPLEX_TPR
prepare_mmpbsa_in
# 6. run mmpbsa calculation

conda activate gmxMMPBSA
unset PYTHONPATH
#unset LD_LIBRARY_PATH
echo -e "$PWD"
echo -e "gmx_MMPBSA -O -i $MMPBSA_IN_FILE -cs $COMPLEX_TPR -ct $COMPLEX_XTC -ci $COMPLEX_INDEX -cg $RECPTEOR_LIGAND_INDEX -cp $COMPLEX_TOP -o $MMPBSA_OUT_DAT -eo $MMPBSA_OUT_CSV -nogui"
mpirun -np 16 gmx_MMPBSA -O -i $MMPBSA_IN_FILE -cs $COMPLEX_TPR -ct $COMPLEX_XTC -ci $COMPLEX_INDEX -cg $RECPTEOR_LIGAND_INDEX -cp $COMPLEX_TOP -o $MMPBSA_OUT_DAT -eo $MMPBSA_OUT_CSV -nogui

conda deactivate