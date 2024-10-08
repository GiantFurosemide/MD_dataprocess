import numpy as np

def generate_color_gradient(length):
    # 定义颜色
    blue = np.array([0, 0, 255])
    white = np.array([255, 255, 255])
    red = np.array([255, 0, 0])

    # 创建一个指定长度的list
    colors = np.zeros((length, 3), dtype=int)
    colors1 = np.linspace(blue, white, length // 2)
    colors2 = np.linspace(white,red, length - length // 2)
    colors = np.vstack((colors1, colors2))

    #convert to integer
    colors = np.round(colors).astype(int)

    color_list = [tuple(color) for color in colors]
    assert len(color_list) == length
    color_list.reverse()
    return color_list

def rgb_to_hex(rgb):
    return '#{:02x}{:02x}{:02x}'.format(rgb[0], rgb[1], rgb[2])



if __name__ == '__main__':
    # 示例调用
    length = 50
    color_gradient = generate_color_gradient(length)
    print(color_gradient)
    color_gradient = [ rgb_to_hex(i) for i in color_gradient]
    print(color_gradient)
