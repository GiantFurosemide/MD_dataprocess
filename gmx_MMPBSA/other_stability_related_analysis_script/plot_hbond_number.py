'''
read xvg file, then plot and save png
'''
import os
import argparse
import matplotlib.pyplot as plt

def plot_two_columns(data_file:str,
                     xlabel:str,
                     ylabel:str,
                     title:str):
    # Read data from file
    x = []
    y = []
    
    with open(data_file, 'r') as file:
        for line in file:
            if line.startswith('#') or line.startswith('@'):
                continue
            values = line.split()
            x.append(float(values[0]))
            y.append(int(values[1]))

    # Plot the data
    plt.figure(figsize=(10, 6))
    plt.plot(x, y)

    # Add labels and title
    plt.xlabel(xlabel) 
    plt.xticks(fontsize=14)
    plt.ylabel(ylabel)
    plt.yticks(fontsize=14)
    plt.title(title,fontsize=16)

    # Save plot as PNG
    plt.savefig(data_file.replace(".xvg", ".png"))
    print(f"save png file to {data_file.replace('.xvg', '.png')}")

    # Show the plot
    #plt.show()
#def plot_hbond_number():


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Plot data from a .dat file and save as a PNG image.')
    parser.add_argument('-d','--data_file', help='Path to the input .dat file')
    parser.add_argument('--xlabel', default='',help='Label for the X-axis')
    parser.add_argument('--ylabel', default='',help='Label for the Y-axis')
    parser.add_argument('--title',default='', help='Title of the plot')

    args = parser.parse_args()

    plot_two_columns(args.data_file, args.xlabel, args.ylabel, args.title)
