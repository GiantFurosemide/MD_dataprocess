import glob
import os

trr_files = glob.glob('./*.trr')
gro_name= input('>Please input gro filename:\n>').strip()
for trr in trr_files:
	filename  =  os.path.basename(trr).split('.')[0]
	outname = filename+'.xtc'
	cmd = f"echo 0 | gmx trjconv -f {trr} -s {gro_name} -o {outname}"
	print(cmd)
	os.system(cmd)
cmd = f"mkdir xtc && cd xtc && mv ../*.xtc . && gmx trjcat -f ./*.xtc -o merged.xtc"
print(cmd)
os.system(cmd)
cmd = f'cd xtc && echo 1 0|gmx trjconv -f merged.xtc -s {gro_name} -pbc nojump -center -o nojump.xtc'
print(cmd)
os.system(cmd)
cmd = f'cd xtc && echo 1 1 0|gmx trjconv -f nojump.xtc -s {gro_name} -center -o nojump_rottrans.xtc -fit rot+trans && rm -v nojump.xtc'
print(cmd)
os.system(cmd)
cmd = "cd xtc && mv -v merged.xtc ../.. && mv -v nojump_rottrans.xtc ../.. && rm ./*.xtc && cd .. && rm -r xtc"
print(cmd)
os.system(cmd)
print('done!')