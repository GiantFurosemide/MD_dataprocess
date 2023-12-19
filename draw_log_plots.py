import os
import pandas as pd
import matplotlib.pyplot as plt

log_columns = {
    "loop_ID":0,     
    "temperature":1,      
    "pressure":2,      
    "kinetic":3,      
    "potential":4,      
    "viral":5,      
    "lboxx":6,     
    "lboxy":7,      
    "lboxz":8, 
    }

def read_data(file_path, selected_columns):
    data = {col: [] for col in selected_columns}

    with open(file_path, 'r') as file:
        lines = file.readlines()
        # Assuming the first line contains column names, skip it
        for line in lines[1:]:
            values = line.split()
            for col in selected_columns:
                data[col].append(float(values[selected_columns[col]]))

    return data

def plot_scatter_and_save(folder_path, x_column, y_column, output_csv):
    all_data = {x_column: [], y_column: []}

    for file_name in os.listdir(folder_path):
        if file_name.endswith(".txt"):
            file_path = os.path.join(folder_path, file_name)
            data = read_data(file_path, {x_column: log_columns[x_column], y_column: log_columns[y_column]})

            all_data[x_column].extend(data[x_column])
            all_data[y_column].extend(data[y_column])

            #plt.plot(data[x_column], data[y_column], label=file_name)

    # Save the combined data to CSV
    df = pd.DataFrame(all_data)
    df.to_csv(output_csv, index=False)
    print(f"> save to {output_csv}")

    plt.scatter(df[x_column], df[y_column])
    plt.xlabel(x_column)
    plt.ylabel(y_column)
    #plt.legend()
    plt.title(f'{x_column} vs {y_column}')
    #plt.show()
    
    plt.savefig(f"{x_column}-vs-{y_column}.png")
    print(f"> save to {x_column}-vs-{y_column}.png")
    plt.clf()

if __name__ == "__main__":
    folder_path = input(">Please input log_txt folder's name:\n>").strip()  # 替换为你的文件夹路径
    #x_column = 'loop_ID'  # 选择x轴列
    #y_column = 'pressure'  # 选择y轴列
    output_csv = "output.csv"  # 指定CSV文件名

    for k in list(log_columns.keys())[1:]:
        plot_scatter_and_save(folder_path, 'loop_ID', k, output_csv)

    #plot_scatter_and_save(folder_path, 'loop_ID', 'pressure', output_csv)
    #plot_scatter_and_save(folder_path, 'loop_ID', "kinetic", output_csv)

