# Load the molecule
mol new step4.1_equilibration.gro

# Change display method to orthographic
display projection Orthographic

# Create representation by expression "protein" and change "draw method" to "NewCartoon"
mol representation NewCartoon 
mol selection {protein}
mol addrep top

# Hide all representations
# mol delrep 0 top

# Save visualization state
save_state useme.vmd

# Load data to molecule
mol addfile atom_rottrans.xtc waitfor all
