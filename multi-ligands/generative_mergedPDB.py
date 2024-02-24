"""
B_structure（蛋白，一个） 将会放在盒子中心
A_structure（小分子，多个）将会在盒子内随机放置并且不会和B_structure在5埃内重叠，
        且A_structure的多个小分子之间不会在2.5埃内重叠

"""

import MDAnalysis as mda
import numpy as np
from scipy.spatial.distance import cdist
import copy


# step 0: set output path
#ligan_pdb="/Users/muwang/Documents/work/project/20230713_Haemoglobin_Art_jkw/data/structure/2dn1/OXY.pdb"
#ligand_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/PP1-acedrg.pdb"
#ligand_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/dasatinib-acedrg.pdb"
ligand_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/ligand-smile/DAS.acpype/DAS_NEW.pdb"
#ligand_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/ligand-smile/PP1.acpype/PP1_NEW.pdb"

#input_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/structures/clean-minimized-alignto2DN2/1RQA-clean-minimized_align.pdb'
#output_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/jupyter/output/structure_add_OXY/1RQA.pdb'
#input_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/structures/clean-minimized-alignto2DN2/1Y7D-clean-minimized_align.pdb'
#output_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/jupyter/output/structure_add_OXY/1Y7D.pdb'
#input_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/structures/clean-minimized-alignto2DN2/1Y7G-clean-minimized_align.pdb'
#output_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/jupyter/output/structure_add_OXY/1Y7G.pdb'
#input_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/structures/clean-minimized-alignto2DN2/3NMM-clean-minimized_align.pdb'
#output_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/jupyter/output/structure_add_OXY/3NMM.pdb'
#input_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/structures/hemoglobin/非携氧态T/2dn2_clean_prepared_1.pdb'
#output_pdb = '/Users/muwang/Documents/work/project/20240117_Haemoglobin_Art_jkw/project/20240129_mutation/jupyter/output/structure_add_OXY/2dn2.pdb'

#input_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/1y57-res309-533.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-PP1-10w.pdb"
#input_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/1y57-res309-533.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-dasatinib-10w.pdb"
#input_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/1y57-res309-533.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-acpype-10w.pdb"
#input_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/1y57-res309-533.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-PP1-acpype-10w.pdb"
#input_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/1y57-res309-533.pdb"
input_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/maestro-output/1y57-res266-533.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-100-acpype-100w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-200-acpype-100w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-2-acpype-10w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-4-acpype-10w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-3-acpype-10w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-PP1-3-10w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-PP1-2-10w.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-PP1-2-10w-new.pdb"
output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-PP1-3-10w-new.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-3-10w-new.pdb"
#output_pdb="/Users/muwang/Documents/work/project/20240131_kinase_src_swimming/data/structures/for_md_build/src-DAS-2-10w-new.pdb"
# Step 1: Load A.pdb and B.pdb
A_structure = mda.Universe(ligand_pdb)
B_structure = mda.Universe(input_pdb)

# Step 2: Define the box dimensions
box_size = 100  # Angstroms

# Step 3: Randomly position the 10 A proteins
num_A_proteins = 3  #936 94 10 20 50 (4 for PP1;10 for dasatinib)
box_center = np.array([box_size / 2, box_size / 2, box_size / 2])
THRESHOLD1 = 5.0
THRESHOLD2 = 3.5


## 检查两个坐标集是否重叠的函数
#def check_overlap(coords1, coords2,threshold=5):
#    """
#    coords1: AtomsGroup
#    coords2: Atom
#    
#    """
#    min_dists = []
#    for i in range(len(coords1)):
#        diff = coords1[i] - coords2 
#        dists = np.linalg.norm(diff, axis=1)
#        min_dists.append(np.min(dists))
#    return min(min_dists) < threshold # threshold default 5 Angstrom


#def check_overlap(listA, listB,threshold=5):
#    # 将listA和listB中的numpy arrays合并为单个数组，以便使用cdist计算距离
#    arrayA = np.vstack(listA)
#    arrayB = np.vstack(listB)
#
#    # 计算所有listA中的坐标到所有listB中的坐标的距离矩阵
#    distances = cdist(arrayA, arrayB)
#
#    # 检查是否所有距离均大于5
#    all_distances_greater_than_threshold = np.all(distances > threshold)
#
#    return all_distances_greater_than_threshold
#
#def get_coordinates_with_distances_greater_than_threshold(listA, listB,threshold=5):
#    # 将listA和listB中的numpy arrays合并为单个数组，以便使用cdist计算距离
#    arrayA = np.vstack(listA)
#    arrayB = np.vstack(listB)
#
#    # 计算所有listA中的坐标到所有listB中的坐标的距离矩阵
#    distances = cdist(arrayA, arrayB)
#
#    # 找到距离大于5的坐标索引
#    indices = np.where(np.all(distances > threshold, axis=1))
#
#    # 获取距离大于5的坐标
#    coordinates_with_distances_greater_than_threshold = arrayA[indices]
#
#    return coordinates_with_distances_greater_than_threshold

def get_coordinates_with_distances_greater_than_threshold(listA, listB, threshold):
    # 将listA和listB中的numpy arrays合并为单个数组，以便使用cdist计算距离
    arrayA = np.vstack(listA)
    arrayB = np.vstack(listB)

    # 计算所有listA中的坐标到所有listB中的坐标的距离矩阵
    distances = cdist(arrayA, arrayB)
    min_ = min(distances.flatten())
    max_ = max(distances.flatten())
    # 找到距离大于阈值的坐标索引
    indices = np.where(np.all(distances > threshold, axis=1))
    #indices = np.where(np.any(distances < threshold, axis=1))

    #indices = np.where(distances < threshold)
    # 获取距离大于阈值的坐标
    coordinates_with_distances_greater_than_threshold = arrayA[indices]
     

    return coordinates_with_distances_greater_than_threshold

def generate_random_coordinates(num_coordinates):
    # 生成num_coordinates个随机坐标，范围在[0, 1)
    return (np.random.rand(num_coordinates, 3)-0.5)*box_size

def process_lists(listC, listB, threshold1=5.0,threshold2=2.0):
    listD = get_coordinates_with_distances_greater_than_threshold(listC, listB, threshold1)
    while len(listC) > len(listD):

        
        # 生成需要补充的随机坐标个数
        num_random_coordinates = len(listC) - len(listD)
        # 生成随机坐标并添加到listC中
        listE = generate_random_coordinates(num_random_coordinates)
        #listC = np.vstack((listC, listE))

        # 用listC中的坐标与listB进行新一轮的距离比较
        listF = get_coordinates_with_distances_greater_than_threshold(listE, listB, threshold1)

        # 用listF中的坐标与listD进行新一轮的距离比较，得到合并后的新listD
        listG = get_coordinates_with_distances_greater_than_threshold(listF, listD, threshold2)
        listD = np.vstack((listD, listG))

        print(f"len listD = {len(listD)}")

    return listD

# Step 4: Place the B protein at the center
B_protein_coords = B_structure.atoms.positions
B_centered_coords = B_protein_coords - np.mean(B_protein_coords, axis=0) + box_center

# 随机生成10组蛋白质A的坐标
#A_positions = []
#for i in range(num_A_proteins):
#    overlaps = True
#    print(f'{len(A_positions)}')
#    while overlaps:
#    # Generate random positions for each A protein
#        random_position = (np.random.rand(3)-0.5) * box_size
#        # random_position 不可以与 B_centered_coords在5埃内重叠
#        overlaps = check_overlap([random_position], B_protein_coords,threshold=5)
#        # random_position 不可以与 A_positions的小分子在2.5埃内重叠
#        if A_positions:
#            #print(A_positions)
#            #assert overlaps == False
#            assert any([check_overlap([random_position],[s],threshold=2.5) for s in A_positions])
#            
#        overlaps = not (not overlaps and not any([check_overlap(random_position,s,threshold=2.5) for s in A_positions]))            
#    A_positions.append(random_position)
A_positions = (np.random.rand(num_A_proteins,3)-0.5) * box_size
A_positions = process_lists(A_positions,B_centered_coords,threshold1=THRESHOLD1,threshold2=THRESHOLD2)

assert len(get_coordinates_with_distances_greater_than_threshold(A_positions, B_centered_coords, threshold=THRESHOLD1))==len(A_positions)

A_protein_coords = A_structure.atoms.positions
A_centered_coords = A_protein_coords - np.mean(A_protein_coords, axis=0) + box_center
A_structure.atoms.positions = A_centered_coords

# Step 5: Create the combined structure (C.pdb)
num_A_atoms = A_structure.atoms.positions.shape[0]
num_B_atoms = B_structure.atoms.positions.shape[0]
total_num_atoms = num_A_atoms * num_A_proteins + num_B_atoms

# Create an empty array to hold the positions of all atoms in C.pdb
C_positions = np.zeros((total_num_atoms, 3))

# Assign positions for A proteins
for i, position in enumerate(A_positions):
    C_positions[i * num_A_atoms: (i + 1) * num_A_atoms, :] = A_structure.atoms.positions + position

# Assign positions for B protein
C_positions[num_A_atoms * num_A_proteins:] = B_centered_coords

# Create the combined structure (C.pdb)
entities = []
#ini_id = A_structure.atoms.residues.resids[0]
for i in range(num_A_proteins):
    u_copy = A_structure.copy()
    u_copy.segments.segids = f'APP'
    temp_atom_group = u_copy.atoms
    #print(temp_atom_group.residues.resids)
    #print('aaaa')
    #temp_atom_group.residues.resids = ini_id + i
    temp_atom_group.residues.resids += i

    #print(temp_atom_group.residues.resids)
    #print('>>')
    
    #print(temp_atom_group.residues.resids)
    
    entities.append(temp_atom_group)
    del temp_atom_group

for i in entities:
    #ini_id += 1
    #i.residues.resids = ini_id
    print(i.segments.segids)
    
entities += [B_structure.atoms]



C_structure = mda.Merge(*entities)
print(C_positions.shape)
C_structure.atoms.positions = C_positions

# Save the combined structure to C.pdb
C_structure.atoms.write(output_pdb)
print('done')

