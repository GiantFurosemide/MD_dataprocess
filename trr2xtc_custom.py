import glob
import os

def run_cmd(cmd:str):
	print(cmd)
	os.system(cmd)

trr_files = glob.glob('./*.trr')
gro_name= '../../md-input/npt_ab.gro' 
cmd=f"cp -v {gro_name} ../step4.1_equilibration.gro" # prepare gro file for next step
run_cmd(cmd)

for trr in trr_files:
	filename  =  os.path.basename(trr).split('.')[0]
	outname = filename+'.xtc'
	cmd = f"echo 0 | gmx trjconv -f {trr} -s {gro_name} -o {outname}"
	run_cmd(cmd)

cmd = f"mkdir xtc ; cd xtc ; mv ../*.xtc . ; gmx trjcat -f ./*.xtc -o merged.xtc"
run_cmd(cmd)

cmd = "cd xtc ; mv -v merged.xtc ../.. ; rm ./*.xtc ; cd .. ; rm -r xtc"
run_cmd(cmd)

print('done!')