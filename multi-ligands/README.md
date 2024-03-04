# Scripts Instruction

## ligand_info _prepare.py

Will generate ligand info files: ligand_config.sh, generate_pure_protein_pdb.sh

and a directory: ligand_info/

ligand_config.sh, generate_pure_protein_pdb.sh and ligand_info/ will be called by mdbuild_add_multi_ligands.sh

## mdbuild_add_multi_ligands.sh

A script to build md system and complete minimization/equilibruim/production/analysis.

Update gromacs\md system\HPC parameters in this script before building.

## mdbuild_add_one_ligand.sh

Previous version for one ligand MD system building.

# Usage

```bash
# usage for md system building 

# 1. update ligand information in ligand_info_prepare.py,
# then generate ligand info related scripts for mdbuild_add_multi_ligands.sh
python ligand_info_prepare.py

# 2. update MD simulation parameters in mdbuild_add_multi_ligands.sh
# the script will build md system and complete minimization/equilibruim/production/analysis  
source mdbuild_add_multi_ligands.sh

```


# TODO

Modulize gromacs\md system\HPC parameters in a new configure file.
