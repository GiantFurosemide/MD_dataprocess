import os
import pandas as pd
import matplotlib.pyplot as plt
import argparse

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
    df = df.sort_values(by=x_column)
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

def add_parser():
    # Create ArgumentParser object
    parser = argparse.ArgumentParser(description='Plot log files')

    # Add argument for folder_path with shorthand -f
    parser.add_argument('-f', '--folder_path', type=str, help='Specify the folder path of log files')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Check if folder_path is provided
    if args.folder_path:
        folder_path = args.folder_path
        print(f'folder_path is set to: {folder_path}')
        return folder_path
    else:
        print('No folder_path provided. Please use -f or --folder_path to specify the folder path.')
        return None
begin_str = '''
#################################################
 start to draw log plots (draw_log_plots.py)
#################################################
'''

end_str = '''
#################################################
 log plots complete (draw_log_plots.py)
#################################################

'''
if __name__ == "__main__":
    #folder_path = input(">Please input log_txt folder's name:\n>").strip()  # 替换为你的文件夹路径
    print(begin_str)
    folder_path = add_parser()
    # check folder_path
    if folder_path is None:
        print("Error: folder_path is None.")
        exit()

    # output_csv = "output.csv"  # 指定CSV文件名

    keys = list(log_columns.keys())
    for k in keys[1:]:
        output_csv = f"{keys[0]}-vs-{k}_data.csv"
        plot_scatter_and_save(folder_path, keys[0], k, output_csv)

    print("done!")
    print(end_str)       

