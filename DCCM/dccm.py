'''
######################################
Draw DCCM of (atom, residue, residue side chain, residue backbone) level

usage:
    python dccm.py -s step4.1_equilibration.gro -f atom_rottrans_all.xtc


input: 
    gro file: step4.1_equilibration.gro
    aligned xtc/trr: atom_rottrans_all.xtc
output:
    DCCM_atom.txt
    DCCM_atom.png
    DCCM_Residue.txt
    DCCM_residue.png
    DCCM_Residue_sidechain.txt
    DCCM_residue_sidechain.png
    DCCM_residue_backbone.txt
    DCCM_residue_backbone.png
#####################################
'''

# argparse
import argparse
parser = argparse.ArgumentParser(description='Draw DCCM of (atom, residue, residue side chain, residue backbone) level')
parser.add_argument('-s', '--topol', type=str, help='input gro file', required=True)
parser.add_argument('-f', '--traj', type=str, help='input xtc file', required=True)

args = parser.parse_args()
my_top_file = args.topol
my_xtc_file = args.traj

########################################################################################

import numpy as np
import MDAnalysis as mda
import matplotlib.pyplot as plt
import seaborn as sns

########################################################################################
# 1. atom level DCCM calculation
########################################################################################


# Load your trajectory and topology files

top_file = my_top_file 
xtc_file = my_xtc_file
u = mda.Universe(top_file, xtc_file)

# Select the atoms you want to include in the analysis
atoms = u.select_atoms('protein')

# Calculate the covariance matrix
cov_matrix = np.cov(atoms.positions.T, rowvar=False)

# Compute the DCCM
dccm = np.corrcoef(cov_matrix)

# Save or visualize the DCCM
np.savetxt('DCCM_atom.txt', dccm)


# 载入DCCM数据
dccm = np.loadtxt('DCCM_atom.txt')

# 创建热图
plt.figure(figsize=(10, 8))
sns.heatmap(dccm, cmap='coolwarm', center=0, square=True, cbar_kws={"shrink": .8})
plt.title('Dynamical Cross-Correlation Matrix (DCCM)')
plt.xlabel('Atom Index')
plt.ylabel('Atom Index')
# save plt
plt.savefig('DCCM_atom.png', dpi=300)
# plt.show()
plt.close()

########################################################################################
# 2. residue level DCCM calculation
########################################################################################


# 选择蛋白质的残基
residues = u.select_atoms('protein').residues

# 初始化残基中心坐标矩阵
residue_coords = np.zeros((len(residues), len(u.trajectory), 3))

# 计算每一帧的残基中心坐标
for ts in u.trajectory:
    for i, res in enumerate(residues):
        residue_coords[i, ts.frame] = res.atoms.center_of_mass()
    print(f"calculating frame {ts.frame}")

# 计算去除平移和旋转后的坐标矩阵
residue_coords -= residue_coords.mean(axis=1, keepdims=True)

# 计算协方差矩阵
cov_matrix = np.cov(residue_coords.reshape(len(residues), -1))

# 计算DCCM
dccm = np.corrcoef(cov_matrix)

# 保存DCCM结果
np.savetxt('DCCM_Residue.txt', dccm)


# 载入DCCM数据
dccm = np.loadtxt('DCCM_Residue.txt')

# 创建热图
plt.figure(figsize=(10, 8))
sns.heatmap(dccm, cmap='coolwarm', center=0, square=True, cbar_kws={"shrink": .8})
plt.title('Dynamical Cross-Correlation Matrix (DCCM)')
plt.xlabel('Residue Index')
plt.ylabel('Residue Index')
# save plt
plt.savefig('DCCM_residue.png', dpi=300)
#plt.show()
plt.close()

########################################################################################
# 3. residue side chain level DCCM calculation
########################################################################################


# 选择蛋白质的残基
residues = u.select_atoms('protein').residues

# 初始化残基中心坐标矩阵
residue_coords = np.zeros((len(residues), len(u.trajectory), 3))

# 计算每一帧的残基side cahin中心坐标
for ts in u.trajectory:
    for i, res in enumerate(residues):
        residue_coords[i, ts.frame] = res.atoms.select_atoms('not backbone').center_of_mass()
    print(f"calculating frame {ts.frame}")

# 计算去除平移和旋转后的坐标矩阵
residue_coords -= residue_coords.mean(axis=1, keepdims=True)

# 计算协方差矩阵
cov_matrix = np.cov(residue_coords.reshape(len(residues), -1))

# 计算DCCM
dccm = np.corrcoef(cov_matrix)

# 保存DCCM结果
np.savetxt('DCCM_Residue_sidechain.txt', dccm)


# 载入DCCM数据
dccm = np.loadtxt('DCCM_Residue_sidechain.txt')

# 创建热图
plt.figure(figsize=(10, 8))
sns.heatmap(dccm, cmap='coolwarm', center=0, square=True, cbar_kws={"shrink": .8})
plt.title('Dynamical Cross-Correlation Matrix (DCCM)')
plt.xlabel('Residue Index')
plt.ylabel('Residue Index')
# save plt
plt.savefig('DCCM_residue_sidechain.png', dpi=300)
# plt.show()
plt.close()

########################################################################################
# 4. residue backbone level DCCM calculation
########################################################################################


# 选择蛋白质的残基
residues = u.select_atoms('protein').residues

# 初始化残基中心坐标矩阵
residue_coords = np.zeros((len(residues), len(u.trajectory), 3))

# 计算每一帧的残基side cahin中心坐标
for ts in u.trajectory:
    for i, res in enumerate(residues):
        residue_coords[i, ts.frame] = res.atoms.select_atoms('backbone').center_of_mass()
    print(f"calculating frame {ts.frame}")

# 计算去除平移和旋转后的坐标矩阵
residue_coords -= residue_coords.mean(axis=1, keepdims=True)

# 计算协方差矩阵
cov_matrix = np.cov(residue_coords.reshape(len(residues), -1))

# 计算DCCM
dccm = np.corrcoef(cov_matrix)

# 保存DCCM结果
np.savetxt('DCCM_Residue_backbone.txt', dccm)
i

# 载入DCCM数据
dccm = np.loadtxt('DCCM_Residue_backbone.txt')

# 创建热图
plt.figure(figsize=(10, 8))
sns.heatmap(dccm, cmap='coolwarm', center=0, square=True, cbar_kws={"shrink": .8})
plt.title('Dynamical Cross-Correlation Matrix (DCCM)')
plt.xlabel('Residue Index')
plt.ylabel('Residue Index')
# save plt
plt.savefig('DCCM_residue_backbone.png', dpi=300)
#plt.show()
plt.close()
