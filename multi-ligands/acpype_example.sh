# acpype by mol2
obabel -ipdb PP1-jligand.pdb -omol2 -h > PP1.mol2
acpype -i PP1.mol2

obabel -ipdb DAS-jligand.pdb -omol2 -h > DAS.mol2 
acpype -i DAS.mol2 -f

obabel -ipdb DAS-jligand.pdb -omol -h > DAS.sdf  
acpype -i DAS.sdf -f

# acpype by smile
#obabel -ismi smi/dasatinib.smi  -omol2 -h > DAS2.mol2 
acpype -i "$(cat smi/dasatinib.smi)" 