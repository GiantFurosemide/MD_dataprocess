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
with open("../input_gro_path.txt", 'r') as in_file:
	gro_name = in_file.readlines()[0].strip() # absolute path of the gro file
#gro_name= input('>Please input gro filename:\n>').strip()
cmd=f"cp -v {gro_name} ../step4.1_equilibration.gro" # prepare gro file for next step
run_cmd(cmd)
itp_file = os.path.join( os.path.dirname(gro_name),"copyItpFile.itp")
cmd = f"cp -v {itp_file} ../topol.top" # prepare top file for next step
itp_name = os.path.abspath("../topol.top")

default_mdp_parm="""
title             = production MD for protein in explicit water 

; Run parameters
integrator        = md              ; leap-frog algorithm
nsteps            = 100000000        ; 0.002 * 250000000.0 = 500000.0 ps or 500.0 ns
dt                = 0.0025           ; 2 fs

; Output control
nstxout           = 400000                ; save coordinates every 100 ps
nstvout           = 400000                ; save velocities every 100 ps
nstxtcout         = 400000             ; xtc compressed trajectory output every 100 ps
nstenergy         = 400000             ; save energies every 100 ps
nstlog            = 400000             ; update log file every 100 ps
nstcomm           = 1000               ; center of mass motion removal
; Bond parameters
constraint_algorithm = shake         ; holonomic constraints
shake-tol = 0.0001
constraints          = h-bonds       ;  (even heavy atom-H bonds) constrained
;lincs_iter           = 1             ; accuracy of LINCS
;lincs_order          = 4             ; also related to accuracy

; Neighborsearching
ns_type           = grid             ; search neighboring grid cells
nstlist           = 25               ; with Verlet lists the optimal nstlist is >= 10, with GPUs >= 20.
rlist             = 1.0              ; short-range neighborlist cutoff (in nm)
rcoulomb          = 1.0              ; short-range electrostatic cutoff (in nm)
rvdw              = 1.0              ; short-range van der Waals cutoff (in nm)
rlistlong         = 1.0              ; long-range neighborlist cutoff (in nm)
cutoff-scheme     = Verlet

; Electrostatics
coulombtype       = PME              ; Particle Mesh Ewald for long-range electrostatics
pme_order         = 4                ; cubic interpolation
fourierspacing    = 0.16             ; grid spacing for FFT

; Temperature coupling is on
tcoupl          =  nose-hoover              
tc-grps         = Protein Non-Protein     ; two coupling groups - more accurate
tau_t           = 0.1    0.1              ; time constant, in ps
ref_t           = 298    298             ; reference temperature, one for each group,in K

;; Pressure coupling is on
;pcoupl          = Parrinello-Rahman     ; pressure coupling is on for NPT
;pcoupltype      = isotropic             ; uniform scaling of box vectors
;tau_p           = 2.0                   ; time constant, in ps
;ref_p           = 1.0                   ; reference pressure, in bar
;compressibility = 4.5e-5                ; isothermal compressibility of water, bar^-1

; Periodic boundary conditions
pbc            = xyz                    ; 3-D PBC

; Dispersion correction
DispCorr       = EnerPres               ; account for cut-off vdW scheme

; Velocity generation
gen_vel        = no                     ; Velocity generation is off
gen_temp       = 298                    ; reference temperature, for protein in K
energygrps = Protein

"""
with open("../production_tmp.mdp", 'w') as out_file:
	out_file.write(default_mdp_parm)

default_mdp_name = os.path.abspath("../production_tmp.mdp")
tpr_name = os.path.abspath("../step4.1_equilibration.tpr")

# genertate tpr file
cmd = f"echo 0 | gmx grompp -f {default_mdp_name} -c {gro_name} -p {itp_name} -o {tpr_name}"
run_cmd(cmd)

for trr in trr_files:
	filename  =  os.path.basename(trr).split('.')[0]
	outname = filename+'.xtc'
	cmd = f"echo 0 | gmx trjconv -f {trr} -s {tpr_name} -o {outname}"
	run_cmd(cmd)

	# check if the xtc file is generated, if not, re-execute the command, up to 20 times
	if not os.path.exists(outname):
		print(f"Error: {outname} is not generated.")
		for i in range(20):
			print(f"Re-executing the command: {cmd}")
			run_cmd(cmd)
			if os.path.exists(outname):
				break

cmd = f"mkdir xtc ;  cd xtc ;  mv ../*.xtc . ;  gmx trjcat -f ./*.xtc -o merged.xtc"
run_cmd(cmd)

cmd = "cd xtc ;  mv -v merged.xtc ../.. ;  rm ./*.xtc ;  cd .. ;  rm -r xtc"
run_cmd(cmd)

print(end_str)