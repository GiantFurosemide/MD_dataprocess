# acpype by mol2
obabel -ipdb DAS-jligand.pdb -omol2 -h > DAS.mol2 
acpype -i DAS.mol2 -f

# acpype by mol
obabel -ipdb DAS-jligand.pdb -omol -h > DAS.sdf  
acpype -i DAS.sdf -f

# acpype by smile, 
acpype -i 'CCCC' -b 'DAS'
acpype -i "$(cat smi/dasatinib.smi)" -b 'DAS'
