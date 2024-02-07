from rdkit import Chem
from rdkit.Chem import AllChem

# Define your SMILES string
smiles_string = "CCO"

# Convert SMILES to RDKit molecule object
molecule = Chem.MolFromSmiles(smiles_string)

# Generate 3D coordinates
molecule = Chem.AddHs(molecule)
AllChem.EmbedMolecule(molecule)
molecule = Chem.RemoveHs(molecule)

# Write to SDF file
writer = Chem.SDWriter('output.sdf')
writer.write(molecule)
writer.close()

# use argparse to 