'''
Usage:
extract rows (29 32 31 47 from index 1) from a file (a.dat) and write them to another file(b.dat).
> python script_name.py -i a.dat -o b.dat -r 29 32 31 47


'''



import argparse

def extract_rows(input_file: str, output_file: str, rows_to_extract: list):
    """
    Extracts specified rows from input_file and writes them to output_file.
    Reports if any rows in rows_to_extract are out of range.

    Parameters:
    input_file (str): Path to the input file.
    output_file (str): Path to the output file.
    rows_to_extract (list): List of row numbers to extract (1-based index).
    """
    processed_rows = []
    rest_rows = rows_to_extract.copy()
    total_lines = 0

    # First pass to determine the total number of lines
    with open(input_file, 'r') as infile:
        for _ in infile:
            total_lines += 1

    # Check for out-of-range rows
    out_of_range_rows = [row for row in rows_to_extract if row > total_lines or row < 1]
    if out_of_range_rows:
        print(f"Warning: The following rows are out of range and will be ignored: {out_of_range_rows}")

    # Second pass to extract and write the valid rows
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for current_line_number, line in enumerate(infile, start=1):
            if current_line_number in rows_to_extract:
                outfile.write(line)
                processed_rows.append(current_line_number)
                rest_rows.remove(current_line_number)
    
    # Log the processed and remaining rows
    print(f"Processed rows: {processed_rows}")
    print(f"Remaining rows: {rest_rows}")

def main():
    parser = argparse.ArgumentParser(description='Extract specified rows from a file and write them to another file.')
    parser.add_argument('-i', '--input_file', type=str, required=True, help='Path to the input file')
    parser.add_argument('-o', '--output_file', type=str, required=True, help='Path to the output file')
    parser.add_argument('-r', '--rows_to_extract', type=int, nargs='+', required=True, help='List of row numbers to extract (1-based index)')

    args = parser.parse_args()

    extract_rows(args.input_file, args.output_file, args.rows_to_extract)

if __name__ == '__main__':
    main()
