import glob


top_parm = "step5_input.parm7"
nc_files = [f"step7_{int(i)+1}.nc" for i in range(len(glob.glob("step7_*.nc")))]

######
assert sorted(nc_files) == sorted(glob.glob("step7_*.nc"))
cpptraj_file_in=f"parm {top_parm}\n"
cmd = ""
for i in nc_files:
    cmd += f"trajin {i}\n"
cpptraj_file_in += cmd
cpptraj_file_in += "trajout merge.cn \n"

with open("cpptraj.in","w") as file_out:
    file_out.write(cpptraj_file_in)
print("save cmds to cpptraj.in")
print("run:\n cpptraj -i cpptraj.in")