# Python dependency

tested enviroment:

```plaintext
python=3.10
MDanalysis=2.5.0
```

# Usage

1. Use 'mergeAMBERtraj.sh' to merge all coordination and velocity to 'merge_amber.nc'.

First merge coordination and velocity to 'merge.nc' and 'velocity.nc' respectively. Then merge 'merge.nc' and 'velocity.nc' to 'merge_amber.nc'. Maybe due to the format of 'velocity.nc' is different from original amber format. the value of  velocity in 'merge_amber.nc' is all 0, but provided as placeholder for next step.

2. Use 'AMBERtraj2GMXtraj.py' to update velocity in 'merge_amber.nc'

Use python package 'xarray' to extract velocity from 'velocity.nc' and then update 'merge_amber.nc'. final out is converted to a trr file for further process in gromacs.
