def fasta_to_seqres(fasta_file):
    seqres_records = []

    with open(fasta_file, 'r') as fasta:
        current_chain_id = 'A'
        current_sequence = ""
        current_residue_count = 0

        for line in fasta:
            if line.startswith('>'):
                # New chain, store previous chain information
                if current_sequence:
                    seqres_records.extend(format_seqres_record(current_chain_id, current_sequence, current_residue_count))
                    current_residue_count = 0
                    current_sequence = ""

                # Extract chain identifier from the header line
                current_chain_id = line[1:].strip()
            else:
                # Accumulate sequence for the current chain
                current_sequence += line.strip()
                current_residue_count += len(line.strip())

        # Process the last chain
        if current_sequence:
            seqres_records.extend(format_seqres_record(current_chain_id, current_sequence, current_residue_count))

    return seqres_records

def format_seqres_record(chain_id, sequence, residue_count):
    seqres_records = []
    seqres_template = "SEQRES {serial:3d} {chain_id} {residue_count:-5d} {residues}"

    serial = 1
    residues = []  # Initialize residues list

    for residue in sequence:
        # Convert one-letter code to three-letter code
        three_letter_code = one_to_three_letter_code(residue)

        if len(residues) == 13:
            # Output SEQRES record and reset counters
            seqres_records.append(seqres_template.format(serial=serial, chain_id=chain_id, residue_count=residue_count, residues=" ".join(residues)))
            serial += 1
            residues = []

        residues.append(three_letter_code)

    # Output the last SEQRES record
    if residues:
        seqres_records.append(seqres_template.format(serial=serial, chain_id=chain_id, residue_count=residue_count, residues=" ".join(residues)))

    return seqres_records

def one_to_three_letter_code(one_letter_code):
    # Define a dictionary for one to three letter code mapping
    aa_mapping = {
        'A': 'ALA', 'R': 'ARG', 'N': 'ASN', 'D': 'ASP', 'C': 'CYS', 'E': 'GLU',
        'Q': 'GLN', 'G': 'GLY', 'H': 'HIS', 'I': 'ILE', 'L': 'LEU', 'K': 'LYS',
        'M': 'MET', 'F': 'PHE', 'P': 'PRO', 'S': 'SER', 'T': 'THR', 'W': 'TRP',
        'Y': 'TYR', 'V': 'VAL'
    }

    return aa_mapping.get(one_letter_code, 'XXX')  # Default to 'XXX' if not found

# Example usage
fasta_file_path = '2FE_clean2.fasta'
seqres_records = fasta_to_seqres(fasta_file_path)

# Print or save the SEQRES records
for record in seqres_records:
    print(record)