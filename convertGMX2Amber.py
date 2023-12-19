import parmed as pmd



# 将GROMACS拓扑转换为AMBER格式
gmx_top = pmd.load_file('processed.top', xyz='npt_ab.gro')
#gmx_top = pmd.load_file('npt_ab.itp', xyz='npt_ab.gro')
gmx_top.save('npt_ab.rst7', format='rst7')
gmx_top.save('npt_ab.prmtop', format='amber')


#gmx_top = pmd.load_file('npt_ab.top', xyz='npt_ab.gro')
#gmx_top.save('pmaa.top', format='amber')
#gmx_top.save('pmaa.crd', format='rst7')



