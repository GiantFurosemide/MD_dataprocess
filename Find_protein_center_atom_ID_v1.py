#!/usr/bin/env python3

import numpy as np

def read_gro_file(filename):
    with open(filename, 'r') as file:
        lines = file.readlines()
    
    atom_coords = []
    for line in lines[2:-1]:  # Skip the first two lines and the last line
        parts = line.split()
        atom_id = int(parts[2])
        x = float(parts[3])
        y = float(parts[4])
        z = float(parts[5])
        atom_coords.append((atom_id, x, y, z))
    
    return atom_coords

def find_center_atom(atom_coords):
    coords = np.array([[x, y, z] for _, x, y, z in atom_coords])
    center = np.mean(coords, axis=0)
    
    distances = np.linalg.norm(coords - center, axis=1)
    closest_atom_index = np.argmin(distances)
    
    return atom_coords[closest_atom_index][0]

def main():
    input_file = "npt_ab_protein.gro"
    atom_coords = read_gro_file(input_file)
    center_atom_id = find_center_atom(atom_coords)
    print(f"{center_atom_id}")

if __name__ == "__main__":
    main()
