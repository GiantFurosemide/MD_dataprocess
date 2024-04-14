# Load the molecule
mol new step4.1_equilibration.gro

# Change display method to orthographic
display projection Orthographic
color Display Background white
# Create representation by expression "protein" and change "draw method" to "NewCartoon"
# mol 0
mol representation NewCartoon 
mol selection {protein and not hydrogen}
mol addrep top

# mol 1 
mol representation VDW 
mol selection {resname UNL and not hydrogen}
mol addrep top

# mol 2 
mol representation VDW 
mol selection {resname LIG and not hydrogen}
mol addrep top

# mol 3 
mol representation VDW 
mol selection {resname MOL and not hydrogen}
mol addrep top

## mol 4
#mol representation Licorice 
#mol selection {resid 404 to 406}
#mol addrep top

mol modstyle 0 0 NewCartoon
#mol modcolor 5 0 ColorID 3
#mol modstyle 4 0 Licorice 0.300000 12.000000 12.000000

# Save visualization state
# save_state useme.vmd

# Hide all representations
# mol delrep 0 top

# Load data to molecule
mol addfile atom_rottrans.xtc waitfor all

# Save visualization state
save_state useme.vmd

#
menu rmsdtt on