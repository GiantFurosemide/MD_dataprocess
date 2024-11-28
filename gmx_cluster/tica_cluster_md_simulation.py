# use mdtraj, pyemma(pca,tica), matplotlib to visualize the cluster
# input:
# 1. trajectory file


import MDAnalysis as mda
import pyemma
import numpy as np
import matplotlib.pyplot as plt
from pyemma.util.contexts import settings
import os

class TICAClusterAnalysis:
    def __init__(self, traj_path, top_path, output_dir='output'):
        """
        Initialize the TICA clustering analysis
        
        Parameters:
        -----------
        traj_path : str or list
            Path to trajectory file(s) or list of paths
        top_path : str
            Path to topology file
        output_dir : str
            Directory for saving results
        """
        self.traj_path = traj_path if isinstance(traj_path, list) else [traj_path]
        self.top_path = top_path
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)
        
    def load_trajectory(self):
        """Load trajectory files and align to alpha carbons"""
        self.u = [mda.Universe(self.top_path, traj) for traj in self.traj_path]
        print(f"Loaded {len(self.u)} trajectory files")
        
        
    def calculate_features(self):
        """Calculate backbone torsions as features"""
        feat = pyemma.coordinates.featurizer(self.top_path)
        feat.add_backbone_torsions()
        self.data = pyemma.coordinates.load(self.traj_path, features=feat)
        
    def perform_tica(self, lag=10, dim=2):
        """
        Perform TICA dimensionality reduction
        
        Parameters:
        -----------
        lag : int
            Lag time in frames
        dim : int
            Number of TICA dimensions to keep
        """
        self.tica = pyemma.coordinates.tica(self.data, lag=lag, dim=dim)
        self.tica_output = self.tica.get_output()
        
    def cluster_data(self, n_clusters=5):
        """
        Perform k-means clustering on TICA-transformed data
        
        Parameters:
        -----------
        n_clusters : int
            Number of clusters
        """
        self.kmeans = pyemma.coordinates.cluster_kmeans(
            self.tica_output, 
            k=n_clusters, 
            max_iter=50
        )
        self.cluster_centers = self.kmeans.get_output()
        
    def plot_tica_space(self):
        """Plot data points in TICA space colored by cluster assignment"""
        plt.figure(figsize=(10, 8))
        scatter = plt.scatter(
            self.tica_output[0][:, 0],
            self.tica_output[0][:, 1],
            c=self.cluster_centers[0],
            cmap='viridis',
            alpha=0.5
        )
        plt.colorbar(scatter, label='Cluster')
        plt.xlabel('TIC 1')
        plt.ylabel('TIC 2')
        plt.title('TICA projection with cluster assignments')
        plt.savefig(os.path.join(self.output_dir, 'tica_clusters.png'))
        plt.close()
        
    def run_analysis(self, lag=10, dim=2, n_clusters=5):
        """Run the complete analysis pipeline"""
        self.load_trajectory()
        self.calculate_features()
        self.perform_tica(lag=lag, dim=dim)
        self.cluster_data(n_clusters=n_clusters)
        self.plot_tica_space()
        
if __name__ == "__main__":
    # Example usage
    traj_path = "trajectory.xtc"  # Replace with your trajectory file
    top_path = "topology.pdb"     # Replace with your topology file
    
    analysis = TICAClusterAnalysis(traj_path, top_path)
    analysis.run_analysis(lag=10, dim=2, n_clusters=5)