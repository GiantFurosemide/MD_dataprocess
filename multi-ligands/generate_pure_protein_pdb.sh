
# python generate 
LIGAND_LETTER_LIST=(
    "AAA"
    "UNL"
    "LIG"
)
# should change RESNAME in ligand_NEW.pdb or in myprotein.pdb

for my_ligname_letter in ${LIGAND_LETTER_LIST[@]};
do 
    grep -v $my_ligname_letter receptor_tmp.pdb > receptor_tmp.pdb
done;
mv receptor_tmp.pdb receptor.pdb