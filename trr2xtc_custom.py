import glob
import os

def run_cmd(cmd:str):
	print(cmd)
	os.system(cmd)

trr_files = glob.glob('./*.trr')

for gro_file in glob.glob('../../md-input/*.gro'):
	#gro_name= '../../md-input/npt_ab.gro' 
	cmd=f"cp -v {gro_file} ../step4.1_equilibration.gro" # prepare gro file for next step
	run_cmd(cmd)
gro_name='../step4.1_equilibration.gro'


for trr in trr_files:
	filename  =  os.path.basename(trr).split('.')[0]
	outname = filename+'.xtc'
	cmd = f"echo 0 | gmx trjconv -f {trr} -s {gro_name} -o {outname}"
	run_cmd(cmd)

	# check if the xtc file is generated, if not, re-execute the command, up to 20 times
	if not os.path.exists(outname):
		print(f"Error: {outname} is not generated.")
		for i in range(20):
			print(f"Re-executing the command: {cmd}")
			run_cmd(cmd)
			if os.path.exists(outname):
				break

cmd = f"mkdir xtc ; cd xtc ; mv ../*.xtc . ; gmx trjcat -f ./*.xtc -o merged.xtc"
run_cmd(cmd)

cmd = "cd xtc ; mv -v merged.xtc ../.. ; rm ./*.xtc ; cd .. ; rm -r xtc"
run_cmd(cmd)

print('done!')