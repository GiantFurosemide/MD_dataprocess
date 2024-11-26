#!/bin/bash

# cluster the protein structure by gmx cluster
# then visualize the cluster by pyemma

# Parse command line arguments
while getopts "s:f:" opt; do
    case $opt in
        s) structure="$OPTARG";;
        f) trajectory="$OPTARG";;
        *) echo "Invalid option: -$OPTARG" >&2
           exit 1;;
    esac
done

# Check if required arguments are provided
if [ -z "$structure" ] || [ -z "$trajectory" ]; then
    echo "Usage: bash gmx_cluster.sh -s <structure.gro> -f <trajectory.xtc>"
    exit 1
fi

# Create index file for protein
echo "Protein" | gmx make_ndx -f "$structure" -o protein.ndx

# Perform clustering
gmx cluster \
    -f "$trajectory" \
    -s "$structure" \
    -n protein.ndx \
    -method linkage \
    -cutoff 0.2 \
    -o clusters.xpm \
    -g cluster_groups.log \
    -cl clusters.pdb \
    << EOF
Protein
Protein
EOF

# Generate Python script for visualization
cat > visualize_clusters.py << 'EOF'
import pyemma
import matplotlib.pyplot as plt
import mdtraj as md

# Load clusters
clusters = md.load('clusters.pdb')

# Plot first 5 cluster representatives
fig, axes = plt.subplots(2, 3, figsize=(15, 10))
axes = axes.ravel()

for i in range(min(5, len(clusters))):
    clusters[i].save_pdb(f'cluster_{i+1}.pdb')
    axes[i].imshow(md.compute_rg(clusters[i]))
    axes[i].set_title(f'Cluster {i+1}')

plt.tight_layout()
plt.savefig('cluster_visualization.png')
EOF

# Run visualization
python visualize_clusters.py

echo "Clustering complete! Check clusters.pdb for structures and cluster_visualization.png for plots."

#bash gmx_cluster.sh -s step4.1_equilibration.gro -f atom_rottrans_all.xtc