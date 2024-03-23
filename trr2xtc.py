import glob
import os

begin_str = '''
#################################################
 start to convert trr files to xtc files (trr2xtc.py)
#################################################
'''

end_str = '''
#################################################
 trr files have been converted to xtc files (trr2xtc.py)
#################################################

'''

def run_cmd(cmd:str):
	print(cmd)
	os.system(cmd)

print(begin_str)

trr_files = glob.glob('./*.trr')
gro_name= input('>Please input gro filename:\n>').strip()
cmd=f"cp -v {gro_name} ../step4.1_equilibration.gro" # prepare gro file for next step
run_cmd(cmd)

for trr in trr_files:
	filename  =  os.path.basename(trr).split('.')[0]
	outname = filename+'.xtc'
	cmd = f"echo 0 | gmx trjconv -f {trr} -s {gro_name} -o {outname}"
	run_cmd(cmd)

cmd = f"mkdir xtc ;  cd xtc ;  mv ../*.xtc . ;  gmx trjcat -f ./*.xtc -o merged.xtc"
run_cmd(cmd)

cmd = "cd xtc ;  mv -v merged.xtc ../.. ;  rm ./*.xtc ;  cd .. ;  rm -r xtc"
run_cmd(cmd)

print(end_str)