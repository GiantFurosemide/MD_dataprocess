
import MDAnalysis
from MDAnalysis.analysis.pca import PCA
from sklearn.cluster import KMeans
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import patheffects
import os

# INPUT

gro = "protein.gro"
trajectory = "atom_rottrans_all_protein_fit.xtc"
n_clusters = 2  # number of clusters for kmeans
output_dir = "cluster_frames"

############################################################################
# Create output directory
if not os.path.exists(output_dir):
    os.makedirs(output_dir)




# Load the trajectory
universe = MDAnalysis.Universe(gro, trajectory)
universe.trajectory[0]


# PCA

pca = PCA(universe,select='protein and name CA').run()
n_pcs = np.where(pca.results.cumulated_variance > 0.95)[0][0]
atomgroup = universe.select_atoms('protein and name CA')
pca_space = pca.transform(atomgroup, n_components=n_pcs) # 每个frame对应的pca

# KMeans

# kmeans 可视化
kmeans = KMeans(n_clusters=n_clusters, random_state=0).fit(pca_space[:,0:2]) # select the first two PCs
fig, ax = plt.subplots()
ax.scatter(pca_space[:,0], pca_space[:,1], c=kmeans.labels_)
ax.set_xlabel('PC1')
ax.set_ylabel('PC2')


#kmeans.labels_ # 包含每个样本所属簇的标签
cluster_frames = [[] for i in range(kmeans.n_clusters)] # 每个样本所属簇的标签
for i, label in enumerate(kmeans.labels_):
    cluster_frames[label].append(i)




# find the frame which with the smallest distance to all the other frames in the same cluster
cluster_centroids = list(kmeans.cluster_centers_)


# 计算每个簇的中心点
cluster_mean_coords = list(kmeans.cluster_centers_)


# 计算每个簇的中心点对应的frame
cluster_centroids = [] #对应的frame
for cluster, mean_coord in zip(cluster_frames, cluster_mean_coords):
    distances = [np.linalg.norm(pca_space[frame][0:2] - mean_coord)
                 for frame in cluster]
    centroid_frame = cluster[np.argmin(distances)]
    cluster_centroids.append(centroid_frame)


#print(cluster_centroids)
# color the centroids aas red trangles and print the frame number label on the plot
for i, centroid in enumerate(cluster_centroids):
    ax.plot(pca_space[centroid, 0], pca_space[centroid, 1], 'r^')
    ax.text(pca_space[centroid, 0]+0.5, pca_space[centroid, 1]+0.5, f"frame_{str(centroid)}", fontsize=12,
            path_effects=[patheffects.withStroke(linewidth=2, foreground='w')])

# plot first frame as blue star
ax.plot(pca_space[0, 0], pca_space[0, 1], 'r*')
ax.text(pca_space[0, 0]+0.5, pca_space[0, 1]+0.5, f"ref_frame_0", fontsize=12,
        path_effects=[patheffects.withStroke(linewidth=2, foreground='w')])


#plt.show()
plt.savefig(os.path.join(output_dir, 'pca_kmeans.png'))

print(f"save the plot as {os.path.join(output_dir, 'pca_kmeans.png')}")

# save frame in cluster_centroid to a pdb file
for i, frame in enumerate(cluster_centroids):
    universe.trajectory[frame]
    universe.atoms.write(os.path.join(output_dir, f"cluster_{i}.pdb"))
    print(f"save the frame in cluster_{i} to {os.path.join(output_dir, f'cluster_{i}.pdb')}")

# convert input gro to pdb as reference
universe_ref = MDAnalysis.Universe(gro)
universe_ref.atoms.write(os.path.join(output_dir, "reference.pdb"))
print(f"save the reference structure to {os.path.join(output_dir, 'reference.pdb')}")

# save pca space to a csv file, each row is a frame, each column is a PC
np.savetxt(os.path.join(output_dir, "pca_space.csv"), pca_space, delimiter=",")
print(f"save the pca space to {os.path.join(output_dir, 'pca_space.csv')}")