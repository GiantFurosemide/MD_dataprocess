#Working version 2
#Extract protein size, shape and orientation from PDB file (contain protein only), record them. Suggest water box size from 3 choices.
#For less than 10 proteins, suggest to view proteins by pymol, VMD etc to get this information, which is faster.
#For more than 100 proteins, suggest using this automatic script (make it run overnight).
#Shiping XU, 2024.02.01

#I.Store the information about protein shape, size and orientation
#Step 0: Set the geometric center in coordinate origin (0,0) 
#Use VMD to center the protein is faster? (pending: use VMD in scripts, check VMD manual; check ChaptGPT: windows-scripts-VMD)
from Bio.PDB import PDBParser, Select
from Bio import PDB
import numpy as np
import os
from scipy.spatial import cKDTree
from scipy.spatial.distance import pdist
from scipy.spatial.transform import Rotation
import shutil



def calculate_geometric_center(coordinates):
    num_atoms = len(coordinates)
    center = np.sum(coordinates, axis=0) / num_atoms
    return center

def translation(input_pdb_path, output_pdb_path):
    # Create a PDB parser
    parser = PDB.PDBParser(QUIET=True)

    # Parse the input PDB file
    structure = parser.get_structure("protein", input_pdb_path)

    # Extract atomic coordinates
    coordinates = []
    for model in structure:
        for chain in model:
            for residue in chain:
                for atom in residue:
                    coordinates.append(atom.coord)

    if not coordinates:
        print("No atomic coordinates found in the PDB file.")
        return

    # Calculate the geometric center
    geometric_center = calculate_geometric_center(np.array(coordinates))

    # Translate the coordinates by the negative of the geometric center
    for model in structure:
        for chain in model:
            for residue in chain:
                for atom in residue:
                    atom.coord -= geometric_center

    # Create a PDBIO object to write the modified structure
    io = PDB.PDBIO()

    # Save the modified structure to the output PDB file
    io.set_structure(structure)
    io.save(output_pdb_path)
    
    
def rotate_coordinates(coordinates, angle_degrees, rotation_axis):
    # Map the rotation axis to the corresponding axis index
    axis_index = {'x': 0, 'y': 1, 'z': 2}[rotation_axis]

    # Create a rotation matrix for the specified axis and angle
    angle_radians = np.radians(angle_degrees)
    rotation_matrix = Rotation.from_euler(rotation_axis, angle_radians).as_matrix()

    # Apply the rotation to all coordinates
    rotated_coordinates = np.dot(coordinates, rotation_matrix.T)
    return rotated_coordinates
    
def rotate_protein(input_pdb_path, output_pdb_path, angles_x, angles_y, angles_z):
    # Create a PDB parser
    parser = PDB.PDBParser(QUIET=True)

    # Parse the input PDB file
    structure = parser.get_structure("protein", input_pdb_path)

    # Extract atomic coordinates
    coordinates = []
    for model in structure:
        for chain in model:
            for residue in chain:
                for atom in residue:
                    coordinates.append(atom.coord)

    if not coordinates:
        print("No atomic coordinates found in the PDB file.")
        return

    # Perform rotations and save each structure
    for angle_x in angles_x:
        for angle_y in angles_y:
            for angle_z in angles_z:
                # Perform the rotation around the x-axis
                rotated_coordinates_x = rotate_coordinates(np.array(coordinates), angle_x, 'x')

                # Perform the rotation around the y-axis
                rotated_coordinates_y = rotate_coordinates(rotated_coordinates_x, angle_y, 'y')

                # Perform the rotation around the z-axis
                rotated_coordinates_z = rotate_coordinates(rotated_coordinates_y, angle_z, 'z')

                # Update the coordinates in the structure
                atom_index = 0
                for model in structure:
                    for chain in model:
                        for residue in chain:
                            for atom in residue:
                                atom.coord = rotated_coordinates_z[atom_index]
                                atom_index += 1

                # Create a PDBIO object to write the modified structure
                io = PDB.PDBIO()

                # Generate a label for the output PDB structure
                output_label = f"Temp_rotated_x{angle_x}_y{angle_y}_z{angle_z}.pdb"
                output_path = os.path.join(output_pdb_path, output_label)

                # Save the rotated structure to the output PDB file
                io.set_structure(structure)
                io.save(output_path)

                print(f"Rotation completed: {output_path}")

def calculate_max_interatomic_distance(pdb_filename):
    # Create a PDB parser
    parser = PDBParser(QUIET=True)

    # Load the PDB file
    structure = parser.get_structure('protein', pdb_filename)

    # Extract coordinates of all atoms in the structure
    all_atoms = []
    for model in structure:
        for chain in model:
            for residue in chain:
                for atom in residue:
                    all_atoms.append(atom.get_coord())

    # Select 6 atoms with the maximum and minimum x, y, and z coordinates
    selected_atoms = sorted(all_atoms, key=lambda atom: (atom[0], atom[1], atom[2]))[:3] + \
                      sorted(all_atoms, key=lambda atom: (atom[0], atom[1], atom[2]), reverse=True)[:3]

    # Calculate pairwise distances iteratively
    max_distance = 0.0
    n_atoms = len(selected_atoms)

    for i in range(n_atoms - 1):
        for j in range(i + 1, n_atoms):
            distance_ij = pdist([selected_atoms[i], selected_atoms[j]])[0]
            max_distance = max(max_distance, distance_ij)

    return max_distance

def find_and_rename_max_distance_structure(input_folder):
    max_distance = 0.0
    max_distance_filename = ""
    base = ""
    
    # Iterate over rotated PDB files
    for filename in os.listdir(input_folder):
        if filename.startswith("Temp_rotated") and filename.endswith(".pdb"):
            pdb_filepath = os.path.join(input_folder, filename)
            distance = calculate_max_interatomic_distance(pdb_filepath)

            # Compare and update max_distance
            if distance > max_distance:
                max_distance = distance
                max_distance_filename = filename
                
    print(f"Maximum inter-atomic distance: {max_distance}")   
    
    # Rename the rotated file with maximum distance
    if max_distance_filename:
        base_name = os.path.splitext(max_distance_filename)[0]
        new_name = f"{base_name}_maximum.pdb"
        new_path = os.path.join(input_folder, new_name)
        max_distance_filepath = os.path.join(input_folder, max_distance_filename)

        # Check if the file with the new name already exists, if so, replace it
        if os.path.exists(new_path):
            os.remove(new_path)

        shutil.move(max_distance_filepath, new_path)
        print(f"File with maximum distance: {new_name}")

        # Remove other rotated PDB files
        for filename in os.listdir(input_folder):
            if filename.startswith("Temp_rotated") and filename.endswith(".pdb") and filename != new_name:
                file_path = os.path.join(input_folder, filename)
                os.remove(file_path)
    else:
        print("No PDB files found in the specified folder.")
    
    return max_distance

def rename_Temp_file(input_folder, newname):
    for filename in os.listdir(input_folder):
        if filename.startswith("Temp") and filename.endswith(".pdb"):
            old_path = os.path.join(input_folder, filename)
            new_path = os.path.join(input_folder, newname)

            # Check if the file with the new name already exists, if so, replace it
            if os.path.exists(new_path):
                os.remove(new_path)

            os.rename(old_path, new_path)
    
if __name__ == "__main__":       
    input_translation = "7oik.pdb"    
    # Extract the base name of output_translation without the extension
    base_name0 = os.path.splitext(os.path.basename(input_translation))[0]
    output_translation = f"{base_name0}-center.pdb"
    translation(input_translation, output_translation)
    
    # Construct the input_rotation path using the same base name
    input_rotation = output_translation
    output_rotation = "./"
    os.makedirs(output_rotation, exist_ok=True)

    # Define the rotation angles
    angles_x = [0, 30, 60]
    angles_y = [0, 30, 60]
    angles_z = [0, 30, 60]

    rotate_protein(input_rotation, output_rotation, angles_x, angles_y, angles_z)
    
    # Specify the folder containing rotated PDB files
    input_folder = "./"

    # Call the function to find and rename the structure with maximum distance
    a = find_and_rename_max_distance_structure(input_folder)
    
    # Rename the rotated file
    newname = f"{base_name0}_rotation.pdb"
    rename_Temp_file(input_folder, newname)
    
    #Define the rotation angles for rotating around z axis to find maximum x^2+y^2
    angles_x = [0]
    angles_y = [0]
    angles_z = [0, 15, 30, 45, 60, 75]
    
    input_rotation = newname
    output_rotation = "./"
    rotate_protein(input_rotation, output_rotation, angles_x, angles_y, angles_z)
    
    #Next find the maximum x^2+y^2