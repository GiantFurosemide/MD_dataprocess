# first make a nc with velocity of 0
merged_nc = 'merge_amber.nc'
vel_nc = 'velocity.nc'
# generate gro by pemnd
gro = "light.gro"
##
out_trr_all = "light.trr"
#out_trr_protein = "light_protein.trr"
my_dt='ns'

#####################################################
import xarray as xr
ds_vel= xr.open_dataset(vel_nc)
vel = ds_vel['coordinates'].values

import MDAnalysis as mda

u =mda.Universe(gro,merged_nc)
trj_l = len(u.trajectory)
assert trj_l == vel.shape[0]


## write protein
#protein = u.select_atoms("protein")
#with mda.Writer(out_trr_protein,protein.n_atoms,dt=my_dt) as W :
#    for i in range(trj_l):
#        u.trajectory[i]
#        protein.atoms.velocities = vel[i]
#        W.write(protein.atoms)
#        print(f'writing frame {i} to {out_trr_protein}')
#
# write all atoms

with mda.Writer(out_trr_all,u.atoms.n_atoms,dt=my_dt) as W :
    for i in range(trj_l):
        u.trajectory[i]
        u.atoms.velocities = vel[i]
        W.write(u.atoms)
        print(f'writing frame {i} to {out_trr_all}')