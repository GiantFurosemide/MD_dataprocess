# MD_dataprocess

Backup MD data processing related scripts.

These scripts will do following tasks in order:

1. convert gromacs .trr files to .xtc files, and merge into 'merge.xtc'.
2. extract Atom Group ‘protein’ from original .gro file to a new file 'npt_ab_protein.gro' for subsequent processing.
3. periodic boundary condition treatment by methods:

* protocol1: whole->atom
* protocol2: whole->atom->nojumps

4. center & align and generate .xtc files

* protocol1: atom_rottrans.xtc
* protocol2: atom_rottrans_nojump.xtc

5. plot information in log files: temperature/pressure/kinetic/potential/viral/lbox
6. automate visualization by vmd tcl scripts.

## File description

### 1. md_process.sh

Main script. Copy post_process_mv.sh/trr2xtc.py/atom_only_pbc.sh/draw_log_plots.py/useme.tcl to work directory and execute processing protocol.

### 2. post_process_mv.sh

Move trr files to ./coor_nc, log files to ./log_txt.

### 3. trr2xtc.py

convert trr to xtc and merge all xtc files.

### 4. atom_only_pbc.sh

Deal with PBC in two protocols. Check atom index for PBC treatment and centering manually and interact with scripts. Output with Atom Group 'protein' by default, update this script for other types of entities.

### 5. useme.tcl

Visualization by vmd:

* Change display method to orthographic
* save visualization state to 'useme.vmd'
* load trajectory 'atom_rottrans.xtc'

### 6.draw_log_plots.py

Read log files in directory 'log_txt', plot temperature/pressure/kinetic/potential/viral/lbox

## Usage

1. updata variable SCRIPTS_DIR in md_process.sh to access to all neccesery scripts.
2. copy md_process.sh to data's directory, for example 'md_post_output', source it.
3. input initial gro file
4. input atom index for PBC treatment and centering.

## TODO

* update automatic center atom selection, for example by centroid.
* pbc nojump is not robust.
