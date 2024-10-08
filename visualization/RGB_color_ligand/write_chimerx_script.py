
import os
from RGB_color import generate_color_gradient, rgb_to_hex


length = 51
color_gradient = generate_color_gradient(length)
print(color_gradient)
color_gradient = [ rgb_to_hex(i) for i in color_gradient]
# 生成ChimeraX脚本
with open('color_gradient.cxc', 'w') as f:
    #f.write('color #0 ')
    f.write('set bgColor white \n')
    f.write('color #1 #9a9996ff \n')
    f.write('view #1  \n')
    for i in range(1,1+length):
        f.write('color #2.%d ' % i)
        f.write(color_gradient[i-1])
        f.write(' ')
        f.write('\n')
print("> in chimeraX, load protein as #1, ligands as #2")
print("> in chimeraX, run the following command:")
print(f"open {os.getcwd()}/color_gradient.cxc")